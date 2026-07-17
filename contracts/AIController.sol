// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Types.sol";
import "./Ships.sol";
import "./Lobbies.sol";
import "./Game.sol";
import "./IMaps.sol";

// Plays single-player matches as an on-chain opponent. AIController simply
// *is* one of the two players (creator or joiner) — it owns real Ships NFTs,
// builds a real Fleet, and calls the unmodified Game.moveShip exactly like a
// human wallet would. No changes were needed to Game/Ships/Fleets/Lobbies/
// Maps to support this; the only addition elsewhere is
// Lobbies.isAllowedToCreateLobbies, letting this contract call
// createLobbyForAddresses without being Lobbies' owner.
contract AIController is Ownable, IERC721Receiver {
    error NotAITurn();
    error GameEnded();
    error NotInLobby();
    error LobbyNotReadyForFleet();
    error ShipDataNotFound();

    // Safety bound on how many of the AI's ships takeAITurn will move in a
    // single call; generous headroom over AI_FLEET_SIZE.
    uint private constant MAX_SHIP_MOVES_PER_CALL = 12;
    uint8 private constant AI_FLEET_SIZE = 3;

    Ships public ships;
    Lobbies public lobbies;
    Game public game;
    IMaps public maps;

    event SinglePlayerMatchStarted(
        uint indexed lobbyId,
        address indexed human,
        bool aiIsCreator
    );
    event AIFleetCreated(uint indexed lobbyId, uint fleetId);
    event AITurnTaken(
        uint indexed gameId,
        uint shipId,
        ActionType actionType,
        uint targetShipId
    );

    constructor(
        address _ships,
        address _lobbies,
        address _game,
        address _maps
    ) Ownable(msg.sender) {
        ships = Ships(_ships);
        lobbies = Lobbies(_lobbies);
        game = Game(_game);
        maps = IMaps(_maps);
    }

    // Creates a lobby with `_human` and this contract as the two players.
    // Restricted to this contract's owner (a trusted backend/relayer), which
    // must in turn be granted Lobbies.isAllowedToCreateLobbies. The human
    // joins with their own fleet via the normal Lobbies.createFleet flow;
    // call setupAIFleet separately to build this contract's fleet.
    function startSinglePlayerMatch(
        address _human,
        bool _humanIsCreator,
        uint _costLimit,
        uint _turnTime,
        uint _selectedMapId,
        uint _maxScore
    ) external onlyOwner returns (uint lobbyId) {
        address creator = _humanIsCreator ? _human : address(this);
        address joiner = _humanIsCreator ? address(this) : _human;
        lobbies.createLobbyForAddresses(
            creator,
            joiner,
            _costLimit,
            _turnTime,
            _selectedMapId,
            _maxScore
        );
        lobbyId = lobbies.lobbyCount();
        emit SinglePlayerMatchStarted(lobbyId, _human, !_humanIsCreator);
    }

    // Mints a fresh, fully-constructed fleet for this contract and registers
    // it with Lobbies. Permissionless: anyone can trigger it once the lobby
    // exists with this contract as a player — there's no funds or state at
    // risk in doing so. A new fleet is minted per match rather than reusing a
    // persistent roster (destroyed ships stay permanently locked in this
    // game, so there's nothing to reuse between matches).
    function setupAIFleet(uint _lobbyId) external returns (uint fleetId) {
        Lobby memory lobby = lobbies.getLobby(_lobbyId);
        bool isCreator = lobby.basic.creator == address(this);
        if (!isCreator && lobby.players.joiner != address(this))
            revert NotInLobby();
        if (lobby.state.status != LobbyStatus.FleetSelection)
            revert LobbyNotReadyForFleet();

        uint[] memory shipIds = new uint[](AI_FLEET_SIZE);
        Position[] memory positions = new Position[](AI_FLEET_SIZE);

        for (uint8 i = 0; i < AI_FLEET_SIZE; i++) {
            shipIds[i] = ships.createSpecificShip(
                address(this),
                _buildAIShipTemplate(i)
            );
            // Creator ships must sit in columns 0-3, joiner ships in 13-16
            // (Fleets.createFleet's position validation) — place the AI's
            // ships in a fixed column near its own edge of the board.
            positions[i] = isCreator
                ? Position({row: int16(uint16(i)), col: 0})
                : Position({row: int16(uint16(i)), col: 16});
        }

        lobbies.createFleet(_lobbyId, shipIds, positions);

        lobby = lobbies.getLobby(_lobbyId);
        fleetId = isCreator
            ? lobby.players.creatorFleetId
            : lobby.players.joinerFleetId;
        emit AIFleetCreated(_lobbyId, fleetId);
    }

    function _buildAIShipTemplate(
        uint8 _index
    ) internal view returns (Ship memory s) {
        s.name = "AI Ship";
        s.owner = address(this);
        s.traits.variant = 1;
        // Base-tier accuracy/hull/speed and no armor/shields keep every AI
        // ship cheap, so a 3-ship fleet fits comfortably under any lobby's
        // cost limit.
        if (_index == 0) {
            s.equipment = Equipment({
                mainWeapon: MainWeapon.Laser,
                armor: Armor.None,
                shields: Shields.None,
                special: Special.EMP
            });
        } else if (_index == 1) {
            s.equipment = Equipment({
                mainWeapon: MainWeapon.Railgun,
                armor: Armor.None,
                shields: Shields.None,
                special: Special.RepairDrones
            });
        } else {
            s.equipment = Equipment({
                mainWeapon: MainWeapon.MissileLauncher,
                armor: Armor.Light,
                shields: Shields.None,
                special: Special.FlakArray
            });
        }
    }

    // Moves every one of the AI's currently-unmoved ships in this round (the
    // turn only stays with the AI across consecutive ship moves when the
    // other side has none left to move, but handling that case here means a
    // caller never has to retry in a loop off-chain). Permissionless: a
    // frontend fires this right after the human's moveShip confirms.
    function takeAITurn(uint _gameId) external {
        GameDataView memory g = game.getGame(_gameId);
        if (g.metadata.ended) revert GameEnded();
        if (g.turnState.currentTurn != address(this)) revert NotAITurn();

        for (uint i = 0; i < MAX_SHIP_MOVES_PER_CALL; i++) {
            bool isCreator = g.metadata.creator == address(this);
            uint shipId = _findUnmovedShip(g, isCreator);
            if (shipId == 0) break;

            _takeShipTurn(_gameId, g, shipId, isCreator);

            g = game.getGame(_gameId);
            if (g.metadata.ended || g.turnState.currentTurn != address(this))
                break;
        }
    }

    function _takeShipTurn(
        uint _gameId,
        GameDataView memory g,
        uint _shipId,
        bool _isCreator
    ) internal {
        (
            int16 destRow,
            int16 destCol,
            ActionType action,
            uint actionTarget
        ) = _decideMove(_gameId, g, _shipId, _isCreator);

        game.moveShip(_gameId, _shipId, destRow, destCol, action, actionTarget);
        emit AITurnTaken(_gameId, _shipId, action, actionTarget);
    }

    function _decideMove(
        uint _gameId,
        GameDataView memory g,
        uint _shipId,
        bool _isCreator
    )
        internal
        view
        returns (
            int16 destRow,
            int16 destCol,
            ActionType action,
            uint actionTarget
        )
    {
        Position memory myPos = _findPosition(g, _shipId);
        Attributes memory myAttrs = _attributesFor(g, _shipId);

        (
            uint targetId,
            Position memory targetPos,
            bool reachable,
            bool found
        ) = _selectTarget(
                g,
                _isCreator,
                myPos,
                myAttrs.movement,
                myAttrs.range
            );

        destRow = myPos.row;
        destCol = myPos.col;
        action = ActionType.Pass;

        if (!found) {
            return (destRow, destCol, action, actionTarget);
        }

        if (reachable) {
            if (!(myPos.row == targetPos.row && myPos.col == targetPos.col)) {
                (destRow, destCol) = _stepToward(
                    myPos,
                    targetPos,
                    myAttrs.movement
                );
            }
            if (
                _canShootFrom(_gameId, destRow, destCol, targetPos, myAttrs.range)
            ) {
                action = ActionType.Shoot;
                actionTarget = targetId;
            }
        } else {
            (destRow, destCol) = _stepToward(myPos, targetPos, myAttrs.movement);
        }
    }

    function _canShootFrom(
        uint _gameId,
        int16 _row,
        int16 _col,
        Position memory _targetPos,
        uint8 _range
    ) internal view returns (bool) {
        uint8 distance = _manhattan(
            Position({row: _row, col: _col}),
            _targetPos
        );
        if (distance > _range) return false;
        if (distance <= 1) return true;
        return
            maps.hasMaps(_gameId, _row, _col, _targetPos.row, _targetPos.col);
    }

    function _findUnmovedShip(
        GameDataView memory g,
        bool _isCreator
    ) internal pure returns (uint) {
        uint[] memory active = _isCreator
            ? g.creatorActiveShipIds
            : g.joinerActiveShipIds;
        uint[] memory moved = _isCreator
            ? g.creatorMovedShipIds
            : g.joinerMovedShipIds;

        for (uint i = 0; i < active.length; i++) {
            bool hasMoved = false;
            for (uint j = 0; j < moved.length; j++) {
                if (moved[j] == active[i]) {
                    hasMoved = true;
                    break;
                }
            }
            if (!hasMoved) return active[i];
        }
        return 0;
    }

    function _findPosition(
        GameDataView memory g,
        uint _shipId
    ) internal pure returns (Position memory) {
        for (uint i = 0; i < g.shipPositions.length; i++) {
            if (g.shipPositions[i].shipId == _shipId) {
                return g.shipPositions[i].position;
            }
        }
        revert ShipDataNotFound();
    }

    function _attributesFor(
        GameDataView memory g,
        uint _shipId
    ) internal pure returns (Attributes memory) {
        for (uint i = 0; i < g.shipIds.length; i++) {
            if (g.shipIds[i] == _shipId) {
                return g.shipAttributes[i];
            }
        }
        revert ShipDataNotFound();
    }

    // Picks a target among currently-alive enemy ships: prefers the lowest-HP
    // enemy reachable this turn (move budget + weapon range combined), and
    // falls back to the nearest enemy overall (to move toward, without
    // shooting) if none are reachable yet.
    function _selectTarget(
        GameDataView memory g,
        bool _isCreator,
        Position memory _from,
        uint8 _movement,
        uint8 _range
    )
        internal
        pure
        returns (
            uint targetId,
            Position memory targetPos,
            bool reachable,
            bool found
        )
    {
        uint16 reach = uint16(_movement) + uint16(_range);
        (targetId, targetPos, reachable) = _bestReachableEnemy(
            g,
            _isCreator,
            _from,
            reach
        );
        if (reachable) {
            found = true;
            return (targetId, targetPos, reachable, found);
        }
        (targetId, targetPos, found) = _nearestEnemy(g, _isCreator, _from);
    }

    function _bestReachableEnemy(
        GameDataView memory g,
        bool _isCreator,
        Position memory _from,
        uint16 _reach
    )
        internal
        pure
        returns (uint targetId, Position memory targetPos, bool found)
    {
        uint8 bestHp;
        uint8 bestDistance;
        for (uint i = 0; i < g.shipPositions.length; i++) {
            ShipPosition memory sp = g.shipPositions[i];
            if (sp.status != 0 || sp.isCreator == _isCreator) continue;
            Attributes memory attrs = _attributesFor(g, sp.shipId);
            if (attrs.hullPoints == 0) continue;
            uint8 distance = _manhattan(_from, sp.position);
            if (uint16(distance) > _reach) continue;
            if (
                !found ||
                attrs.hullPoints < bestHp ||
                (attrs.hullPoints == bestHp && distance < bestDistance)
            ) {
                found = true;
                bestHp = attrs.hullPoints;
                bestDistance = distance;
                targetId = sp.shipId;
                targetPos = sp.position;
            }
        }
    }

    function _nearestEnemy(
        GameDataView memory g,
        bool _isCreator,
        Position memory _from
    )
        internal
        pure
        returns (uint targetId, Position memory targetPos, bool found)
    {
        uint8 bestDistance;
        for (uint i = 0; i < g.shipPositions.length; i++) {
            ShipPosition memory sp = g.shipPositions[i];
            if (sp.status != 0 || sp.isCreator == _isCreator) continue;
            Attributes memory attrs = _attributesFor(g, sp.shipId);
            if (attrs.hullPoints == 0) continue;
            uint8 distance = _manhattan(_from, sp.position);
            if (!found || distance < bestDistance) {
                found = true;
                bestDistance = distance;
                targetId = sp.shipId;
                targetPos = sp.position;
            }
        }
    }

    // Greedily moves toward `_target` by up to `_movement` Manhattan steps,
    // never overshooting (so it always lands strictly between `_from` and
    // `_target`, and therefore always stays in-bounds). Doesn't check for
    // occupied destination cells — landing on one just rams (Game.sol
    // silently converts the action to Pass), which never reverts.
    function _stepToward(
        Position memory _from,
        Position memory _target,
        uint8 _movement
    ) internal pure returns (int16 destRow, int16 destCol) {
        int16 rowDiff = _target.row - _from.row;
        int16 colDiff = _target.col - _from.col;
        uint16 budget = uint16(_movement);

        uint16 rowAbs = uint16(rowDiff >= 0 ? rowDiff : -rowDiff);
        uint16 colAbs = uint16(colDiff >= 0 ? colDiff : -colDiff);

        uint16 rowStep;
        uint16 colStep;

        if (rowAbs >= colAbs) {
            rowStep = rowAbs < budget ? rowAbs : budget;
            budget -= rowStep;
            colStep = colAbs < budget ? colAbs : budget;
        } else {
            colStep = colAbs < budget ? colAbs : budget;
            budget -= colStep;
            rowStep = rowAbs < budget ? rowAbs : budget;
        }

        destRow = rowDiff >= 0
            ? _from.row + int16(rowStep)
            : _from.row - int16(rowStep);
        destCol = colDiff >= 0
            ? _from.col + int16(colStep)
            : _from.col - int16(colStep);
    }

    // Ships are ERC-721 tokens minted directly to this contract (its own AI
    // fleet), so it must accept them via the safe-transfer receiver hook.
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function _manhattan(
        Position memory a,
        Position memory b
    ) internal pure returns (uint8) {
        int16 rowDiff = a.row >= b.row ? a.row - b.row : b.row - a.row;
        int16 colDiff = a.col >= b.col ? a.col - b.col : b.col - a.col;
        return uint8(uint16(rowDiff) + uint16(colDiff));
    }
}

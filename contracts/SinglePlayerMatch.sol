// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Types.sol";
import "./Ships.sol";
import "./Lobbies.sol";
import "./Game.sol";
import "./IGameOrchestrator.sol";

// Plays single-player matches as an on-chain opponent. A human creates a
// normal Lobbies lobby reserved for this contract's address; this contract
// accepts it (acceptMatch) and builds its own fleet (setupAIFleet) through
// the exact same Lobbies flow a human would use — fees, timeouts, and fleet
// creation are all shared with PvP, per Lobbies.isSinglePlayerOrchestrator.
// Once both fleets are set, Lobbies calls this contract's startGame, which
// forwards straight to core Game.sol, exactly like PvPMatch does for PvP.
contract SinglePlayerMatch is Ownable, IGameOrchestrator, IERC721Receiver {
    Ships public ships;
    Lobbies public lobbies;
    Game public game;

    // Safety bound on how many of the AI's ships takeAITurn will move in a
    // single call; generous headroom over AI_FLEET_SIZE.
    uint private constant MAX_SHIP_MOVES_PER_CALL = 12;
    uint8 private constant AI_FLEET_SIZE = 3;

    error NotLobbiesContract();
    error NotGame();
    error NotInLobby();
    error LobbyNotReadyForFleet();
    error GameEnded();
    error NotAITurn();
    error ShipDataNotFound();

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
        address _game
    ) Ownable(msg.sender) {
        ships = Ships(_ships);
        lobbies = Lobbies(_lobbies);
        game = Game(_game);
    }

    function setLobbiesAddress(address _lobbies) external onlyOwner {
        lobbies = Lobbies(_lobbies);
    }

    function setGameAddress(address _game) external onlyOwner {
        game = Game(_game);
    }

    // Accepts a lobby reservation naming this contract as the joiner.
    // Permissionless — anyone can trigger it once the human has reserved a
    // lobby for this contract; there's no funds/state at risk in doing so.
    function acceptMatch(uint _lobbyId) external {
        lobbies.acceptGame(_lobbyId);
    }

    // Mints a fresh, fully-constructed fleet for this contract and registers
    // it with Lobbies. Permissionless, same reasoning as acceptMatch. A new
    // fleet is minted per match rather than reusing a persistent roster
    // (destroyed ships stay permanently locked in this game, so there's
    // nothing to reuse between matches).
    function setupAIFleet(uint _lobbyId) external returns (uint fleetId) {
        Lobby memory lobby = lobbies.getLobby(_lobbyId);
        if (lobby.players.joiner != address(this)) revert NotInLobby();
        if (lobby.state.status != LobbyStatus.FleetSelection)
            revert LobbyNotReadyForFleet();

        uint[] memory shipIds = new uint[](AI_FLEET_SIZE);
        Position[] memory positions = new Position[](AI_FLEET_SIZE);

        for (uint8 i = 0; i < AI_FLEET_SIZE; i++) {
            shipIds[i] = ships.createSpecificShip(
                address(this),
                _buildAIShipTemplate(i)
            );
            // Joiner ships must sit in columns 13-16 (Fleets.createFleet's
            // position validation) — the AI is always the joiner.
            positions[i] = Position({row: int16(uint16(i)), col: 16});
        }

        lobbies.createFleet(_lobbyId, shipIds, positions);

        lobby = lobbies.getLobby(_lobbyId);
        fleetId = lobby.players.joinerFleetId;
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

    // Called by Lobbies once both sides' fleets are set; forwards straight
    // through to core Game.sol, exactly like PvPMatch.startGame.
    function startGame(
        uint _lobbyId,
        address _creator,
        address _joiner,
        uint _creatorFleetId,
        uint _joinerFleetId,
        bool _creatorGoesFirst,
        uint _turnTime,
        uint _selectedMapId,
        uint _maxScore
    ) external {
        if (msg.sender != address(lobbies)) revert NotLobbiesContract();
        game.startGame(
            _lobbyId,
            _creator,
            _joiner,
            _creatorFleetId,
            _joinerFleetId,
            _creatorGoesFirst,
            _turnTime,
            _selectedMapId,
            _maxScore
        );
    }

    // Moves every one of the AI's currently-unmoved ships in this round (the
    // turn only stays with the AI across consecutive ship moves when the
    // human has none left to move, but handling that case here means a
    // caller never has to retry in a loop off-chain). Permissionless: a
    // frontend fires this right after the human's moveShip confirms.
    //
    // v0 scripted behavior per ship (deliberately simple/placeholder, not a
    // heuristic — more specific rules to come later):
    //   1. If a player ship already occupies the square one column to the
    //      left, stay and fire at it.
    //   2. Otherwise, if not already in column 0, move one square left; if a
    //      player ship is now one column to the left of the new position,
    //      fire at it; otherwise just move.
    //   3. Otherwise (already in column 0, nothing adjacent), Pass.
    function takeAITurn(uint _gameId) external {
        GameDataView memory g = game.getGame(_gameId);
        if (g.metadata.ended) revert GameEnded();
        if (g.turnState.currentTurn != address(this)) revert NotAITurn();

        for (uint i = 0; i < MAX_SHIP_MOVES_PER_CALL; i++) {
            uint shipId = _findUnmovedShip(g);
            if (shipId == 0) break;

            _takeShipTurn(_gameId, g, shipId);

            g = game.getGame(_gameId);
            if (g.metadata.ended || g.turnState.currentTurn != address(this))
                break;
        }
    }

    function _takeShipTurn(
        uint _gameId,
        GameDataView memory g,
        uint _shipId
    ) internal {
        (
            int16 destRow,
            int16 destCol,
            ActionType action,
            uint actionTarget
        ) = _decideMove(g, _shipId);

        game.moveShip(_gameId, _shipId, destRow, destCol, action, actionTarget);
        emit AITurnTaken(_gameId, _shipId, action, actionTarget);
    }

    function _decideMove(
        GameDataView memory g,
        uint _shipId
    )
        internal
        pure
        returns (
            int16 destRow,
            int16 destCol,
            ActionType action,
            uint actionTarget
        )
    {
        Position memory myPos = _findPosition(g, _shipId);
        destRow = myPos.row;
        destCol = myPos.col;
        action = ActionType.Pass;

        // Case 1: a player ship already occupies the square one column left
        (uint adjacentEnemy, bool adjacentFound) = _findEnemyAt(
            g,
            myPos.row,
            myPos.col - 1
        );
        if (adjacentFound) {
            action = ActionType.Shoot;
            actionTarget = adjacentEnemy;
            return (destRow, destCol, action, actionTarget);
        }

        // Case 3: already at the left edge, nothing to do
        if (myPos.col == 0) {
            return (destRow, destCol, action, actionTarget);
        }

        // Case 2: move one square left, then fire if a player ship is now
        // one column to the left of the new position
        destCol = myPos.col - 1;
        (uint newAdjacentEnemy, bool newAdjacentFound) = _findEnemyAt(
            g,
            destRow,
            destCol - 1
        );
        if (newAdjacentFound) {
            action = ActionType.Shoot;
            actionTarget = newAdjacentEnemy;
        }
    }

    // Finds an alive, enemy (non-AI-owned) ship at the exact given position.
    function _findEnemyAt(
        GameDataView memory g,
        int16 _row,
        int16 _col
    ) internal pure returns (uint shipId, bool found) {
        for (uint i = 0; i < g.shipPositions.length; i++) {
            ShipPosition memory sp = g.shipPositions[i];
            // The AI is always the joiner, so enemy ships are always the
            // creator's (isCreator == true).
            if (sp.status != 0 || !sp.isCreator) continue;
            if (sp.position.row == _row && sp.position.col == _col) {
                return (sp.shipId, true);
            }
        }
        return (0, false);
    }

    function _findUnmovedShip(
        GameDataView memory g
    ) internal pure returns (uint) {
        uint[] memory active = g.joinerActiveShipIds;
        uint[] memory moved = g.joinerMovedShipIds;

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

    // IGameOrchestrator: called by core Game.sol whenever a session this
    // contract started ends. No leaderboard/fleet bookkeeping needed here —
    // fleet cleanup already happens unconditionally inside core
    // Game._endGame; single-player result tracking is a separate concern for
    // later.
    function onGameEnded(uint, address, address) external view {
        if (msg.sender != address(game)) revert NotGame();
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
}

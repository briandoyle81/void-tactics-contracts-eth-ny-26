// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Types.sol";
import "./Ships.sol";
import "./Lobbies.sol";
import "./Game.sol";
import "./IGameOrchestrator.sol";
import "./AIEncounters.sol";
import "./IMaps.sol";
import "./IShipAttributes.sol";
import "./AIBehavior.sol";

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
    AIEncounters public aiEncounters;
    IMaps public maps;
    IShipAttributes public shipAttributes;

    // Static per-ship info cached at setupAIFleet mint time (from the same
    // AIShipConfig already fetched there), so takeAITurn's decision engine
    // never needs an extra Ships/AIEncounters call mid-turn to learn what
    // archetype/faction/special a ship has.
    struct AIShipInfo {
        Archetype archetype;
        uint16 variant;
        Special special;
    }
    mapping(uint => AIShipInfo) public aiShipInfo;

    error NotLobbiesContract();
    error NotGame();
    error NotInLobby();
    error LobbyNotReadyForFleet();
    error GameEnded();
    error NotAITurn();
    error NoAIPlacementsConfigured();

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
        address _aiEncounters,
        address _maps,
        address _shipAttributes
    ) Ownable(msg.sender) {
        ships = Ships(_ships);
        lobbies = Lobbies(_lobbies);
        game = Game(_game);
        aiEncounters = AIEncounters(_aiEncounters);
        maps = IMaps(_maps);
        shipAttributes = IShipAttributes(_shipAttributes);
    }

    function setLobbiesAddress(address _lobbies) external onlyOwner {
        lobbies = Lobbies(_lobbies);
    }

    function setGameAddress(address _game) external onlyOwner {
        game = Game(_game);
    }

    function setAIEncountersAddress(address _aiEncounters) external onlyOwner {
        aiEncounters = AIEncounters(_aiEncounters);
    }

    function setMapsAddress(address _maps) external onlyOwner {
        maps = IMaps(_maps);
    }

    function setShipAttributesAddress(
        address _shipAttributes
    ) external onlyOwner {
        shipAttributes = IShipAttributes(_shipAttributes);
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
    //
    // Fleet composition/placement is driven entirely by AIEncounters: an
    // admin-curated row/col -> AIShipConfig mapping for the lobby's selected
    // preset map (contracts/AIEncounters.sol), rather than a hardcoded
    // template. Fleet size is therefore dynamic (1-8 ships, whatever the
    // map's admin configured) instead of always exactly 3. A map with no
    // configured placements — including selectedMapId == 0 — reverts rather
    // than silently falling back to a default fleet, matching this
    // codebase's established "fail loud on unconfigured admin data"
    // precedent (see ShipAttributes' unconfigured-variant reverts).
    function setupAIFleet(uint _lobbyId) external returns (uint fleetId) {
        Lobby memory lobby = lobbies.getLobby(_lobbyId);
        if (lobby.players.joiner != address(this)) revert NotInLobby();
        if (lobby.state.status != LobbyStatus.FleetSelection)
            revert LobbyNotReadyForFleet();

        (Position[] memory positions, uint[] memory configIds) = aiEncounters
            .getMapPlacements(lobby.gameConfig.selectedMapId);
        if (positions.length == 0) revert NoAIPlacementsConfigured();

        uint[] memory shipIds = new uint[](positions.length);
        for (uint i = 0; i < positions.length; i++) {
            AIEncounters.AIShipConfig memory config = aiEncounters
                .getAIShipConfig(configIds[i]);
            shipIds[i] = ships.createSpecificShip(
                address(this),
                _buildAIShipFromConfig(config)
            );
            aiShipInfo[shipIds[i]] = AIShipInfo({
                archetype: config.archetype,
                variant: config.traits.variant,
                special: config.equipment.special
            });
        }

        lobbies.createFleet(_lobbyId, shipIds, positions);

        lobby = lobbies.getLobby(_lobbyId);
        fleetId = lobby.players.joinerFleetId;
        emit AIFleetCreated(_lobbyId, fleetId);
    }

    function _buildAIShipFromConfig(
        AIEncounters.AIShipConfig memory _config
    ) internal view returns (Ship memory s) {
        s.name = _config.name;
        s.owner = address(this);
        s.equipment = _config.equipment;
        s.traits = _config.traits;
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

    // Moves exactly one of the AI's currently-unmoved ships. Permissionless:
    // a frontend fires this right after the human's moveShip confirms. When
    // the AI has more ships left to move than the human this round (turn
    // order alternates ship-by-ship, but stays with whichever side still has
    // unmoved ships once the other side runs out), the turn stays with the
    // AI after this call returns — the caller is expected to call
    // takeAITurn again, once per remaining AI ship, exactly like the human
    // fires one moveShip transaction per ship. This keeps every call's gas
    // cost to "decide and move one ship" instead of scaling with fleet size.
    //
    // Decision-making is delegated to AIBehavior, dispatched by the ship's
    // cached archetype (see decideMove below). Only fetches Maps' scoring
    // tile positions when this ship is actually Turtle-archetype and would
    // use them — every other archetype never touches it.
    function takeAITurn(uint _gameId) external {
        GameDataView memory g = game.getGame(_gameId);
        if (g.metadata.ended) revert GameEnded();
        if (g.turnState.currentTurn != address(this)) revert NotAITurn();

        uint shipId = _findUnmovedShip(g);
        if (shipId == 0) return;

        _takeShipTurn(_gameId, g, shipId);
    }

    function _takeShipTurn(
        uint _gameId,
        GameDataView memory g,
        uint _shipId
    ) internal {
        AIBehavior.Decision memory d = _decideMove(_gameId, g, _shipId);

        // Defense in depth: a heuristic bug or an edge case the rules
        // didn't anticipate should degrade to "this ship does nothing this
        // turn," not abort every other ship's move in this same call.
        try
            game.moveShip(
                _gameId,
                _shipId,
                d.destRow,
                d.destCol,
                d.action,
                d.actionTarget
            )
        {
            emit AITurnTaken(_gameId, _shipId, d.action, d.actionTarget);
        } catch {
            (Position memory myPos, bool found) = AIBehavior.findPosition(
                g,
                _shipId
            );
            if (found) {
                try
                    game.moveShip(
                        _gameId,
                        _shipId,
                        myPos.row,
                        myPos.col,
                        ActionType.Pass,
                        0
                    )
                {
                    emit AITurnTaken(_gameId, _shipId, ActionType.Pass, 0);
                } catch {}
            }
        }
    }

    function _decideMove(
        uint _gameId,
        GameDataView memory g,
        uint _shipId
    ) internal view returns (AIBehavior.Decision memory d) {
        (Position memory myPos, bool posFound) = AIBehavior.findPosition(
            g,
            _shipId
        );
        (Attributes memory myAttrs, bool attrsFound) = AIBehavior
            .findAttributes(g, _shipId);
        if (!posFound || !attrsFound) {
            d.destRow = myPos.row;
            d.destCol = myPos.col;
            d.action = ActionType.Pass;
            return d;
        }

        AIShipInfo memory info = aiShipInfo[_shipId];
        AIBehavior.Ctx memory ctx = AIBehavior.Ctx({
            g: g,
            maps: maps,
            gameId: _gameId,
            shipId: _shipId,
            pos: myPos,
            attrs: myAttrs
        });

        if (info.archetype == Archetype.Sniper) {
            return
                AIBehavior.decideSniper(
                    ctx,
                    game.GRID_HEIGHT(),
                    game.GRID_WIDTH()
                );
        } else if (info.archetype == Archetype.Support) {
            return
                AIBehavior.decideSupport(
                    ctx,
                    shipAttributes,
                    info.special,
                    info.variant
                );
        } else if (info.archetype == Archetype.Turtle) {
            ScoringPosition[] memory scoringPositions = maps
                .getGameScoringPositions(_gameId);
            return AIBehavior.decideTurtle(ctx, scoringPositions);
        } else if (info.archetype == Archetype.Rammer) {
            return AIBehavior.decideRammer(ctx, info.variant);
        }
        // Grunt and Aggressor (and the default for any future archetype
        // value not yet handled above) share the same engage-or-approach
        // logic — see AIBehavior's header comment on why.
        return AIBehavior.decideEngageOrApproach(ctx);
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

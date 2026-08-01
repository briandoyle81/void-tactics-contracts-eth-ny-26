// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./AIShips.sol";
import "./Lobbies.sol";
import "./Game.sol";
import "./IGameOrchestrator.sol";
import "./AIEncounters.sol";
import "./IMaps.sol";
import "./IShipAttributes.sol";
import "./AIBehavior.sol";
import "./IUniversalCredits.sol";
import "./NodeMap.sol";
import "./IFleets.sol";

// Plays single-player matches as an on-chain opponent. Players enter via a
// node-graph campaign (NodeMap) rather than the Lobbies UI: startNodeMatch
// mints both fleets directly through Fleets and kicks off Game.sol in one
// call, with no lobby involved. gameId is offset into a range disjoint from
// Lobbies-sourced (PvP) game ids so the two id spaces never collide (see
// NODE_MATCH_ID_OFFSET). `lobbies` is kept only as a legacy reference —
// nothing in this flow depends on it.
contract SinglePlayerMatch is Ownable, IGameOrchestrator {
    AIShips public ships;
    Lobbies public lobbies;
    Game public game;
    AIEncounters public aiEncounters;
    IMaps public maps;
    IShipAttributes public shipAttributes;
    IUniversalCredits public universalCredits;
    NodeMap public nodeMap;
    IFleets public fleets;

    // Node-match game ids live in a disjoint range above Lobbies.lobbyCount
    // (PvP's id source), so Game.sol's gameId == lobbyId scheme can never
    // collide between a PvP game and a node-match game. 2**40 (~1.1T) is
    // comfortably past any realistic lobbyCount while staying ~8,192x under
    // Number.MAX_SAFE_INTEGER (2**53-1) — frontend code that treats gameId
    // as a JS number (rather than bigint) needs this to stay exact.
    // Public (unlike before) so the frontend has a documented, contract-
    // read way to tell a node-match gameId from a PvP one if it ever needs
    // that without already knowing from context which flow started it.
    uint public constant NODE_MATCH_ID_OFFSET = 2 ** 40;
    uint public nodeMatchCount;
    mapping(uint => uint) public gameIdToNodeId;
    mapping(uint => address) public gameIdToHuman;
    // Full AI roster minted for a game, recorded at mint time so it can be
    // released back to AIShips' pool as a whole at game end — surviving
    // *and* destroyed ships alike, since destroyed ships are spliced out of
    // Game.sol's playerActiveShipIds mid-match and can't be reconstructed
    // from that set alone.
    mapping(uint => uint[]) public gameIdToAiShipIds;

    // Static per-ship info cached at setupAIFleet mint time (from the same
    // AIShipConfig already fetched there), so takeAITurn's decision engine
    // never needs an extra Ships/AIEncounters call mid-turn to learn what
    // archetype/faction/special a ship has.
    struct AIShipInfo {
        Archetype archetype;
        uint16 variant;
        Special special;
        MainWeapon mainWeapon;
    }
    mapping(uint => AIShipInfo) public aiShipInfo;

    error NotGame();
    error GameEnded();
    error NotAITurn();
    error NoAIPlacementsConfigured();
    error NodeNotUnlocked();

    event AIFleetCreated(uint indexed gameId, uint fleetId);
    event NodeMatchStarted(
        uint indexed gameId,
        uint indexed nodeId,
        address indexed human
    );
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
        address _shipAttributes,
        address _nodeMap,
        address _fleets
    ) Ownable(msg.sender) {
        ships = AIShips(_ships);
        lobbies = Lobbies(_lobbies);
        game = Game(_game);
        aiEncounters = AIEncounters(_aiEncounters);
        maps = IMaps(_maps);
        shipAttributes = IShipAttributes(_shipAttributes);
        nodeMap = NodeMap(_nodeMap);
        fleets = IFleets(_fleets);
    }

    function setLobbiesAddress(address _lobbies) external onlyOwner {
        lobbies = Lobbies(_lobbies);
    }

    // Lets a future AIShips pool (with a higher AI_SHIP_ID_OFFSET) be
    // swapped in without redeploying this contract — see Game.setAddresses
    // for why this matters.
    function setShipsAddress(address _ships) external onlyOwner {
        ships = AIShips(_ships);
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

    function setUniversalCreditsAddress(
        address _universalCredits
    ) external onlyOwner {
        universalCredits = IUniversalCredits(_universalCredits);
    }

    function setNodeMapAddress(address _nodeMap) external onlyOwner {
        nodeMap = NodeMap(_nodeMap);
    }

    function setFleetsAddress(address _fleets) external onlyOwner {
        fleets = IFleets(_fleets);
    }

    // The AI's own ships are owned by address(this), so whenever the AI
    // destroys a human ship, ShipsRouter.setTimestampDestroyed's kill reward
    // mints UTC here (unlike a human destroying an AI ship, which now pays
    // out in DEC instead — see DestroyRewardLib) with no way for this
    // contract to otherwise spend or move it. Lets the owner claim it out.
    function withdrawUC() external onlyOwner {
        uint balance = universalCredits.balanceOf(address(this));
        require(
            universalCredits.transfer(owner(), balance),
            "UC withdrawal failed"
        );
    }

    // Entry point into a vs-AI match: no Lobbies involved. _nodeId must be
    // unlocked for msg.sender (NodeMap.isNodeUnlocked — a root node, or any
    // one of its prerequisites already completed by this player). Every
    // other parameter of the match (map, fleet cost ceiling, turn time, max
    // score, who goes first) is curated on the node itself rather than
    // player-supplied, matching how AIEncounters already curates AI
    // loadouts per map — a campaign node is a fixed, pre-designed encounter.
    function startNodeMatch(
        uint _nodeId,
        uint[] calldata _shipIds,
        Position[] calldata _positions
    ) external returns (uint gameId) {
        if (!nodeMap.isNodeUnlocked(msg.sender, _nodeId))
            revert NodeNotUnlocked();

        NodeMap.CampaignNode memory node = nodeMap.getNode(_nodeId);

        nodeMatchCount++;
        gameId = NODE_MATCH_ID_OFFSET + nodeMatchCount;

        uint humanFleetId = fleets.createFleet(
            gameId,
            msg.sender,
            _shipIds,
            _positions,
            node.costLimit,
            true
        );

        uint aiFleetId = _mintAIFleet(node.mapId, gameId);

        gameIdToNodeId[gameId] = _nodeId;
        gameIdToHuman[gameId] = msg.sender;

        game.startGame(
            gameId,
            msg.sender,
            address(this),
            humanFleetId,
            aiFleetId,
            node.creatorGoesFirst,
            node.turnTime,
            node.mapId,
            node.maxScore
        );

        emit NodeMatchStarted(gameId, _nodeId, msg.sender);
    }

    // Allocates a fleet from AIShips' pool for this contract and registers
    // it with Fleets directly. Ships come from AIShips.allocateShip, which
    // reuses a slot released by a previously-finished match (see
    // onGameEnded/releaseShips below) when one is available, rather than
    // minting a fresh token every match.
    //
    // Fleet composition/placement is driven entirely by AIEncounters: an
    // admin-curated row/col -> AIShipConfig mapping for the node's map
    // (contracts/AIEncounters.sol), rather than a hardcoded template. Fleet
    // size is therefore dynamic (1-8 ships, whatever the map's admin
    // configured) instead of always exactly 3. A map with no configured
    // placements reverts rather than silently falling back to a default
    // fleet, matching this codebase's established "fail loud on
    // unconfigured admin data" precedent (see ShipAttributes' unconfigured-
    // variant reverts).
    //
    // Deliberately NOT capped by node.costLimit (or anything else) — that
    // limit exists to constrain the human's own fleet-building choices, not
    // to second-guess what an admin curated for an encounter. An admin
    // should be free to place a fleet that's arbitrarily expensive relative
    // to the node's costLimit; node.enemyThreat is purely descriptive
    // reference for that curation, never enforced here.
    function _mintAIFleet(
        uint _mapId,
        uint _gameId
    ) internal returns (uint fleetId) {
        (Position[] memory positions, uint[] memory configIds) = aiEncounters
            .getMapPlacements(_mapId);
        if (positions.length == 0) revert NoAIPlacementsConfigured();

        uint[] memory shipIds = new uint[](positions.length);
        for (uint i = 0; i < positions.length; i++) {
            AIEncounters.AIShipConfig memory config = aiEncounters
                .getAIShipConfig(configIds[i]);
            shipIds[i] = ships.allocateShip(
                address(this),
                _buildAIShipFromConfig(config)
            );
            aiShipInfo[shipIds[i]] = AIShipInfo({
                archetype: config.archetype,
                variant: config.traits.variant,
                special: config.equipment.special,
                mainWeapon: config.equipment.mainWeapon
            });
        }
        gameIdToAiShipIds[_gameId] = shipIds;

        fleetId = fleets.createFleet(
            _gameId,
            address(this),
            shipIds,
            positions,
            type(uint).max,
            false
        );
        emit AIFleetCreated(_gameId, fleetId);
    }

    function _buildAIShipFromConfig(
        AIEncounters.AIShipConfig memory _config
    ) internal view returns (Ship memory s) {
        s.name = _config.name;
        s.owner = address(this);
        s.equipment = _config.equipment;
        s.traits = _config.traits;
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

        // If every one of the AI's remaining ships is at 0 HP (destroyed in
        // combat but still mid the 3-round reactor-critical grace period —
        // see Game.sol's shipsWithZeroHP), it has nothing left it can
        // meaningfully do. Moving on would just repeat the deadlock this
        // whole function used to hit: round-completion/turn-switching only
        // run inside a *successful* moveShip call, and nothing else can
        // trigger one while it's still the AI's turn — a human can always
        // manually Retreat their own last 0-HP ship, but the AI has no
        // decision to make there, so just surrender instead. Same mechanism
        // PvPMatch uses for a human flee/timeout — SinglePlayerMatch is the
        // orchestrator of its own games (Game.startGame set it at kickoff),
        // so it's equally entitled to call forceEndSession.
        if (!_hasAnyLiveShip(g)) {
            game.forceEndSession(_gameId, g.metadata.creator, address(this));
            return;
        }

        uint shipId = _findUnmovedShip(g);
        if (shipId == 0) return;

        _takeShipTurn(_gameId, g, shipId);
    }

    function _hasAnyLiveShip(
        GameDataView memory g
    ) internal pure returns (bool) {
        for (uint i = 0; i < g.joinerActiveShipIds.length; i++) {
            (Attributes memory attrs, bool found) = AIBehavior.findAttributes(
                g,
                g.joinerActiveShipIds[i]
            );
            if (found && attrs.hullPoints > 0) return true;
        }
        return false;
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
            attrs: myAttrs,
            mainWeapon: info.mainWeapon,
            scoringPositions: maps.getGameScoringPositions(_gameId),
            gridWidth: game.GRID_WIDTH(),
            gridHeight: game.GRID_HEIGHT()
        });

        if (info.archetype == Archetype.Sniper) {
            return AIBehavior.decideSniper(ctx);
        } else if (info.archetype == Archetype.Support) {
            return
                AIBehavior.decideSupport(
                    ctx,
                    shipAttributes,
                    info.special,
                    info.variant
                );
        } else if (info.archetype == Archetype.Turtle) {
            return AIBehavior.decideTurtle(ctx);
        }
        // Grunt and Aggressor share this engage-or-approach logic — see
        // AIBehavior's header comment on why. Rammer has no AI decision
        // path (the AI never rams; player-controlled Rammer ships are
        // unaffected — see RamResolver), so it falls through to the same
        // default as any future archetype not yet handled above.
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
            if (hasMoved) continue;

            // A 0-HP ship's only legal moveShip action is Retreat (see
            // Game.sol's hullPoints==0 guard) — _takeShipTurn never
            // attempts that, so picking it here would revert every time
            // and this ship would never enter joinerMovedShipIds. Since
            // this loop always returns the *first* unmoved ship, that
            // would permanently block every other ship behind it too,
            // and — because currentTurn only advances inside a
            // successful moveShip — deadlock the whole match. Game.sol's
            // own round-completion math already treats a 0-HP ship as
            // accounted for without requiring it to move (shipsWithZeroHP
            // / _setShipHPToZero), so mirror that here: skip it and keep
            // looking for a ship that can actually act.
            (Attributes memory attrs, bool found) = AIBehavior.findAttributes(
                g,
                active[i]
            );
            if (found && attrs.hullPoints == 0) continue;

            return active[i];
        }
        return 0;
    }

    // IGameOrchestrator: called by core Game.sol whenever a session this
    // contract started ends. Fleet cleanup already happens unconditionally
    // inside core Game._endGame. Releases this game's full AI roster back
    // to AIShips' pool exactly once here — win, loss, or draw — rather than
    // per-ship-destroyed mid-match, so a slot is never touched while its
    // game might still reference it. If this was a node match and the
    // human won, also records the node as completed so it counts as a
    // prerequisite for unlocking other nodes — never on an AI win or draw.
    function onGameEnded(uint _gameId, address _winner, address) external {
        if (msg.sender != address(game)) revert NotGame();

        ships.releaseShips(gameIdToAiShipIds[_gameId]);
        delete gameIdToAiShipIds[_gameId];

        uint nodeId = gameIdToNodeId[_gameId];
        if (nodeId != 0 && _winner == gameIdToHuman[_gameId]) {
            nodeMap.recordCompletion(_winner, nodeId);
        }
    }

    // ILobbiesOrchestratorCheck: ShipsRouter.setTimestampDestroyed (via
    // DestroyRewardLib) calls this — through config.lobbyAddress, now
    // pointed at this contract instead of Lobbies — to tell an AI-owned
    // ship from a player-owned one. AI ships are always allocated to
    // address(this) (see _mintAIFleet), so a plain identity check replaces
    // Lobbies' old address=>bool mapping exactly.
    function isSinglePlayerOrchestrator(
        address _address
    ) external view returns (bool) {
        return _address == address(this);
    }
}

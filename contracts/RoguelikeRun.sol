// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

enum RunStatus {
    None,
    Active,
    Won,
    Ended
}

struct Run {
    RunStatus status;
    // Bumped on every startRun for this player. shipHP/locked below are
    // keyed by (player, generation, ...) rather than living directly in
    // this struct, specifically so a new run doesn't inherit a previous
    // run's locked-node/damage state: `delete`-ing a struct never resets
    // nested mappings in Solidity, so a plain `mapping(uint => bool) locked`
    // member here would silently carry stale locks into a player's second
    // run in the same campaign. Bumping the generation instead makes old
    // entries permanently unreachable (not reset, just orphaned) — cheaper
    // and simpler than actually clearing them.
    uint generation;
    uint campaignId;
    uint currentNodeId;
    uint currentCostCap;
    // The Fleets.Fleet id reserving every roster ship (inFleet == true) so
    // it can't be fielded anywhere else while this run is active. See
    // RoguelikeMatch for how this is created/torn down.
    uint reservationFleetId;
    uint[] rosterShipIds;
}

// Per-player roguelike run ledger — dumb state only (no Game/Fleets/token
// calls of its own), mutated exclusively by an allowed orchestrator
// (RoguelikeMatch), mirroring NodeMap.isAllowedToCompleteNodes' shape.
// Split out from RoguelikeMatch specifically to keep that contract's own
// bytecode budget centered on orchestration logic.
contract RoguelikeRun is Ownable {
    mapping(address => Run) private runs;

    // player => generation => shipId => persisted hull points (0 = not yet
    // damaged this run / unset — a real roster ship's stored HP is never 0,
    // since a ship that reaches 0 HP is destroyed and dropped from the
    // roster entirely, never left in it at 0).
    mapping(address => mapping(uint => mapping(uint => uint8)))
        private shipHPByGen;
    // player => generation => nodeId => locked out for this run.
    mapping(address => mapping(uint => mapping(uint => bool)))
        private lockedByGen;

    mapping(address => bool) public isAllowedToModifyRuns;

    error NotAllowedToModifyRuns();
    error RunAlreadyActive();

    event RunStarted(address indexed player, uint indexed campaignId);
    event RunEnded(address indexed player, bool won);

    constructor() Ownable(msg.sender) {}

    modifier onlyAllowed() {
        if (!isAllowedToModifyRuns[msg.sender])
            revert NotAllowedToModifyRuns();
        _;
    }

    function setIsAllowedToModifyRuns(
        address _address,
        bool _allowed
    ) external onlyOwner {
        isAllowedToModifyRuns[_address] = _allowed;
    }

    function startRun(
        address _player,
        uint _campaignId,
        uint _rootNodeId,
        uint _initialCostCap,
        uint[] calldata _initialRoster,
        uint _reservationFleetId
    ) external onlyAllowed {
        Run storage run = runs[_player];
        if (run.status == RunStatus.Active) revert RunAlreadyActive();

        run.status = RunStatus.Active;
        run.generation += 1;
        run.campaignId = _campaignId;
        run.currentNodeId = _rootNodeId;
        run.currentCostCap = _initialCostCap;
        run.reservationFleetId = _reservationFleetId;
        run.rosterShipIds = _initialRoster;

        emit RunStarted(_player, _campaignId);
    }

    function setCurrentNode(address _player, uint _nodeId) external onlyAllowed {
        runs[_player].currentNodeId = _nodeId;
    }

    function lockNode(address _player, uint _nodeId) external onlyAllowed {
        Run storage run = runs[_player];
        lockedByGen[_player][run.generation][_nodeId] = true;
    }

    function isNodeLocked(
        address _player,
        uint _nodeId
    ) external view returns (bool) {
        Run storage run = runs[_player];
        return lockedByGen[_player][run.generation][_nodeId];
    }

    function setCostCap(address _player, uint _costCap) external onlyAllowed {
        runs[_player].currentCostCap = _costCap;
    }

    function setRoster(
        address _player,
        uint[] calldata _shipIds
    ) external onlyAllowed {
        runs[_player].rosterShipIds = _shipIds;
    }

    function setReservationFleetId(
        address _player,
        uint _fleetId
    ) external onlyAllowed {
        runs[_player].reservationFleetId = _fleetId;
    }

    function setShipHP(
        address _player,
        uint _shipId,
        uint8 _hullPoints
    ) external onlyAllowed {
        Run storage run = runs[_player];
        shipHPByGen[_player][run.generation][_shipId] = _hullPoints;
    }

    // 0 means "not yet damaged this run" — RoguelikeMatch treats that as
    // "use the fresh 100% ShipAttributes just calculated," never as "enter
    // combat at 0 HP."
    function getShipHP(
        address _player,
        uint _shipId
    ) external view returns (uint8) {
        Run storage run = runs[_player];
        return shipHPByGen[_player][run.generation][_shipId];
    }

    function endRun(address _player, bool _won) external onlyAllowed {
        runs[_player].status = _won ? RunStatus.Won : RunStatus.Ended;
        emit RunEnded(_player, _won);
    }

    function getRun(address _player) external view returns (Run memory) {
        return runs[_player];
    }

    function hasActiveRun(address _player) external view returns (bool) {
        return runs[_player].status == RunStatus.Active;
    }
}

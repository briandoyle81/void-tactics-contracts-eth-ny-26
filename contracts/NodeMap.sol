// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMaps.sol";
import "./Types.sol";

// Admin-curated campaign graph for vs-AI matches: a full node/prerequisite
// graph (not flat per-node flags) so branches and shortcuts are possible,
// with ANY-of unlock semantics (completing any one prerequisite unlocks a
// node) so shortcuts can converge back into the main path. Mirrors Maps.sol/
// AIEncounters.sol's owner-or-editor idiom deliberately, since curating this
// graph is conceptually an extension of the same map-authoring workflow.
//
// Each node is a fully curated encounter, not just a map reference:
// costLimit/turnTime/maxScore/creatorGoesFirst all live here instead of
// being player-supplied, mirroring how AIEncounters already curates AI
// loadouts per map — a campaign node represents a fixed, pre-designed
// encounter, not a flexible custom lobby.
contract NodeMap is Ownable {
    struct CampaignNode {
        uint id;
        uint campaignId;
        uint mapId;
        uint[] prerequisites;
        uint costLimit; // max player threat: the human fleet's cost cap, enforced by Fleets.createFleet
        uint turnTime;
        uint maxScore;
        bool creatorGoesFirst;
        bool exists;
    }

    IMaps public maps;

    // A campaign is just a grouping label for nodes — no metadata beyond
    // existence (display names/flavor text live off-chain, same as maps
    // and AI ship configs elsewhere in this codebase). Node ids stay
    // globally unique across all campaigns (unchanged from before
    // campaigns existed); campaignId only determines which campaign a
    // node is grouped under for the query functions below.
    mapping(uint => bool) public campaignExists;
    uint public campaignCount;
    // campaignId => node ids in that campaign, in creation order. Kept in
    // sync by createNode/updateNode so getNodesInCampaign/
    // getCampaignCompletion are O(that campaign's own node count), not a
    // full scan of every node ever created.
    mapping(uint => uint[]) private campaignNodeIds;

    // campaignId => required ship variant for a human fleet entering any
    // node in this campaign (0 = unrestricted). See setCampaignRequiredVariant.
    mapping(uint => uint16) public campaignRequiredVariant;

    mapping(uint => CampaignNode) private nodes;
    uint public nodeCount;

    // player => nodeId => completed. Idempotent (no revert on repeat
    // completion, unlike TutorialClaim.sol's one-shot claim) since replaying
    // a beaten node should stay playable.
    mapping(address => mapping(uint => bool)) public completedNodes;

    // Addresses allowed to create/edit nodes (in addition to the owner) —
    // same pattern as Maps.isMapEditor.
    mapping(address => bool) public isNodeEditor;

    // Addresses allowed to call recordCompletion (only SinglePlayerMatch
    // needs this) — same pattern as Game.isAllowedToStartGames.
    mapping(address => bool) public isAllowedToCompleteNodes;

    error NotNodeEditor();
    error NotAllowedToCompleteNodes();
    error MapNotFound();
    error InvalidMapMode();
    error CampaignNotFound();
    error NodeNotFound();
    error SelfPrerequisite();
    error PrerequisiteNotFound();
    error PrerequisiteNotInNode();

    event NodeEditorSet(address indexed editor, bool allowed);
    event CompleterSet(address indexed completer, bool allowed);
    event CampaignCreated(uint indexed campaignId);
    event NodeCreated(
        uint indexed nodeId,
        uint indexed campaignId,
        uint mapId
    );
    event NodeUpdated(uint indexed nodeId);
    event NodeCompleted(address indexed player, uint indexed nodeId);

    constructor(address _maps) Ownable(msg.sender) {
        maps = IMaps(_maps);
    }

    /// @dev Restricts to the owner or an allowed node editor.
    modifier onlyNodeEditor() {
        if (msg.sender != owner() && !isNodeEditor[msg.sender])
            revert NotNodeEditor();
        _;
    }

    function setMapsAddress(address _maps) external onlyOwner {
        maps = IMaps(_maps);
    }

    /**
     * @dev Grant or revoke node-editor rights (create/edit campaign nodes).
     * @param _editor The address to update
     * @param _allowed Whether the address may edit nodes
     */
    function setNodeEditor(address _editor, bool _allowed) external onlyOwner {
        isNodeEditor[_editor] = _allowed;
        emit NodeEditorSet(_editor, _allowed);
    }

    /**
     * @dev Grant or revoke rights to record node completions (e.g. the
     * SinglePlayerMatch contract, on a human win).
     * @param _completer The address to update
     * @param _allowed Whether the address may record completions
     */
    function setIsAllowedToCompleteNodes(
        address _completer,
        bool _allowed
    ) external onlyOwner {
        isAllowedToCompleteNodes[_completer] = _allowed;
        emit CompleterSet(_completer, _allowed);
    }

    /// @dev A campaign node needs a map that exists and is valid for PvE
    /// (PvE or Both) — a PvP-only map attached here would let a player
    /// enter a "campaign" match on a map never designed/encountered for it.
    function _requireMapUsableForCampaign(uint _mapId) internal view {
        if (!maps.mapExists(_mapId)) revert MapNotFound();
        MapMode mode = maps.mapMode(_mapId);
        if (mode != MapMode.PvE && mode != MapMode.Both)
            revert InvalidMapMode();
    }

    /// @dev Campaigns are created explicitly (fail-loud, matching this
    /// codebase's established "no implicit/unconfigured content" idiom —
    /// see ShipAttributes' unconfigured-variant reverts) rather than
    /// letting createNode silently allocate a new campaignId on first use.
    function createCampaign()
        external
        onlyNodeEditor
        returns (uint campaignId)
    {
        campaignCount++;
        campaignId = campaignCount;
        campaignExists[campaignId] = true;
        emit CampaignCreated(campaignId);
    }

    // Restricts which ship variant a HUMAN fleet must be to start a node
    // match in this campaign (0 = unrestricted, the default). The AI side
    // is entirely independent of this — AI fleet variant comes from
    // AIEncounters' map placements, not from here (see docs/faction-2.md
    // section 8: the campaign's AI fleets are variant 2 even where the
    // human side is restricted to variant 1). Enforced in
    // SinglePlayerMatch.startNodeMatch, not here, since NodeMap has no
    // dependency on ship data.
    function setCampaignRequiredVariant(
        uint _campaignId,
        uint16 _variant
    ) external onlyNodeEditor {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        campaignRequiredVariant[_campaignId] = _variant;
    }

    // Enemy threat is not tracked on-chain — the frontend derives it by
    // summing ShipAttributes.calculateShipCost over
    // AIEncounters.getMapPlacements for the node's mapId, so it's always
    // exact and never goes stale if the encounter's placements are edited
    // after this node is created.
    function createNode(
        uint _campaignId,
        uint _mapId,
        uint[] calldata _prerequisites,
        uint _costLimit,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst
    ) external onlyNodeEditor returns (uint nodeId) {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        _requireMapUsableForCampaign(_mapId);

        nodeCount++;
        nodeId = nodeCount;

        for (uint i = 0; i < _prerequisites.length; i++) {
            _requirePrerequisiteValid(nodeId, _prerequisites[i]);
        }

        CampaignNode storage node = nodes[nodeId];
        node.id = nodeId;
        node.campaignId = _campaignId;
        node.mapId = _mapId;
        node.prerequisites = _prerequisites;
        node.costLimit = _costLimit;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;
        node.exists = true;

        campaignNodeIds[_campaignId].push(nodeId);

        emit NodeCreated(nodeId, _campaignId, _mapId);
    }

    function updateNode(
        uint _nodeId,
        uint _campaignId,
        uint _mapId,
        uint[] calldata _prerequisites,
        uint _costLimit,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst
    ) external onlyNodeEditor {
        CampaignNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        _requireMapUsableForCampaign(_mapId);

        for (uint i = 0; i < _prerequisites.length; i++) {
            _requirePrerequisiteValid(_nodeId, _prerequisites[i]);
        }

        if (_campaignId != node.campaignId) {
            _removeFromCampaignNodeIds(node.campaignId, _nodeId);
            campaignNodeIds[_campaignId].push(_nodeId);
        }

        node.campaignId = _campaignId;
        node.mapId = _mapId;
        node.prerequisites = _prerequisites;
        node.costLimit = _costLimit;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;

        emit NodeUpdated(_nodeId);
    }

    // Order doesn't matter here (campaignNodeIds is an unordered bag for
    // query purposes), so swap-and-pop — same pattern as removePrerequisite.
    function _removeFromCampaignNodeIds(
        uint _campaignId,
        uint _nodeId
    ) internal {
        uint[] storage ids = campaignNodeIds[_campaignId];
        uint length = ids.length;
        for (uint i = 0; i < length; i++) {
            if (ids[i] == _nodeId) {
                ids[i] = ids[length - 1];
                ids.pop();
                return;
            }
        }
    }

    function addPrerequisite(
        uint _nodeId,
        uint _prerequisiteId
    ) external onlyNodeEditor {
        CampaignNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();
        _requirePrerequisiteValid(_nodeId, _prerequisiteId);
        node.prerequisites.push(_prerequisiteId);
        emit NodeUpdated(_nodeId);
    }

    // Order doesn't matter for an ANY-of unlock check, so this is a
    // swap-and-pop rather than a shift.
    function removePrerequisite(
        uint _nodeId,
        uint _prerequisiteId
    ) external onlyNodeEditor {
        CampaignNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();

        uint length = node.prerequisites.length;
        for (uint i = 0; i < length; i++) {
            if (node.prerequisites[i] == _prerequisiteId) {
                node.prerequisites[i] = node.prerequisites[length - 1];
                node.prerequisites.pop();
                emit NodeUpdated(_nodeId);
                return;
            }
        }
        revert PrerequisiteNotInNode();
    }

    function _requirePrerequisiteValid(
        uint _nodeId,
        uint _prerequisiteId
    ) internal view {
        if (_prerequisiteId == _nodeId) revert SelfPrerequisite();
        if (!nodes[_prerequisiteId].exists) revert PrerequisiteNotFound();
    }

    /**
     * @dev A node with no prerequisites is always unlocked (a root node).
     * Otherwise, true as soon as the player has completed ANY one of its
     * prerequisites — not all — so shortcut nodes can converge back into
     * the main path from more than one earlier node.
     */
    function isNodeUnlocked(
        address _player,
        uint _nodeId
    ) public view returns (bool) {
        CampaignNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();
        if (node.prerequisites.length == 0) return true;

        for (uint i = 0; i < node.prerequisites.length; i++) {
            if (completedNodes[_player][node.prerequisites[i]]) return true;
        }
        return false;
    }

    function recordCompletion(address _player, uint _nodeId) external {
        if (!isAllowedToCompleteNodes[msg.sender])
            revert NotAllowedToCompleteNodes();
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        completedNodes[_player][_nodeId] = true;
        emit NodeCompleted(_player, _nodeId);
    }

    function getNode(uint _nodeId) external view returns (CampaignNode memory) {
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        return nodes[_nodeId];
    }

    function getPrerequisites(
        uint _nodeId
    ) external view returns (uint[] memory) {
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        return nodes[_nodeId].prerequisites;
    }

    function isNodeCompleted(
        address _player,
        uint _nodeId
    ) external view returns (bool) {
        return completedNodes[_player][_nodeId];
    }

    function getAllNodes() external view returns (CampaignNode[] memory all) {
        all = new CampaignNode[](nodeCount);
        for (uint i = 1; i <= nodeCount; i++) {
            all[i - 1] = nodes[i];
        }
    }

    function getNodesInCampaign(
        uint _campaignId
    ) external view returns (uint[] memory) {
        return campaignNodeIds[_campaignId];
    }

    /// @dev The primary integration point for other contracts: learn, in
    /// one call, exactly which of a campaign's nodes a given player has
    /// completed — without looping N separate isNodeCompleted calls or
    /// needing to already know the campaign's node ids ahead of time.
    function getCampaignCompletion(
        address _player,
        uint _campaignId
    ) external view returns (uint[] memory nodeIds, bool[] memory completed) {
        nodeIds = campaignNodeIds[_campaignId];
        completed = new bool[](nodeIds.length);
        for (uint i = 0; i < nodeIds.length; i++) {
            completed[i] = completedNodes[_player][nodeIds[i]];
        }
    }

    /// @dev Convenience for the common "gate something on 100% campaign
    /// clear" case (e.g. a rewards/badge contract), so callers don't have
    /// to fetch getCampaignCompletion and scan it themselves. An empty or
    /// nonexistent campaign is never "completed".
    function isCampaignFullyCompleted(
        address _player,
        uint _campaignId
    ) external view returns (bool) {
        uint[] storage ids = campaignNodeIds[_campaignId];
        uint length = ids.length;
        if (length == 0) return false;
        for (uint i = 0; i < length; i++) {
            if (!completedNodes[_player][ids[i]]) return false;
        }
        return true;
    }
}

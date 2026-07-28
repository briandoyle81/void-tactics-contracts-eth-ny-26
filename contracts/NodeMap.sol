// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMaps.sol";

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
        uint mapId;
        uint[] prerequisites;
        uint costLimit;
        uint turnTime;
        uint maxScore;
        bool creatorGoesFirst;
        bool exists;
    }

    IMaps public maps;

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
    error NodeNotFound();
    error SelfPrerequisite();
    error PrerequisiteNotFound();
    error PrerequisiteNotInNode();

    event NodeEditorSet(address indexed editor, bool allowed);
    event CompleterSet(address indexed completer, bool allowed);
    event NodeCreated(uint indexed nodeId, uint indexed mapId);
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

    function createNode(
        uint _mapId,
        uint[] calldata _prerequisites,
        uint _costLimit,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst
    ) external onlyNodeEditor returns (uint nodeId) {
        if (!maps.mapExists(_mapId)) revert MapNotFound();

        nodeCount++;
        nodeId = nodeCount;

        for (uint i = 0; i < _prerequisites.length; i++) {
            _requirePrerequisiteValid(nodeId, _prerequisites[i]);
        }

        CampaignNode storage node = nodes[nodeId];
        node.id = nodeId;
        node.mapId = _mapId;
        node.prerequisites = _prerequisites;
        node.costLimit = _costLimit;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;
        node.exists = true;

        emit NodeCreated(nodeId, _mapId);
    }

    function updateNode(
        uint _nodeId,
        uint _mapId,
        uint[] calldata _prerequisites,
        uint _costLimit,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst
    ) external onlyNodeEditor {
        CampaignNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();
        if (!maps.mapExists(_mapId)) revert MapNotFound();

        for (uint i = 0; i < _prerequisites.length; i++) {
            _requirePrerequisiteValid(_nodeId, _prerequisites[i]);
        }

        node.mapId = _mapId;
        node.prerequisites = _prerequisites;
        node.costLimit = _costLimit;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;

        emit NodeUpdated(_nodeId);
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
}

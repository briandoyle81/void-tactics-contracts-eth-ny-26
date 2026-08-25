// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMaps.sol";
import "./Types.sol";

// Non-combat nodes have no map/AI encounter — the player repairs, adjusts
// roster composition, and/or gets a new fleet-cost cap instead of fighting.
enum RoguelikeNodeKind {
    Combat,
    Resupply
}

// twoWay only means the player can walk BACK across this specific edge
// later (e.g. a resupply hub they can return to) — it does not exempt the
// child from being locked out as someone else's sibling when a different
// one-way sibling is chosen. See RoguelikeMatch's lockout logic.
struct RoguelikeEdge {
    uint childId;
    bool twoWay;
}

struct RoguelikeNode {
    uint id;
    uint campaignId;
    RoguelikeNodeKind kind;
    // Combat-only (ignored for Resupply nodes):
    uint mapId;
    uint turnTime;
    uint maxScore;
    bool creatorGoesFirst;
    uint enemyThreat; // descriptive only, never enforced — same as NodeMap
    // Resupply-only (ignored for Combat nodes):
    uint costCapOverride; // 0 = no change to the run's current cost cap
    RoguelikeEdge[] children;
    bool exists;
}

// Admin-curated mission graph for the roguelike campaign mode — sits
// alongside NodeMap.sol (the existing, replayable, ANY-of-prerequisite
// campaign), not a replacement for it. Deliberately parent-lists-children
// (the reverse of NodeMap's child-lists-prerequisites) because the
// roguelike's branch-lockout rule needs "what are this node's other
// children" at the moment a player commits to one of them — a cheap,
// direct lookup here, which would otherwise require scanning every node in
// the campaign under NodeMap's model.
contract RoguelikeNodeMap is Ownable {
    IMaps public maps;

    mapping(uint => bool) public campaignExists;
    uint public campaignCount;
    // No prerequisites==0 analog exists under a children-model to
    // auto-detect a campaign's entry point, so it's set explicitly.
    mapping(uint => uint) public campaignRootNode;
    // 0-100, applied as a floor (never heals a ship down) to every combat
    // node's survivors on a win. Read by RoguelikeMatch.onGameEnded.
    mapping(uint => uint8) public campaignAutoHealPercent;
    // 0 = unrestricted. Same pattern as NodeMap.campaignRequiredVariant.
    mapping(uint => uint16) public campaignRequiredVariant;
    // The fleet-cost cap a run starts with — admin-curated, not
    // player-chosen (same reasoning as combat nodes' own costLimit).
    // Resupply nodes can raise/lower it from here via costCapOverride.
    mapping(uint => uint) public campaignInitialCostCap;

    mapping(uint => RoguelikeNode) private nodes;
    uint public nodeCount;

    mapping(address => bool) public isNodeEditor;

    error NotNodeEditor();
    error MapNotFound();
    error InvalidMapMode();
    error CampaignNotFound();
    error NodeNotFound();
    error ChildNotFound();
    error SelfChild();
    error ChildAlreadyExists();
    error ChildNotInNode();
    error InvalidHealPercent();

    event NodeEditorSet(address indexed editor, bool allowed);
    event CampaignCreated(uint indexed campaignId);
    event NodeCreated(
        uint indexed nodeId,
        uint indexed campaignId,
        RoguelikeNodeKind kind
    );
    event NodeUpdated(uint indexed nodeId);
    event ChildAdded(uint indexed parentId, uint indexed childId, bool twoWay);
    event ChildRemoved(uint indexed parentId, uint indexed childId);

    constructor(address _maps) Ownable(msg.sender) {
        maps = IMaps(_maps);
    }

    modifier onlyNodeEditor() {
        if (msg.sender != owner() && !isNodeEditor[msg.sender])
            revert NotNodeEditor();
        _;
    }

    function setMapsAddress(address _maps) external onlyOwner {
        maps = IMaps(_maps);
    }

    function setNodeEditor(address _editor, bool _allowed) external onlyOwner {
        isNodeEditor[_editor] = _allowed;
        emit NodeEditorSet(_editor, _allowed);
    }

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

    function setCampaignRoot(
        uint _campaignId,
        uint _nodeId
    ) external onlyNodeEditor {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        campaignRootNode[_campaignId] = _nodeId;
    }

    function setCampaignAutoHealPercent(
        uint _campaignId,
        uint8 _percent
    ) external onlyNodeEditor {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        if (_percent > 100) revert InvalidHealPercent();
        campaignAutoHealPercent[_campaignId] = _percent;
    }

    function setCampaignRequiredVariant(
        uint _campaignId,
        uint16 _variant
    ) external onlyNodeEditor {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        campaignRequiredVariant[_campaignId] = _variant;
    }

    function setCampaignInitialCostCap(
        uint _campaignId,
        uint _costCap
    ) external onlyNodeEditor {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        campaignInitialCostCap[_campaignId] = _costCap;
    }

    /// @dev A combat node needs a map that exists and is valid for PvE
    /// (PvE or Both) — mirrors NodeMap._requireMapUsableForCampaign exactly.
    function _requireMapUsableForCampaign(uint _mapId) internal view {
        if (!maps.mapExists(_mapId)) revert MapNotFound();
        MapMode mode = maps.mapMode(_mapId);
        if (mode != MapMode.PvE && mode != MapMode.Both)
            revert InvalidMapMode();
    }

    // _mapId/_turnTime/_maxScore/_creatorGoesFirst/_enemyThreat are
    // Combat-only (pass 0/false for a Resupply node); _costCapOverride is
    // Resupply-only (pass 0 for a Combat node, meaning "no override").
    function createNode(
        uint _campaignId,
        RoguelikeNodeKind _kind,
        uint _mapId,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst,
        uint _enemyThreat,
        uint _costCapOverride
    ) external onlyNodeEditor returns (uint nodeId) {
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        if (_kind == RoguelikeNodeKind.Combat) {
            _requireMapUsableForCampaign(_mapId);
        }

        nodeCount++;
        nodeId = nodeCount;

        RoguelikeNode storage node = nodes[nodeId];
        node.id = nodeId;
        node.campaignId = _campaignId;
        node.kind = _kind;
        node.mapId = _mapId;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;
        node.enemyThreat = _enemyThreat;
        node.costCapOverride = _costCapOverride;
        node.exists = true;

        emit NodeCreated(nodeId, _campaignId, _kind);
    }

    function updateNode(
        uint _nodeId,
        uint _campaignId,
        RoguelikeNodeKind _kind,
        uint _mapId,
        uint _turnTime,
        uint _maxScore,
        bool _creatorGoesFirst,
        uint _enemyThreat,
        uint _costCapOverride
    ) external onlyNodeEditor {
        RoguelikeNode storage node = nodes[_nodeId];
        if (!node.exists) revert NodeNotFound();
        if (!campaignExists[_campaignId]) revert CampaignNotFound();
        if (_kind == RoguelikeNodeKind.Combat) {
            _requireMapUsableForCampaign(_mapId);
        }

        node.campaignId = _campaignId;
        node.kind = _kind;
        node.mapId = _mapId;
        node.turnTime = _turnTime;
        node.maxScore = _maxScore;
        node.creatorGoesFirst = _creatorGoesFirst;
        node.enemyThreat = _enemyThreat;
        node.costCapOverride = _costCapOverride;

        emit NodeUpdated(_nodeId);
    }

    function addChild(
        uint _parentId,
        uint _childId,
        bool _twoWay
    ) external onlyNodeEditor {
        RoguelikeNode storage parent = nodes[_parentId];
        if (!parent.exists) revert NodeNotFound();
        if (!nodes[_childId].exists) revert ChildNotFound();
        if (_childId == _parentId) revert SelfChild();
        for (uint i = 0; i < parent.children.length; i++) {
            if (parent.children[i].childId == _childId)
                revert ChildAlreadyExists();
        }
        parent.children.push(RoguelikeEdge({childId: _childId, twoWay: _twoWay}));
        emit ChildAdded(_parentId, _childId, _twoWay);
    }

    // Swap-and-pop — order doesn't matter for graph traversal, same pattern
    // NodeMap.removePrerequisite/_removeFromCampaignNodeIds already use.
    function removeChild(uint _parentId, uint _childId) external onlyNodeEditor {
        RoguelikeNode storage parent = nodes[_parentId];
        if (!parent.exists) revert NodeNotFound();
        uint length = parent.children.length;
        for (uint i = 0; i < length; i++) {
            if (parent.children[i].childId == _childId) {
                parent.children[i] = parent.children[length - 1];
                parent.children.pop();
                emit ChildRemoved(_parentId, _childId);
                return;
            }
        }
        revert ChildNotInNode();
    }

    function getNode(
        uint _nodeId
    ) external view returns (RoguelikeNode memory) {
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        return nodes[_nodeId];
    }

    function getChildren(
        uint _nodeId
    ) external view returns (RoguelikeEdge[] memory) {
        if (!nodes[_nodeId].exists) revert NodeNotFound();
        return nodes[_nodeId].children;
    }

    // Finds the edge from _parentId to _childId, reverting if _childId
    // isn't actually one of _parentId's children — RoguelikeMatch uses this
    // both to validate a requested move and to learn whether it's two-way.
    function getEdge(
        uint _parentId,
        uint _childId
    ) external view returns (bool twoWay) {
        RoguelikeNode storage parent = nodes[_parentId];
        if (!parent.exists) revert NodeNotFound();
        for (uint i = 0; i < parent.children.length; i++) {
            if (parent.children[i].childId == _childId)
                return parent.children[i].twoWay;
        }
        revert ChildNotInNode();
    }
}

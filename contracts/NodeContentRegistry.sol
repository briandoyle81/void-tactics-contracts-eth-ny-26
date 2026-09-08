// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

// Permanent, on-chain title/description storage for campaign and roguelike
// nodes — the top layer of the frontend's three-layer content fallback
// (this registry -> Postgres draft -> static placeholder config -> generic
// default; see docs/update for the frontend-side pull/edit/publish flow).
// Deliberately additive and standalone: it does NOT extend NodeMap's
// CampaignNode or RoguelikeNodeMap's RoguelikeNode structs, since both of
// those contracts are already deployed with live campaigns/nodes and
// adding fields to their structs would require redeploying and re-seeding
// everything already created. A node is identified here by (isRoguelike,
// nodeId) rather than a shared id space, since NodeMap and RoguelikeNodeMap
// each run their own independent global nodeCount/nodes mapping — the same
// numeric nodeId can exist in both graphs simultaneously.
//
// Content is written via one batched call (setNodeContentBatch) rather than
// per-node writes, since a single campaign can hold up to ~100 nodes and
// requiring 100 signed transactions to publish one campaign's copy isn't a
// workable admin flow. The frontend's publish flow authors content in
// Postgres first (instant, no gas) and only calls setNodeContentBatch once
// an admin explicitly publishes a batch of finished edits here.
contract NodeContentRegistry is Ownable {
    struct NodeContentEntry {
        string title;
        string description;
    }

    // isRoguelike => nodeId => content. isRoguelike distinguishes NodeMap
    // node ids from RoguelikeNodeMap node ids, which are assigned from two
    // separate global counters and can collide numerically.
    mapping(bool => mapping(uint => NodeContentEntry)) private content;

    // Addresses allowed to publish node content (in addition to the owner)
    // — same isNodeEditor/onlyNodeEditor idiom as NodeMap.sol/
    // RoguelikeNodeMap.sol, kept as this contract's own independent
    // allowlist rather than deferring to either of those contracts'
    // isNodeEditor mappings. That avoids an extra cross-contract call per
    // batched write and matches how this codebase already grants the same
    // wallet editor rights on each content-bearing contract separately
    // (see MAP_EDITOR's grants in DeployAndConfig.ts) rather than sharing
    // one allowlist across contracts.
    mapping(address => bool) public isNodeEditor;

    error NotNodeEditor();
    error ArrayLengthMismatch();

    event NodeEditorSet(address indexed editor, bool allowed);
    event NodeContentSet(
        bool indexed isRoguelike,
        uint indexed nodeId,
        string title,
        string description
    );

    constructor() Ownable(msg.sender) {}

    /// @dev Restricts to the owner or an allowed node-content editor.
    modifier onlyNodeEditor() {
        if (msg.sender != owner() && !isNodeEditor[msg.sender])
            revert NotNodeEditor();
        _;
    }

    /**
     * @dev Grant or revoke node-content publishing rights.
     * @param _editor The address to update
     * @param _allowed Whether the address may publish node content
     */
    function setNodeEditor(address _editor, bool _allowed) external onlyOwner {
        isNodeEditor[_editor] = _allowed;
        emit NodeEditorSet(_editor, _allowed);
    }

    /**
     * @dev Publish title/description for many nodes in one call. All four
     * arrays must be the same length; entry i sets content for
     * (isRoguelike[i], nodeIds[i]). Overwrites any existing entry for that
     * key — this is a full publish, not a partial patch.
     */
    function setNodeContentBatch(
        bool[] calldata isRoguelike,
        uint[] calldata nodeIds,
        string[] calldata titles,
        string[] calldata descriptions
    ) external onlyNodeEditor {
        uint len = nodeIds.length;
        if (
            isRoguelike.length != len ||
            titles.length != len ||
            descriptions.length != len
        ) revert ArrayLengthMismatch();

        for (uint i = 0; i < len; i++) {
            content[isRoguelike[i]][nodeIds[i]] = NodeContentEntry({
                title: titles[i],
                description: descriptions[i]
            });
            emit NodeContentSet(
                isRoguelike[i],
                nodeIds[i],
                titles[i],
                descriptions[i]
            );
        }
    }

    /// @dev Empty strings for both fields if nothing has been published yet.
    function getNodeContent(
        bool _isRoguelike,
        uint _nodeId
    ) external view returns (string memory title, string memory description) {
        NodeContentEntry storage entry = content[_isRoguelike][_nodeId];
        return (entry.title, entry.description);
    }

    /**
     * @dev Batched counterpart to getNodeContent, for reading many nodes'
     * content in one call (the frontend's sync-on-open step). isRoguelike
     * and nodeIds must be the same length.
     */
    function getNodeContentBatch(
        bool[] calldata isRoguelike,
        uint[] calldata nodeIds
    )
        external
        view
        returns (string[] memory titles, string[] memory descriptions)
    {
        uint len = nodeIds.length;
        if (isRoguelike.length != len) revert ArrayLengthMismatch();

        titles = new string[](len);
        descriptions = new string[](len);
        for (uint i = 0; i < len; i++) {
            NodeContentEntry storage entry = content[isRoguelike[i]][
                nodeIds[i]
            ];
            titles[i] = entry.title;
            descriptions[i] = entry.description;
        }
    }
}

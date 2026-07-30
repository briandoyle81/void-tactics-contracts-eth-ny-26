// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal read surface for other contracts that need to know a player's
// campaign progress without importing all of NodeMap.sol (which pulls in
// Ownable/IMaps/the full admin write surface just for that). Node ids are
// globally unique across all campaigns; campaignId only groups nodes for
// the campaign-scoped queries below — see NodeMap.sol's header comment.
interface INodeMap {
    function isNodeCompleted(
        address _player,
        uint _nodeId
    ) external view returns (bool);

    function isNodeUnlocked(
        address _player,
        uint _nodeId
    ) external view returns (bool);

    function campaignExists(uint _campaignId) external view returns (bool);

    function campaignCount() external view returns (uint);

    function getNodesInCampaign(
        uint _campaignId
    ) external view returns (uint[] memory);

    // The primary integration point: which of a campaign's nodes has
    // _player completed, in one call.
    function getCampaignCompletion(
        address _player,
        uint _campaignId
    ) external view returns (uint[] memory nodeIds, bool[] memory completed);

    function isCampaignFullyCompleted(
        address _player,
        uint _campaignId
    ) external view returns (bool);
}

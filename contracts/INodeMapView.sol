// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal read-only view of NodeMap.sol — same pattern IGameView.sol
// already uses (Tournament.sol's own local IGame is the original
// precedent), rather than importing the whole NodeMap contract.
interface INodeMapView {
    function isNodeCompleted(
        address _player,
        uint _nodeId
    ) external view returns (bool);
}

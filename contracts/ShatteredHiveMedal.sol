// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./INodeMapView.sol";

// Soulbound (non-transferable) one-per-address campaign completion medal.
// Awarded via a player-initiated claimMedal() — mirrors TutorialClaim.sol's
// shape (a separate contract the player calls directly, self-verifying
// eligibility) rather than an automatic mint hooked into NodeMap/
// SinglePlayerMatch's game-ending path, so a bug here can never affect
// match completion. Holding this medal is what VariantPurchaseGate.sol
// requires for variant-2 ship purchases (configured there, not here).
contract ShatteredHiveMedal is ERC721, Ownable {
    INodeMapView public nodeMap;
    // The campaign's true final node — deliberately an explicit,
    // owner-configurable value rather than inferred from NodeMap's graph
    // structure (the campaign graph can have multiple leaf nodes, e.g. a
    // dead-end branch, that are NOT the intended final mission).
    uint public finalNodeId;

    uint public nextTokenId = 1;

    error AlreadyClaimed();
    error CampaignNotCompleted();
    error Soulbound();

    constructor(
        address _nodeMap,
        uint _finalNodeId
    ) ERC721("Shattered Hive Campaign Medal", "HIVEMEDAL") Ownable(msg.sender) {
        nodeMap = INodeMapView(_nodeMap);
        finalNodeId = _finalNodeId;
    }

    function setNodeMapAddress(address _nodeMap) external onlyOwner {
        nodeMap = INodeMapView(_nodeMap);
    }

    function setFinalNodeId(uint _finalNodeId) external onlyOwner {
        finalNodeId = _finalNodeId;
    }

    // Player-initiated, self-verifying, one-shot per address.
    function claimMedal() external {
        if (balanceOf(msg.sender) > 0) revert AlreadyClaimed();
        if (!nodeMap.isNodeCompleted(msg.sender, finalNodeId)) {
            revert CampaignNotCompleted();
        }
        _mint(msg.sender, nextTokenId++);
    }

    // Owner-only recovery/support escape hatch — no completion check, same
    // one-per-address guard as claimMedal.
    function ownerMint(address _player) external onlyOwner {
        if (balanceOf(_player) > 0) revert AlreadyClaimed();
        _mint(_player, nextTokenId++);
    }

    // Soulbound: allow minting (from == address(0)), revert on every
    // transfer or burn.
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721) returns (address) {
        if (_ownerOf(tokenId) != address(0)) revert Soulbound();
        return super._update(to, tokenId, auth);
    }
}

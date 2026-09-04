// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./INodeMapView.sol";
import "./IShatteredHiveMedalArt.sol";

// Soulbound (non-transferable) one-per-address campaign completion medal.
// Awarded via a player-initiated claimMedal() — mirrors TutorialClaim.sol's
// shape (a separate contract the player calls directly, self-verifying
// eligibility) rather than an automatic mint hooked into NodeMap/
// SinglePlayerMatch's game-ending path, so a bug here can never affect
// match completion. Holding this medal is what VariantPurchaseGate.sol
// requires for variant-2 ship purchases (configured there, not here).
contract ShatteredHiveMedal is ERC721, Ownable {
    using Strings for uint256;

    INodeMapView public nodeMap;
    // Owner-settable (not a constructor param) so the art can be swapped
    // later — e.g. a rendering fix — without redeploying this contract and
    // losing every holder's token id/ownership history. See
    // ShatteredHiveMedalArt.sol.
    IShatteredHiveMedalArt public art;
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

    function setArtAddress(address _art) external onlyOwner {
        art = IShatteredHiveMedalArt(_art);
    }

    // The medal has no traits/equipment to key art off of (see
    // ShatteredHiveMedalArt.sol) — every token renders the same image, same
    // two-layer Base64 (SVG -> data URI -> JSON -> data URI) pattern
    // RenderMetadata.sol/ImageRenderer.sol already use for ship art.
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        _requireOwned(_tokenId);

        string memory image = string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(art.getSVG()))
            )
        );
        string memory json = string(
            abi.encodePacked(
                '{"name": "Shattered Hive Campaign Medal #',
                _tokenId.toString(),
                '","description": "Awarded for completing the Shattered Hive campaign.","image": "',
                image,
                '"}'
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(bytes(json))
                )
            );
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

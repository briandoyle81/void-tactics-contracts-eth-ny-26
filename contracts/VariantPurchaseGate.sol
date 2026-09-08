// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Generic "does this address hold the NFT required to mint variant X"
// registry. Deployed standalone and called from Ships.sol (already the
// tightest-margin contract in the repo — see CLAUDE.md) so that Ships.sol
// never needs to grow new code when a future variant gets a similar gate:
// it just stays ignorant of which variants are gated and on what, and
// owner-configuration below is what actually adds a new gate.
//
// requiredNft[variant] == address(0) means that variant is ungated.
contract VariantPurchaseGate is Ownable {
    mapping(uint16 => address) public requiredNft;

    error GateRequirementNotMet(uint16 variant);

    constructor() Ownable(msg.sender) {}

    function setRequiredNft(uint16 _variant, address _nft) external onlyOwner {
        requiredNft[_variant] = _nft;
    }

    function checkGate(uint16 _variant, address _to) external view {
        address nft = requiredNft[_variant];
        if (nft != address(0) && IERC721(nft).balanceOf(_to) == 0) {
            revert GateRequirementNotMet(_variant);
        }
    }
}

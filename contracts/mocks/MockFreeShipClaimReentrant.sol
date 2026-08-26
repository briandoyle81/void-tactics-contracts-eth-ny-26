// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IFreeShipClaimTarget {
    function claimFreeShips(uint16 variant) external;
}

// Reenters FreeShipClaim.claimFreeShips from the ERC721 mint callback
// triggered by its own first claim — used to verify the SP-01 fix (see
// docs/pre-audit.md) actually blocks a second claim within the same
// transaction.
contract MockFreeShipClaimReentrant is IERC721Receiver {
    address public target;
    bool private attacking;
    uint16 private variant;

    function setTarget(address _target) external {
        target = _target;
    }

    function claim(uint16 _variant) external {
        attacking = true;
        variant = _variant;
        IFreeShipClaimTarget(target).claimFreeShips(_variant);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        if (attacking) {
            // Single-shot: only reenter from the very first mint's
            // callback, not every subsequent one in the same batch. Reuses
            // the same (valid) variant as the outer call so a revert here
            // reflects the reentrancy guard, not an unrelated bad input.
            attacking = false;
            IFreeShipClaimTarget(target).claimFreeShips(variant);
        }
        return this.onERC721Received.selector;
    }
}

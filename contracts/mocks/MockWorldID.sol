// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../IWorldID.sol";

/// @dev Test double for the World ID router. By default every proof verifies;
/// flip `shouldRevert` to simulate an invalid proof.
contract MockWorldID is IWorldID {
    bool public shouldRevert;

    function setShouldRevert(bool _v) external {
        shouldRevert = _v;
    }

    function verifyProof(
        uint256,
        uint256,
        uint256,
        uint256,
        uint256,
        uint256[8] calldata
    ) external view {
        require(!shouldRevert, "MockWorldID: invalid proof");
    }
}

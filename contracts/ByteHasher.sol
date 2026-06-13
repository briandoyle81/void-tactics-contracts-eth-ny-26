// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

library ByteHasher {
    /// @dev Creates a keccak256 hash of `value`, reduced to a field element so
    /// it fits the World ID circuit's input field (drops the most-significant byte).
    /// @param value The bytes to hash.
    /// @return The hash reduced to a field element.
    function hashToField(bytes memory value) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(value))) >> 8;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IWorldID {
    /// @notice Reverts if the zero-knowledge proof is invalid.
    /// @param root The root of the Merkle tree (signal of the proof).
    /// @param groupId The group identifier (1 for Orb-verified, on-chain only).
    /// @param signalHash A keccak256 hash of the signal, reduced to a field element.
    /// @param nullifierHash The nullifier hash for this proof, preventing reuse.
    /// @param externalNullifierHash A hash of the app id and action.
    /// @param proof The zero-knowledge proof.
    function verifyProof(
        uint256 root,
        uint256 groupId,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external view;
}

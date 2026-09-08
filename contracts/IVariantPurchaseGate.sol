// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal interface Ships.sol calls into — keeps Ships.sol ignorant of
// *which* variants are gated or *what* they're gated on (which NFT, or any
// future gating condition). All of that lives in VariantPurchaseGate.sol,
// which has real headroom, unlike Ships.sol.
interface IVariantPurchaseGate {
    function checkGate(uint16 _variant, address _to) external view;
}

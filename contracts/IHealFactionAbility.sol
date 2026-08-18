// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Implemented by whichever faction ability resolver Game.sol has flagged
// via factionAbilityIsHeal[variant] == true (e.g. RepairResolver). Lets
// callers (SinglePlayerMatch, for single-player AI) discover the ability's
// heal range generically, without knowing which specific faction/resolver
// they're dealing with. RepairResolver already satisfies this via its
// public `range` state variable's auto-generated getter -- no resolver
// changes needed to conform, this just formalizes the shape callers rely on.
interface IHealFactionAbility {
    function range() external view returns (uint8);
}

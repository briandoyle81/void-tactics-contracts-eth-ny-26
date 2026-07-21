// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";

// Implemented by whichever contract Game.sol delegates a faction's innate
// ability to (via Game.factionAbilityResolvers[variant]). Dispatch is keyed
// by traits.variant, not by an equipped item — every ship of that faction
// gets the ability regardless of loadout, unlike Special (which requires
// equipping a specific equipment.special slot). The resolver owns every
// pre-dispatch check for its ability — targeting, range, ownership — and
// Game.sol trusts its returned effects completely, applying them without
// re-validating anything. This is what lets new faction abilities be added
// without touching Game.sol's bytecode again.
interface IFactionAbilityResolver {
    function resolveFactionAbility(
        uint gameId,
        uint shipId,
        uint16 variant,
        uint targetShipId,
        int16 actingRow,
        int16 actingCol
    ) external view returns (SpecialEffect[] memory effects);
}

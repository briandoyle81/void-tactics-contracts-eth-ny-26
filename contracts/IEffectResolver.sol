// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";

// Implemented by whichever contract Game.sol delegates a resolver-backed
// effect to — either a faction's innate ability (via
// Game.factionAbilityResolvers[variant], keyed by traits.variant, granted to
// every ship of that faction regardless of loadout) or an equipped Special
// item (via Game.specialResolvers[special], keyed by the equipped
// equipment.special). Both dispatch through the same
// SpecialEffectsLib.resolveAndApply, which is resolver-address-agnostic.
// The resolver owns every pre-dispatch check for its own effect —
// targeting, range, ownership — and Game.sol trusts its returned effects
// completely, applying them without re-validating anything. This is what
// lets new faction abilities and new equipped specials be added without
// touching Game.sol's bytecode again.
interface IEffectResolver {
    function resolveEffect(
        uint gameId,
        uint shipId,
        uint16 variant,
        uint targetShipId,
        int16 actingRow,
        int16 actingCol
    ) external view returns (SpecialEffect[] memory effects);
}

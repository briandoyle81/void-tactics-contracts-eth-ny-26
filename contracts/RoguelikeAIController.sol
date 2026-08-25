// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./AIBehavior.sol";
import "./IShipAttributes.sol";

// AI turn-decision dispatch for RoguelikeMatch, deployed as its own
// contract rather than called the way SinglePlayerMatch calls AIBehavior
// directly. AIBehavior is a library of `internal` functions, so every
// contract that calls its decideX functions gets that logic *inlined* into
// its own bytecode, not shared via delegatecall — this is exactly what
// pushed SinglePlayerMatch.sol to ~19.7/24 KiB. Externalizing just the
// decision step here means it's deployed exactly once; RoguelikeMatch pays
// a small external-call gas cost per AI turn instead of a second copy of
// this logic in its own contract, which it doesn't have the budget for
// alongside its run/resupply/HP-persistence logic. Mirrors
// SinglePlayerMatch._decideMove's dispatch exactly.
contract RoguelikeAIController {
    function decide(
        AIBehavior.Ctx memory ctx,
        IShipAttributes shipAttributes,
        Archetype archetype,
        Special special,
        uint16 variant,
        bool hasHealFactionAbility,
        uint8 healFactionAbilityRange
    ) external view returns (AIBehavior.Decision memory) {
        if (archetype == Archetype.Sniper) {
            return AIBehavior.decideSniper(ctx);
        } else if (archetype == Archetype.Support) {
            return
                AIBehavior.decideSupport(
                    ctx,
                    shipAttributes,
                    special,
                    variant,
                    hasHealFactionAbility,
                    healFactionAbilityRange
                );
        } else if (archetype == Archetype.Turtle) {
            return AIBehavior.decideTurtle(ctx);
        }
        // Grunt and Aggressor share this engage-or-approach logic; Rammer
        // has no AI decision path (the AI never rams) and falls through to
        // the same default as any future archetype not yet handled above —
        // matches SinglePlayerMatch._decideMove exactly.
        return AIBehavior.decideEngageOrApproach(ctx);
    }
}

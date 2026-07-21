// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Types.sol";
import "./IFactionAbilityResolver.sol";
import "./IShipAttributes.sol";

// Split out of Game.sol — already the tightest-margin contract in the repo —
// and deployed as a standalone library (an external function taking
// `GameData storage` compiles to a DELEGATECALL stub at Game.sol's call
// sites instead of being inlined), per CLAUDE.md: reduce bytecode via
// libraries rather than touching the contract-size check.
//
// Two things live here:
// 1. RepairDrones/EMP/FlakArray arithmetic — the three natively-implemented
//    equipment.special abilities, unchanged logic, just relocated.
// 2. Faction-ability dispatch (resolveAndApply): the resolver call, the
//    SpecialEffect[] ABI decode, and all hull/reactor/relocate arithmetic
//    directly against game storage. The one thing it deliberately does NOT
//    do is remove a ship from the game itself — that needs Game.sol's
//    `ships`/`fleets` references and its existing, heavily-invariant
//    `_removeShipFromGame` (fleet cleanup, game-end checks, orchestrator
//    callback). Instead this returns a normalized list of ships to remove
//    (and how), which Game.sol applies via that existing function.
library SpecialEffectsLib {
    int16 constant NO_RELOCATE = type(int16).min;

    error InvalidMove();

    // RepairDrones/EMP range + arithmetic, moved here from Game.sol for the
    // same bytecode-headroom reason as everything else in this file — same
    // math and revert conditions as before, just relocated.
    function validateSpecialRange(
        GameData storage game,
        IShipAttributes shipAttributes,
        int16 _newRow,
        int16 _newCol,
        uint _targetShipId,
        Special _special,
        uint16 _variant
    ) external view {
        Position storage targetPos = game.shipPositions[_targetShipId].position;
        uint8 specialRange = shipAttributes.getSpecialRange(_special, _variant);
        uint8 manhattan = _manhattanDistance(Position(_newRow, _newCol), targetPos);
        if (manhattan > specialRange) revert InvalidMove();
    }

    function performRepairDrones(
        GameData storage game,
        IShipAttributes shipAttributes,
        uint _targetShipId,
        uint16 _variant
    ) external {
        Attributes storage targetAttributes = game.shipAttributes[_targetShipId];
        uint8 repairStrength = shipAttributes.getSpecialStrength(
            Special.RepairDrones,
            _variant
        );
        uint16 newHullPoints;
        unchecked {
            newHullPoints = uint16(targetAttributes.hullPoints) + uint16(repairStrength);
        }
        targetAttributes.hullPoints = newHullPoints > targetAttributes.maxHullPoints
            ? targetAttributes.maxHullPoints
            : uint8(newHullPoints);
        EnumerableSet.remove(game.shipsWithZeroHP, _targetShipId);
    }

    // Returns true once the target's reactor timer reaches critical (>= 3);
    // caller (Game.sol) still owns the actual removal via its own
    // _removeShipFromGame, same as every other removal path in this file.
    function performEMP(
        GameData storage game,
        IShipAttributes shipAttributes,
        uint _actingShipId,
        uint _targetShipId,
        uint16 _variant
    ) external returns (bool critical) {
        Attributes storage targetAttributes = game.shipAttributes[_targetShipId];
        uint8 empStrength = shipAttributes.getSpecialStrength(Special.EMP, _variant);
        game.lastDamage[_targetShipId] = _actingShipId;
        targetAttributes.reactorCriticalTimer += empStrength;
        return targetAttributes.reactorCriticalTimer >= 3;
    }

    // FlakArray: self-centered AoE against both fleets, moved here from
    // Game.sol for the same reason as everything else in this file — same
    // math as before, just relocated.
    struct FlakContext {
        uint shipId; // ship using the FlakArray
        int16 row;
        int16 col;
        uint8 range;
        uint8 strength;
    }

    function performFlakArray(
        GameData storage game,
        IShipAttributes shipAttributes,
        uint _shipId,
        int16 _newRow,
        int16 _newCol,
        uint16 _variant
    ) external {
        FlakContext memory ctx = FlakContext({
            shipId: _shipId,
            row: _newRow,
            col: _newCol,
            range: shipAttributes.getSpecialRange(Special.FlakArray, _variant),
            strength: shipAttributes.getSpecialStrength(Special.FlakArray, _variant)
        });

        _processFlakArrayForFleet(
            game,
            ctx,
            game.playerActiveShipIds[game.metadata.creator]
        );
        _processFlakArrayForFleet(
            game,
            ctx,
            game.playerActiveShipIds[game.metadata.joiner]
        );
    }

    function _processFlakArrayForFleet(
        GameData storage game,
        FlakContext memory ctx,
        EnumerableSet.UintSet storage shipIds
    ) private {
        uint shipCount = EnumerableSet.length(shipIds);
        Position memory flakPos = Position(ctx.row, ctx.col);

        for (uint i = 0; i < shipCount; i++) {
            uint targetShipId = EnumerableSet.at(shipIds, i);
            Position storage shipPos = game.shipPositions[targetShipId].position;
            uint8 distance = _manhattanDistance(flakPos, shipPos);

            if (distance <= ctx.range && targetShipId != ctx.shipId) {
                game.lastDamage[targetShipId] = ctx.shipId;
                Attributes storage targetAttrs = game.shipAttributes[targetShipId];
                uint8 damage = uint8(
                    ctx.strength -
                        ((uint16(ctx.strength) * targetAttrs.damageReduction) / 100)
                );
                if (damage >= targetAttrs.hullPoints) {
                    targetAttrs.hullPoints = 0;
                    EnumerableSet.remove(game.shipMovedThisRound, targetShipId);
                    EnumerableSet.add(game.shipsWithZeroHP, targetShipId);
                } else {
                    targetAttrs.hullPoints -= damage;
                }
            }
        }
    }

    function _manhattanDistance(
        Position memory a,
        Position memory b
    ) private pure returns (uint8) {
        uint8 rowDiff = a.row > b.row
            ? uint8(uint16(a.row - b.row))
            : uint8(uint16(b.row - a.row));
        uint8 colDiff = a.col > b.col
            ? uint8(uint16(a.col - b.col))
            : uint8(uint16(b.col - a.col));
        return rowDiff + colDiff;
    }

    // Bundled to keep resolveAndApply's own parameter/local count low
    // (Solidity's legacy codegen runs out of stack slots quickly across a
    // multi-parameter external function with a loop and several locals).
    struct ResolveContext {
        uint gameId;
        uint shipId;
        uint16 variant;
        uint targetShipId;
        int16 newRow;
        int16 newCol;
    }

    // Bundled for the same stack-pressure reason as ResolveContext.
    // Relocations are deferred (not applied here) rather than applied
    // inline: a relocate that lands on a cell a removal is about to vacate
    // must run strictly after that removal, since Game.sol's
    // _removeShipFromGame clears a ship's grid cell using that ship's own
    // stored position — if a relocate already overwrote that cell first,
    // the removal would wipe the relocated ship's new occupancy right back
    // out. Game.sol applies removals (via its own _removeShipFromGame) and
    // then calls applyRelocations, in that order.
    struct EffectResults {
        uint[] removeShipIds;
        uint8[] removeKinds;
        uint[] relocateShipIds;
        // row * 1000 + col (both always non-negative, well within the grid) —
        // packed into one array instead of two to keep this return struct's
        // ABI decode/encode footprint down.
        int32[] relocatePositions;
    }

    function resolveAndApply(
        GameData storage game,
        address resolver,
        ResolveContext memory ctx
    ) external returns (EffectResults memory results) {
        SpecialEffect[] memory effects = IFactionAbilityResolver(resolver)
            .resolveFactionAbility(
                ctx.gameId,
                ctx.shipId,
                ctx.variant,
                ctx.targetShipId,
                ctx.newRow,
                ctx.newCol
            );

        // Allocate for the worst case (every effect turns out to need
        // removal, or every effect turns out to relocate), fill in a single
        // pass, then shrink the length words in place — same pattern
        // Game.getAllShipPositions already uses.
        results.removeShipIds = new uint[](effects.length);
        results.removeKinds = new uint8[](effects.length);
        results.relocateShipIds = new uint[](effects.length);
        results.relocatePositions = new int32[](effects.length);
        uint removeIdx;
        uint relocateIdx;

        for (uint i = 0; i < effects.length; i++) {
            SpecialEffect memory effect = effects[i];
            (bool removed, uint8 kind) = _applyEffect(game, ctx.shipId, effect);
            if (removed) {
                results.removeShipIds[removeIdx] = effect.shipId;
                results.removeKinds[removeIdx] = kind;
                removeIdx++;
            } else if (effect.newRow != NO_RELOCATE) {
                results.relocateShipIds[relocateIdx] = effect.shipId;
                results.relocatePositions[relocateIdx] =
                    int32(effect.newRow) *
                    1000 +
                    int32(effect.newCol);
                relocateIdx++;
            }
        }

        uint[] memory removeShipIds = results.removeShipIds;
        uint8[] memory removeKinds = results.removeKinds;
        uint[] memory relocateShipIds = results.relocateShipIds;
        int32[] memory relocatePositions = results.relocatePositions;
        assembly {
            mstore(removeShipIds, removeIdx)
            mstore(removeKinds, removeIdx)
            mstore(relocateShipIds, relocateIdx)
            mstore(relocatePositions, relocateIdx)
        }
    }

    // Applies one effect's hull/reactor delta directly to game storage
    // (relocation is deferred — see EffectResults). Returns (true, kind) if
    // the ship needs removing via Game.sol's _removeShipFromGame (kind: 1 =
    // retreat, 2 = destroy) — Game.sol acts on this without re-deriving it.
    function _applyEffect(
        GameData storage game,
        uint _actingShipId,
        SpecialEffect memory _effect
    ) private returns (bool removed, uint8 kind) {
        if (_effect.removalKind != 0) {
            return (true, _effect.removalKind);
        }

        Attributes storage attrs = game.shipAttributes[_effect.shipId];

        if (_effect.reactorTimerDelta != 0) {
            int16 newTimer = int16(uint16(attrs.reactorCriticalTimer)) +
                int16(_effect.reactorTimerDelta);
            if (newTimer < 0) newTimer = 0;
            // A reactor delta that just went critical destroys the ship —
            // it never gets to apply a hull delta or relocate from this same
            // effect (mirrors the old ramming code's "a rammer destroyed by
            // its own 3rd ram never occupies the tile" behavior).
            if (newTimer >= 3) return (true, 2);
            attrs.reactorCriticalTimer = uint8(uint16(newTimer));
        }

        if (_effect.hullDelta != 0) {
            _applyHullDelta(
                game,
                attrs,
                _effect.shipId,
                _effect.hullDelta,
                _actingShipId
            );
        }

        return (false, 0);
    }

    // Capped at maxHullPoints on heal, same as RepairDrones.
    function _applyHullDelta(
        GameData storage game,
        Attributes storage attrs,
        uint _shipId,
        int16 _hullDelta,
        uint _actingShipId
    ) private {
        if (_hullDelta < 0) {
            uint16 damage = uint16(uint32(-int32(_hullDelta)));
            if (damage >= attrs.hullPoints) {
                attrs.hullPoints = 0;
                EnumerableSet.remove(game.shipMovedThisRound, _shipId);
                EnumerableSet.add(game.shipsWithZeroHP, _shipId);
                game.lastDamage[_shipId] = _actingShipId;
            } else {
                attrs.hullPoints -= uint8(damage);
            }
        } else {
            uint16 newHullPoints = uint16(attrs.hullPoints) +
                uint16(uint16(_hullDelta));
            attrs.hullPoints = newHullPoints > attrs.maxHullPoints
                ? attrs.maxHullPoints
                : uint8(newHullPoints);
            EnumerableSet.remove(game.shipsWithZeroHP, _shipId);
        }
    }

    // Applies deferred relocations — call after Game.sol has applied every
    // removal from the same resolveAndApply's EffectResults, so a relocate
    // never gets clobbered by a same-batch removal clearing its destination.
    function applyRelocations(
        GameData storage game,
        uint[] memory _shipIds,
        int32[] memory _positions
    ) external {
        for (uint i = 0; i < _shipIds.length; i++) {
            int16 newRow = int16(_positions[i] / 1000);
            int16 newCol = int16(_positions[i] % 1000);
            Position storage p = game.shipPositions[_shipIds[i]].position;
            game.grid[p.row][p.col] = 0;
            game.grid[newRow][newCol] = _shipIds[i];
            p.row = newRow;
            p.col = newCol;
        }
    }
}

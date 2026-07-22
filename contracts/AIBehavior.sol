// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./IMaps.sol";
import "./IShipAttributes.sol";

// Single-player AI turn-decision engine. Every function here is
// internal/pure/view (no storage writes), so this compiles as a plain
// internal Solidity library — inlined into SinglePlayerMatch's own
// bytecode, no separate deployment/delegatecall needed (unlike
// SpecialEffectsLib.sol, which needs external+storage because it writes
// game state; this only ever reads and returns a decision).
//
// Design constraint: every decision here is paid for in gas by the human
// player triggering takeAITurn, and Solidity has no real search/pathfinding
// primitives. So this is deliberately a cheap ordered priority-list per
// archetype (check a primitive, act or fall through) rather than anything
// resembling enumerate-and-score optimization. Movement ("step toward"/
// "step away") is greedy axis-priority stepping toward/away from a single
// target point, not pathfinding — it ignores obstacles/other ships, the
// same simplification the original v0 script already had. SinglePlayerMatch
// wraps each ship's actual moveShip call in try/catch specifically to
// absorb the rare case this produces an illegal move (e.g. stepping onto an
// occupied cell) rather than reverting the whole turn.
library AIBehavior {
    struct Decision {
        int16 destRow;
        int16 destCol;
        ActionType action;
        uint actionTarget;
    }

    // Bundles the values almost every function here needs, to keep
    // individual function signatures short — Solidity's legacy codegen
    // runs out of stack slots quickly once a view function has ~6+
    // parameters plus a handful of locals, the same issue SpecialEffectsLib
    // hit earlier for the same reason.
    struct Ctx {
        GameDataView g;
        IMaps maps;
        uint gameId;
        uint shipId;
        Position pos;
        Attributes attrs;
    }

    // ---- shared lookups over GameDataView (already fetched once per
    // takeAITurn call — these never make a new Game call) ----

    function findPosition(
        GameDataView memory g,
        uint shipId
    ) internal pure returns (Position memory pos, bool found) {
        for (uint i = 0; i < g.shipPositions.length; i++) {
            if (g.shipPositions[i].shipId == shipId) {
                return (g.shipPositions[i].position, true);
            }
        }
    }

    function findAttributes(
        GameDataView memory g,
        uint shipId
    ) internal pure returns (Attributes memory attrs, bool found) {
        for (uint i = 0; i < g.shipIds.length; i++) {
            if (g.shipIds[i] == shipId) {
                return (g.shipAttributes[i], true);
            }
        }
    }

    function _manhattan(
        Position memory a,
        Position memory b
    ) private pure returns (uint16) {
        uint16 rowDiff = a.row > b.row
            ? uint16(a.row - b.row)
            : uint16(b.row - a.row);
        uint16 colDiff = a.col > b.col
            ? uint16(a.col - b.col)
            : uint16(b.col - a.col);
        return rowDiff + colDiff;
    }

    // Enemy (opposing side) in manhattan range with LOS, preferring the
    // lowest nonzero HP target (focus the weakest); if every in-range enemy
    // is already at 0 HP, returns the first one found (still a legal Shoot,
    // still meaningful reactor-timer progress toward removing it).
    function _bestEnemyInRange(
        Ctx memory ctx,
        Position memory fromPos,
        uint8 range
    ) private view returns (uint targetId, bool found) {
        uint8 bestHp = type(uint8).max;
        bool bestIsZero = false;
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0 || !sp.isCreator)
                continue; // AI is always joiner, so enemies are isCreator
            uint16 dist = _manhattan(fromPos, sp.position);
            if (dist > range) continue;
            if (
                dist > 1 &&
                !ctx.maps.hasMaps(
                    ctx.gameId,
                    fromPos.row,
                    fromPos.col,
                    sp.position.row,
                    sp.position.col
                )
            ) continue;

            (Attributes memory attrs, bool attrsFound) = findAttributes(
                ctx.g,
                sp.shipId
            );
            if (!attrsFound) continue;

            if (!found) {
                targetId = sp.shipId;
                found = true;
                bestHp = attrs.hullPoints;
                bestIsZero = attrs.hullPoints == 0;
                continue;
            }
            if (bestIsZero && attrs.hullPoints > 0) {
                // any live target beats defaulting to a 0-HP one
                targetId = sp.shipId;
                bestHp = attrs.hullPoints;
                bestIsZero = false;
            } else if (
                !bestIsZero && attrs.hullPoints > 0 && attrs.hullPoints < bestHp
            ) {
                targetId = sp.shipId;
                bestHp = attrs.hullPoints;
            }
        }
    }

    // Same shape as _bestEnemyInRange but for the AI's own side, preferring
    // a 0-HP ally (a RepairDrones hit revives it) over the most-injured
    // alive ally.
    function _bestAllyToHeal(
        Ctx memory ctx,
        uint8 range
    ) private pure returns (uint targetId, bool found) {
        uint8 bestHp = type(uint8).max;
        bool bestIsZero = false;
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0 || sp.isCreator)
                continue; // own side only, not self
            if (_manhattan(ctx.pos, sp.position) > range) continue;

            (Attributes memory attrs, bool attrsFound) = findAttributes(
                ctx.g,
                sp.shipId
            );
            if (!attrsFound || attrs.hullPoints >= attrs.maxHullPoints)
                continue; // not actually injured

            bool isZero = attrs.hullPoints == 0;
            if (!found) {
                targetId = sp.shipId;
                found = true;
                bestHp = attrs.hullPoints;
                bestIsZero = isZero;
                continue;
            }
            if (isZero && !bestIsZero) {
                targetId = sp.shipId;
                bestHp = attrs.hullPoints;
                bestIsZero = true;
            } else if (isZero == bestIsZero && attrs.hullPoints < bestHp) {
                targetId = sp.shipId;
                bestHp = attrs.hullPoints;
            }
        }
    }

    // Enemy at exactly 0 HP, adjacent (Ram's fixed range — see
    // SinglePlayerMatch's header comment on why this isn't discovered
    // dynamically from RamResolver). LOS is guaranteed at distance 1
    // (mirrors Game._performShoot's own "can always see adjacent" rule), so
    // no Maps call needed here.
    function _zeroHPEnemyAdjacent(
        Ctx memory ctx
    ) private pure returns (uint targetId, bool found) {
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0 || !sp.isCreator)
                continue;
            if (_manhattan(ctx.pos, sp.position) != 1) continue;
            (Attributes memory attrs, bool attrsFound) = findAttributes(
                ctx.g,
                sp.shipId
            );
            if (attrsFound && attrs.hullPoints == 0) return (sp.shipId, true);
        }
    }

    // Nearest enemy position, anywhere on the board (any HP). preferZeroHP
    // makes this look only at 0-HP enemies first (for Rammer beelining
    // toward a ram opportunity), falling back to any enemy if none exist.
    function _nearestEnemyPosition(
        Ctx memory ctx,
        bool preferZeroHP
    ) private pure returns (Position memory pos, bool found) {
        uint16 bestDist = type(uint16).max;
        if (preferZeroHP) {
            for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
                ShipPosition memory sp = ctx.g.shipPositions[i];
                if (sp.shipId == ctx.shipId || sp.status != 0 || !sp.isCreator)
                    continue;
                (Attributes memory attrs, bool attrsFound) = findAttributes(
                    ctx.g,
                    sp.shipId
                );
                if (!attrsFound || attrs.hullPoints != 0) continue;
                uint16 dist = _manhattan(ctx.pos, sp.position);
                if (!found || dist < bestDist) {
                    pos = sp.position;
                    found = true;
                    bestDist = dist;
                }
            }
            if (found) return (pos, found);
        }
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0 || !sp.isCreator)
                continue;
            uint16 dist = _manhattan(ctx.pos, sp.position);
            if (!found || dist < bestDist) {
                pos = sp.position;
                found = true;
                bestDist = dist;
            }
        }
    }

    function _nearestScoringTile(
        ScoringPosition[] memory scoringPositions,
        Position memory myPos
    ) private pure returns (Position memory pos, bool found) {
        uint16 bestDist = type(uint16).max;
        for (uint i = 0; i < scoringPositions.length; i++) {
            Position memory candidate = Position({
                row: scoringPositions[i].row,
                col: scoringPositions[i].col
            });
            uint16 dist = _manhattan(myPos, candidate);
            if (!found || dist < bestDist) {
                pos = candidate;
                found = true;
                bestDist = dist;
            }
        }
    }

    // Greedy axis-priority step toward target, clamped to movement budget.
    // Covers as much of the larger-delta axis as the budget allows first,
    // then spends any remainder on the other axis — the resulting point is
    // always within movement of `from` (a legal moveShip destination) and
    // strictly closer to `to`. Does not check grid bounds or occupancy
    // (see this file's header comment) — `to` is always an existing,
    // in-bounds ship/tile position, and moving partway toward an in-bounds
    // point from an in-bounds point stays in bounds.
    function _stepToward(
        Position memory from,
        Position memory to,
        uint8 movement
    ) private pure returns (Position memory) {
        int16 rowDelta = to.row - from.row;
        int16 colDelta = to.col - from.col;
        // Grid coordinates are tiny (rows 0-10, cols 0-16), so these deltas
        // are always well within int16 range — negating them can't overflow.
        uint16 rowDist = rowDelta < 0 ? uint16(-rowDelta) : uint16(rowDelta);
        uint16 colDist = colDelta < 0 ? uint16(-colDelta) : uint16(colDelta);

        uint16 budget = movement;
        int16 rowStep;
        int16 colStep;
        if (rowDist >= colDist) {
            uint16 useRow = rowDist < budget ? rowDist : budget;
            rowStep = rowDelta < 0 ? -int16(useRow) : int16(useRow);
            budget -= useRow;
            uint16 useCol = colDist < budget ? colDist : budget;
            colStep = colDelta < 0 ? -int16(useCol) : int16(useCol);
        } else {
            uint16 useCol = colDist < budget ? colDist : budget;
            colStep = colDelta < 0 ? -int16(useCol) : int16(useCol);
            budget -= useCol;
            uint16 useRow = rowDist < budget ? rowDist : budget;
            rowStep = rowDelta < 0 ? -int16(useRow) : int16(useRow);
        }
        return Position({row: from.row + rowStep, col: from.col + colStep});
    }

    // Same idea, opposite direction, clamped to the grid (retreating can
    // run off the board, unlike stepping toward an existing in-bounds
    // target).
    function _stepAway(
        Position memory from,
        Position memory threat,
        uint8 movement,
        int16 gridHeight,
        int16 gridWidth
    ) private pure returns (Position memory) {
        // Mirror threat through `from` to get an "away" target point, then
        // reuse _stepToward's budget-allocation logic toward that point.
        int16 awayRow = from.row + (from.row - threat.row);
        int16 awayCol = from.col + (from.col - threat.col);
        if (awayRow < 0) awayRow = 0;
        if (awayRow >= gridHeight) awayRow = gridHeight - 1;
        if (awayCol < 0) awayCol = 0;
        if (awayCol >= gridWidth) awayCol = gridWidth - 1;
        return
            _stepToward(from, Position({row: awayRow, col: awayCol}), movement);
    }

    // ---- per-archetype rule lists ----

    // Grunt & Aggressor share this v1: shoot from here if anything's in
    // range, else close distance and re-check from the new position — a
    // direct generalization of the original v0 script's "adjacent enemy:
    // fire; else step left and fire if now adjacent" shape, just toward the
    // nearest enemy instead of a fixed direction. _bestEnemyInRange already
    // focuses the weakest target, which covers the "prioritize kills" intent
    // for both without inventing a fake distinction between the two.
    function decideEngageOrApproach(
        Ctx memory ctx
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        (uint target, bool found) = _bestEnemyInRange(
            ctx,
            ctx.pos,
            ctx.attrs.range
        );
        if (found) {
            d.action = ActionType.Shoot;
            d.actionTarget = target;
            return d;
        }

        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            false
        );
        if (!enemyFound) return d;

        Position memory newPos = _stepToward(
            ctx.pos,
            enemyPos,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
        (uint target2, bool found2) = _bestEnemyInRange(
            ctx,
            newPos,
            ctx.attrs.range
        );
        if (found2) {
            d.action = ActionType.Shoot;
            d.actionTarget = target2;
        }
    }

    // Shoots from range without moving when possible; retreats (steps away
    // from the nearest enemy) rather than staying adjacent to engage.
    function decideSniper(
        Ctx memory ctx,
        int16 gridHeight,
        int16 gridWidth
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            false
        );
        if (!enemyFound) return d;
        uint16 dist = _manhattan(ctx.pos, enemyPos);

        if (dist > 1) {
            (uint target, bool found) = _bestEnemyInRange(
                ctx,
                ctx.pos,
                ctx.attrs.range
            );
            if (found) {
                d.action = ActionType.Shoot;
                d.actionTarget = target;
                return d;
            }
            // out of range entirely: close the gap partway, then re-check
            Position memory newPos = _stepToward(
                ctx.pos,
                enemyPos,
                ctx.attrs.movement
            );
            d.destRow = newPos.row;
            d.destCol = newPos.col;
            (uint target2, bool found2) = _bestEnemyInRange(
                ctx,
                newPos,
                ctx.attrs.range
            );
            if (found2) {
                d.action = ActionType.Shoot;
                d.actionTarget = target2;
            }
            return d;
        }

        // adjacent to an enemy: retreat rather than engage
        Position memory awayPos = _stepAway(
            ctx.pos,
            enemyPos,
            ctx.attrs.movement,
            gridHeight,
            gridWidth
        );
        d.destRow = awayPos.row;
        d.destCol = awayPos.col;
    }

    // Heals the weakest ally in RepairDrones range if equipped with it;
    // otherwise behaves like Grunt; otherwise closes toward whichever ally
    // most needs staying in healing range of.
    function decideSupport(
        Ctx memory ctx,
        IShipAttributes shipAttributes,
        Special mySpecial,
        uint16 myVariant
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        if (mySpecial == Special.RepairDrones) {
            uint8 healRange = shipAttributes.getSpecialRange(
                Special.RepairDrones,
                myVariant
            );
            (uint allyTarget, bool allyFound) = _bestAllyToHeal(
                ctx,
                healRange
            );
            if (allyFound) {
                d.action = ActionType.Special;
                d.actionTarget = allyTarget;
                return d;
            }
        }

        (uint target, bool found) = _bestEnemyInRange(
            ctx,
            ctx.pos,
            ctx.attrs.range
        );
        if (found) {
            d.action = ActionType.Shoot;
            d.actionTarget = target;
            return d;
        }

        // Nothing to heal or shoot from here: move toward whichever ally is
        // most injured (stay useful), ignoring enemies entirely (Support
        // hangs back rather than chasing a fight).
        (uint allyTarget2, bool allyFound2) = _bestAllyToHeal(
            ctx,
            type(uint8).max
        );
        if (!allyFound2) return d;
        (Position memory allyPos, bool posFound) = findPosition(
            ctx.g,
            allyTarget2
        );
        if (!posFound) return d;
        Position memory newPos = _stepToward(
            ctx.pos,
            allyPos,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
    }

    // Holds/seeks unclaimed scoring tiles; shoots opportunistically from
    // wherever it ends up if an enemy is in range from the current
    // position (never gives up a free shot just to move toward a tile).
    function decideTurtle(
        Ctx memory ctx,
        ScoringPosition[] memory scoringPositions
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        (uint target, bool found) = _bestEnemyInRange(
            ctx,
            ctx.pos,
            ctx.attrs.range
        );
        if (found) {
            d.action = ActionType.Shoot;
            d.actionTarget = target;
            return d;
        }

        (Position memory tilePos, bool tileFound) = _nearestScoringTile(
            scoringPositions,
            ctx.pos
        );
        if (!tileFound) return d;
        Position memory newPos = _stepToward(
            ctx.pos,
            tilePos,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
    }

    // Faction-1 only: Rams an adjacent 0-HP enemy if variant is 1; otherwise
    // behaves like Grunt/Aggressor, but beelines toward a 0-HP enemy
    // anywhere on the board when nothing's in range, to set up the next
    // ram opportunity.
    function decideRammer(
        Ctx memory ctx,
        uint16 myVariant
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        if (myVariant == 1) {
            (uint ramTarget, bool ramFound) = _zeroHPEnemyAdjacent(ctx);
            if (ramFound) {
                d.action = ActionType.FactionAbility;
                d.actionTarget = ramTarget;
                return d;
            }
        }

        (uint target, bool found) = _bestEnemyInRange(
            ctx,
            ctx.pos,
            ctx.attrs.range
        );
        if (found) {
            d.action = ActionType.Shoot;
            d.actionTarget = target;
            return d;
        }

        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            true
        );
        if (!enemyFound) return d;
        Position memory newPos = _stepToward(
            ctx.pos,
            enemyPos,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
        (uint target2, bool found2) = _bestEnemyInRange(
            ctx,
            newPos,
            ctx.attrs.range
        );
        if (found2) {
            d.action = ActionType.Shoot;
            d.actionTarget = target2;
        }
    }
}

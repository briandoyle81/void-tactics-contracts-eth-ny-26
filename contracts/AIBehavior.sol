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
        MainWeapon mainWeapon;
        ScoringPosition[] scoringPositions;
        int16 gridWidth;
        int16 gridHeight;
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

    // Enemy (opposing side) in manhattan range with LOS. Primary sort key is
    // "standing on a scoring tile" (contesting the objective is worth more
    // than shaving HP off someone who isn't); within the same tier, prefers
    // the lowest nonzero HP target (focus the weakest), falling back to the
    // first found if every in-range enemy in that tier is already at 0 HP
    // (still a legal Shoot, still meaningful reactor-timer progress).
    function _bestEnemyInRange(
        Ctx memory ctx,
        Position memory fromPos,
        uint8 range
    ) private view returns (uint targetId, bool found) {
        uint8 bestHp = type(uint8).max;
        bool bestIsZero = false;
        bool bestOnTile = false;
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

            bool onTile = _isScoringTile(ctx.scoringPositions, sp.position);

            if (!found) {
                targetId = sp.shipId;
                found = true;
                bestHp = attrs.hullPoints;
                bestIsZero = attrs.hullPoints == 0;
                bestOnTile = onTile;
                continue;
            }
            if (onTile != bestOnTile) {
                // on-tile always beats off-tile, regardless of HP
                if (onTile) {
                    targetId = sp.shipId;
                    bestHp = attrs.hullPoints;
                    bestIsZero = attrs.hullPoints == 0;
                    bestOnTile = true;
                }
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

    function _isScoringTile(
        ScoringPosition[] memory scoringPositions,
        Position memory p
    ) private pure returns (bool) {
        for (uint i = 0; i < scoringPositions.length; i++) {
            if (
                scoringPositions[i].row == p.row &&
                scoringPositions[i].col == p.col
            ) return true;
        }
        return false;
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

    // Nearest enemy position, anywhere on the board (any HP). preferZeroHP
    // makes this look only at 0-HP enemies first, falling back to any enemy
    // if none exist — kept as a general targeting option even though no
    // archetype currently passes true (Rammer, the only caller that did,
    // was removed) — e.g. a future assassin-style archetype beelining for
    // a finishing blow would want this exact behavior.
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

    function _isOccupiedByOther(
        Ctx memory ctx,
        Position memory p
    ) private pure returns (bool) {
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0) continue;
            if (sp.position.row == p.row && sp.position.col == p.col)
                return true;
        }
        return false;
    }

    // Picks a scoring-tile movement target. Preference order:
    //   1. Unclaimed (unoccupied) tile on this ship's weapon-range-
    //      appropriate side of the grid — long-range weapons (Railgun,
    //      MissileLauncher) stick close to the AI's own spawn side (high
    //      columns), short-range weapons (Laser, PlasmaCannon) push toward
    //      the midline/opponent's side (low columns) — nearest first.
    //   2. Unclaimed tile on either side, nearest first (no matching-side
    //      tile exists on this map).
    //   3. Any tile at all, even one currently held by a ship, nearest
    //      first — so there's always somewhere to head as long as scoring
    //      tiles exist, rather than stalling out with nothing to do.
    function _bestScoringTile(
        Ctx memory ctx
    ) private pure returns (Position memory pos, bool found) {
        int16 midCol = ctx.gridWidth / 2;
        bool longRange = ctx.mainWeapon == MainWeapon.Railgun ||
            ctx.mainWeapon == MainWeapon.MissileLauncher;

        for (uint pass = 0; pass < 3; pass++) {
            uint16 bestDist = type(uint16).max;
            for (uint i = 0; i < ctx.scoringPositions.length; i++) {
                Position memory candidate = Position({
                    row: ctx.scoringPositions[i].row,
                    col: ctx.scoringPositions[i].col
                });
                if (pass < 2 && _isOccupiedByOther(ctx, candidate)) continue;
                if (pass == 0) {
                    bool onOwnSide = longRange
                        ? candidate.col >= midCol
                        : candidate.col <= midCol;
                    if (!onOwnSide) continue;
                }
                uint16 dist = _manhattan(ctx.pos, candidate);
                if (!found || dist < bestDist) {
                    pos = candidate;
                    bestDist = dist;
                    found = true;
                }
            }
            if (found) return (pos, true);
        }
    }

    // True when this ship is already standing on a scoring tile with no
    // enemy in range from here (caller guarantees the latter — the
    // free-shoot check already failed) and should therefore just hold
    // position instead of being lured away by "seek a scoring tile"/
    // "approach the enemy" movement logic. Overridden only when ALL of:
    // this ship could actually reach a shot by moving anyway, another
    // living ally could reach this tile itself if this ship leaves, and no
    // enemy is currently positioned to threaten the tile — i.e. leaving is
    // genuinely free. Any one of those failing means hold.
    function _shouldHoldScoringTile(Ctx memory ctx) private view returns (bool) {
        if (!_isScoringTile(ctx.scoringPositions, ctx.pos)) return false;

        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            false
        );
        if (enemyFound) {
            Position memory stepped = _stepToward(
                ctx.pos,
                enemyPos,
                ctx.attrs.movement
            );
            (, bool couldShoot) = _bestEnemyInRange(
                ctx,
                stepped,
                ctx.attrs.range
            );
            if (
                couldShoot &&
                _allyCanCoverTile(ctx) &&
                !_enemyThreatensTile(ctx, ctx.pos)
            ) {
                return false;
            }
        }
        return true;
    }

    // Any other living ally that could reach this position under its own
    // movement stat this turn — used to decide whether it's safe for the
    // ship currently on the tile to leave it uncovered.
    function _allyCanCoverTile(
        Ctx memory ctx
    ) private view returns (bool) {
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.shipId == ctx.shipId || sp.status != 0 || sp.isCreator)
                continue; // own side only, not self
            (Attributes memory attrs, bool found) = findAttributes(
                ctx.g,
                sp.shipId
            );
            if (!found) continue;
            if (_manhattan(sp.position, ctx.pos) <= attrs.movement)
                return true;
        }
        return false;
    }

    // Any living enemy whose weapon range (with LOS) already reaches the
    // given tile from its current position — used to decide whether a tile
    // is actually safe to leave uncovered.
    function _enemyThreatensTile(
        Ctx memory ctx,
        Position memory tilePos
    ) private view returns (bool) {
        for (uint i = 0; i < ctx.g.shipPositions.length; i++) {
            ShipPosition memory sp = ctx.g.shipPositions[i];
            if (sp.status != 0 || !sp.isCreator) continue;
            (Attributes memory attrs, bool found) = findAttributes(
                ctx.g,
                sp.shipId
            );
            if (!found) continue;
            uint16 dist = _manhattan(sp.position, tilePos);
            if (dist > attrs.range) continue;
            if (
                dist > 1 &&
                !ctx.maps.hasMaps(
                    ctx.gameId,
                    sp.position.row,
                    sp.position.col,
                    tilePos.row,
                    tilePos.col
                )
            ) continue;
            return true;
        }
        return false;
    }

    function _holdDecision(
        Ctx memory ctx
    ) private pure returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;
    }

    // Shared fallback movement step used by every archetype whose primary
    // directive (shoot, heal, retreat) didn't produce a decision this turn:
    // close on the nearest enemy, but only follow through on that step if it
    // would actually bring an enemy into range this turn — otherwise
    // redirect the move toward a scoring tile instead, since walking toward
    // an enemy that stays out of reach anyway makes no more progress than
    // walking toward the objective. Falls back to the enemy-directed step if
    // no scoring tile exists on the map at all (or enemyFound is false and
    // there's no tile either, in which case this just holds position).
    function _approachOrSeekTile(
        Ctx memory ctx,
        Position memory enemyPos,
        bool enemyFound
    ) private view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        Position memory towardEnemy = ctx.pos;
        if (enemyFound) {
            towardEnemy = _stepToward(ctx.pos, enemyPos, ctx.attrs.movement);
            (uint target, bool found) = _bestEnemyInRange(
                ctx,
                towardEnemy,
                ctx.attrs.range
            );
            if (found) {
                d.destRow = towardEnemy.row;
                d.destCol = towardEnemy.col;
                d.action = ActionType.Shoot;
                d.actionTarget = target;
                return d;
            }
        }

        (Position memory tilePos, bool tileFound) = _bestScoringTile(ctx);
        if (tileFound) {
            Position memory towardTile = _stepToward(
                ctx.pos,
                tilePos,
                ctx.attrs.movement
            );
            d.destRow = towardTile.row;
            d.destCol = towardTile.col;
            return d;
        }

        if (enemyFound) {
            d.destRow = towardEnemy.row;
            d.destCol = towardEnemy.col;
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
    // range, else close distance if that would actually bring an enemy into
    // range this turn, else redirect toward a scoring tile (see
    // _approachOrSeekTile) — a direct generalization of the original v0
    // script's "adjacent enemy: fire; else step left and fire if now
    // adjacent" shape, just toward the nearest enemy instead of a fixed
    // direction. _bestEnemyInRange already focuses the weakest/on-tile
    // target, which covers the "prioritize kills" intent for both without
    // inventing a fake distinction between the two.
    function decideEngageOrApproach(
        Ctx memory ctx
    ) internal view returns (Decision memory d) {
        (uint target, bool found) = _bestEnemyInRange(
            ctx,
            ctx.pos,
            ctx.attrs.range
        );
        if (found) {
            d.destRow = ctx.pos.row;
            d.destCol = ctx.pos.col;
            d.action = ActionType.Shoot;
            d.actionTarget = target;
            return d;
        }

        if (_shouldHoldScoringTile(ctx)) return _holdDecision(ctx);

        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            false
        );
        return _approachOrSeekTile(ctx, enemyPos, enemyFound);
    }

    // Shoots from range without moving when possible; retreats (steps away
    // from the nearest enemy) rather than staying adjacent to engage. When
    // out of range entirely, closes the gap only if that would bring an
    // enemy into range this turn, else redirects toward a scoring tile (see
    // _approachOrSeekTile) — Sniper's weapon is always long-range (Railgun),
    // so this naturally biases it toward tiles on its own side.
    function decideSniper(
        Ctx memory ctx
    ) internal view returns (Decision memory d) {
        (Position memory enemyPos, bool enemyFound) = _nearestEnemyPosition(
            ctx,
            false
        );
        if (!enemyFound) {
            if (_shouldHoldScoringTile(ctx)) return _holdDecision(ctx);
            return _approachOrSeekTile(ctx, enemyPos, false);
        }
        uint16 dist = _manhattan(ctx.pos, enemyPos);

        if (dist > 1) {
            (uint target, bool found) = _bestEnemyInRange(
                ctx,
                ctx.pos,
                ctx.attrs.range
            );
            if (found) {
                d.destRow = ctx.pos.row;
                d.destCol = ctx.pos.col;
                d.action = ActionType.Shoot;
                d.actionTarget = target;
                return d;
            }
            if (_shouldHoldScoringTile(ctx)) return _holdDecision(ctx);
            return _approachOrSeekTile(ctx, enemyPos, true);
        }

        // adjacent to an enemy: retreat rather than engage
        d.action = ActionType.Pass;
        Position memory awayPos = _stepAway(
            ctx.pos,
            enemyPos,
            ctx.attrs.movement,
            ctx.gridHeight,
            ctx.gridWidth
        );
        d.destRow = awayPos.row;
        d.destCol = awayPos.col;
    }

    // Heals the weakest ally in RepairDrones range if equipped with it, or
    // shoots an enemy in range — both free actions from the current
    // position, so neither is ever skipped in favor of moving. Otherwise
    // seeks an unclaimed scoring tile first (the objective matters more
    // than positioning near an ally that isn't hurt yet), falling back to
    // closing toward whichever ally most needs staying in healing range of
    // if no scoring tile exists on the map.
    function decideSupport(
        Ctx memory ctx,
        IShipAttributes shipAttributes,
        Special mySpecial,
        uint16 myVariant
    ) internal view returns (Decision memory d) {
        d.destRow = ctx.pos.row;
        d.destCol = ctx.pos.col;
        d.action = ActionType.Pass;

        // KNOWN LIMITATION: this hardcodes "faction 1's healer lives at
        // slot 2" (Slot2 == RepairDrones for variant 1 today). Special is a
        // per-faction local slot now, not a global identity — slot 2 could
        // be a damage special for some other faction, and this check would
        // silently misfire (treating a non-heal special as a heal, or vice
        // versa skipping a real heal at a different slot). Needs a
        // data-driven signal (e.g. a SpecialData.isHeal-style flag) before
        // this Support archetype can work correctly for factions other
        // than variant 1 — out of scope for the slot-based dispatch
        // refactor that introduced this comment.
        if (mySpecial == Special.Slot2) {
            uint8 healRange = shipAttributes.getSpecialRange(
                Special.Slot2,
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

        if (_shouldHoldScoringTile(ctx)) return d; // already Pass-at-current-pos

        (Position memory dest, bool destFound) = _bestScoringTile(ctx);
        if (!destFound) {
            // No scoring tile on this map: fall back to staying useful near
            // whichever ally is most injured.
            (uint allyTarget, bool allyFound) = _bestAllyToHeal(
                ctx,
                type(uint8).max
            );
            if (!allyFound) return d;
            (dest, destFound) = findPosition(ctx.g, allyTarget);
            if (!destFound) return d;
        }

        Position memory newPos = _stepToward(
            ctx.pos,
            dest,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
    }

    // Holds/seeks unclaimed scoring tiles (weapon-range-biased, see
    // _bestScoringTile); shoots opportunistically from wherever it ends up
    // if an enemy is in range from the current position (never gives up a
    // free shot just to move toward a tile).
    function decideTurtle(
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

        if (_shouldHoldScoringTile(ctx)) return d; // already Pass-at-current-pos

        (Position memory tilePos, bool tileFound) = _bestScoringTile(ctx);
        if (!tileFound) return d;

        // The best available tile may already be held by another ship
        // (everything else on the map is claimed) — standing exactly on it
        // is an illegal move anyway, so once within 1 tile just hold there
        // rather than endlessly retrying the last step.
        if (
            _isOccupiedByOther(ctx, tilePos) &&
            _manhattan(ctx.pos, tilePos) <= 1
        ) {
            return d;
        }

        Position memory newPos = _stepToward(
            ctx.pos,
            tilePos,
            ctx.attrs.movement
        );
        d.destRow = newPos.row;
        d.destCol = newPos.col;
    }

}

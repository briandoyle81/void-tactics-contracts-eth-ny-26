# Frontend Update Guide — 2026-08-26 Miscellaneous Fixes

**Written: 2026-08-26, updated 2026-08-27.** Describes contract state as of this date — check the contracts repo's recent commits if it's been a while. Three unrelated changes: `RandomManager.sol`'s commit-reveal rewrite (see below — as of 2026-08-27 this needs no new integration steps at all, mint→construct is still exactly 2 transactions), a new revert condition on the three targeted combat effects, and two new reverts in the roguelike campaign mode (`RoguelikeMatch.sol`). Nothing else in the ship-purchase/construct flow changed.

## New: two roguelike-campaign reverts (`RoguelikeMatch.sol`)

**Note:** these postdate the roguelike-campaign frontend doc you already have — not reflected there, only here.

**File:** `contracts/RoguelikeMatch.sol` (see `docs/pre-audit.md` SP-04/SP-05).

| Error | Where | Meaning |
|---|---|---|
| `NodeAlreadyDefeated` | `enterCombatNode` | This Combat node was already won earlier in the current run and is being re-entered via a `twoWay` back-edge (e.g. a resupply hub with routes to more than one fight). Re-fighting it is blocked outright — its kill rewards were already paid out once and can't be farmed again this run. Grey out/disable that route in the UI once a node shows as defeated rather than letting the player attempt it. |
| `ActiveGameInProgress` | `retreatRun(0)` | Can't abandon the run "between nodes" while a combat match is still live. Call `retreatRun(activeGameId)` to forfeit the match first, then `retreatRun(0)` to end the run — or just let the match resolve naturally. |

## New: targeting an already-destroyed/fled ship now reverts

**File(s):** `contracts/DroneSwarmResolver.sol`, `contracts/EMPResolver.sol`, `contracts/RamResolver.sol` (see `docs/pre-audit.md` SP-02).

`Drone Swarm`, `EMP`, and `Ram` special-ability targeting all previously accepted a `targetShipId` that belonged to a ship already destroyed or fled from the game — `shipPositions` entries aren't deleted on removal, only status-flipped, so the existing `target.shipId == 0` check didn't catch this. Each resolver's `validateTarget` (or equivalent pre-check) now also reverts if `target.status != 0`:

| Contract | Error |
|---|---|
| `DroneSwarmResolver` | `TargetNotFound` |
| `EMPResolver` | `TargetNotFound` |
| `RamResolver` | `InvalidRamTarget` |

**Why this matters for the UI:** if your targeting picker builds its candidate list from a snapshot that isn't refreshed every turn, a target that died or fled since the snapshot was taken will now cause the action to revert instead of (previously) silently corrupting round-transition state. Refresh live ship status right before submitting one of these three actions, or catch the revert and re-prompt target selection.

---

# RandomManager Commit-Reveal Rewrite

## TL;DR

**Buying and constructing ships is exactly 2 transactions, same as it always was — nothing new to integrate.**

1. Buy or claim ships (`purchaseWithFlow`, `FreeShipClaim.claimFreeShips`, etc.) — **unchanged**. Each new ship still gets a `serialNumber` at mint time via `RandomManager.requestRandomness()`, same as before.
2. Call `constructShip`/`constructAllMyShips`/`constructShips` — **unchanged call**. Internally, this now reveals each ship's randomness (locking it in permanently) on first use if the entropy source has had a chance to refresh, then applies it — no separate reveal transaction required.

This was a security fix (see `docs/pre-audit.md`'s C-01/C-02 remediation addendum, and the 2026-08-27 follow-up addendum, for the full writeup) — the original `RandomManager` let anyone predict or manipulate ship traits before committing to construct. The fix is real (traits are genuinely not previewable/manipulable before they're locked in), it just no longer requires a separate step to get it.

**History, for context:** earlier same-day versions of this doc described a mandatory middle "reveal" transaction (first one-per-ship, then batched). That step has since been folded into `constructShip` itself — construction now does the reveal internally on first use instead of requiring a prior `revealRandomness`/`revealRandomnessBatch` call. If you already built around the 3-step flow, it still works unchanged (calling `revealRandomness` ahead of time is harmless — `constructShip` just sees it's already revealed and uses the cached result) — but you no longer need to build it that way for new integrations.

## The one thing to still handle: too-early construction

`constructShip` can't succeed the instant after minting — it has to wait until the chain's randomness source has actually refreshed, which on Base is **not every block**. Measured empirically: Base's `block.prevrandao` only changes roughly every 6 L2 blocks (~12 seconds), because it's relayed from Ethereum L1's own randomness, not generated fresh per L2 block.

Practically:
- Best case: ~1 block (~2s) if the mint happened to land right before a refresh.
- Worst case: ~6 blocks (~12s) if it landed right after one.
- **Don't hardcode a wait time or a fixed block count.** Call the new view instead:

```solidity
function canFulfill(uint requestId) external view returns (bool);
function canFulfillBatch(uint[] calldata requestIds) external view returns (bool);
```

Poll `canFulfillBatch` with the full list of serial numbers from the mint (or just try `constructShip`/`constructAllMyShips` and retry on a `TooSoonToReveal` revert with a short backoff) rather than assuming any specific number of blocks or seconds. Returns `true` once every id in the batch is either already revealed or ready to be — since every request from one mint transaction shares one commit block, in practice they all flip to ready at once. If Base's block-time ratio ever changes, this adapts automatically — a hardcoded wait wouldn't.

## Suggested integration pattern

```
1. purchaseWithFlow(...) / claimFreeShips(...)                         — 1 tx, mints N ships
2. Read the new ship ids and their serialNumbers (Ships.ships(id).traits.serialNumber)
3. Poll canFulfillBatch(serialNumbers) until true (or catch TooSoonToReveal and retry)
4. constructShip(id) / constructAllMyShips() / constructShips(ids)     — 1 tx, reveals + constructs all N
```

That's it — 2 transactions total (mint, then construct), regardless of N. Step 3 is a free read, not a transaction.

## Errors reference

| Error | Where | Meaning |
|---|---|---|
| `RequestNotFound` | `constructShip` (via `fulfillRandomRequest`), `canFulfill`/`canFulfillBatch` (return `false` instead of reverting) | The ship's serial number was never issued by `requestRandomness`. Shouldn't happen from normal ship data — this would indicate a corrupted/mismatched id, a caller-side bug. |
| `TooSoonToReveal` | `constructShip` (via `fulfillRandomRequest`) | The randomness source hasn't refreshed since the ship was minted yet. Wait and retry, or check `canFulfillBatch` first. Not attacker-triggerable against you specifically — it only depends on chain time passing. |

## Optional: pre-warming (not required for new integrations)

`revealRandomness(uint requestId)` / `revealRandomnessBatch(uint[] requestIds)` still exist and do the same lock-in `constructShip` would do automatically — calling them ahead of time just moves the (SSTORE-heavy) first-reveal gas cost into its own transaction, e.g. if a backend keeper wants to spread that cost out ahead of a large batched `constructAllMyShips()` call, or if you want to preview a ship's fully-resolved traits (via `GenerateNewShip.generateShip`, using `RandomManager.requests(id).result`) before the player pays gas to construct. Nothing requires this — skip it entirely unless you have a specific reason to pre-warm.

```solidity
function revealRandomness(uint requestId) external returns (uint64);
function revealRandomnessBatch(uint[] calldata requestIds) external returns (uint64[] memory results);
function canRevealBatch(uint[] calldata requestIds) external view returns (bool); // true if calling revealRandomnessBatch on this exact array would succeed
```

`revealRandomnessBatch` tolerates an already-revealed id in its array (skips it, returns the cached result) rather than reverting the whole batch — this matters because reveal is permissionless, so a third party (or your own earlier pre-warm call) could have already revealed one of your ids. `RequestNotFound`/`TooSoonToReveal` still revert the whole batch, since neither is something a third party can selectively trigger against your specific array.

## What did NOT change

- Ship purchase/claim mechanics, pricing, tiers, referrals — all untouched.
- `constructShip`/`constructAllMyShips`/`constructShips`' call signatures — identical to before, and still exactly 2 transactions total per purchase, same as pre-rewrite.
- Everything downstream of construction (ship traits, rendering, gameplay) — unaffected; traits are still derived the same way, just from a value that's now actually unpredictable and permanently locked in, instead of freely previewable/manipulable.

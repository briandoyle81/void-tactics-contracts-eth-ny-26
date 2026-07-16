# Void Tactics Smart Contract Security & Code Quality Audit

> **Status:** Pre-audit internal review  
> **Date:** 2026-06-12  
> **Auditor:** Internal (Claude Code)  
> **Scope:** All contracts in `contracts/`

---

## Executive Summary

This audit covers 20 production Solidity contracts plus supporting interfaces, mocks, and renderer contracts in the Void Tactics on-chain turn-based strategy game. The contracts implement ship NFTs (ERC-721), a game loop (Lobbies → Fleets → Game), a scoring map system, an ERC-20 token (UTC), a ship-modification marketplace (DroneYard), and an NFT renderer.

**Overall Risk Level: HIGH** — Several high-severity issues exist that can affect game integrity, NFT security, or funds. The most urgent are: insecure on-chain randomness, multiple unguarded public functions that let anyone overwrite game state, a fee/version overwrite bug in `ShipAttributes.setCosts`, permanently locked UTC in `DroneYard`, a flak damage mutation bug, missing negative-coordinate validation, and multiple debug functions left in production.

| Severity | Count |
|---|---|
| Critical | 3 |
| High | 8 |
| Medium | 8 |
| Low | 8 |
| Informational | 10 |

*(Critical/High counts updated 2026-07-16: H-07 was reclassified to Critical — see C-01 above — shifting the original 2/9 split to 3/8. Does not include the Tournament/Maps addendum findings (T-01–T-04) added below, which post-date this snapshot.)*

---

## Critical Findings

### C-01 — `RandomManager.fulfillRandomRequest` Does Not Verify the Request Exists

**File:** `contracts/RandomManager.sol`, lines 20–29  
**Severity:** Critical  
**Status:** Reclassified 2026-07-16 (was H-07 — elevated to Critical, moved above the randomness-source finding below; not yet fixed)

`fulfillRandomRequest(uint _requestId)` accepts any `_requestId` value and returns a `block.prevrandao`-derived value. There is no mapping of outstanding requests, no check that the ID was ever issued by `requestRandomness()`, and no single-use prevention. Any caller (including MEV bots or validators) can call `fulfillRandomRequest` with a forged ID to front-run ship construction and predict or manipulate the random outcome before `constructShip` is called.

**Why it matters:** Combined with C-02 below, this means randomness has no commit-reveal protection whatsoever. An attacker can observe the mempool for a `constructShip` call, front-run with `fulfillRandomRequest` using the same serial number to learn the output, and selectively abort their own construction if the result is unfavourable.

---

### C-02 — Insecure On-Chain Randomness via `block.prevrandao`

**File:** `contracts/RandomManager.sol`, lines 14–28  
**Severity:** Critical

`requestRandomness()` and `fulfillRandomRequest()` both derive their output exclusively from `block.prevrandao` (formerly `DIFFICULTY`) and a simple incrementing counter. On PoS Ethereum and EVM-compatible chains using a similar mechanism, the block proposer knows `block.prevrandao` before committing the block, making it manipulable. A validator who is also a player (or colluding with one) can re-roll the random seed by skipping block proposals until a favorable value appears.

**Why it matters:** All ship trait randomness (accuracy, hull, speed, weapon, armor/shields, special ability, shiny flag, starting kill count, and ship name) flows through this function. An attacker can grind for max-stat ships, creating severe pay-to-win or cheat-to-win advantages. The comment `// TODO: Update to CadenceRandomConsumer` confirms this is a known placeholder, but the current contract is deployed.

---

### ~~C-03 — `Game.calculateShipAttributes` and `Game.calculateFleetAttributes` Are Unguarded Public State-Writing Functions~~

**File:** `contracts/Game.sol`, lines 247–274  
**Severity:** Critical  
**Status:** Fixed 2026-07-16 (see Addendum below)

`calculateShipAttributes(uint _gameId, uint _shipId)` is `public` with no access control and no check that the ship actually belongs to the specified game. Anyone can call it for any `(_gameId, _shipId)` pair and overwrite the in-game ship attributes (range, damage, hull points, movement, damage reduction) with freshly recalculated values from `ShipAttributes`.

**Why it matters:**
1. If a `ShipAttributes` version upgrade occurs mid-game, any player can re-roll their own ships' stats upward, breaking the game's snapshot model.
2. Attributes are intentionally snapshotted at game start so the `costsVersion` lock prevents in-flight changes; this function bypasses that snapshot entirely.
3. `calculateFleetAttributes(uint _gameId, uint[] memory _shipIds)` (line 267) has the same visibility and has no check that `_shipIds` belong to that game.

**Note (2026-07-16):** `games[_gameId].shipAttributes` (`Types.sol:154`) is scoped per-game, not global — so this finding was never about cross-game contamination (that part of the original concern was overstated; see L-01 note below). The real bug, confirmed and fixed, is that the write was unconditionally repeatable: nothing stopped this `public` function from being called again after the one-time snapshot `_initializeFleetAttributes` takes at game start, letting a live game's attributes be re-pulled from `ShipAttributes` mid-match if the admin changes its current version/costs. Visibility was intentionally left `public` (players are expected to self-serve this during fleet setup) — the fix is a snapshot-once guard, not access control. See the Addendum for the implementation.

---

## High Severity Findings

### ~~H-01 — `ShipAttributes.setCosts` Increments Version Then Overwrites It~~

**File:** `contracts/ShipAttributes.sol`, lines 342–345  
**Severity:** High  
**Status:** Fixed 2026-07-16

```solidity
function setCosts(Costs memory _costs) external onlyOwner {
    costs.version++;
    costs = _costs;  // ← overwrites costs.version with whatever _costs.version is
}
```

The function increments `costs.version`, then replaces the entire struct with the caller-supplied `_costs`. If the caller passes a `_costs.version` that is stale, zero, or matches the previous version, the version field will be wrong. All ships use `costsVersion` to detect staleness; a wrong version will either permanently lock all ships out of fleets (`ShipCostVersionMismatch`) or allow ships with outdated cost calculations to enter fleets silently.

**Fix:** `newVersion` is now computed from storage (`costs.version + 1`) *before* the struct is overwritten, and reasserted onto `costs.version` after `costs = _costs`, so the caller-supplied `_costs.version` is discarded entirely — it's no longer possible to corrupt the version by passing a stale/zero/duplicate value. This also resolves M-01 below, which is the same bug. `test/ShipCostsVersions.test.ts` and `test/Ships.test.ts` (104 tests) pass unchanged.

**Why it matters:** The costs-version system is the primary guard preventing ships with old (potentially underpriced) stats from entering competitive games. Corrupting it breaks fleet validation for all subsequent lobbies.

---

### ~~H-02 — `Game.moveShip` Does Not Validate Negative Grid Coordinates~~

**File:** `contracts/Game.sol`, lines 527–530  
**Severity:** High  
**Status:** Fixed 2026-07-16 (fixed together with M-06 below, same root cause)

```solidity
if (_newRow >= GRID_HEIGHT || _newCol >= GRID_WIDTH)
    revert InvalidMove();
```

Because `_newRow` and `_newCol` are `int16`, a player can pass negative values (e.g., `_newRow = -1`). The comparison `int16(-1) >= int16(11)` is `false`, so the bounds check passes. The ship is then placed in `game.grid[-1][-1]`, which in Solidity maps to a valid but unintended storage slot (a mapping with key `type(int16).max` for two's-complement). Similarly, `_placeShipOnGrid` (line 229) only checks `>= GRID_HEIGHT` and `>= GRID_WIDTH`, missing the lower-bound check.

**Why it matters:** A player can teleport ships to invisible negative-coordinate cells, escaping opponent fire while still being able to shoot, effectively making them invincible for the rest of the game.

**Fix:** Added `_newRow < 0 || _newCol < 0` to `moveShip`'s bounds check and `_row < 0 || _column < 0` to `_placeShipOnGrid`'s (M-06), alongside the existing upper-bound checks. Full test suite (301 tests) passes unchanged; no contract-size regression.

---

### ~~H-03 — FlakArray Mutates `flakStrength` Across Targets, Nerfing Subsequent Hits~~

**File:** `contracts/Game.sol`, lines 1069–1083  
**Severity:** High  
**Status:** Fixed 2026-07-16

```solidity
flakStrength = uint8(
    flakStrength -
        ((uint16(flakStrength) * damageReduction) / 100)
);
```

`flakStrength` is a value parameter passed into `_processFlakArrayForFleet`. The damage reduction is applied to `flakStrength` and the result is written back into the same variable. Each subsequent target in the loop therefore receives progressively reduced damage rather than the original `flakStrength` minus that target's own damage reduction. The second fleet call in `_performFlakArray` further inherits the already-reduced value.

**Why it matters:** The intended behaviour is "apply each target's damage reduction to the base flak strength." The actual behaviour penalises later targets (and the second fleet) with cumulative reductions. In edge cases where all targets have high damage reduction, the effective damage approaches zero for anything hit after the first target.

**Fix:** The per-target reduced damage is no longer written back into the `flakStrength` parameter. A naive fix (a new `uint8 damage` local) hit `CompilerError: Stack too deep` — this function is already at the stack-depth limit under `viaIR: false` (see `hardhat.config.ts`). Instead, the already-in-scope `damageReduction` variable's slot is reused to hold the computed damage once it's no longer needed for the reduction calculation itself, so the fix adds zero new stack slots and zero bytecode-size risk. `flakStrength` (the base value) is now read-only for the rest of the loop, so every target's damage is computed independently from the true base value, matching the intended behaviour. Full suite (301 tests) passes; no contract-size regression.

---

### ~~H-04 — `DroneYard` Has No Withdrawal Function; UTC Accumulates and Is Permanently Locked~~

**File:** `contracts/DroneYard.sol`, lines 113–163  
**Severity:** High  
**Status:** Fixed 2026-07-16

`modifyShip` transfers UTC tokens from the caller to `address(this)`, but `DroneYard` has no `withdraw`, no owner, no `Ownable`, and no rescue function. All modification fees are permanently locked in the contract with no mechanism to recover them.

**Why it matters:** Every ship modification permanently burns UTC tokens from the economy. If this is unintentional, it is a financial loss; if it was intended as a burn mechanism, the effect is undocumented and constitutes an undisclosed economic parameter.

**Fix:** `DroneYard` now inherits `Ownable` (deployer becomes owner via the existing Ignition deploy flow, same pattern as `Maps`/`ShipAttributes`/`GameResults`), and a new `onlyOwner` `withdraw(address _to)` sweeps the contract's full UTC balance to `_to`, emitting `Withdrawn(to, amount)`. Contract is tiny (6.6 KiB vs. the 24 KiB limit) so this carried no size risk. Full suite (301 tests) passes unchanged.

---

### ~~H-05 — `shipBreaker` Does Not Check `inFleet` Before Burning~~

**File:** `contracts/Ships.sol`, lines 701–739  
**Severity:** High  
**Status:** Fixed 2026-07-16

`shipBreaker` checks ownership (`s.owner != msg.sender`) but does **not** check `s.shipData.inFleet` before marking the ship destroyed and calling `_burn`. The `_update` override does check `inFleet` and would revert on the burn, so normally this is blocked — but only because the ERC-721 override is the last line of defence. If a ship is in a game, calling `shipBreaker` with its ID will revert at `_burn`, which is correct, but `s.shipData.timestampDestroyed = block.timestamp` writes before `_burn`. Because `_burn` reverts, the timestamp write is also reverted; however, this pattern is fragile and relying on the EVM revert cascade from `_burn` as the guard is a design smell flagged in the code itself (line 711 TODO).

**Why it matters:** Any future change to burn logic (e.g., moving the inFleet check) could leave ships permanently marked as `timestampDestroyed` while still in a live fleet/game, breaking the game for both players.

**Fix:** `shipBreaker` now checks `s.shipData.inFleet` itself (reusing the existing `ShipInFleet` error `_update` already throws) right after the ownership check, before `timestampDestroyed` is ever written — so the guard no longer depends on `_burn`'s revert to undo a state write that shouldn't have happened in the first place. Ships.sol was already tight (23.749 KiB); this added 47 bytes, landing at 23.796 KiB, still under the 24 KiB limit. Full suite (301 tests) passes unchanged.

---

### ~~H-06 — `Maps.getScoreAndZeroOut` Is `public` With No Access Control~~

**File:** `contracts/Maps.sol`, lines 602–612  
**Severity:** High  
**Status:** Fixed 2026-07-16

```solidity
function getScoreAndZeroOut(
    uint _gameId, int16 _row, int16 _col
) public returns (uint8) {
```

This function zeros out a `onlyOnce` scoring tile for the given game. Any external caller can call it to drain scoring tiles from any live game, preventing both players from earning objective points.

**Why it matters:** An attacker (or losing player) can zero out all scoring tiles immediately after a game starts, ensuring the game can only end by ship destruction, bypassing the map-objective victory condition entirely.

**Fix:** Added the same `msg.sender != gameAddress && msg.sender != owner()` guard (reverting `NotGameContract()`) already used by `applyPresetMapToGame`/`applyPresetScoringMapToGame` in this same contract. `getScoreAndZeroOut` is only ever called from `Game._handleEndOfRound`, and no test calls it directly, so this is a drop-in restriction with no behavioral change for legitimate callers. Maps.sol has plenty of headroom (12.967 KiB vs. the 24 KiB limit). Full suite (301 tests) passes unchanged.

---

### H-07 — `Game.flee` Is Missing a `_requireGameExists` Check

**File:** `contracts/Game.sol`, lines 1358–1380  
**Severity:** High  
**Status:** Deferred 2026-07-16 — `Game.sol` is too close to the 24 KiB contract-size limit to take the fix right now; see note below. Not struck through — still open, revisit when there's headroom.

The commented-out check (lines 1360–1361 with "TODO: I think this is fine") means `flee` operates on a default-zeroed `GameData` storage reference when called with a non-existent `_gameId`. When `game.metadata.winner == address(0)` and `game.metadata.creator == address(0)`, the second guard (`msg.sender != creator && msg.sender != joiner`) will revert with `NotInGame` for any non-zero address. However, a call with a non-existent game ID and `address(0)` as a player would pass (since `address(0) == address(0)`) and trigger `_endGame(0, address(0), address(0))`, writing garbage winner state to game slot 0.

**Why it matters:** Silent execution on non-existent game IDs can corrupt game slot 0, emit misleading `GameUpdate` events, and interfere with `gameResults.recordGameResult` if the draw path is ever altered. In practice, exploiting this specific path requires `msg.sender == address(0)` (no known private key can transact from there), so live exploitability is low — but the guard should still exist as defense-in-depth and to remove the dead TODO comment.

**Deferral note (2026-07-16):** Proposed fix, not yet applied: replace the commented-out dead check with a real call to the existing `_requireGameExists(_gameId)` helper (already shared by 6 other call sites in this file — `getGame`, `getAllShipPositions`, `moveShip`, `endGameOnTimeout`, etc.), which should cost only the small per-call-site overhead rather than duplicating the check body. As of this note, `Game.sol` is at 23.879 KiB against the 24 KiB (24,576-byte) limit — roughly 124 bytes of headroom. Deliberately holding off on spending any of that margin on this fix until we've either found more size savings elsewhere or confirmed the margin can absorb it safely alongside other pending fixes.

---

### H-08 — `Ships.purchaseWithFlow` Referral Transfer Occurs Before State Finality

**File:** `contracts/Ships.sol`, lines 163–165  
**Severity:** High  
**Status:** Deferred 2026-07-16 — self-referral half is accepted as intended behavior; the revert-on-receive half is confirmed pure griefing/DoS (no funds at risk), deferring a fix. Not struck through — still open, revisit later.

In `purchaseWithFlow`, `_processReferral` executes a raw ETH transfer via `.call{value: referralAmount}("")` inside the same function after minting. If the referrer is a contract and reverts on receive, the entire `purchaseWithFlow` transaction reverts, meaning the buyer loses their ships. There is also no prevention of a buyer naming themselves as `_referral`, allowing them to reclaim a portion of their own payment (self-referral).

**Why it matters:** A malicious referral address can grief buyers by refusing ETH. Any buyer can self-refer to get a discount once their referralCount crosses a tier threshold. Both are exploitable with zero cost.

**Deferral note (2026-07-16):**
- **Self-referral:** accepted as acceptable/intended — not a bug to fix. Buyers being able to reclaim a portion of their own payment via self-referral once their `referralCount` crosses a tier threshold is fine as-is.
- **Revert-on-receive griefing:** confirmed the actual blast radius is narrower than "the buyer loses their ships" suggests. `purchaseWithFlow` is a single `external payable nonReentrant` call; if `_processReferral`'s `.call{value: referralAmount}("")` fails, `_processReferral` reverts, which unwinds the *entire* transaction — the ship mints, the `amountPurchased` update, and the ETH transfer all roll back atomically (EVM revert semantics mean the buyer's `msg.value` is never actually taken on a reverted call). Net effect: no ships created, no funds charged, buyer only loses the gas spent on the failed attempt. So this is pure griefing/DoS, not a fund-loss bug — a malicious referral address can be handed out (e.g. via a referral link) to make every purchase through it fail, with no way for the buyer to know in advance. Deferred rather than fixed for now; a future fix would decouple the referral payout from the mint (e.g. pull-payment/credit balance for referrers instead of a synchronous push transfer) so a hostile referrer can only forfeit their own payout, not block the buyer's purchase.

---

## Medium Severity Findings

### ~~M-01 — `ShipAttributes.setCosts` Version Increment Is Silently Overwritten~~

**File:** `contracts/ShipAttributes.sol`, lines 342–344  
**Severity:** Medium  
**Status:** Fixed 2026-07-16 — same bug as H-01, fixed together (see H-01 above).

`costs = _costs` copies the entire `Costs` struct including its `version` field from the caller. The `costs.version++` on line 343 is therefore meaningless unless the caller passes `_costs.version == (old_version + 1)`. The intended auto-increment is silently defeated.

---

### ~~M-02 — `Game._performRepairDrones` Has a `uint8` Addition Overflow Risk~~

**File:** `contracts/Game.sol`, lines 974–978  
**Severity:** Medium  
**Status:** Fixed 2026-07-16

```solidity
uint8 newHullPoints = targetAttributes.hullPoints + repairStrength;
```

If `hullPoints` is close to 255 and `repairStrength` is large, this addition will wrap around. Because both operands are `uint8`, the addition is done in `uint8` arithmetic by the compiler. Solidity ≥0.8 will catch this and revert, but the revert error is opaque (`Panic(0x11)` arithmetic overflow) and there is an acknowledged comment at line 982 warning of fragility.

**Why it matters:** A RepairDrones use on a ship with 250/255 HP and a repairStrength of 40 will revert the entire `moveShip` transaction, effectively locking the player out of their turn if they attempt the repair. The maxHullPoints cap (lines 975–977) is checked **after** the overflowing addition.

**Fix:** Considered "reorder the cap check to happen before the addition" (compute `headroom = maxHullPoints - hullPoints`, compare, then add) but rejected it — that trades one checked `uint8` addition for a checked subtraction *plus* a checked addition in the safe branch, since Solidity inserts overflow-check machinery for every checked arithmetic op regardless of whether it can prove the op safe; that reorder would have cost more bytecode, not less. Instead, the sum is now computed in `uint16` (max 255+255=510, which always fits) inside an `unchecked` block — since the addition provably cannot overflow at that width, `unchecked` just strips out dead-weight revert machinery the compiler couldn't prove unreachable on its own, rather than skipping a real safety check. The final `uint8(newHullPoints)` truncation only happens in the branch where we've already confirmed it fits under `maxHullPoints`. Net effect: bug fixed *and* `Game.sol` shrank by 15 bytes (23.879 → 23.864 KiB). Full suite (301 tests) passes unchanged.

---

### ~~M-03 — `UniversalCredits` Has `hardhat/console.sol` in Production~~

**File:** `contracts/UniversalCredits.sol`, line 4  
**Severity:** Medium  
**Status:** Fixed 2026-07-16

```solidity
import "hardhat/console.sol";
```

This is not commented out (unlike `Ships.sol` where it is commented). On a non-Hardhat network the import resolves to a no-op library, but it adds unnecessary bytecode weight and signals the contract was not prepared for production deployment. If the `console.sol` contract is not deployed on the target chain, all calls to `UniversalCredits` could fail at deployment.

**Fix:** Removed the import (confirmed zero `console.*` calls anywhere in the file, so it was pure dead weight). Contract size unchanged (2.787 KiB before and after) — an unused `console.sol` import doesn't add runtime bytecode when nothing calls it — but this closes the production-readiness signal and the (theoretical) deployment-risk concern outright. Full suite (301 tests) passes unchanged.

---

### M-04 — `ShipAttributes` Attribute Version Arrays Can Be Out-of-Bounds Indexed

**File:** `contracts/ShipAttributes.sol`, lines 120–155; `contracts/GenerateNewShip.sol`, lines 88–109  
**Severity:** Medium  
**Status:** Won't fix (2026-07-16) — accepted as-is, not planned. Not struck through — left open for visibility, but no further action intended.

`calculateShipAttributes` indexes `attributesVersions[version].guns[uint8(_ship.equipment.mainWeapon)]` without checking array length. `MainWeapon`, `Armor`, `Shields`, and `Special` enums each have 8 values (including 4 `future*` placeholders). The `setAllAttributes` function takes arbitrary-length arrays. If a version is deployed with only 4 gun entries (current default) and a ship has equipment enum value 4–7 (`future1–future4`), the call panics with an out-of-bounds access. `GenerateNewShip` uses `% 4` for weapon generation, but `customizeShip` accepts arbitrary `Equipment` values.

---

### ~~M-05 — `Lobbies.createLobby` and `joinLobby` Accept Excess ETH With No Refund~~

**File:** `contracts/Lobbies.sol`, lines 262–264, 329–331  
**Severity:** Medium  
**Status:** Fixed 2026-07-16

The fee check is `if (msg.value < additionalLobbyFee) revert InsufficientFee()`. Any ETH sent over `additionalLobbyFee` is silently retained by the contract. Players who over-pay (by mistake or via frontend error) permanently lose the difference.

**Fix:** Both checks now require an exact fee (`msg.value != additionalLobbyFee`) instead of a minimum, so overpayment reverts up front with `InsufficientFee()` rather than being silently kept. All existing tests already pay the exact fee (`parseEther("1")` matching `additionalLobbyFee`), so this is a drop-in tightening with no behavior change for legitimate callers.

Also closed two related gaps in the same functions where the fee branch is skipped entirely and `msg.value` wasn't validated at all: the UTC-reservation path in `createLobby` (`_reservedJoiner != address(0)`, which pays via UTC and needs no ETH) and the free-lobby path in both `createLobby` and `joinLobby` (`activeLobbiesCount < freeGamesPerAddress`), plus `joinLobby`'s reserved-lobby path (joiner owes no ETH fee — the creator already paid the UTC reservation fee). All four now revert `InsufficientFee()` on any nonzero `msg.value` when no fee is actually owed. Full suite (301 tests) passes unchanged; Lobbies.sol has plenty of headroom (14.677 KiB vs. the 24 KiB limit).

---

### ~~M-06 — `Game._placeShipOnGrid` Does Not Validate Negative Coordinates~~

**File:** `contracts/Game.sol`, lines 229–233  
**Severity:** Medium  
**Status:** Fixed 2026-07-16 — see H-02 above.

```solidity
if (
    _row >= GRID_HEIGHT ||
    _column >= GRID_WIDTH ||
    game.grid[_row][_column] != 0
) revert InvalidMove();
```

`int16` row/column values are not lower-bound-checked. Ships could be initially placed at negative coordinates if the `Fleets.createFleet` position validation is bypassed or if there is a future code path that calls `_placeShipOnGrid` directly.

---

### ~~M-07 — `Game.endGameOnTimeout` Winner-Determination Is Biased~~

**File:** `contracts/Game.sol`, lines 1335–1354  
**Severity:** Medium  
**Status:** Not a bug (2026-07-16) — confirmed working as designed, no fix needed.

```solidity
_endGame(_gameId, msg.sender, game.turnState.currentTurn);
```

The caller of `endGameOnTimeout` receives the win. This creates a front-running opportunity: if both players notice the timeout simultaneously, whoever broadcasts first wins. On high-latency chains or during congestion, the losing player of a close game can time their `endGameOnTimeout` call to arrive slightly after the opponent's turn starts, then immediately invoke timeout at the block after the turn time expires.

**Resolution (2026-07-16):** Re-examined the actual guard at line 1374 — `if (msg.sender == game.turnState.currentTurn) revert InvalidMove();` — which means the player whose turn timed out can *never* call this function to declare themselves the winner; only the other (waiting) player can call it, and doing so is exactly how they're meant to claim victory over an unresponsive opponent. That's the intended design (confirmed with the project owner), not a bug: "if player 1 has run out of time, player 2 can seize victory by calling this function" is the feature working correctly, not a winner-determination flaw.

The narrower residual case the original write-up was gesturing at — transaction-ordering nondeterminism right at the exact timeout boundary (a legitimate in-time move and an opponent's timeout call landing in the same block/close succession) — is an inherent property of any block-time-based turn timer, not something specific to this contract's logic, and isn't being tracked as a separate issue.

---

### ~~M-08 — `Maps.updatePresetMap` Cannot Fully Clear Old Tiles~~

**File:** `contracts/Maps.sol`, lines 135–198  
**Severity:** Medium  
**Status:** Not a bug (2026-07-16) — confirmed working as designed, no fix needed.

`updatePresetMap` calls `_getPresetMap(_mapId)` to get current blocked positions, then clears them before setting new ones. However, if a prior update only set a subset of tiles and those mappings have been manually altered via `setBlockedTile`, the "clear old positions" step may be incomplete, leaving stale blocked positions for games that use that preset.

**Resolution (2026-07-16):** Re-examined `_getPresetMap` (`Maps.sol:380-408`) and `_getPresetScoringMap` (`Maps.sol:457-492`) — neither reads a remembered/cached list of positions. Both do a full brute-force scan of all 187 grid cells (`GRID_HEIGHT * GRID_WIDTH`), checking `presetBlockedMaps[_mapId][row][col]` / `presetScoringMaps[_mapId][row][col]` directly for every cell. That means `updatePresetMap`'s "clear old positions" step always finds and clears *every* tile currently `true` for that map ID at call time, live — it can't go stale because it isn't relying on history in the first place.

The finding's second claim — that `setBlockedTile` can desync this — doesn't hold up either: `setBlockedTile(_gameId, ...)` writes to `blockedTiles[_gameId][row][col]`, a completely separate mapping from `presetBlockedMaps[_mapId][row][col]`. It mutates per-*game* live-tile state, not preset-map storage, so it structurally cannot affect a preset map's blocked tiles at all. The "clear" step is provably complete by construction; no fix needed.

---

## Low Severity Findings

### L-01 — `Game.calculateShipAttributes` Does Not Validate Ship-to-Game Membership

**File:** `contracts/Game.sol`, lines 247–274  
**Severity:** Low

There is no check that the `_shipId` belongs to the game identified by `_gameId`.

**Note (2026-07-16):** Since `games[_gameId].shipAttributes` (`Types.sol:154`) is a mapping scoped inside that game's own storage struct (not a global `shipId => Attributes` mapping), calling this with an unrelated `_shipId` only ever writes into that game's own unused slot for that id — it cannot reach into or corrupt a *different* live game's data. The practical risk is narrower than "rewritten into a live game" implies. Still worth adding the membership check as defense in depth, but it is not required for the C-03 fix (see Addendum), which closes the actual exploit path (re-rolling a ship's own attributes mid-match) via a snapshot-once guard instead.

---

### L-02 — `Fleets.removeShipFromFleet` Reads Cost After Clearing `inFleet`

**File:** `contracts/Fleets.sol`, lines 194–198  
**Severity:** Low

```solidity
ships.setInFleet(_shipId, false);

Ship memory ship = ships.getShip(_shipId);
fleet.totalCost -= ship.shipData.cost;
```

`setInFleet(false)` is called first. Then `getShip` is called to read `ship.shipData.cost`. If the cost changed between fleet entry and removal, `fleet.totalCost` will underflow or become incorrect. In Solidity ≥0.8 this will revert.

---

### L-03 — `Ships.syncShipCosts` Is Fully Permissionless and Can Corrupt Storage for ID 0

**File:** `contracts/Ships.sol`, lines 354–358  
**Severity:** Low

The NatSpec warns "invalid ids corrupt storage." Calling `syncShipCosts` on ship ID 0 will silently write to the default ship struct without any token existing.

---

### L-04 — `Game.flee` Allows Calling After a Draw (Winner Is `address(0)`)

**File:** `contracts/Game.sol`, lines 1358–1380  
**Severity:** Low

After a draw, `game.metadata.winner` is set to `address(0)`. The guard `if (game.metadata.winner != address(0))` then passes on a finished drawn game, allowing `flee` to trigger a second `_endGame` call. The `GameResults` contract will revert on `GameAlreadyRecorded`, but fleet-removal code may still execute on already-cleared fleets.

---

### L-05 — `ShipAttributes` Has No Events for Version or Cost Changes

**File:** `contracts/ShipAttributes.sol`  
**Severity:** Low

`setCosts`, `setCurrentAttributesVersion`, and `setAllAttributes` change critical game parameters with no emitted events. Off-chain clients and indexers have no way to learn when attributes or costs changed without polling.

---

### L-06 — `Ships.claimFreeShips` Does Not Increment `amountPurchased`

**File:** `contracts/Ships.sol`, lines 611–631  
**Severity:** Low

`amountPurchased[msg.sender]` is never incremented in `claimFreeShips`. The transfer guard in `_update` requires `amountPurchased[oldOwner] >= 10`. A player who only ever used `claimFreeShips` can never transfer their ships. This may be intentional (free ships are soulbound) but is not documented and differs from ships obtained via `purchaseWithFlow` or `createShips`.

---

### L-07 — `ShipPurchaser._processReferral` Does Not Prevent Self-Referral

**File:** `contracts/ShipPurchaser.sol`, lines 54–80  
**Severity:** Low

`purchaseWithUC` does not check `_referral != msg.sender` or `_referral != _to`. A buyer can pass their own address as referral and — once `referralCount[self] >= 1000` — receive a 10% discount on all future purchases funded from the protocol's own UTC balance.

---

### L-08 — `Game._endGame` Can Be Double-Invoked, Causing Revert on Fleet Removal

**File:** `contracts/Game.sol`, lines 417–435  
**Severity:** Low

`_endGame` can be triggered from multiple paths with no guard against double-invocation within the same transaction. If `_removeShipsFromFleet` calls `fleets.removeShipFromFleet` on an already-empty fleet, the Fleets contract will revert with `ShipNotFound`, potentially trapping the game in an un-finishable state.

---

## Informational Findings

### I-01 — Multiple Debug Functions Left in Production `Game` Contract

**File:** `contracts/Game.sol`, lines 1204–1252  
**Severity:** Informational

`debugDestroyShip`, `debugSetHullPointsToZero`, and `debugSetShipPosition` are all `external onlyOwner`. While `onlyOwner` limits their blast radius, their presence in production is a centralisation risk and will confuse auditors and players about whether the contract is final.

---

### I-02 — Severe Centralisation: Owner Can Alter Any Live Game, Cost, or Attribute

**File:** `contracts/Game.sol`, `contracts/ShipAttributes.sol`, `contracts/Maps.sol`, `contracts/Ships.sol`, `contracts/Lobbies.sol`  
**Severity:** Informational

The deployer key controls: modifying any ship's position in any live game; destroying any ship in any game; zeroing any ship's HP; changing all ship attributes and costs globally; pausing all minting and lobby creation; setting/removing minting authorization; and applying custom maps to any game ID. There are no timelocks, multisig requirements, or governance mechanisms.

---

### I-03 — `UniversalCredits.mintedAmount` Mapping Is Declared But Never Updated

**File:** `contracts/UniversalCredits.sol`, line 16  
**Severity:** Informational

`mapping(address => uint) public mintedAmount` is stored but the `mint` function never writes to it. It is dead storage.

---

### I-04 — `RandomManager` Is a Permanent Placeholder With No Upgrade Path

**File:** `contracts/RandomManager.sol`  
**Severity:** Informational

The comment `// TODO: Update to CadenceRandomConsumer` indicates intent to replace this with Flow's Cadence random oracle. Currently deployed as-is, there is no mechanism to upgrade it, and the randomness is a single-step hash with no commit-reveal.

---

### I-05 — Inconsistent Solidity Pragma Versions Across Contracts

**File:** Multiple  
**Severity:** Informational

- `^0.8.28`: `Game`, `Fleets`, `Lobbies`, `Maps`, `GameResults`, `ShipAttributes`, `Types`, `UniversalCredits`
- `^0.8.24`: `Ships`, `ShipPurchaser`, `DroneYard`, `GenerateNewShip`, `RenderMetadata`
- `>=0.7.0 <0.9.0`: `CadenceArchCaller`

`CadenceArchCaller`'s wide pragma range allows compilation with 0.7.x, which lacks checked arithmetic.

---

### I-06 — `Game.lastDamage` Is a Global Mapping Not Scoped Per-Game

**File:** `contracts/Game.sol`, line 27  
**Severity:** Informational

`mapping(uint target => uint lastDamager) public lastDamage` is keyed by `targetShipId` globally, not per-game. If ship ID 5 is targeted in game 1 and later in game 2, the entry for game 1 is overwritten by game 2. This cross-game contamination is a logic concern for future features involving multi-game ships.

---

### I-07 — `Game.getGamesForPlayer` Has Unbounded Array Iteration

**File:** `contracts/Game.sol`, lines 1504–1508  
**Severity:** Informational

`getGamesForPlayer` calls `getGamesFromIds(playerGames[_player])`. `playerGames` is a dynamic array that grows without bound for every game a player participates in. A player with thousands of games will cause the view to run out of gas. There is no pagination.

---

### I-08 — `Lobbies.getAllLobbiesForPlayerWithDupes` Returns Duplicates

**File:** `contracts/Lobbies.sol`, lines 746–763  
**Severity:** Informational

The function comment says "This function will have dupes that must be filtered on the client side." Returning duplicates from an on-chain function is an unusual pattern that may cause confusion and double-processing bugs in client applications.

---

### I-09 — `Ships._update` Modifies Internal State Before `super._update` Call

**File:** `contracts/Ships.sol`, lines 395–439  
**Severity:** Informational

The custom `_update` override modifies `shipsOwned` storage before the `super._update` call. If the base class were changed so that `super._update` could revert after partially executing (e.g., a new hook), the internal state and ERC-721 state could become inconsistent. Currently safe with OpenZeppelin's implementation, but fragile.

---

### I-10 — `Fleets.createFleet` Validates Positions Twice, Wasting Gas

**File:** `contracts/Fleets.sol`, lines 68–147  
**Severity:** Informational

Positions are first validated for column bounds (creator: 0–3, joiner: 13–16) in lines 68–81, then a bitset duplicate check runs in lines 126–147. The two-pass approach means row/column validation is effectively done twice for each position. This is a gas inefficiency, not a safety issue.

---

## Summary Table

| ID | Contract | Function | Severity | Category |
|---|---|---|---|---|
| C-01 | RandomManager | `fulfillRandomRequest` | Critical | Improper Randomness (reclassified from H-07) |
| C-02 | RandomManager | `requestRandomness`, `fulfillRandomRequest` | Critical | Improper Randomness |
| ~~C-03~~ | Game | `calculateShipAttributes`, `calculateFleetAttributes` | Critical | ~~Access Control~~ (Fixed) |
| ~~H-01~~ | ShipAttributes | `setCosts` | High | ~~Logic Bug~~ (Fixed) |
| ~~H-02~~ | Game | `moveShip` | High | ~~Bounds Check~~ (Fixed) |
| ~~H-03~~ | Game | `_processFlakArrayForFleet` | High | ~~Logic Bug~~ (Fixed) |
| ~~H-04~~ | DroneYard | `modifyShip` | High | ~~Locked Funds~~ (Fixed) |
| ~~H-05~~ | Ships | `shipBreaker` | High | ~~State Management~~ (Fixed) |
| ~~H-06~~ | Maps | `getScoreAndZeroOut` | High | ~~Access Control~~ (Fixed) |
| H-07 | Game | `flee` | High | Missing Validation |
| H-08 | Ships | `purchaseWithFlow` | High | DoS / Self-Referral |
| ~~M-01~~ | ShipAttributes | `setCosts` | Medium | ~~Logic Bug~~ (Fixed) |
| ~~M-02~~ | Game | `_performRepairDrones` | Medium | ~~Integer Overflow~~ (Fixed) |
| ~~M-03~~ | UniversalCredits | import | Medium | ~~Production Readiness~~ (Fixed) |
| M-04 | ShipAttributes | `calculateShipAttributes` | Medium | Array OOB (Won't Fix) |
| ~~M-05~~ | Lobbies | `createLobby`, `joinLobby` | Medium | ~~Fee Handling~~ (Fixed) |
| ~~M-06~~ | Game | `_placeShipOnGrid` | Medium | ~~Bounds Check~~ (Fixed) |
| ~~M-07~~ | Game | `endGameOnTimeout` | Medium | ~~Front-Running~~ (Not a bug) |
| ~~M-08~~ | Maps | `updatePresetMap` | Medium | ~~Logic Bug~~ (Not a bug) |
| L-01 | Game | `calculateShipAttributes` | Low | Missing Validation |
| L-02 | Fleets | `removeShipFromFleet` | Low | State Ordering |
| L-03 | Ships | `syncShipCosts` | Low | Access Control |
| L-04 | Game | `flee` | Low | Edge Case |
| L-05 | ShipAttributes | Multiple setters | Low | Missing Events |
| L-06 | Ships | `claimFreeShips` | Low | Logic / Documentation |
| L-07 | ShipPurchaser | `purchaseWithUC` | Low | Missing Validation |
| L-08 | Game | `_endGame` | Low | Double-Invocation |
| I-01 | Game | debug functions | Info | Production Readiness |
| I-02 | Multiple | Owner functions | Info | Centralisation |
| I-03 | UniversalCredits | `mintedAmount` | Info | Dead Code |
| I-04 | RandomManager | (all) | Info | Architecture |
| I-05 | Multiple | pragma | Info | Code Quality |
| I-06 | Game | `lastDamage` | Info | Data Isolation |
| I-07 | Game | `getGamesForPlayer` | Info | Gas / DoS |
| I-08 | Lobbies | `getAllLobbiesForPlayerWithDupes` | Info | Code Quality |
| I-09 | Ships | `_update` | Info | ERC-721 Safety |
| I-10 | Fleets | `createFleet` | Info | Gas Efficiency |
| T-01 | Tournament | `resolveDraw` | High | Missing Validation |
| T-02 | Tournament | `assignMatchGame`, `recordResult` | High | Result Replay |
| T-03 | Tournament | `assignMatchGame`, `resolveDraw` | High | Locked Funds |
| ~~T-04~~ | Maps | `setMapEditor` | Informational | ~~Widened Blast Radius~~ (Moot) |

---

## Addendum — Post-Audit Findings in `Tournament.sol` (2026-07-16)

> **Status:** Follow-up review  
> **Date:** 2026-07-16  
> **Scope:** Changes merged after the baseline audit commit (`9a9a049`): `contracts/Tournament.sol`, `contracts/GameBlobRegistry.sol`, `contracts/ByteHasher.sol`, `contracts/IWorldID.sol`, `contracts/mocks/MockWorldID.sol`, and access-control changes to `contracts/Maps.sol`.

None of the findings above (C-01 through I-10) have been remediated in the current tree. The only change to a previously-audited file is `Maps.sol` gaining an `isMapEditor` role (see T-04 below); the underlying bugs it touches (H-06, M-08) are unchanged.

`Tournament.sol` is new since the audit and holds real funds (entry fees + sponsor prize pools). It introduces three findings of its own.

### T-01 — `resolveDraw` Does Not Verify a Draw (or Any Game) Occurred

**File:** `contracts/Tournament.sol`, lines 332–349  
**Severity:** High

```solidity
function resolveDraw(
    uint256 tournamentId,
    uint256 matchId,
    bytes32 walrusBlobId
) external {
    TournamentData storage t = _get(tournamentId);
    if (msg.sender != t.creator) revert NotCreator();
    if (t.state != TournamentState.Active) revert NotActive();
    if (matchId >= t.bracket.length) revert MatchNotFound();
    Match storage m = t.bracket[matchId];
    if (m.resolved) revert MatchAlreadyResolved();
    if (m.player1 == address(0) || m.player2 == address(0)) revert MatchNotReady();

    address winner = t.seed[m.player1] <= t.seed[m.player2]
        ? m.player1
        : m.player2;
    _resolve(t, matchId, winner, walrusBlobId);
}
```

The function never reads `m.gameId`, never calls into `GameResults` or `Game`, and never checks that a game was even assigned to the match, let alone that it ended in a draw. It only checks that `msg.sender` is the tournament creator and that both bracket slots are filled. The comment above it frames this as a stopgap for the one case where `GameResults` can't represent an outcome (draws are never recorded there), but nothing in the code restricts its use to that case.

**Why it matters:** The tournament creator can call `resolveDraw` on any active, unresolved match at any time — including matches where no game has been played at all — and it will deterministically resolve to whichever player registered first (lower seed). This lets a creator fast-forward or force the outcome of the entire bracket without any of the underlying games being played, defeating the contract's stated design goal that "winners are read trustlessly from GameResults on the same chain."

---

### T-02 — `assignMatchGame` / `recordResult` Accept Any Historical `gameId`, Enabling Result Replay

**File:** `contracts/Tournament.sol`, lines 288–325  
**Severity:** High

`assignMatchGame` (creator-only) sets `m.gameId` to an arbitrary caller-supplied value with no check that the referenced game is new, that it was created after the match was scheduled, or that it has any relationship to the tournament at all:

```solidity
function assignMatchGame(
    uint256 tournamentId,
    uint256 matchId,
    uint256 gameId
) external {
    ...
    m.gameId = gameId;
    emit MatchGameAssigned(tournamentId, matchId, gameId);
}
```

`recordResult` then only validates that the stored `GameResult`'s winner/loser pair matches the match's two seeded players:

```solidity
GameResult memory gr = gameResults.getGameResult(m.gameId);
bool ok = (gr.winner == m.player1 && gr.loser == m.player2) ||
    (gr.winner == m.player2 && gr.loser == m.player1);
if (!ok) revert WinnerNotInMatch();
```

Since `gameId` is the same global ID space used by ordinary (non-tournament) games (per the `game == lobbyId` change in `Game.sol`/`Lobbies.sol`), and `GameResults` records are permanent and never expire, any game the two matched players have ever played against each other — before the tournament existed, before the match was scheduled, or played casually outside the bracket UI — is a valid candidate for `assignMatchGame`.

**Why it matters:** The creator can resolve a scheduled match using an old, unrelated result between the same two players instead of requiring them to actually play the current tournament match. This requires no cooperation from the players themselves (only from the creator), and breaks the "trustless from GameResults" guarantee the contract claims, since linkage between a `gameId` and a specific tournament match is entirely creator-asserted with no on-chain freshness or provenance check.

---

### T-03 — No Recovery Path for an Active Tournament With an Unresponsive Creator

**File:** `contracts/Tournament.sol`, lines 288–349 (`assignMatchGame`, `resolveDraw`); no corresponding admin/timeout function exists  
**Severity:** High

Once `start()` moves a tournament to `TournamentState.Active`, the only two functions that can move a match toward resolution (`assignMatchGame`, `resolveDraw`) are gated with `if (msg.sender != t.creator) revert NotCreator();`. `recordResult` is permissionless but requires `m.gameId != 0`, which only the creator can set. There is no timeout, no owner override, and no forfeit-by-inactivity path anywhere in the contract for an `Active` tournament — `cancel()` only works while `state == Registration`.

**Why it matters:** If the creator stops participating after `start()` (abandons the tournament, loses their key, or simply never calls `assignMatchGame`), every match is permanently stuck, `finalize()` can never be reached (`t.champion` never gets set), and `t.prizePool` — entry fees from every registrant plus any sponsor contribution — is locked in the contract with no rescue mechanism. This is the same failure mode as the audit's `DroneYard` H-04 finding (permanently locked funds), applied to a contract that pools money from many independent players rather than one.

---

### ~~T-04 — `Maps.setMapEditor` Widens the Blast Radius of Unfixed M-08~~

**File:** `contracts/Maps.sol`, lines 42–75 (added), interacting with existing M-08  
**Severity:** Informational  
**Status:** Moot (2026-07-16) — both underlying concerns (H-06, M-08) are now resolved; nothing left for this finding to track.

The new `onlyMapEditor` modifier (owner or any address flagged via `setMapEditor`) now gates `createPresetMap`, `updatePresetMap`, `updatePresetScoringMap`, `setBlockedTile`, and `setScoringTile`. This is a legitimate access-control improvement over the previous `onlyOwner`-only surface, but it does not fix `updatePresetMap`'s incomplete-tile-clearing bug (M-08). It does mean that whatever set of addresses `setMapEditor` is granted to going forward will each be able to trigger the still-unresolved M-08 behavior, where previously only the single owner key could.

**Update 2026-07-16:** H-06 (`getScoreAndZeroOut` unguarded) was fixed — see H-06 above. M-08 itself turned out not to be a bug at all (see M-08 above — `_getPresetMap`/`_getPresetScoringMap` do a full live grid re-scan on every call, so the "clear" step can't go stale, and `setBlockedTile` writes to a structurally separate mapping). With both of the concerns this finding was tracking resolved, there's no remaining blast radius to worry about — widening who can call `updatePresetMap` etc. via `setMapEditor` is fine as-is.

---

## Addendum — C-03 Remediation (2026-07-16)

**File:** `contracts/Game.sol`, `calculateShipAttributes` (line ~258)

Fixed by adding a snapshot-once guard rather than access control, since `calculateShipAttributes` is intentionally `public` so players can self-serve recalculating their own ships during fleet setup (there is no `msg.sender` restriction to begin with — it was never really "callable only by the owning player," just callable by anyone for any ship). The change:

```solidity
function calculateShipAttributes(uint _gameId, uint _shipId) public {
    GameData storage game = games[_gameId];
    Attributes storage attributes = game.shipAttributes[_shipId];
    if (attributes.version != 0) revert InvalidMove(); // already calculated for this game
    ...
}
```

`attributes.version` is 0 only before the first calculation for that `(gameId, shipId)` pair — `ShipAttributes.currentAttributesVersion` is seeded to `1` in its constructor and only ever increases, so a non-zero `version` reliably means "already snapshotted for this game." This closes the actual exploit path (re-pulling a newer `ShipAttributes` version/cost update into an already-started game) while leaving the one legitimate call, from `_initializeFleetAttributes` at game start, unaffected. Reuses the existing `InvalidMove` error rather than adding a new one, to avoid growing the contract's bytecode further (see size note below).

**Ship-to-game membership (L-01):** left unaddressed — confirmed lower risk than originally stated since `shipAttributes` is scoped per-game storage (see the L-01 note above), not a cross-game hazard. Can be added later as defense in depth.

**Contract size:** `Game.sol` was already within ~20 bytes of the 24 KiB (24,576-byte) Spurious Dragon limit before this change (`hardhat.config.ts` even has a comment noting `runs: 1` "keeps Game under 24 KiB"). The new guard added 34 bytes, pushing it over. Rather than touch the optimizer settings (disallowed by `CLAUDE.md` regardless — no ignoring size limits), `getAllShipPositions` (same file) was rewritten to drop its redundant first pass: it used to scan the full grid once just to count live ships (to size the `positions` memory array) and a second time to populate it. It now allocates for the theoretical worst case (`GRID_HEIGHT * GRID_WIDTH + goneShipIds.length`), fills in one pass, and shrinks the array's length word in place via `assembly { mstore(positions, index) }` once the actual count is known — same return value, one grid scan instead of two. Net effect: `Game.sol` dropped from 24.014 KiB to 23.824 KiB, restoring headroom. `Game.test.ts` passes unchanged.

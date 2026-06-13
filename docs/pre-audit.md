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
| Critical | 2 |
| High | 9 |
| Medium | 8 |
| Low | 8 |
| Informational | 10 |

---

## Critical Findings

### C-01 — Insecure On-Chain Randomness via `block.prevrandao`

**File:** `contracts/RandomManager.sol`, lines 14–28  
**Severity:** Critical

`requestRandomness()` and `fulfillRandomRequest()` both derive their output exclusively from `block.prevrandao` (formerly `DIFFICULTY`) and a simple incrementing counter. On PoS Ethereum and EVM-compatible chains using a similar mechanism, the block proposer knows `block.prevrandao` before committing the block, making it manipulable. A validator who is also a player (or colluding with one) can re-roll the random seed by skipping block proposals until a favorable value appears.

**Why it matters:** All ship trait randomness (accuracy, hull, speed, weapon, armor/shields, special ability, shiny flag, starting kill count, and ship name) flows through this function. An attacker can grind for max-stat ships, creating severe pay-to-win or cheat-to-win advantages. The comment `// TODO: Update to CadenceRandomConsumer` confirms this is a known placeholder, but the current contract is deployed.

---

### C-02 — `Game.calculateShipAttributes` and `Game.calculateFleetAttributes` Are Unguarded Public State-Writing Functions

**File:** `contracts/Game.sol`, lines 247–274  
**Severity:** Critical

`calculateShipAttributes(uint _gameId, uint _shipId)` is `public` with no access control and no check that the ship actually belongs to the specified game. Anyone can call it for any `(_gameId, _shipId)` pair and overwrite the in-game ship attributes (range, damage, hull points, movement, damage reduction) with freshly recalculated values from `ShipAttributes`.

**Why it matters:**
1. If a `ShipAttributes` version upgrade occurs mid-game, any player can re-roll their own ships' stats upward, breaking the game's snapshot model.
2. Attributes are intentionally snapshotted at game start so the `costsVersion` lock prevents in-flight changes; this function bypasses that snapshot entirely.
3. `calculateFleetAttributes(uint _gameId, uint[] memory _shipIds)` (line 267) has the same visibility and has no check that `_shipIds` belong to that game.

---

## High Severity Findings

### H-01 — `ShipAttributes.setCosts` Increments Version Then Overwrites It

**File:** `contracts/ShipAttributes.sol`, lines 342–345  
**Severity:** High

```solidity
function setCosts(Costs memory _costs) external onlyOwner {
    costs.version++;
    costs = _costs;  // ← overwrites costs.version with whatever _costs.version is
}
```

The function increments `costs.version`, then replaces the entire struct with the caller-supplied `_costs`. If the caller passes a `_costs.version` that is stale, zero, or matches the previous version, the version field will be wrong. All ships use `costsVersion` to detect staleness; a wrong version will either permanently lock all ships out of fleets (`ShipCostVersionMismatch`) or allow ships with outdated cost calculations to enter fleets silently.

**Why it matters:** The costs-version system is the primary guard preventing ships with old (potentially underpriced) stats from entering competitive games. Corrupting it breaks fleet validation for all subsequent lobbies.

---

### H-02 — `Game.moveShip` Does Not Validate Negative Grid Coordinates

**File:** `contracts/Game.sol`, lines 527–530  
**Severity:** High

```solidity
if (_newRow >= GRID_HEIGHT || _newCol >= GRID_WIDTH)
    revert InvalidMove();
```

Because `_newRow` and `_newCol` are `int16`, a player can pass negative values (e.g., `_newRow = -1`). The comparison `int16(-1) >= int16(11)` is `false`, so the bounds check passes. The ship is then placed in `game.grid[-1][-1]`, which in Solidity maps to a valid but unintended storage slot (a mapping with key `type(int16).max` for two's-complement). Similarly, `_placeShipOnGrid` (line 229) only checks `>= GRID_HEIGHT` and `>= GRID_WIDTH`, missing the lower-bound check.

**Why it matters:** A player can teleport ships to invisible negative-coordinate cells, escaping opponent fire while still being able to shoot, effectively making them invincible for the rest of the game.

---

### H-03 — FlakArray Mutates `flakStrength` Across Targets, Nerfing Subsequent Hits

**File:** `contracts/Game.sol`, lines 1069–1083  
**Severity:** High

```solidity
flakStrength = uint8(
    flakStrength -
        ((uint16(flakStrength) * damageReduction) / 100)
);
```

`flakStrength` is a value parameter passed into `_processFlakArrayForFleet`. The damage reduction is applied to `flakStrength` and the result is written back into the same variable. Each subsequent target in the loop therefore receives progressively reduced damage rather than the original `flakStrength` minus that target's own damage reduction. The second fleet call in `_performFlakArray` further inherits the already-reduced value.

**Why it matters:** The intended behaviour is "apply each target's damage reduction to the base flak strength." The actual behaviour penalises later targets (and the second fleet) with cumulative reductions. In edge cases where all targets have high damage reduction, the effective damage approaches zero for anything hit after the first target.

---

### H-04 — `DroneYard` Has No Withdrawal Function; UTC Accumulates and Is Permanently Locked

**File:** `contracts/DroneYard.sol`, lines 113–163  
**Severity:** High

`modifyShip` transfers UTC tokens from the caller to `address(this)`, but `DroneYard` has no `withdraw`, no owner, no `Ownable`, and no rescue function. All modification fees are permanently locked in the contract with no mechanism to recover them.

**Why it matters:** Every ship modification permanently burns UTC tokens from the economy. If this is unintentional, it is a financial loss; if it was intended as a burn mechanism, the effect is undocumented and constitutes an undisclosed economic parameter.

---

### H-05 — `shipBreaker` Does Not Check `inFleet` Before Burning

**File:** `contracts/Ships.sol`, lines 701–739  
**Severity:** High

`shipBreaker` checks ownership (`s.owner != msg.sender`) but does **not** check `s.shipData.inFleet` before marking the ship destroyed and calling `_burn`. The `_update` override does check `inFleet` and would revert on the burn, so normally this is blocked — but only because the ERC-721 override is the last line of defence. If a ship is in a game, calling `shipBreaker` with its ID will revert at `_burn`, which is correct, but `s.shipData.timestampDestroyed = block.timestamp` writes before `_burn`. Because `_burn` reverts, the timestamp write is also reverted; however, this pattern is fragile and relying on the EVM revert cascade from `_burn` as the guard is a design smell flagged in the code itself (line 711 TODO).

**Why it matters:** Any future change to burn logic (e.g., moving the inFleet check) could leave ships permanently marked as `timestampDestroyed` while still in a live fleet/game, breaking the game for both players.

---

### H-06 — `Maps.getScoreAndZeroOut` Is `public` With No Access Control

**File:** `contracts/Maps.sol`, lines 602–612  
**Severity:** High

```solidity
function getScoreAndZeroOut(
    uint _gameId, int16 _row, int16 _col
) public returns (uint8) {
```

This function zeros out a `onlyOnce` scoring tile for the given game. Any external caller can call it to drain scoring tiles from any live game, preventing both players from earning objective points.

**Why it matters:** An attacker (or losing player) can zero out all scoring tiles immediately after a game starts, ensuring the game can only end by ship destruction, bypassing the map-objective victory condition entirely.

---

### H-07 — `RandomManager.fulfillRandomRequest` Does Not Verify the Request Exists

**File:** `contracts/RandomManager.sol`, lines 20–29  
**Severity:** High

`fulfillRandomRequest(uint _requestId)` accepts any `_requestId` value and returns a `block.prevrandao`-derived value. There is no mapping of outstanding requests, no check that the ID was ever issued by `requestRandomness()`, and no single-use prevention. Any caller (including MEV bots or validators) can call `fulfillRandomRequest` with a forged ID to front-run ship construction and predict or manipulate the random outcome before `constructShip` is called.

**Why it matters:** Combined with C-01, this means randomness has no commit-reveal protection whatsoever. An attacker can observe the mempool for a `constructShip` call, front-run with `fulfillRandomRequest` using the same serial number to learn the output, and selectively abort their own construction if the result is unfavourable.

---

### H-08 — `Game.flee` Is Missing a `_requireGameExists` Check

**File:** `contracts/Game.sol`, lines 1358–1380  
**Severity:** High

The commented-out check (lines 1360–1361 with "TODO: I think this is fine") means `flee` operates on a default-zeroed `GameData` storage reference when called with a non-existent `_gameId`. When `game.metadata.winner == address(0)` and `game.metadata.creator == address(0)`, the second guard (`msg.sender != creator && msg.sender != joiner`) will revert with `NotInGame` for any non-zero address. However, a call with a non-existent game ID and `address(0)` as a player would pass (since `address(0) == address(0)`) and trigger `_endGame(0, address(0), address(0))`, writing garbage winner state to game slot 0.

**Why it matters:** Silent execution on non-existent game IDs can corrupt game slot 0, emit misleading `GameUpdate` events, and interfere with `gameResults.recordGameResult` if the draw path is ever altered.

---

### H-09 — `Ships.purchaseWithFlow` Referral Transfer Occurs Before State Finality

**File:** `contracts/Ships.sol`, lines 163–165  
**Severity:** High

In `purchaseWithFlow`, `_processReferral` executes a raw ETH transfer via `.call{value: referralAmount}("")` inside the same function after minting. If the referrer is a contract and reverts on receive, the entire `purchaseWithFlow` transaction reverts, meaning the buyer loses their ships. There is also no prevention of a buyer naming themselves as `_referral`, allowing them to reclaim a portion of their own payment (self-referral).

**Why it matters:** A malicious referral address can grief buyers by refusing ETH. Any buyer can self-refer to get a discount once their referralCount crosses a tier threshold. Both are exploitable with zero cost.

---

## Medium Severity Findings

### M-01 — `ShipAttributes.setCosts` Version Increment Is Silently Overwritten

**File:** `contracts/ShipAttributes.sol`, lines 342–344  
**Severity:** Medium

`costs = _costs` copies the entire `Costs` struct including its `version` field from the caller. The `costs.version++` on line 343 is therefore meaningless unless the caller passes `_costs.version == (old_version + 1)`. The intended auto-increment is silently defeated.

---

### M-02 — `Game._performRepairDrones` Has a `uint8` Addition Overflow Risk

**File:** `contracts/Game.sol`, lines 974–978  
**Severity:** Medium

```solidity
uint8 newHullPoints = targetAttributes.hullPoints + repairStrength;
```

If `hullPoints` is close to 255 and `repairStrength` is large, this addition will wrap around. Because both operands are `uint8`, the addition is done in `uint8` arithmetic by the compiler. Solidity ≥0.8 will catch this and revert, but the revert error is opaque (`Panic(0x11)` arithmetic overflow) and there is an acknowledged comment at line 982 warning of fragility.

**Why it matters:** A RepairDrones use on a ship with 250/255 HP and a repairStrength of 40 will revert the entire `moveShip` transaction, effectively locking the player out of their turn if they attempt the repair. The maxHullPoints cap (lines 975–977) is checked **after** the overflowing addition.

---

### M-03 — `UniversalCredits` Has `hardhat/console.sol` in Production

**File:** `contracts/UniversalCredits.sol`, line 4  
**Severity:** Medium

```solidity
import "hardhat/console.sol";
```

This is not commented out (unlike `Ships.sol` where it is commented). On a non-Hardhat network the import resolves to a no-op library, but it adds unnecessary bytecode weight and signals the contract was not prepared for production deployment. If the `console.sol` contract is not deployed on the target chain, all calls to `UniversalCredits` could fail at deployment.

---

### M-04 — `ShipAttributes` Attribute Version Arrays Can Be Out-of-Bounds Indexed

**File:** `contracts/ShipAttributes.sol`, lines 120–155; `contracts/GenerateNewShip.sol`, lines 88–109  
**Severity:** Medium

`calculateShipAttributes` indexes `attributesVersions[version].guns[uint8(_ship.equipment.mainWeapon)]` without checking array length. `MainWeapon`, `Armor`, `Shields`, and `Special` enums each have 8 values (including 4 `future*` placeholders). The `setAllAttributes` function takes arbitrary-length arrays. If a version is deployed with only 4 gun entries (current default) and a ship has equipment enum value 4–7 (`future1–future4`), the call panics with an out-of-bounds access. `GenerateNewShip` uses `% 4` for weapon generation, but `customizeShip` accepts arbitrary `Equipment` values.

---

### M-05 — `Lobbies.createLobby` and `joinLobby` Accept Excess ETH With No Refund

**File:** `contracts/Lobbies.sol`, lines 262–264, 329–331  
**Severity:** Medium

The fee check is `if (msg.value < additionalLobbyFee) revert InsufficientFee()`. Any ETH sent over `additionalLobbyFee` is silently retained by the contract. Players who over-pay (by mistake or via frontend error) permanently lose the difference.

---

### M-06 — `Game._placeShipOnGrid` Does Not Validate Negative Coordinates

**File:** `contracts/Game.sol`, lines 229–233  
**Severity:** Medium

```solidity
if (
    _row >= GRID_HEIGHT ||
    _column >= GRID_WIDTH ||
    game.grid[_row][_column] != 0
) revert InvalidMove();
```

`int16` row/column values are not lower-bound-checked. Ships could be initially placed at negative coordinates if the `Fleets.createFleet` position validation is bypassed or if there is a future code path that calls `_placeShipOnGrid` directly.

---

### M-07 — `Game.endGameOnTimeout` Winner-Determination Is Biased

**File:** `contracts/Game.sol`, lines 1335–1354  
**Severity:** Medium

```solidity
_endGame(_gameId, msg.sender, game.turnState.currentTurn);
```

The caller of `endGameOnTimeout` receives the win. This creates a front-running opportunity: if both players notice the timeout simultaneously, whoever broadcasts first wins. On high-latency chains or during congestion, the losing player of a close game can time their `endGameOnTimeout` call to arrive slightly after the opponent's turn starts, then immediately invoke timeout at the block after the turn time expires.

---

### M-08 — `Maps.updatePresetMap` Cannot Fully Clear Old Tiles

**File:** `contracts/Maps.sol`, lines 135–198  
**Severity:** Medium

`updatePresetMap` calls `_getPresetMap(_mapId)` to get current blocked positions, then clears them before setting new ones. However, if a prior update only set a subset of tiles and those mappings have been manually altered via `setBlockedTile`, the "clear old positions" step may be incomplete, leaving stale blocked positions for games that use that preset.

---

## Low Severity Findings

### L-01 — `Game.calculateShipAttributes` Does Not Validate Ship-to-Game Membership

**File:** `contracts/Game.sol`, lines 247–274  
**Severity:** Low

Even if access control is added, there is no check that the `_shipId` belongs to the game identified by `_gameId`. A ship from a different game or an unrelated ship can have its attributes rewritten into a live game.

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
| C-01 | RandomManager | `requestRandomness`, `fulfillRandomRequest` | Critical | Improper Randomness |
| C-02 | Game | `calculateShipAttributes`, `calculateFleetAttributes` | Critical | Access Control |
| H-01 | ShipAttributes | `setCosts` | High | Logic Bug |
| H-02 | Game | `moveShip` | High | Bounds Check |
| H-03 | Game | `_processFlakArrayForFleet` | High | Logic Bug |
| H-04 | DroneYard | `modifyShip` | High | Locked Funds |
| H-05 | Ships | `shipBreaker` | High | State Management |
| H-06 | Maps | `getScoreAndZeroOut` | High | Access Control |
| H-07 | RandomManager | `fulfillRandomRequest` | High | Improper Randomness |
| H-08 | Game | `flee` | High | Missing Validation |
| H-09 | Ships | `purchaseWithFlow` | High | DoS / Self-Referral |
| M-01 | ShipAttributes | `setCosts` | Medium | Logic Bug |
| M-02 | Game | `_performRepairDrones` | Medium | Integer Overflow |
| M-03 | UniversalCredits | import | Medium | Production Readiness |
| M-04 | ShipAttributes | `calculateShipAttributes` | Medium | Array OOB |
| M-05 | Lobbies | `createLobby`, `joinLobby` | Medium | Fee Handling |
| M-06 | Game | `_placeShipOnGrid` | Medium | Bounds Check |
| M-07 | Game | `endGameOnTimeout` | Medium | Front-Running |
| M-08 | Maps | `updatePresetMap` | Medium | Logic Bug |
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

> **Note:** This plan was approved for documentation only. It ended up being implemented in the same session by mistake — that wasn't what was asked for. Leaving that note here for the record; treat the plan below as the design reference regardless.

# Void Tactics: Per-Variant Ship Attributes/Specials + Single-Player AI Opponent

## Context

Void Tactics currently ships a single ship "variant" concept (`Traits.variant`, a `uint16`) that is **100% cosmetic and inert** — stored on mint, echoed in NFT metadata, never read by any attribute/cost/special calculation, and never read by any renderer. As new ship variants get added, the team wants variant to become a *real* gameplay axis: different variants should have different attributes per hull-piece type (engine, bridge, etc.) and different special-ability effects.

Separately, the team wants a single-player mode where a human plays through the exact same move/shoot/special/capture-points flow, but against an on-chain procedural AI opponent instead of a second human — explicitly without introducing parallel/duplicated combat logic in the contracts.

**The dominant constraint shaping this entire plan**: `Game.sol` (23.890 KiB deployed) and `Ships.sol` (23.796 KiB deployed) are both within ~110–210 bytes of Solidity's 24,576-byte (EIP-170) contract-size ceiling. `hardhat.config.ts` already runs the optimizer at `runs: 1` (pure size-minimization) and has `viaIR` disabled due to pre-existing "stack too deep" issues — there is no compiler-lever headroom left, and per `CLAUDE.md` the size-limit check must never be disabled or bypassed; any regression must be fixed by writing less bytecode, not by loosening the check. This has been verified directly (`npx hardhat compile` contract-sizer output, matching `docs/pre-audit.md`'s own tracked history of near-misses in this file). By contrast, `ShipAttributes.sol` (12.194 KiB, ~11.8 KiB free), `Fleets.sol` (7.075 KiB, ~16.9 KiB free), `GenerateNewShip.sol` (4.710 KiB, ~19.3 KiB free), `Tournament.sol`, and `DroneYard.sol` all have substantial room. Every design choice below routes new logic into the contracts that can absorb it, and treats any touch to `Game.sol`/`Ships.sol` as a scarce resource to be spent as minimally as possible.

Both tasks turn out to have a common shape once this constraint is taken seriously: **Task 1 lands almost entirely in `ShipAttributes.sol`, with a surgical 4-call-site parameter-threading change in `Game.sol`. Task 2 requires *zero* changes to `Game.sol`, `Ships.sol`, `Fleets.sol`, `Lobbies.sol`, or `Maps.sol` at all** — it's implemented as one new, unconstrained contract that plays by the exact same rules as a human wallet.

---

## Task 1: Per-Variant Ship Attributes and Specials

### Current state (confirmed by direct code read)

- `AttributesVersion` (`Types.sol:260-271`) holds flat 1D arrays: `foreAccuracy[]`/`hull[]`/`engineSpeeds[]` (indexed by `Traits.accuracy`/`hull`/`speed` tier 0-2 — these are, conceptually, the "bridge"/"hull"/"engine" hull-piece bonuses; an existing code comment literally says "bridge + level extend range" for accuracy), plus `guns[]`/`armors[]`/`shields[]`/`specials[]` (indexed by the corresponding equipment enum, 8 slots each: 4 real + 4 `future1-4` reserved/unimplemented).
- `ShipAttributes.calculateShipAttributes(Ship memory)` and its helpers already receive the full `Ship` (including `traits.variant`) — no new plumbing needed to get variant *into* these functions, only the internal array lookups need to become variant-aware.
- `getSpecialRange(Special)` / `getSpecialStrength(Special)` (`ShipAttributes.sol:277-290`) are indexed **only** by the enum value — a given special's strength/range is currently identical for every ship in the game, with zero per-ship/variant/rank modulation. These are the only two functions Game.sol actually calls that need a signature change.
- `Costs` (`Types.sol:219-230`) has no variant term; `calculateShipCost` sums `baseCost + accuracy + hull + speed + mainWeapon + armor + shields + special` — no variant addend.
- **Confirmed pre-existing gap**: `DroneYard.modifyShip` → `Ships.customizeShip`/`_applyShipCustomization` currently lets a player change a constructed ship's `traits.variant` to *any* `uint16` — no `maxVariant` bound (unlike the `InvalidVariant` check `_mintShip` already enforces at mint time), and not counted in either `DroneYard._calculateNewModifications` or `Ships._calculateModifications`'s pricing formula. This must be closed before variant carries real stat value, or it's a free/unbounded stat-swap exploit.
- `GenerateNewShip.generateShip(...)` takes `variant` as a caller-supplied parameter and assigns it straight through — it does not roll variant randomly today; `Ships.sol` decides the value before minting, bounded by owner-settable `maxVariant`.

### Struct/mapping changes — `Types.sol`

Only the three hull-piece tier arrays and the specials table become variant-scoped (`guns`/`armors`/`shields` stay global — they're equipment slots, not hull-piece traits, and keeping them global keeps this change smaller):

- New struct `VariantAttributeData { uint8[] foreAccuracy; uint8[] hull; uint8[] engineSpeeds; SpecialData[] specials; }`.
- `AttributesVersion`: remove the top-level `foreAccuracy`/`hull`/`engineSpeeds`/`specials` fields; add `mapping(uint16 => VariantAttributeData) variantData;`. Legal Solidity — `AttributesVersion` instances live only in storage (`attributesVersions` mapping), never copied to `memory`, so a nested mapping field is safe.
- `Costs`: add `uint8[] variant;` indexed by `traits.variant`, mirroring the existing `accuracy`/`hull`/`speed` pattern. A stronger variant should cost more, or fleet-cost-limit balancing (`Fleets.createFleet`'s cost check) gets silently invalidated — the owner tunes this the same empirical way every other cost axis is tuned today, via `setCosts`.

### `ShipAttributes.sol` changes

- `calculateShipAttributes`/`_calculateHullPoints`/`_calculateMovement`: change `version.hull[...]` etc. lookups to `version.variantData[_ship.traits.variant].hull[...]` etc.
- `getSpecialRange`/`getSpecialStrength`: new signature adds `uint16 _variant`, reading `attributesVersions[currentAttributesVersion].variantData[_variant].specials[uint8(_special)]`.
- **New function** `setVariantAttributes(uint16 _version, uint16 _variant, uint8[] _foreAccuracy, uint8[] _hull, uint8[] _engineSpeeds, SpecialData[] _specials) external onlyOwner` — a separate function from `setAllAttributes`, not a parameter added to it. 6 params, well under stack-depth risk. Delete+push into `attributesVersions[_version].variantData[_variant]`, same pattern `setAllAttributes` already uses.
- `setAllAttributes` **shrinks** from 9 params to 5 (`_baseHull`, `_baseSpeed`, `_guns`, `_armors`, `_shields`) since the variant-scoped arrays move to `setVariantAttributes`. Net reduction in an already-large parameter list.
- **Decided: fail loud for unconfigured variants.** No defensive bounds-checking/zero-default in the lookups — if `Ships.maxVariant` is raised before `setVariantAttributes` is called for the new variant, construction/attribute calculation for that variant reverts (empty-array index-out-of-bounds). This is intentional: it forces the correct admin ordering (configure `ShipAttributes` for a variant *before* raising `maxVariant` to admit it) to be caught immediately rather than silently shipping underpowered ships. Document this ordering requirement directly in `setVariantAttributes`'s NatSpec and in `Ships.setMaxVariant`'s.
- **Decided: no auto-copy of variant data across version bumps.** Bumping `currentAttributesVersion` via `setAllAttributes` does not carry forward any variant's prior `variantData` — each version's variant tables must be explicitly (re-)configured via `setVariantAttributes`. This keeps `setAllAttributes` itself cheap and variant-count-agnostic; an auto-copy would need to loop over every configured variant inside a single owner transaction, with cost growing unboundedly as `maxVariant` grows.
- `calculateShipCost`: add `+ costs.variant[ship.traits.variant]`.

### `IShipAttributes.sol`

Mirror the signature changes: `getSpecialRange`/`getSpecialStrength` gain `uint16 _variant`; add `setVariantAttributes(...)`; shrink `setAllAttributes` to match.

### `Game.sol` — the entire touched surface (4 call sites, verified exact)

`_performSpecial` (`Game.sol:924`) already has `_usingShip` in scope when it calls into each handler. Thread `_usingShip.traits.variant` through:

1. `_validateSpecialRange` (`Game.sol:972`) → add `uint16 _variant` param → `getSpecialRange(_special, _variant)`.
2. `_performRepairDrones` (`Game.sol:990`) → add `uint16 _variant` param → `getSpecialStrength(Special.RepairDrones, _variant)`.
3. `_performEMP` (`Game.sol:1023`) → add `uint16 _variant` param → `getSpecialStrength(Special.EMP, _variant)`.
4. `_performFlakArray` (`Game.sol:1043`) → add `uint16 _variant` param → both `getSpecialRange`/`getSpecialStrength(Special.FlakArray, _variant)`.

That's it: 4 internal functions each gain one `uint16` argument at their one call site each. No new branches, no new external calls, no new storage reads. **This is the single most size-sensitive step in the whole plan (Game.sol has ~113 bytes of headroom) — compile and check the contract-sizer delta immediately after this change, in isolation from every other change.** If it regresses, look for a same-file offsetting savings first (this repo has precedent for exactly that, e.g. a prior two-pass→one-pass loop rewrite that freed ~190 bytes) rather than touching optimizer settings.

### `future1`-`future4` Special slots stay a separate, independent axis

Because `VariantAttributeData.specials` stays a full `SpecialData[8]` per variant, every slot — including the 4 unimplemented `future1-4` — automatically gets per-variant numeric scaling for free. Implementing what `future1` actually *does* (a genuinely new behavior) still requires a new handler + a new branch in `_performSpecial`'s dispatch in `Game.sol` — that stays a separate, Game.sol-bytecode-gated future initiative, not something this refactor needs to do. This is the deliberate resolution to "different specials with different effects": **numeric strength/range scaling per variant is the mechanism this refactor delivers** (cheap, fits the budget); genuinely new special behaviors remain possible later via the `future1-4` enum slots, independently.

### Variant bound-check gap (DroneYard) — decided: DroneYard-only for now

- `IShips.sol`: add `function maxVariant() external view returns (uint16);` (exposes the already-`public` state var — zero new logic in `Ships.sol`).
- `DroneYard.validateShip`: add a bound check (`_newShip.traits.variant == 0 || > ships.maxVariant()` → revert), mirroring `_mintShip`'s existing guard.
- `DroneYard._calculateNewModifications`: count a variant change the same way `shiny` is counted — a flat categorical weight (recommend `+3`, matching shiny's weight; tunable later, not a structural decision).
- **Decided: do not duplicate this check in `Ships._applyShipCustomization`** — `Ships.sol` has only ~209 bytes of headroom, the tightest margin in the codebase, and DroneYard is the only currently-authorized caller that lets an end user set variant. Instead, **add a comment in `Ships._applyShipCustomization`** (or the nearest appropriate spot in `Ships.sol`) explicitly noting: variant bounds are enforced by the caller (currently only `DroneYard`) and not centrally here, due to bytecode headroom; any future `isAllowedToCreateShips`-authorized contract that lets end users set variant must reimplement this bound itself until `Ships.sol` has room for a central check (tracked via `docs/ShipsSizeOptimizationAnalysis.md`'s existing ~3.3-3.5 KiB of identified, not-yet-applied savings).
- `Ships._calculateModifications` (used by `_applyShipCustomization`'s own `ship.shipData.modified` counter, which future DroneYard pricing depends on) should also get the variant-change accounting — but flagged as the second-most size-sensitive step in this plan (~209 bytes headroom). Compile/check immediately after this specific change; if it regresses, apply one or two items from `docs/ShipsSizeOptimizationAnalysis.md` (e.g. converting a `public` view getter to `external`) first.

### `GenerateNewShip.sol` — optional random-variant roll

Add an opt-in random-variant path (ample headroom, ~19.3 KiB free): a sentinel input (e.g. `variant == 0` passed in) tells `generateShip` to roll a variant in `[1, maxVariant]` via the same `keccak256(randomBase++)` pattern already used for every other trait. Requires passing `maxVariant` into `generateShip` as a new parameter (cheap, this contract has room). Keeps existing callers (fixed-variant purchases, tutorial ships, promo flows) working unchanged — purely additive.

### Migration — decided: clean redeploy

No proxy/upgradeable pattern exists in this repo; the `AttributesVersion` struct-shape change means a **fresh `ShipAttributes` deployment**, not an in-place upgrade. Confirmed pre-launch — no careful byte-for-byte continuity needed. New constructor seeds `attributesVersions[1].variantData[1]` with sensible baseline values (can mirror today's flat v1 values, or be redesigned now that variant differentiation exists — team's call at implementation time). After deploy, repoint `Ships.setConfig`/`Game.setAddresses` (both owner-only) at the new address.

### Migration for existing tests

`setAllAttributes`'s signature change breaks its existing callers (`test/ShipCostsVersions.test.ts`, `test/Ships.test.ts` — several call sites). Each needs updating to the new 5-param shape plus a companion `setVariantAttributes` call for variant 1. New tests should also exercise: a second variant with different values, the fail-loud unconfigured-variant revert, and the DroneYard bound-check/pricing addition.

---

## Task 2: Single-Player AI Opponent

### Why zero changes are needed to Game.sol/Ships.sol/Fleets.sol/Lobbies.sol/Maps.sol

`Game.moveShip`'s authorization is purely `msg.sender == game.turnState.currentTurn` and `ship.owner == msg.sender` — Solidity makes no EOA/contract distinction here, confirmed identical in `endGameOnTimeout` and `flee`. `GameMetadata.creator`/`joiner` are just two `address` fields. This means: **a new `AIController` contract can simply *be* one of the two players** — own real `Ships` NFTs, build a real `Fleet`, get set as `joiner` (or `creator`) — and when it's the AI's turn, it calls the existing, completely unmodified `Game.moveShip(...)` itself, passing every check a human wallet would. All AI decision logic lives in this one new contract, reading state exclusively through already-`public`/`external` view functions (`Game.getGame`, `getShipAttributes`, `getAllShipPositions`; `Maps.getGameMapState`, `Maps.hasMaps`).

Existing scaffolding confirmed reusable as-is:
- `Lobbies.createLobbyForAddresses(creator, joiner, ...)` (`onlyOwner`) creates a lobby with both addresses pre-set, fully bypassing the human-oriented ETH/UTC fee and reservation logic (confirmed by reading the function body — none of that machinery appears in it). Natural entry point for a human-vs-AI game.
- `Lobbies.createFleet` is gated only to `lobby.basic.creator`/`lobby.players.joiner` — no owner-gate, no human-only restriction. Once `AIController` is one of those two addresses, it calls this exactly like a human wallet would.
- `Ships.createShips`/`constructShip` via the existing `isAllowedToCreateShips` authorization mapping (same mechanism `ShipPurchaser` already uses for gasless minting) — `AIController` mints and constructs its own fleet with zero new minting code.

### New contract: `AIController.sol`

Responsibilities:
1. Hold `isAllowedToCreateShips` authorization; mint + construct a **fresh AI fleet for each single-player match** (decided below).
2. `startSinglePlayerMatch(...)` — calls `Lobbies.createLobbyForAddresses`, mints/constructs the AI's ships, calls `Lobbies.createFleet` for itself. The human separately calls `Lobbies.createFleet` through their own wallet, same as any PvP game.
3. `takeAITurn(uint gameId) external` — **permissionless**, callable by anyone. Confirms `Game.getGame(gameId).turnState.currentTurn == address(this)`, computes a move via internal heuristics, calls `Game.moveShip(...)`.
4. Internal heuristic logic only — no state-mutating dependency on any other contract changing.

No size constraint is inherited from `Game.sol`/`Ships.sol` since this is a brand-new contract — but still compile/size-check it in isolation once written, given how much view-function-reading + heuristic logic it will contain.

### Decided: permissionless pull-based turn triggering, not a Game.sol hook

`takeAITurn` is a standalone function anyone can call, rather than adding an auto-invoke hook to `Game.sol` right after a human's move (which would need a new external-call dependency added to Game.sol's move-completion path — an avoidable risk against ~113 bytes of headroom). **UX tradeoff, worth being explicit about**: this needs an explicit second transaction after each human move. In practice, a frontend fires `takeAITurn` immediately after the human's `moveShip` transaction confirms, so the player experience is "move → beat → see AI respond," not a limitation of what's technically possible, just a bytecode-budget-driven implementation choice.

### Decided: fresh AI fleet minted per match

Ships in this game can be permanently destroyed by normal combat (confirmed: destruction ≠ burn — a destroyed ship's ERC-721 token remains, just locked/unusable forever). Rather than building new "heal/repair a persistent AI roster between games" infrastructure (which doesn't exist for any ship today — healing only happens in-game via the `RepairDrones` special), mint a fresh fleet per match using the existing, already-free (`isAllowedToCreateShips`) mint path. **Accepted tradeoff**: every losing AI ship accumulates permanently on-chain, unowned-by-any-human, worthless — real, unbounded storage growth over many matches. Acceptable for v1; flagged as a known cost, not a blocker.

### Decided: long `turnTime`, no AI-specific timeout handling

`Game.endGameOnTimeout` is a hard forfeit (not a skip-this-turn mechanic), triggerable by whichever address isn't `currentTurn` once `turnTime` elapses. Pass `_turnTime = MAX_TURN_TIME` (24h, the existing ceiling already used for PvP lobbies) for single-player lobbies — makes human win-by-forfeit-exploit against a normally-fast `takeAITurn` call practically impossible, with zero code changes, reusing the exact bound already validated for humans. Residual edge case (acceptable, not special-cased for v1): if nothing calls `takeAITurn` for the full 24 hours, the game just stalls until someone does.

### Decided: track single-player results separately from PvP stats

`GameResults.recordGameResult` is called unconditionally by `Game._endGame` whenever there's a winner. Rather than adding a flag to `GameData`/`GameMetadata` (real, avoidable `Game.sol` bytecode cost), implement this **entirely inside `GameResults.sol`**: an owner-settable `mapping(address => bool) isAIController` (or similar), and when `recordGameResult` sees either `_winner`/`_loser` flagged, route the update into a **separate single-player stats structure** (e.g. a parallel `singlePlayerStats` mapping, or a distinct event) instead of the main PvP `playerStats`/leaderboard path — so single-player participation is visible somewhere (e.g. "AI games played/won") without mixing into PvP win/loss records. `Game.sol` continues calling `recordGameResult` completely unchanged.

### Fees/economics — confirmed no gap

`createLobbyForAddresses` already fully bypasses all human fee/timeout/free-game-count logic; ship minting for the AI fleet bypasses `purchaseWithFlow`/tier pricing via `isAllowedToCreateShips`, exactly like `ShipPurchaser` does today. The only remaining detail is deployment/ops: whoever/whatever calls `AIController.startSinglePlayerMatch` needs the authority to call `Lobbies.createLobbyForAddresses` (i.e., be — or be delegated by — the `Lobbies` owner). Treat as an ops/deployment decision at implementation time (e.g. a trusted backend/relayer key), not a contract-design gap.

### v1 heuristic AI scope

Simple, unconstrained-by-budget logic in `takeAITurn`, roughly: pick an un-moved ship → if an enemy is in range + line-of-sight (`Maps.hasMaps`), shoot (prefer lowest current HP as an "easiest kill" heuristic) → else move toward the nearest enemy or nearest valuable unclaimed scoring tile (`Maps.getGameMapState`) → opportunistically use an available special if a sensible target/range exists (e.g. `RepairDrones` on a friendly below some HP threshold) → `Pass` if nothing productive. Intentionally simple for v1; difficulty tiers or genuinely divergent AI behavior can later be config parameters or multiple `AIController` implementations behind a shared interface — not needed now.

---

## Implementation Order

1. **Task 1 first, fully validated in isolation, before starting Task 2** — Task 1 touches `Game.sol` (minimally); Task 2 adds a brand-new contract. Keeping them sequential makes any bytecode-size regression attributable to a single change.
2. Task 1 sub-order:
   a. `Types.sol` struct changes (no bytecode impact alone).
   b. `ShipAttributes.sol` + `IShipAttributes.sol` (new `VariantAttributeData`, `setVariantAttributes`, shrunk `setAllAttributes`, variant-aware `getSpecialRange`/`getSpecialStrength`/`calculateShipCost`). Compile, check `ShipAttributes.sol` contract-sizer delta (huge headroom, low risk, verify anyway).
   c. Update existing test call sites (`ShipCostsVersions.test.ts`, `Ships.test.ts`) to the new `setAllAttributes`/`setVariantAttributes` split; add new tests for variant-scoped lookups, the fail-loud unconfigured-variant case, and the DroneYard fix.
   d. `IShips.sol` (`maxVariant()` getter) + `DroneYard.sol` (bound check + modification pricing + the explanatory comment placement decision). Compile-check (low risk, ample headroom).
   e. `Ships.sol` `_calculateModifications` variant accounting + the explanatory comment in `_applyShipCustomization`. **Compile and check the contract-sizer delta immediately after this specific change** — Ships.sol's ~209-byte margin is the second-tightest in the plan. If it regresses, apply an item from `docs/ShipsSizeOptimizationAnalysis.md` (e.g. a `public`→`external` conversion) before proceeding.
   f. `Game.sol` — thread `variant` through the 4 call sites listed above. **Compile and check immediately — this is the single most size-sensitive step in the entire plan.**
   g. `GenerateNewShip.sol` random-variant option (independent, can land any time; ample headroom).
   h. Deploy: fresh `ShipAttributes`, seed variant-1 baseline via constructor or a follow-up `setVariantAttributes` call, repoint `Ships.setConfig`/`Game.setAddresses`.
3. Task 2, after Task 1 is stable:
   a. Write `AIController.sol` standalone against existing interfaces (no dependency on further contract changes).
   b. `GameResults.sol` — add the AI-exclusion/separate-tracking mechanism (per the "track separately" decision).
   c. Grant `Ships.setIsAllowedToCreateShips(AIController, true)`; wire up whatever address is authorized to call `startSinglePlayerMatch` (ops decision, per above).
   d. Compile/size-check `AIController.sol` in isolation (no inherited constraint, but confirm it doesn't itself approach 24 KiB given how much view-function reading + heuristic logic it holds).
   e. Full integration test: create single-player lobby → both fleets set → alternating `moveShip`/`takeAITurn` to game completion → `_endGame` fires → `GameResults` routes into the separate single-player stats path, not PvP stats.
4. **At every step, run `npx hardhat compile` and inspect the `hardhat-contract-sizer` output for every touched contract** — this repo has an established, documented pattern (`docs/pre-audit.md`) of measuring exact before/after KiB deltas per change. Never touch `optimizer.runs`, `viaIR`, or any size-check bypass — reduce bytecode instead, per `CLAUDE.md`.

---

## Verification

- **Compile/size gate**: `npx hardhat compile` after every meaningful change; the `hardhat-contract-sizer` plugin (already configured `strict: true`) will hard-fail the build if any contract exceeds 24 KiB — treat any failure as a stop-and-fix-size signal, not something to suppress.
- **Existing test suite**: run the full suite (`npx hardhat test`) after each sub-step in the order above, not just at the end — Task 1 touches shared attribute-calculation code paths exercised by many existing Game/Ships/Fleets tests.
- **New tests to add**:
  - `ShipAttributes`: two ships with the same equipment but different variants produce different `Attributes`/special strength-range; unconfigured-variant lookup reverts (fail-loud); `setVariantAttributes` + shrunk `setAllAttributes` both function correctly together.
  - `DroneYard`/`Ships`: variant-change via `modifyShip` is rejected above `maxVariant`, and is priced (counted in `_calculateNewModifications`); confirm the explanatory comment lands in `Ships._applyShipCustomization`.
  - `AIController`: end-to-end single-player match — lobby creation, both fleets built, several alternating `moveShip`(human)/`takeAITurn`(AI) turns, a full game to completion (win, or a forced-draw scenario), confirming `GameResults` records the outcome into the separate single-player bucket and not the PvP leaderboard.
  - Turn-timeout: confirm a single-player game's `turnTime` is set to the long value and `endGameOnTimeout` behaves as expected if deliberately not called for a stretch (existing mechanic, just confirm the config value flows through `createLobbyForAddresses` correctly).
- **Manual/E2E sanity** (per project convention of testing real usage before declaring done): if a frontend or script exists for exercising Lobbies/Game flows, drive one full single-player match through it end-to-end, confirming the "move, then AI responds" UX behaves acceptably even with the two-transaction turn-triggering design.

## Critical Files

- `contracts/Types.sol` — struct shape changes (`AttributesVersion`, new `VariantAttributeData`, `Costs`)
- `contracts/ShipAttributes.sol` — nearly all of Task 1's new logic; has the bytecode room to absorb it
- `contracts/IShipAttributes.sol` — interface signature updates
- `contracts/Game.sol` — the 4 surgical call-site changes only (`_performSpecial`, `_validateSpecialRange`, `_performRepairDrones`, `_performEMP`, `_performFlakArray`); near-zero headroom, most size-sensitive file in the plan
- `contracts/DroneYard.sol` — variant bound check + pricing fix
- `contracts/Ships.sol` — `_calculateModifications` variant accounting + explanatory comment in `_applyShipCustomization`; second-most size-sensitive file
- `contracts/IShips.sol` — `maxVariant()` getter exposure
- `contracts/GenerateNewShip.sol` — optional random-variant roll (ample headroom)
- **New**: `contracts/AIController.sol` — all of Task 2's new logic, unconstrained by inherited size budget
- `contracts/GameResults.sol` — single-player stats separation
- `contracts/Lobbies.sol`, `contracts/Fleets.sol`, `contracts/Maps.sol` — read-only reference for `AIController`; zero changes
- `docs/ShipsSizeOptimizationAnalysis.md` — existing, pre-identified ~3.3-3.5 KiB of Ships.sol savings to draw on if any Task 1 Ships.sol change regresses size
- `docs/pre-audit.md` — established pattern/precedent for tracking contract-size deltas per change

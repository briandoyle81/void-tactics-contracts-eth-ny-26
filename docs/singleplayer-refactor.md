> **Note:** This plan was approved for documentation only. It ended up being implemented in the same session by mistake — that wasn't what was asked for. Leaving that note here for the record.
>
> **Update:** The original "Task 2: Single-Player AI Opponent" below (an `AIController` contract that impersonates a human player against the existing PvP machinery) was rejected — it duplicates PvP structure instead of enabling a real single-player design. Task 1 (per-variant attributes) is unaffected and stands as implemented. Task 2 is replaced with a narrower prep step: **split `Game.sol` into a core gameplay engine and a separate PvP-orchestration contract**, so the actual single-player design (to be done separately, by the project owner) has clean ground to build on instead of inheriting PvP's lobby/fleet/leaderboard assumptions. The original Task 2 section is kept below, struck through, for the record; the replacement follows it.
>
> **Status: implemented.** `contracts/AIController.sol`/`test/AIController.test.ts` and the `GameResults`/`Lobbies` additions made only to support it were reverted. `Game.sol` now keeps only core gameplay (grid, combat, movement, `Fleets`-based fleet membership/cleanup); `contracts/PvPMatch.sol` (new) owns `flee`/`endGameOnTimeout` and PvP-leaderboard recording via the `contracts/IGameOrchestrator.sol` callback; `Lobbies.sol` now calls `PvPMatch.startGame(...)` instead of `Game.startGame(...)` directly; deploy config updated accordingly. 312 tests pass; `Game.sol` shrank from 23.936 KiB to 23.743 KiB (headroom up from ~66 to ~262 bytes); `PvPMatch.sol` is a lean 4.315 KiB. One pre-existing fragile test (`test/Game.test.ts`, "should handle different fleet sizes correctly") hardcoded ship destinations assuming specific random movement rolls, which shifted when a new contract was added to the deploy sequence — fixed to use no-op moves instead, since the test is about turn-passing with uneven fleet sizes, not movement.
>
> **Follow-up: `Lobbies.sol` now serves both PvP and single-player matches.** `Lobbies` gained `singlePlayerMatch`/`isSinglePlayerOrchestrator` (mirrors the existing `pvpMatch` wiring) and dispatches to whichever orchestrator a lobby's joiner resolves to in `createFleet`'s game-start block — everything else (`createLobby`/`joinLobby`/`acceptGame`/fees/reservation/kick-timeout/fleet creation) is byte-for-byte the same code path for both modes, per explicit instruction. A human starts a single-player match by reserving a lobby for `SinglePlayerMatch`'s address (`createLobby(..., reservedJoiner: singlePlayerMatch)`) exactly like reserving a specific human opponent; `SinglePlayerMatch.acceptMatch`/`setupAIFleet` (permissionless) then call `Lobbies.acceptGame`/`createFleet` on its behalf, since a contract has no private key to call these directly. New `contracts/SinglePlayerMatch.sol` mirrors `PvPMatch.sol`'s `startGame` forwarding and `IGameOrchestrator.onGameEnded`, mints/constructs the AI's 3-ship fleet (ship-minting scaffolding carried over from the deleted `AIController.sol`), and implements `takeAITurn` with the v0 scripted rule given by the project owner (adjacent-left enemy: stay + fire; else move one square left, firing if now adjacent; else Pass at column 0) — deliberately simple, not a heuristic, pending more specific rules later. This also resolves the gameId/lobbyId collision risk flagged earlier: since single-player lobbies now come from the same shared, monotonic `Lobbies.lobbyCount`, there's only one id namespace feeding `Game.startGame`, not two independently-numbered ones. 315 tests pass (`test/SinglePlayerMatch.test.ts`, new); `Lobbies.sol` grew to 15.306 KiB, `SinglePlayerMatch.sol` is 7.742 KiB — both comfortable.

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

## Task 2 (SUPERSEDED — see "Task 2 replacement" below): Single-Player AI Opponent

> This section is kept for the record only. It was implemented, then rejected: making `AIController` impersonate a human player lets it reuse `Game.sol`'s PvP machinery unchanged, but that's exactly the problem — it duplicates PvP structure (lobbies, fleets, creator/joiner turn-passing, PvP leaderboard recording) rather than producing a real single-player design. Do not build against this section. See "Task 2 replacement: Split Game.sol into core + PvP" below instead.

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

## Task 2 replacement: Split `Game.sol` into core + PvP

### Goal

Separate `Game.sol` into **two contracts**: a core gameplay engine that knows only about grid/ship/combat mechanics, and a new PvP-orchestration contract that owns everything specific to "two named sides, matched via a Lobby, with fleets and a PvP leaderboard." This is preparation, not the single-player design itself — the actual single-player mode is a separate design exercise, done later. The point of this step is to stop the core combat engine from being structurally wedded to PvP assumptions, so whatever single-player design comes next has a clean engine to build against instead of having to impersonate a PvP player the way the rejected `AIController` did.

### Current coupling, confirmed by reading `Game.sol` in full (1584 lines) and grepping every external caller

`Game.sol` today mixes two genuinely different concerns in one contract:

**Core gameplay (grid/combat mechanics — mode-agnostic, any future mode needs this unchanged):**
- Grid constants (`GRID_WIDTH`/`GRID_HEIGHT`), `GameData`'s grid/ship-position/ship-attribute storage
- `moveShip` itself: movement-cost validation, grid-bounds checks, ramming (`_moveShipToCellOrRam`), action dispatch (`_performAction` → `_performShoot`/`_performSpecial` + its EMP/RepairDrones/FlakArray handlers), damage calculation, hull points, reactor-critical-timer mechanics
- `_removeShipFromGame` (destruction/retreat bookkeeping), `_setShipHPToZero`, `_incrementReactorCriticalTimerForZeroHPShips`
- Attribute snapshotting: `calculateShipAttributes`, `calculateFleetAttributes`, `getShipAttributes`
- Round completion (`_checkRoundComplete`) and the scoring-tile point-awarding half of `_handleEndOfRound`
- `getAllShipPositions`, `getGame`/`getGamesFromIds`/`getGamesForPlayer`, the debug functions

**PvP-specific (assumes exactly two named sides, `Lobbies`-issued fleets, and a PvP leaderboard):**
- `startGame(...)`: only callable by a single hardcoded `lobbiesAddress`; takes `Lobbies`-issued fleet ids and resolves them via `fleets.getFleetShipIdsAndPositions(...)`
- `_initializeFleetAttributes`/`_placeShipsOnGrid`'s fleet-id-based setup
- The turn-passing model built specifically around `creator`/`joiner` naming: `_switchTurnIfOtherPlayerHasShips`, `_checkPlayerHasUnmovedShips`, `_checkPlayerHasMovableShips`, and `_handleEndOfRound`'s "alternate who goes first each round between creator and joiner"
- `_endGame`'s unconditional call into `gameResults.recordGameResult(...)` and `_removeShipsFromFleet`/`fleets.removeShipFromFleet(...)` cleanup
- `flee` and `endGameOnTimeout` — forfeit/timeout mechanics that assume an adversarial two-human relationship
- `_checkGameEndCondition` (ends the game when one of exactly two named sides has no active ships)

**External callers, confirmed by grep (small, manageable surface):**
- `Lobbies.sol` — exactly one call site: `game.startGame(...)`, fired when both sides' fleets are set.
- `Tournament.sol` — defines its own local `IGame` interface with just `function getGame(uint) external view returns (GameDataView memory);` and calls `game.getGame(m.gameId)` to read final scores/state for match resolution. Read-only, no other coupling.
- `GameResults.sol` — never calls into `Game.sol`; only ever called *from* `Game._endGame`.
- `Fleets.sol` — no coupling in the other direction (`Game.sol` calls `fleets.*`, not vice versa).
- Test suite — `test/Game.test.ts` and others call `moveShip`/`getGame`/`getShipAttributes`/`getAllShipPositions`/`flee`/`endGameOnTimeout` directly and extensively; `startGame` is only ever called indirectly through `Lobbies.createFleet`.

### Proposed split (revised after confirming fleet-clearing is shared, not PvP-only — see below)

**Important correction from the first draft of this plan**: `Fleets` was originally going to be removed from core `Game.sol` entirely. That's wrong. Ship destruction/retreat calls `fleets.removeShipFromFleet(...)` for that one ship *during play* (`_removeShipFromGame`, used by core combat resolution, not just at game end), and the project owner confirmed single-player needs fleet-clearing too. So `Fleets` is a **shared, core** dependency — both modes need it — and stays on `Game.sol` completely unchanged (`moveShip`'s and `_removeShipFromGame`'s existing `fleets.isShipInFleet(...)`/`fleets.removeShipFromFleet(...)` calls, and `_endGame`'s `_removeShipsFromFleet` cleanup for both sides, all stay exactly as they are today). Only `GameResults` (leaderboard), the `lobbiesAddress` single-address gate, and human-forfeit (`flee`/`endGameOnTimeout`) are genuinely PvP-specific. This makes the actual change much smaller and lower-risk than the first draft implied.

**`Game.sol` (core engine — keeps its name, its `Fleets`/`Ships`/`Maps`/`ShipAttributes` dependencies, and its most-used API surface unchanged):**
- Keeps `moveShip`, `getGame`, `getShipAttributes`, `getAllShipPositions`, `calculateShipAttributes`/`calculateFleetAttributes`, the debug functions, `startGame`'s fleet-resolution logic (`_initializeFleetAttributes`/`_placeShipsOnGrid` via `Fleets.getFleetShipIdsAndPositions`), and all internal combat/movement/round/fleet-membership mechanics — **unchanged**.
- `startGame`'s parameter list is **unchanged** (still takes fleet ids, turn config, map/score config — it already didn't hardcode "Lobbies" in its types, only in its access check). Only the access check changes: `lobbiesAddress` (a single hardcoded address) becomes `isAllowedToStartGames` (`mapping(address => bool)`, mirroring the existing `Ships.isAllowedToCreateShips` pattern already used elsewhere in this codebase) — so both `PvPMatch` and, later, a single-player orchestrator can each be authorized independently.
- Gains one new small piece of per-game state: `address orchestrator` on `GameMetadata` (recorded at session-start — whichever authorized contract called `startGame`). This is what lets `flee`/timeout-forfeit move entirely into `PvPMatch.sol`: `Game.sol` exposes a restricted `forceEndSession(gameId, winner, loser)` callable only by `msg.sender == games[gameId].metadata.orchestrator`.
- Removes `IGameResults gameResults` and its `setAddresses` param entirely. `_endGame` no longer calls `gameResults.recordGameResult(...)` directly; instead it calls back into `games[gameId].metadata.orchestrator` via a small callback interface (`IGameOrchestrator.onGameEnded(uint gameId, address winner, address loser) external`), unconditionally (even on a draw — the orchestrator decides what a draw means for it), synchronously, in the same transaction. `_endGame`'s fleet-cleanup (`_removeShipsFromFleet` for both sides) stays exactly as-is, called directly by core `Game.sol`, **not** moved to the callback.
- Removes `flee`, `endGameOnTimeout`, `_isTurnTimedOut`, and the now-unused `NotLobbiesContract`/`NotInGame`/`TurnTimeoutNotReached` errors — these move to `PvPMatch.sol`, which computes the timeout check itself off `Game.getGame(...)`'s already-public `turnState` and calls the new `forceEndSession` to actually end the session.
- Net bytecode effect: loses `IGameResults`, `flee`, `endGameOnTimeout`, `_isTurnTimedOut`; gains a small allowlist mapping+setter, one `orchestrator` field, and `forceEndSession`. Given `Game.sol` is the tightest-margin contract in the repo (23.936 KiB, ~640 bytes headroom), this should still be a net size win — smaller than the first draft's estimate since `Fleets` isn't moving, but `flee`+`endGameOnTimeout` together are a non-trivial amount of code to remove. Confirm with an actual compile once implemented, don't assume.

**New `PvPMatch.sol` (extracted PvP orchestration — much smaller than the first draft, since it doesn't need `Fleets` at all):**
- Owns `flee`/`endGameOnTimeout` (reimplemented against `Game.getGame(...)`'s public view + the new `Game.forceEndSession(...)`, not internal state).
- Is the thing `Lobbies.sol` talks to going forward: `Lobbies`'s one call site retargets from `game.startGame(...)` to `pvpMatch.startGame(...)` (same parameter shape, just forwarded through); `Lobbies.setGameAddress` becomes `Lobbies.setPvpMatchAddress`, since `Lobbies` has no other reason to hold a `Game` reference (confirmed by grep — its only use of `game` was that one call).
- `PvPMatch.startGame(...)` itself just forwards its arguments to `Game.startGame(...)` after checking `msg.sender == lobbiesAddress` — `PvPMatch` doesn't resolve fleets itself; core `Game.sol` still does that part, unchanged.
- Implements `IGameOrchestrator.onGameEnded(...)`: calls `GameResults.recordGameResult(...)` (skipping draws, i.e. `_winner == address(0)`, exactly matching today's guard) — nothing about `Fleets` here, since that's handled inside core `Game._endGame` automatically regardless of which orchestrator started the session.
- Needs address wiring to `Game` and `GameResults` only (no `Ships`/`Fleets`/`Maps` — it never touches them directly). Much smaller than `Lobbies.sol`/`Tournament.sol`; ample headroom either way.

**Everything else, confirmed to need no change or only a one-line retarget:**
- `Tournament.sol` needs **no change** — its local `IGame` interface only calls `getGame(uint)`, which stays on core `Game.sol` with an unchanged return shape.
- `Fleets.sol` needs **no change** — it already gates `removeShipFromFleet`/etc. to `msg.sender == lobbiesAddress || msg.sender == gameAddress`, and `gameAddress` keeps pointing at core `Game.sol` (which keeps calling it directly, unchanged).
- `Maps.sol` needs **no change** — same reasoning; core `Game.sol` keeps calling it directly, `Maps.gameAddress` keeps pointing at core `Game.sol`.
- `Ships.sol`, `ShipAttributes.sol` need **no change** — core `Game.sol` keeps its existing references to both unchanged.
- `contracts/AIController.sol` (this session's rejected work) is **not** part of this step and has been deleted, along with its deploy wiring and the `GameResults`/`Lobbies` additions made only to support it (`isAIController`/`singlePlayerStats` on `GameResults`, `isAllowedToCreateLobbies` on `Lobbies`) — reverted back to their pre-existing state. Once the core/PvP split lands, single-player is a fresh design exercise against the new, decoupled core `Game.sol`.

### Turn-model generalization — resolved (confirmed by the project owner)

The turn-passing model stays exactly as it is today, for both PvP and single-player: each side moves one ship, then passes the turn to the other side; if one side has more ships than the other, that side gets to move its remaining ships at the end (this is exactly what `_switchTurnIfOtherPlayerHasShips`/`_checkPlayerHasUnmovedShips`/`_checkPlayerHasMovableShips` already implement). Confirms the "minimal split" framing above is correct — this mechanic is mode-agnostic and belongs in core `Game.sol`, parameterized by two participant addresses at session-start rather than hardcoded `creator`/`joiner`/`Lobbies`/`Fleets`. No deeper generalization to more-than-two-sides is needed.

### Fleet clearing is a shared need, not PvP-only (confirmed by the project owner)

Single-player also needs fleet clearing when a game ends — not just PvP — though only for the player's own side (the AI side's ship bookkeeping is a separate concern for whatever single-player orchestrator gets built later, and may not even use a `Fleet` the same way). This is exactly why the "Proposed split" above keeps `Fleets` entirely inside core `Game.sol` rather than moving it out to `PvPMatch.sol`: `_endGame`'s existing fleet-cleanup (for both `creator` and `joiner`) runs unconditionally inside core `Game.sol` regardless of which orchestrator started the session, so a future single-player orchestrator gets the same fleet-clearing behavior for free, with no `Fleets`-touching code of its own needed.

### Single-player v0 design notes (informational only — not part of this step, not being implemented now)

The project owner will design the actual single-player mode separately, but gave two concrete pieces of guidance worth recording now so they aren't lost before that design work starts:

- **Turn triggering**: for v0, assume the human player triggers the AI's move with their own follow-up transaction after making their own move (matches the "permissionless, pull-based" `takeAITurn`-style call shape from the rejected `AIController` draft — that part of the earlier design wasn't the problem, only how it was wired into PvP's structure was).
- **v0 scripted AI behavior** (deliberately simple/placeholder — "later I will provide more specific rules"): on its turn, an enemy ship's rule, in priority order:
  1. If a player ship already occupies the square exactly one column to the left of the AI ship's current position, the AI ship stays where it is and fires at it.
  2. Otherwise, if the AI ship is not already in column 0, it moves one square to the left; if a player ship is now exactly one column to the left of its new position, it fires at it; otherwise it just moves (no shot).
  3. Otherwise (already in column 0, nothing adjacent to fire at), it uses the Pass action.

This is intentionally a fixed, deterministic script, not a heuristic — useful for exercising the move/shoot mechanism end-to-end while the real AI design is worked out separately.

### Test/migration impact

- `test/Game.test.ts` and everything else calling `moveShip`/`getGame`/`getShipAttributes`/`getAllShipPositions` directly on the deployed `Game` contract keeps working unchanged — this is the biggest, most-exercised part of the API and it doesn't move.
- Every test that calls `creatorLobbies.write.createFleet(...)` to kick off a game is unaffected in behavior, but the deploy wiring changes (`Lobbies` now points at `PvpMatch`, not `Game`, for starting games) — `ignition/modules/DeployAndConfig.ts` needs `pvpMatch` deployed and wired, and `Lobbies.setGameAddress` swapped for `Lobbies.setPvpMatchAddress`.
- `flee`/`endGameOnTimeout` tests move their target contract from `game` to `pvpMatch` (same call signatures, different deployed address) — should be a mechanical find/replace in the test files that exercise them, not a logic change.
- `GameResultRecorded`/leaderboard tests are unaffected in outcome (same recording happens, just triggered from `PvpMatch.onGameEnded` instead of `Game._endGame`).

### Critical files for this step

- `contracts/Game.sol` — `Fleets`/`Ships`/`Maps`/`ShipAttributes` dependencies and `startGame`'s parameter shape stay unchanged; remove `IGameResults`/`lobbiesAddress`; remove `flee`/`endGameOnTimeout`/`_isTurnTimedOut`; change `startGame`'s access check to the `isAllowedToStartGames` allowlist; add `orchestrator` per-game field + `forceEndSession` + `onGameEnded` callback-out from `_endGame` (fleet cleanup in `_endGame` stays as direct calls, unchanged).
- **New**: `contracts/PvPMatch.sol` — home for `flee`/`endGameOnTimeout` (reimplemented against `Game.getGame(...)` + `Game.forceEndSession(...)`) and `onGameEnded`'s `GameResults` recording. Does **not** touch `Fleets` — that stays entirely inside core `Game.sol`.
- **New**: `contracts/IGameOrchestrator.sol` (or fold into an existing shared interface file) — the `onGameEnded(...)` callback core `Game.sol` needs to call out through.
- `contracts/Lobbies.sol` — retarget its one `game.startGame(...)` call site to `pvpMatch.startGame(...)`; rename `setGameAddress` to `setPvpMatchAddress`.
- `contracts/Tournament.sol` — no code change expected; re-verify after the split that `getGame`'s return shape is untouched.
- `ignition/modules/DeployAndConfig.ts` — deploy `PvPMatch`, wire it to `Game`/`GameResults` only, authorize it on `Game.isAllowedToStartGames`, repoint `Lobbies`.
- Every test file currently targeting `game.write.flee`/`game.write.endGameOnTimeout` (mechanical retarget to the new contract).

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
3. **Task 2 is now the `Game.sol` core/PvP split described above — NOT the `AIController` approach.** Sub-order, **complete** (a-e; f is the actual single-player design, a separate future effort):
   a. Write `contracts/PvPMatch.sol` and `contracts/IGameOrchestrator.sol` first, against `Game.sol`'s *current* shape, without touching `Game.sol` yet — gives a working reference for exactly what the new core API needs to expose before cutting anything out of `Game.sol`. **Done.**
   b. Cut `IGameResults`/`lobbiesAddress`/`flee`/`endGameOnTimeout`/`_isTurnTimedOut` out of `Game.sol` (`IFleets` and `startGame`'s parameter shape stay unchanged); add the `orchestrator` field, `isAllowedToStartGames` allowlist, the `startGame` access-check swap, `forceEndSession`, and the `onGameEnded` callback-out. **Done** — `Game.sol` shrank from 23.936 KiB to 23.743 KiB.
   c. Wire `PvPMatch.sol` up to call into the new core `Game.sol` API; update `Lobbies.sol`'s single call site and its `setGameAddress`→`setPvpMatchAddress` rename. **Done.**
   d. Update `ignition/modules/DeployAndConfig.ts`: deploy `PvPMatch`, wire its addresses, repoint `Lobbies`. **Done.**
   e. Retarget every test currently calling `game.write.flee`/`game.write.endGameOnTimeout`/relying on `Lobbies`→`Game.startGame` wiring to the new `PvPMatch` contract; full suite must pass unchanged otherwise. **Done** — 312 tests pass.
   f. Only after this split is stable and reviewed: design the actual single-player mode against the decoupled core `Game.sol` — separate effort, separate plan, not part of this document. **Not started — next step, owned by the project owner.**
4. **At every step, run `npx hardhat compile` and inspect the `hardhat-contract-sizer` output for every touched contract** — this repo has an established, documented pattern (`docs/pre-audit.md`) of measuring exact before/after KiB deltas per change. Never touch `optimizer.runs`, `viaIR`, or any size-check bypass — reduce bytecode instead, per `CLAUDE.md`.

---

## Verification

- **Compile/size gate**: `npx hardhat compile` after every meaningful change; the `hardhat-contract-sizer` plugin (already configured `strict: true`) will hard-fail the build if any contract exceeds 24 KiB — treat any failure as a stop-and-fix-size signal, not something to suppress.
- **Existing test suite**: run the full suite (`npx hardhat test`) after each sub-step in the order above, not just at the end — Task 1 touches shared attribute-calculation code paths exercised by many existing Game/Ships/Fleets tests.
- **New tests to add**:
  - `ShipAttributes`: two ships with the same equipment but different variants produce different `Attributes`/special strength-range; unconfigured-variant lookup reverts (fail-loud); `setVariantAttributes` + shrunk `setAllAttributes` both function correctly together.
  - `DroneYard`/`Ships`: variant-change via `modifyShip` is rejected above `maxVariant`, and is priced (counted in `_calculateNewModifications`); confirm the explanatory comment lands in `Ships._applyShipCustomization`.
  - `Game`/`PvPMatch` split (once implemented): every existing PvP test still passes unchanged against the new two-contract wiring; a full PvP game still plays start-to-finish (lobby → fleets → `PvPMatch.startGame` → alternating `moveShip` on core `Game.sol` → win/score/flee/timeout paths all still end the game and still record to `GameResults`); confirm `Game.sol` no longer references `IGameResults` at all (it keeps `IFleets` — that dependency doesn't move).
- **Manual/E2E sanity** (per project convention of testing real usage before declaring done): if a frontend or script exists for exercising Lobbies/Game flows, drive one full PvP match through it end-to-end after the split to confirm nothing regressed for existing players.

## Critical Files

- `contracts/Types.sol` — struct shape changes (`AttributesVersion`, new `VariantAttributeData`, `Costs`)
- `contracts/ShipAttributes.sol` — nearly all of Task 1's new logic; has the bytecode room to absorb it
- `contracts/IShipAttributes.sol` — interface signature updates
- `contracts/Game.sol` — Task 1's 4 surgical call-site changes (`_performSpecial`, `_validateSpecialRange`, `_performRepairDrones`, `_performEMP`, `_performFlakArray`), **already done**; Task 2 replacement's core-engine cuts (`IGameResults`/`lobbiesAddress`/`flee`/`endGameOnTimeout` removed, `orchestrator`/`isAllowedToStartGames`/`forceEndSession` added) — **done**
- `contracts/DroneYard.sol` — variant bound check + pricing fix, **already done**
- `contracts/Ships.sol` — `_calculateModifications` variant accounting + explanatory comment in `_applyShipCustomization`, **already done**; second-tightest headroom in the repo, unaffected by the Task 2 replacement
- `contracts/IShips.sol` — `maxVariant()` getter exposure, **already done**
- `contracts/GenerateNewShip.sol` — optional random-variant roll, deliberately deferred (no current caller)
- `contracts/GameResults.sol` — the single-player stats separation added for the rejected `AIController` approach was reverted; `recordGameResult` is back to its original unconditional behavior, now called by `PvPMatch` instead of `Game.sol`
- **Done — Task 2 replacement**: `contracts/PvPMatch.sol`, `contracts/IGameOrchestrator.sol` (new); `contracts/Game.sol` (core-engine cuts); `contracts/Lobbies.sol` (retargeted its one call site); `ignition/modules/DeployAndConfig.ts` (deploys/wires `PvPMatch`)
- `contracts/Tournament.sol`, `contracts/Fleets.sol`, `contracts/Maps.sol` — confirmed to need no changes for the Task 2 replacement
- `contracts/AIController.sol` — this session's rejected work; deleted, along with `test/AIController.test.ts` and the `GameResults`/`Lobbies` additions made only to support it
- `docs/ShipsSizeOptimizationAnalysis.md` — existing, pre-identified ~3.3-3.5 KiB of Ships.sol savings to draw on if any future Ships.sol change regresses size
- `docs/pre-audit.md` — established pattern/precedent for tracking contract-size deltas per change

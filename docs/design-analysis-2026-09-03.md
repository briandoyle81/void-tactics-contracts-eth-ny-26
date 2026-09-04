# Design analysis: what to harden and what to build next

Written 2026-09-03, after building the pluggable roguelike win-effect system
(`IRoguelikeWinEffect`, per-node resolver registry on `RoguelikeNodeMap`,
dispatch in `RoguelikeMatch.onGameEnded`, three concrete resolvers, and the
admin UI). This is a research/recommendation document, not a commitment to
build everything listed — grounded in two searches of the codebase (TODO/
CRITICAL/deferred markers plus `docs/pre-audit.md`/`docs/internal-todos.md`,
and a survey of PvP/Tournament/faction/DroneStorefront systems) rather than
invented from scratch.

One finding is a real bug in what already shipped, not a suggestion — it's
listed first since it's more urgent than any new feature, and status is
tracked here as it's fixed.

## ~~P0 — Bug: a single broken win-effect resolver can brick a combat win~~

**Status: fixed 2026-09-03** — `RoguelikeMatch.onGameEnded`'s win-effect
dispatch loop now try/catch's each resolver call and emits
`WinEffectFailed(player, nodeId, resolver)` on failure instead of
reverting the whole game-ending transaction. Covered by a new test
(`MockAlwaysRevertsWinEffect` + a broken resolver sandwiched between two
working ones, proving both still fire and the win still completes). Full
test suite passing (601/601).

`RoguelikeMatch.onGameEnded`'s win-effect dispatch loop has no error
containment:
```solidity
for (uint i = 0; i < winEffects.length; i++) {
    IRoguelikeWinEffect(winEffects[i]).onNodeWon(player, run.campaignId, run.currentNodeId);
}
```
`onGameEnded` is invoked by `Game.sol:577` as a **bare external call**
(`Game.sol:576-582`, no try/catch) from inside `_endGame` — the function
that sets `game.metadata.ended = true` and releases fleets. If any resolver
in a node's win-effect list reverts (DEC minting deactivated,
`Ships.isAllowedToCreateShips` revoked, an out-of-gas edge case, anything),
the revert bubbles all the way up through `_endGame` and the **entire
game-ending transaction fails** — the win is never recorded, fleets never
release, the player is stuck. One misconfigured resolver on one node would
brick every win at that node for every player, indefinitely, until an admin
fixes the resolver.

**Fix**: wrap each resolver call in a try/catch inside the dispatch loop,
mirroring the pattern already used two lines earlier in the same function
(`try { game.getShipAttributes(_gameId, shipId) } catch {}` for the
auto-heal survivor loop) — a failing effect is swallowed and skipped, never
blocking the win itself.

## P1 — Natural extensions of what's already built (low effort, reuses today's work)

- **No on-chain record of which effects actually fired.** The three
  resolvers emit config-change events (`BonusAmountSet`, etc.) but nothing
  when `onNodeWon` itself runs. Add a
  `WinEffectTriggered(address indexed player, uint indexed nodeId)`-shaped
  event — either one per resolver or a single one emitted from
  `RoguelikeMatch`'s dispatch loop — so a future "run history" UI has
  something to index instead of inferring "did the DEC bonus fire" from a
  raw `Transfer` event.
- **More resolver types**, since the interface is intentionally generic: a
  UTC-bonus resolver (mirrors `DECBonusWinEffect` for the human-side
  currency), a node-unlock resolver (grants access to a bonus branch), a
  resolver that grants a specific curated ship instead of a random one (via
  `Ships.createSpecificShip`, already used by `ShatteredHiveMedal`-style
  content). All slot into the existing catalog/dispatch with zero changes
  to `RoguelikeMatch.sol`.

## ~~P1 — A decision worth making now, while the pattern is fresh: is this roguelike-only?~~

Research confirmed a real asymmetry: **PvP and Tournament have zero
pluggable post-match effects.**
- `PvPMatch.onGameEnded` (`PvPMatch.sol:110-121`) only calls
  `gameResults.recordGameResult(...)` — no reward dispatch of any kind.
- `Tournament.finalize` (`Tournament.sol:433-452`) has one fixed 60/40
  champion/runner-up split of a single undifferentiated prize pool — no
  per-round bonuses, no achievement/NFT hooks, sponsor prizes just add to
  the same pool.

Roguelike now has three layers of configurable post-match economics
(per-run auto-heal floor, the global heal cap, and the per-node win-effect
list); PvP/Tournament have none. Worth deciding deliberately: keep
`IRoguelikeWinEffect` roguelike-specific (simpler, already done), or
generalize it into a mode-agnostic `IWinEffect` (rename, drop the
roguelike-specific `campaignId`/`nodeId` params or make them opaque
context) so the *same* resolver contracts (DEC bonus, ship grant) could be
reused for a PvP win or a Tournament round win too. Generalizing later
means touching the interface and all three resolvers again; deciding now
avoids that rework if PvP/Tournament rewards are ever going to want this.

**Resolved 2026-09-03 — generalized, with dispatch wired into both.**
`IRoguelikeWinEffect` → `IWinEffect`, `onNodeWon(player, campaignId, nodeId)`
→ `onWin(player, contextId)` (a single caller-defined id: roguelike passes
the node id, PvP the game id, Tournament the tournament id). All three
existing resolvers updated (their bodies already ignored the extra
context params, so this was a signature-only change). New dispatch added
to `PvPMatch.onGameEnded` (winner only, own `winEffects` list, empty by
default) and `Tournament.finalize` (champion only, own `winEffects` list,
empty by default) — both individually try/catch'd per resolver from day
one, learning from the P0 fix above rather than repeating it. Deploy
script grants all three resolvers `isAllowedToTrigger` for
`RoguelikeMatch`, `PvPMatch`, and `Tournament` independently. New tests:
`test/PvPMatch.test.ts` (new file) and a "Win effects" describe block in
`test/Tournament.test.ts`, covering default-empty/owner-only, a real
DEC-bonus dispatch, and the broken-resolver resilience case for each.
Full suite passing.

## P2 — Content: faction 3/4 and the planned kill-token now have a proven pattern to follow

Only 2 of an architecturally open-ended faction slot system are built
(`factionAbilityResolvers[1]` = Ram, `[2]` = Repair — confirmed via
`DeployAndConfig.ts`). The previously-noted "future faction-3/4 kill
token" (deferred purely for `Game.sol`/`Ships.sol` bytecode headroom per
`docs/pre-audit.md`'s 2026-08-26 addendum) is a strong candidate to build
the same way win-effects were: **a standalone resolver-style contract
wired in via an allowlist grant, not new logic inlined into an already-tight
core contract.** Today's session proved that pattern twice
(`NodeContentRegistry`, the win-effect resolvers) — it's the established
mitigation for the project's binding 24 KiB constraint, and should be the
default approach for faction-3/4 content whenever it's built.

## P2 — Existing debt flagged by the project's own prior audit, unrelated to today's work

- ~~**`Ships.sol` has three unresolved CRITICAL TODOs**: an unconfirmed
  choice between `ReentrancyGuard`/`ReentrancyGuardTransient`
  (`Ships.sol:9`), an unevaluated side-effect question on free-ship-claim
  purchase counting (`Ships.sol:144`), and predictable-ship-ID griefing on
  `customizeShip` explicitly left as "I don't think I care, but should I?"
  (`Ships.sol:198-201`).~~ **Resolved 2026-09-03**, after a thorough
  re-examination (see the follow-up plan) turned up that two of the three
  were stale/already-fixed and the third had a zero-cost policy fix:
  reentrancy guard confirmed `ReentrancyGuard` is correct (project's
  compiled EVM target is `paris`, pre-Cancun — the transient variant isn't
  usable without a risky project-wide `evmVersion` bump across 6 networks);
  the purchase-counting exemption was already correctly implemented in a
  later commit, TODO just never deleted; `customizeShip`'s TODO rewritten
  into an explicit documented constraint (always use `createSpecificShip`
  for future bonus-ship features, never mint-then-customize-by-id) rather
  than left as an open question. All three were comment-only changes —
  `Ships.sol` deployed size unchanged (23.929 KiB).
- ~~**`getShipsOwned(address)` is built but disabled** (`Ships.sol:714-721`,
  commented out, flagged `TODO CRITICAL: needs pagination`) — there's
  currently no on-chain way to enumerate "every ship a player owns" without
  off-chain indexing. Worth a paginated version if the frontend ever needs
  this directly.~~ **Resolved 2026-09-03** — turned out to be dead code,
  not a real gap: it's the pre-fix version of a problem GR-01 already
  solved via the paginated `shipsOwnedCount`/`shipIdOwnedAt` primitives
  sitting right above it in the same file. Deleted the commented-out block.
- ~~**`ShatteredHiveMedalArt.sol` is a finished renderer never wired into
  `ShatteredHiveMedal.tokenURI`** (which currently just returns `""`) — a
  low-effort win if the medal's on-chain art actually matters to ship.~~
  **Resolved 2026-09-03** — added `IShatteredHiveMedalArt` (new interface),
  an owner-settable `art` reference + `setArtAddress` on
  `ShatteredHiveMedal.sol` (a setter, not a constructor param, so it wires
  onto the already-deployed Base Sepolia contract without a redeploy — 0
  medals had been minted there anyway), and a `tokenURI` override using the
  same two-layer Base64 SVG→JSON pattern `ImageRenderer.sol`/
  `RenderMetadata.sol` already use. Deploy wiring added; `ShatteredHiveMedal`
  grew 4.747→6.010 KiB (still ~18 KiB of headroom). New tests cover
  nonexistent-token revert, owner-only `setArtAddress`, and decoding the
  returned data URI to confirm it embeds the art contract's exact SVG.

## P3 — Bigger lifts, only worth it if actually wanted

- **`DroneStorefront` sells exactly one thing** (a linear tier ladder,
  `tierCoreCost[]`) — not an extensible item catalog. Adding a second DEC
  sink today requires a new contract, not a config change. Worth a real
  catalog rewrite only if more DEC sinks are actually planned.
- **`docs/internal-todos.md`** already has a maintainer backlog
  (referral/wager systems, reserved lobbies, map-creator fee shares,
  minimum fleet size, etc.) — not re-litigated here, just flagged as the
  existing source of truth for unprioritized ideas beyond this analysis.

## Recommendation

Fix P0 before anything else — it's a live bug, not a feature gap. After
that, the two P1 items are the highest-leverage next steps specifically
because they build directly on what's already shipped and tested today
(win-effect trigger events, and the roguelike-only-vs-generalized decision)
rather than opening new surface area. Everything else is real but lower
urgency.

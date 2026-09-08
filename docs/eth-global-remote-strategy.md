# ETH Global Remote — Continuity Track Prize Strategy

_Written 2026-09-08. Describes `docs/eth-global-remote.md` (the ETHGlobal Remote sponsor prize
sheet) as it read on that date — re-check line numbers/amounts if this doc is read much later,
sponsors sometimes edit prize sheets mid-event._

## Context

Void Tactics is entering ETH Global Remote as a **Continuity** team — the game already shipped
(pre-hackathon repo, plus a prior ETH NY 2026 hackathon round that added World ID Tournament
gating, Walrus match records, and Dynamic wallet auth). `docs/eth-global-remote.md` lists this
event's sponsor prize tracks; the goal is to pick 3 sponsors and build real, Continuity-eligible
extensions — not cosmetic integrations bolted on to qualify.

A first pass at this analysis was too shallow: it proposed a "verify AI ship ownership with
World AgentKit" pitch without checking whether the game's "AI ownership" concept was actually a
real agent identity. Three research passes were sent to verify every load-bearing claim against
the actual contracts before recommending anything again. Two claims from the first pass turned
out to be wrong or weak, and one new, much stronger opportunity surfaced that wasn't in the
first pass at all:

- **Wrong:** "AI-owned ships" is not an autonomous agent concept. `SinglePlayerMatch._mintAIFleet`
  just mints ships to the match contract's own address; `AIShips`/`AIBehavior`/`RoguelikeAIController`
  are deterministic, hardcoded priority-list PvE enemies with id ≥ `2**40`. There is no wallet,
  no off-chain decision-maker, no delegate/operator concept anywhere in the repo. A "verify this
  AI agent" pitch built on this would have been dishonest framing of a PvE labeling convention.
- **Weak:** ENS's natural pairing point (`DroneNames.sol`) turned out to be a pure deterministic
  string generator, not a stored registry — there's nothing to "swap for ENS," so any ENS
  integration would be closer to a cosmetic add-on than the ENSv2 track wants ("central to the
  product, not a cosmetic add-on"). Dropped from the top picks.
- **New and strong:** `FreeShipClaim.sol` (10 free ships / 28-day cooldown, address-keyed only)
  and `TutorialClaim.sol` (one-time ship grant + a `GameResults.addWin`/`addLoss` write, also
  address-keyed only) have **zero human-uniqueness protection** — unlike `Tournament.sol`, which
  already gates entry behind Orb-level World ID (`ByteHasher` + nullifier tracking). Any script
  can mint unlimited fresh wallets and drain free ships or inflate win/loss stats forever. This
  is a real, currently-exploitable gap in a shipped product, not a hackathon strawman.
- **Confirmed real:** `docs/pre-audit.md` and `RandomManager.sol`'s own comments already name
  **Chainlink VRF** as "the only way to remove [a documented residual randomness risk]
  entirely." `IRandomManager` was kept deliberately stable so a provider swap needs no changes
  to `Ships.sol`/`Tournament.sol` beyond their existing owner-gated config setters.
- **Confirmed real:** `ShipPurchaser.purchaseUTCWithFlow()` (FLOW → UTC) already exists, and
  `docs/UTC_Price_Prediction_10k_Players.md` already *assumes* an external market price for UTC
  and arbitrage against it — but no DEX integration exists anywhere in the repo. A Uniswap v4
  pool + hook would be building the market the game's own economics docs already assume, not
  bolting on an unrelated feature.
- **Confirmed real, low-risk:** the deploy/ops tooling (`scripts/allowFirebaseMinter.ts`, the
  `METAMASK_WALLET_1` hot key pattern in `.env`) is exactly the kind of leaked-secret risk
  Ledger's Key Ring track targets, and fixing it touches ops scripts, not contract bytecode — no
  pressure on the 24 KiB contract-size limit at all.

Every dollar figure, prize-pool split, and Continuity-eligibility tag below was checked
line-by-line against `docs/eth-global-remote.md`. One inaccuracy from an earlier draft of this
analysis was caught in that pass — see the Chainlink section's correction note.

## Tracks deprioritized after review

Kept out of the final picks; noted here for completeness, each checked against
`docs/eth-global-remote.md`:

- **Hedera** ($15,000 total pool) — its only pool-restricted prize, "♻️ Continuity — $1,000"
  (lines 306-322), explicitly requires the project to have "already exist[ed] in some form on
  Hedera" — Void Tactics has never touched Hedera, so we're not eligible for that specific prize
  regardless of our overall Continuity status. Its other three prizes (AI & Agentic Payments
  $6,000, Open Source Harness $2,000, Tokenization of Anything $6,000, lines 147-305) carry no
  pool restriction and we could technically submit, but none have a natural seam with the
  existing FLOW/Base-denominated game.
- **Arc/Circle** ($10,000 total) — has two Continuity-tagged prizes: "Best DeFi or Agentic
  Application — $1,666" (lines 399-435) and "Launch on Arc Testnet & Push to Mainnet — $1,500"
  (lines 466-491, requires deploy-or-deploy-ready on **Arc mainnet by September 30**). Both are
  eligible in principle, but the game's economy is FLOW/UTC-denominated with no USDC/stablecoin
  surface today, and a mainnet-deploy requirement needs deliberate sign-off per this repo's
  deploy-safety rules — large lift, weak narrative fit.
- **Privy** ($5,000 total) — neither prize (lines 860-901) carries a Continuity tag, but more
  importantly Void Tactics already ships Dynamic for wallet/auth; adding Privy would duplicate
  that shipped integration rather than extend it.
- **1inch** — "Build an Aqua App - Continuity Track — $2,000, 1st $1,500 / 2nd $500" (lines
  627-654) is Continuity-eligible, but there's no existing swap/AMM code in the repo to build on
  (confirmed via grep — zero hits for swap/DEX/AMM/router-as-DEX), a bigger novel lift than the
  Uniswap v4 hook option for a comparable prize size.
- **Bazantic** — "Help an Agent Use Your Hackathon Project — $1,000, up to 2 teams at $500"
  (lines 1049-1069) is Continuity-eligible, but it requires wrapping an internal queryable API
  in an x402/MCP gateway — Void Tactics has no backend API of its own to wrap (the "backend" is
  just a minter-authorization script), so this would mean building net-new API surface just to
  have something to agentify.
- **ENS** — "Best Integration of ENSv2 into an Existing Project — $500" (lines 708-718) is
  Continuity-eligible and cheap, but the natural pairing point we hoped for (`DroneNames.sol`)
  turned out to be a pure deterministic string generator with no stored registry to swap out —
  any ENS integration would land closer to the "cosmetic add-on" the track explicitly warns
  against than to something "central to the product."

## Locked-in picks (2 of 3 sponsors)

### 1. The Graph — "Best AI Tooling or AI Use Case with The Graph (Continuity)" — $5,000 pool

1st $2,500 / 2nd $1,500 / 3rd $1,000; explicitly tagged "🆕 This prize is only available to
Continuity Track participants" at line 87, and the track body itself says "THIS TRACK IS THE
CONTINUITY TRACK" at line 108 — distinct from the "From Scratch" pool at lines 45-85.

No indexer exists anywhere in this repo (or, as far as the contracts repo shows, the separate
frontend repo) — `GameResults`, `Tournament`, `Fleets`, and claim events are only readable by
walking raw chain events. Build:

- A Subgraph indexing `GameResults` (wins/losses), `Tournament` (registrations, brackets, match
  results — `contracts/Tournament.sol`), and `FreeShipClaim`/`TutorialClaim` claim events.
- A Subgraph MCP server (or direct Subgraph Studio queries) exposing natural-language queries
  over this data — e.g. "show me every wallet that claimed free ships from a cluster of
  same-block-funded fresh addresses," which doubles as a real abuse-detection tool for the World
  track below. This is what makes the three picks form one coherent story instead of three
  disconnected integrations.
- Consume live data via an API key from Subgraph Studio (mocked/local data does not qualify per
  the track's own rules).
- Submit under the explicit "THIS TRACK IS THE CONTINUITY TRACK" pool (lines 86-127), not the
  "From Scratch" one at lines 45-85 — document what's pre-existing (the whole game) vs. new (the
  subgraph/MCP work) per the track's requirements.

### 2. World — Selfie Check — $3,500 pool, up to 3 teams at $1,166 each

**Eligibility check:** unlike AgentKit ("🆕 This prize is only available to Continuity Track
participants", line 517), Selfie Check carries no pool-restriction tag at all (lines 540-561) —
it's open to both Start-Fresh and Continuity submissions. Being a Continuity team does not
exclude us from it; it just means we won't get a smaller, protected competing field the way we
would on AgentKit or the other explicitly-tagged tracks below.

Gate `FreeShipClaim.claimFreeShips` and `TutorialClaim.completeTutorialWinPath` /
`completeTutorialLossPath` behind a Selfie Check proof, as a lower-friction complement to
Tournament's existing full-Orb World ID gate — matches the track's own framing almost verbatim
("risk, eligibility, fairness, continuity, or abuse prevention").

- Reuse the pattern `Tournament.sol` already established for World ID: `ByteHasher` for signal
  hashing, a nullifier mapping to prevent proof reuse, proof validation on-chain (not in a
  backend) — see `contracts/Tournament.sol` lines 1-80 and `contracts/IWorldID.sol`.
- `FreeShipClaim.sol` currently only tracks `lastClaimTimestamp[msg.sender]`
  (`contracts/FreeShipClaim.sol:18`) — add a per-nullifier claim record alongside the existing
  per-address cooldown so a proof can't be reused across wallets, without removing the existing
  cooldown logic.
- `TutorialClaim.sol` currently only tracks `tutorialCompleted[player]`
  (`contracts/TutorialClaim.sol:13`) — same nullifier-alongside-address pattern.
- Both are already split-out standalone contracts (per the "Ships.sol size fix pattern" this
  repo already follows, since `Ships.sol`/`Game.sol` are near the 24 KiB limit), so adding World
  ID verification here doesn't pressure the core contracts at all.
- Deliverable also requires a feedback document (World ID docs, Developer Portal, Sandbox App
  experience) per the track's qualification requirements — write this alongside the code, not
  after.

## Third slot — needs further scoping before committing

Kept open per direction: keep Ledger and Uniswap both live for exploration, with Chainlink VRF
as the low-risk fallback. All three are real, grounded, Continuity-eligible, and technically
compatible with each other (they touch different contracts), so more than one could plausibly be
built even if only one is ultimately submitted as the "official" third sponsor.

**A. Chainlink VRF — "Best Chainlink-Powered Upgrade" (Continuity) — $500**

- Lowest effort, lowest risk, lowest prize. New `ChainlinkRandomManager` implementing the
  existing `IRandomManager` interface (`contracts/IRandomManager.sol`); repoint via
  `Ships.setConfig` and `Tournament`'s constructor/config (both owner-gated, no proxy needed). No
  changes to any consuming contract's logic.
- Directly cites a real, documented finding: `docs/pre-audit.md`'s randomness remediation entry
  names Chainlink VRF as the real fix for the residual timing-choice risk in the current
  commit-reveal (`block.prevrandao`) scheme.
- **Correction from an earlier draft of this analysis:** VRF does *not* need to be routed
  through CRE. The track lists five independently-eligible technologies — "Chainlink Runtime
  Environment (CRE) - including Confidential Workflows, Price Feeds, Data Streams, Proof of
  Reserve (PoR), VRF (Verifiable Random Function)" (lines 974-980). The doc's "Important: Please
  use CRE instead of Chainlink Functions or Automation" note (line 984) is a warning about two
  specific *deprecated* products (Functions, Automation), not a requirement that every
  integration go through CRE. Plain VRF (subscription model) is directly eligible on its own —
  scope against that, not a CRE wrapper, unless CRE genuinely simplifies the integration.

**B. Ledger — "Continuity" track — $1,500 (1st $1,000 / 2nd $500)**

- Almost entirely an ops/tooling change: move the hot key used by
  `scripts/allowFirebaseMinter.ts` (and other owner-gated admin actions — RandomManager repoint,
  mint-authorization changes) onto Ledger's Key Ring CLI (`wallet-cli ring`), or add a
  device-confirmation step in front of one of those actions.
- Matches the track's own example almost exactly: "Make wallet-cli ring the key backend for the
  .env... files your repo already has" / "Put a device confirmation in front of an action your
  product already performs."
- Needs scoping: which specific admin action(s) get the device-confirmation treatment, and
  whether the Key Ring CLI needs a CI/VPS enrollment step (no USB port) given deploys likely run
  from a laptop or CI runner rather than a device with the Ledger physically attached.

**C. Uniswap — "Best Uniswap Stack Contribution" (Continuity) — $2,000 (1st $1,000 / 2nd $1,000)**

- Biggest lift of the three. Deploy a real UTC/ETH (or UTC/USDC) Uniswap v4 pool with a custom
  hook enforcing the burn/arbitrage mechanic `docs/UTC_Price_Prediction_10k_Players.md` already
  assumes exists (a small fee-on-swap routed into the existing UTC burn/treasury flow, closing
  the loop between the 1:1 `purchaseUTCWithFlow` mint rate and the assumed external market
  price).
- Needs scoping: exact hook logic (fee capture + where it's routed — does it feed the existing
  `owner()` treasury withdrawal path in `ShipPurchaser.sol`, or a new burn sink?), and whether a
  v4 pool needs its own liquidity seeding plan for a believable demo.
- Requires a `FEEDBACK.md` + Uniswap Developer Feedback Form submission per the track's
  qualification requirements.

## Implementation notes (for whenever this moves from strategy to build)

- Contract-side work (World/Selfie Check nullifier gating, Chainlink VRF `RandomManager` swap,
  any Uniswap hook) is testable the normal way: `npx hardhat test`, after confirming `PRODUCTION`
  is `false` in `ignition/modules/DeployAndConfig.ts` per `CLAUDE.md`. New contracts get their
  own test file following the existing per-contract pattern in `test/`.
- Contract size must be re-checked after any addition to `Ships.sol`/`Tournament.sol` (both are
  near the 24 KiB limit) — prefer the existing pattern of splitting new logic into standalone
  contracts wired through an authorized-minter/allowlist, as `FreeShipClaim.sol` and
  `TutorialClaim.sol` already do, rather than growing the core contracts in place.
- The Graph subgraph is verified by querying it against live Base Sepolia data through Subgraph
  Studio once deployed — mocked/local data does not satisfy the track's own qualification
  requirement.
- Any real deploy (new World ID gate, new RandomManager, a live Uniswap pool) targets Base
  Sepolia only, per `CLAUDE.md`'s deployment-safety rules — no mainnet or other testnet deploy
  without the user explicitly directing that specific deploy.

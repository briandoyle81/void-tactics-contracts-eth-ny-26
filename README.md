# Void Tactics Contracts

> **Note for judges:** This repository couldn't be forked from the original because the original is also mine — GitHub doesn't allow forking your own repo into the same account. The hackathon features described here (Dynamic Flow purchases, World ID tournament registration, Walrus game recording and replay) were all built after the hackathon start time. The original pre-hackathon deployment is at [voidtactics.xyz](https://www.voidtactics.xyz) for comparison.

Hackathon Live Deployment: https://void-tactics-fe-eth-ny-26.vercel.app/
Demo Video: https://youtu.be/r8ehGtyE14E
Original Live Deployment: https://www.voidtactics.xyz

Smart contracts for Void Tactics, an onchain tactical strategy game with NFT ships, configurable fleets, map/lobby flow, and battle outcomes recorded on-chain.

Players build fleets of NFT ships, enter lobbies, compete on a 17×11 grid using movement, weapons, and special abilities, — all resolved trustlessly on-chain. This repository contains the Solidity contracts, Hardhat configuration, and Ignition deployment modules for the full game system.

## Design Philosophy

Void Tactics is built to be **unkillable and composable**. Every rule, every game result, every ship, and every tournament lives on-chain with no proprietary backend required to play. The contracts are the game.

If the original team stops supporting it tomorrow, the game keeps running. Anyone can build a new frontend, a new tournament organizer, a new ship marketplace, or an entirely new game mode on top of the same deployed contracts — without asking permission and without paying platform fees to a middleman. Revenue flows automatically through the protocol to whoever is building on it, including the original deployer.

This extends to the assets themselves. Every ship's art is generated and stored 100% on-chain — no IPFS links, no hosted image servers, no CDN that can go dark. The NFTs are self-contained: the metadata and artwork live in the contracts permanently, regardless of what happens to any external service.

This is the practical difference between a game that is _on-chain_ and one that merely _uses_ a chain. Void Tactics is designed so that the community can own and extend it long after any single team has moved on.

## What's New (ETH New York 2026)

Pre-hackathon contract repo: https://github.com/briandoyle81/warpflow-contracts

Three major features were added during the hackathon, all deployed and live on Base Sepolia:

### Tournament System (World ID)

A full single-elimination tournament contract (`Tournament.sol`) with verifiable human identity at the registration gate. World ID (Orb level, on-chain verification via the Base Sepolia `WorldIDRouter`) enforces one entry per human per tournament — because a bracket where one person controls multiple wallets is not a fair competition.

- Players register with a World ID proof; the `nullifierHash` is stored per-tournament to prevent sybil entries
- The signal is bound to `msg.sender`, so a proof cannot be reused across wallets
- Registration is permissionless; bracket construction, advancing, and finalization are all permissionless
- Prize pool: 1% protocol fee, then 60/40 split to finalist and runner-up (pull payment via `claim`)
- Sponsors can fund a prize pool; refunded automatically if the tournament is cancelled
- Draw resolution via creator-only `resolveDraw` (temporary, marked in code) awards to the earlier-registered player deterministically

### Verifiable Match Records (Walrus)

A `GameBlobRegistry` contract stores each player's Walrus `blobId` for every completed game. During a match, each player's client continuously uploads the current game state to Walrus and updates their on-chain slot — so the record is live throughout the game, not just written at the end.

This design means replays require no traditional backend to exist. As long as either player's blob survives on Walrus, anyone can reconstruct the full match from on-chain events plus the stored state. In the future, players will be able to control how long their records are stored and pay to extend retention themselves.

- Each player owns their own slot: `blobs[gameId][player]` — players write their own record, not a shared one
- Players may update their slot at any time (live updates during play, or re-upload after the fact)
- Replay: call `getBlob` for both participants and use whichever is non-zero; if both are present they are equivalent
- Winner integrity is never derived from the blob — it always comes from `GameResults` on-chain; the blob is an opaque replay pointer only
- The contract is intentionally minimal with a single admin function to rotate the authorized backend writer

### `gameId == lobbyId` Unification

Previously `Lobby` and `Game` maintained independent counters, so a lobby's ID diverged from its game's ID. `Game.startGame` now keys each game by the incoming `_lobbyId`, making the two IDs identical. This eliminates an entire class of off-chain bookkeeping errors when linking tournament matches to their on-chain games and Walrus records.

---

## Deployed Contracts (Base Sepolia, chain 84532)

| Contract           | Address                                      |
| ------------------ | -------------------------------------------- |
| `Game`             | `0x5801c1303e13899FCbC6702b16B77183F1ddB8f4` |
| `GameResults`      | `0x1f341c690C5AaA61D06736AD67937385a76f1FE2` |
| `Tournament`       | `0xF9d579915fc22bCbd2B67bF14Bb8FD75232E97DC` |
| `GameBlobRegistry` | `0xDab9f61b7243b37E9B1f471d0f18ef758AABDF0E` |
| `Lobbies`          | `0xf0Aa01DfF32F2F83e885DF9E637C7875916B04aB` |
| `Fleets`           | `0xF37D64C7FD867eF7BFDb1b52b6bcc449cD866135` |
| `Ships`            | `0xD36B2D129fb48c488cA5cE00e2941995FB9C6D74` |
| `Maps`             | `0xAcEB0a35132a111BA3D3816c5EA6D62AeFa9a86A` |
| `ShipAttributes`   | `0x00e4068255Abf416086f7bF6c507bc36B7a232E7` |
| `UniversalCredits` | `0x86161787160F5A54F1424B7F7119247352DE215e` |

Full address list: `ignition/deployments/chain-84532/deployed_addresses.json`

---

## Tech Stack

- Solidity `0.8.28`
- Hardhat + Ignition
- Viem tooling via `@nomicfoundation/hardhat-toolbox-viem`
- OpenZeppelin Contracts
- World ID on-chain verification (`IWorldID.verifyProof`, Base Sepolia testnet router)
- Walrus decentralized storage (blob references committed on-chain via `GameBlobRegistry`)
- Dynamic wallet/auth (frontend, separate repo)

## Quick Start

### 1) Install dependencies

```bash
npm install
```

### 2) Configure environment

Create a `.env` file in the repository root:

```env
METAMASK_WALLET_1=0xYOUR_PRIVATE_KEY
```

### 3) Compile contracts

```bash
npx hardhat compile
```

### 4) Run tests

```bash
npx hardhat test
```

## Deployment

### Full suite

```bash
npx hardhat ignition deploy ignition/modules/DeployAndConfig.ts --network base-sepolia
```

### Authorize the backend minter

```bash
npx hardhat run scripts/allowFirebaseMinter.ts --network base-sepolia
```

Retry helper for interrupted Ignition deploys:

```bash
./scripts/ignition-deploy-retry.sh --network base-sepolia --deploy-script ignition/modules/DeployAndConfig.ts
```

## Repository Structure

- `contracts/` — core game contracts and token/NFT logic
  - `Tournament.sol` — single-elimination tournament with World ID gate and Walrus match records
  - `GameBlobRegistry.sol` — on-chain index of Walrus blob IDs per completed game
  - `Game.sol`, `Lobbies.sol`, `Fleets.sol` — core game loop
  - `Ships.sol`, `ShipAttributes.sol` — NFT ships and attribute system
  - `GameResults.sol` — canonical on-chain win/loss record
  - `Maps.sol` — configurable game maps with scoring objectives
- `ignition/modules/` — Hardhat Ignition deployment modules
- `test/` — contract tests
- `scripts/` — deployment and maintenance scripts
- `docs/` — design docs, tournament spec, and audit notes

## Notes for Reviewers

- Contract size is enforced at compile time via `hardhat-contract-sizer`; the "ignore contract size" flag is never set (see `.cursor/rules/` and `CLAUDE.md`)
- World ID integration uses on-chain `verifyProof` (not a backend check), so sybil resistance is enforced at the contract level with no trusted intermediary
- Walrus blob integrity: the on-chain `blobId` is an opaque `bytes32` pointer; prize outcomes always derive from `GameResults`, never from blob content
- `Tournament.resolveDraw` is marked `// TEMPORARY` in the contract source — drawn games are an edge case to be addressed post-hackathon with a proper on-chain tiebreak
- `docs/pre-audit.md` contains an internal security review completed during the hackathon
- Multiple testnets are configured in `hardhat.config.ts` (Base Sepolia, Flow Testnet, Ronin Saigon, XAI); the tournament and Walrus integration target Base Sepolia

## License / Usage

All rights reserved unless otherwise stated.
This repository is shared for evaluation and learning; reuse in production or derivative commercial projects requires explicit permission.

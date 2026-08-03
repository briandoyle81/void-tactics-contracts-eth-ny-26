# Void Tactics Contracts

## Contract Size Limits

You are **never** allowed to turn on or enable "ignore contract size" (or equivalent) for compilation.

- Do **not** add or set options that skip or ignore contract size checks (e.g. in Hardhat, Solidity config, or contract-sizer).
- Do **not** suggest disabling or bypassing the 24 KiB deployment / 24 KiB init size limits.
- If contracts exceed size limits, reduce size by refactoring, libraries, or optimizer settings — do not disable the check.

This applies to any config that would ignore or suppress contract size warnings/errors (e.g. `ignoreContractSizeLimit`, `ignoreSizeLimit`, or similar).

## Deployment Safety

- **Never delete folders/directories.** If a directory needs to be removed, tell the user and let them do it themselves.
- To validate contract or deploy-script changes, use the test suite (`npx hardhat test`) and the ephemeral in-memory deploys it performs via `loadFixture`/`hre.ignition.deploy(...)`.
- **Never run `npx hardhat ignition deploy` (or equivalent) against any network other than the local ephemeral `hardhat` network.** Do not deploy to `base-sepolia` or any other real/live network unless the user explicitly directs you to do that specific deploy.

## Hardhat Ignition Execution Order

Hardhat Ignition does **not** guarantee `m.call(...)` invocations execute on-chain in the order they're registered in a deploy module — only `after:`-declared dependencies are honored. Independent calls (or independent branches of a dependency graph) can be interleaved/reordered by Ignition's own scheduler.

- Never assume a resource's on-chain id equals its 1-indexed position in a JS array/loop unless every call that creates one of these resources is *also* explicitly chained to the previous one via `after:` (as `ignition/modules/DeployAndConfig.ts` does for maps, campaigns, and campaign nodes) — without that forced chain, a branching dependency graph (e.g. multiple independent prerequisite chains hanging off a shared node) can silently assign ids out of the order you expect, corrupting anything computed from the guessed id (e.g. a later node's prerequisites pointing at the wrong node).
- This was found and fixed once already (30-node campaign seed, 2026-08-03): two nodes in independent branches got their ids swapped relative to array position. If you add new branching content to a deploy module that assigns ids this way, either keep the "chain every call to the previous one" pattern going, or switch to reading the real id back via `m.readEventArgument(call, "SomeCreatedEvent", "someId", {...})` (already used for `aiConfigIds` in the same file) instead of guessing it.

## Dating Cross-Agent Documents

Any document or set of instructions written for another agent to consume (e.g. a frontend-integration handoff doc, a migration guide) must include the date it was written, near the top. These documents describe contract state at a point in time and go stale as the contracts evolve — a reader needs the date to judge whether the content is still current.

## Rules Sync

Rules are maintained in two places — keep them in sync:

- **Claude Code**: `CLAUDE.md` (this file)
- **Cursor**: `.cursor/rules/*.mdc`

When adding, changing, or removing a rule in one tool, apply the equivalent change in the other. Each Cursor rule maps to a section in `CLAUDE.md` with the same intent.

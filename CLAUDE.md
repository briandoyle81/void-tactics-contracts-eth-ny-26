# Void Tactics Contracts

## Contract Size Limits

You are **never** allowed to turn on or enable "ignore contract size" (or equivalent) for compilation.

- Do **not** add or set options that skip or ignore contract size checks (e.g. in Hardhat, Solidity config, or contract-sizer).
- Do **not** suggest disabling or bypassing the 24 KiB deployment / 24 KiB init size limits.
- If contracts exceed size limits, reduce size by refactoring, libraries, or optimizer settings — do not disable the check.

This applies to any config that would ignore or suppress contract size warnings/errors (e.g. `ignoreContractSizeLimit`, `ignoreSizeLimit`, or similar).

## Rules Sync

Rules are maintained in two places — keep them in sync:

- **Claude Code**: `CLAUDE.md` (this file)
- **Cursor**: `.cursor/rules/*.mdc`

When adding, changing, or removing a rule in one tool, apply the equivalent change in the other. Each Cursor rule maps to a section in `CLAUDE.md` with the same intent.

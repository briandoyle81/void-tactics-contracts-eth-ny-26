#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./ignition-deploy-retry.sh --network <network-name> [--deploy-script <path/to/Module.ts>]

If --deploy-script is omitted, every module in ignition/modules/*.ts is deployed
(in alphabetical order), each with its own retry loop. Paths are resolved from
the repo root.

Options:
  --deploy-script <p> Deploy a single module. If omitted, deploy all modules.
  --skip-verify        Do not pass `--verify` to hardhat ignition deploy
  --no-auto-confirm   Do not auto-answer "y" to any deploy confirmation prompts
  --sleep-seconds <n> Sleep seconds between retries on transient errors (see retry conditions below)

Environment variables:
  LOG_FILE            Log file to write (default: ignition_deploy_retry.log)
  SLEEP_SECONDS      Sleep seconds between retries (default: 5)
EOF
}

NETWORK=""
DEPLOY_SCRIPT=""
VERIFY=1
AUTO_CONFIRM=1
SLEEP_SECONDS_DEFAULT="5"

LOG_FILE="${LOG_FILE:-ignition_deploy_retry.log}"
SLEEP_SECONDS="${SLEEP_SECONDS:-$SLEEP_SECONDS_DEFAULT}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --network)
      NETWORK="${2:-}"
      shift 2
      ;;
    --deploy-script)
      DEPLOY_SCRIPT="${2:-}"
      shift 2
      ;;
    --skip-verify)
      VERIFY=0
      shift 1
      ;;
    --no-auto-confirm)
      AUTO_CONFIRM=0
      shift 1
      ;;
    --sleep-seconds)
      SLEEP_SECONDS="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$NETWORK" ]]; then
  usage >&2
  exit 2
fi

# Run from the repo root so module paths and the Ignition deployment dir resolve
# consistently regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Deploy a single module with an automatic retry loop on transient errors.
# Returns 0 on success, or the deploy command's exit code on a non-retryable error.
deploy_with_retry() {
  local script="$1"
  local CMD=(npx hardhat ignition deploy "$script" --network "$NETWORK")
  if [[ "$VERIFY" -eq 1 ]]; then
    CMD+=(--verify)
  fi

  while true; do
    : > "$LOG_FILE"
    echo "--- deploy $script retry $(date) ---"

    # Run and stream output to log; capture the deploy command exit code from bash's PIPESTATUS.
    set +e
    if [[ "$AUTO_CONFIRM" -eq 1 ]]; then
      # Hardhat Ignition may ask for an interactive confirmation (e.g. "Confirm deploy to network ... (y/N)").
      # Feed "y" continuously so retries never require human interaction.
      "${CMD[@]}" < <(yes) 2>&1 | tee "$LOG_FILE"
    else
      "${CMD[@]}" 2>&1 | tee "$LOG_FILE"
    fi
    local ec="${PIPESTATUS[0]}"
    set -e

    if [[ "$ec" -eq 0 ]]; then
      echo "SUCCESS: $script"
      return 0
    fi

    # Retry on transient errors: nonce mismatch, Ignition rerun hint, underpriced gas, or IGN411
    # without the "use a block explorer" hint (that case needs track-tx or ignition wipe, not a blind retry).
    set +e
    python3 -c '
import pathlib, sys
p = pathlib.Path("'"$LOG_FILE"'")
s = p.read_text(errors="ignore")
explorer_hint = "Please use a block explorer" in s
retry_ign411 = "IGN411" in s and not explorer_hint
retry = (
    "The next nonce" in s
    or "Please try rerunning Hardhat Ignition." in s
    or retry_ign411
    or "transaction underpriced" in s
)
sys.exit(0 if retry else 1)
'
    local retryable=$?
    set -e

    if [[ "$retryable" -eq 0 ]]; then
      echo "Retrying $script due to transient deploy error..."
      sleep "$SLEEP_SECONDS"
      continue
    fi

    echo "Stopping due to non-retryable error in $script (exit code: $ec)"
    return "$ec"
  done
}

if [[ -n "$DEPLOY_SCRIPT" ]]; then
  deploy_with_retry "$DEPLOY_SCRIPT" || exit $?
  exit 0
fi

# No --deploy-script provided: deploy every module in ignition/modules.
shopt -s nullglob
MODULES=(ignition/modules/*.ts)
shopt -u nullglob

if [[ ${#MODULES[@]} -eq 0 ]]; then
  echo "No modules found in ignition/modules/*.ts" >&2
  exit 1
fi

echo "Deploying all modules:"
printf '  %s\n' "${MODULES[@]}"

for module in "${MODULES[@]}"; do
  deploy_with_retry "$module" || {
    ec=$?
    echo "Aborting: $module failed (exit code: $ec)"
    exit "$ec"
  }
done

echo "ALL MODULES DEPLOYED"

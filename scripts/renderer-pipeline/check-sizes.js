const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const { revectorizeOne } = require("./vectorize");
const { loadManifest, flattenLeaves } = require("./lib/manifest");
const { loadPsd, findLayerByName } = require("./lib/psd");
const { BANDS } = require("./lib/tiers");

// Deployed-bytecode budget per leaf. Deliberately under the hard 24576-byte
// EIP-170 cap (see CLAUDE.md -- that cap itself must never be bypassed).
// Several real deployed leaves sit at 95-99.6% of the cap (RenderArmor3:
// 24484/24576), so a much more conservative working budget leaves real
// detail on the table for no reason -- this only needs enough margin to
// tolerate solc/optimizer version drift, not the multi-KB cushion an
// earlier version of this pipeline used.
const DEFAULT_BUDGET_BYTES = 24300;

function runScript(scriptFile, args) {
  execFileSync("node", [path.join(__dirname, "..", scriptFile), ...args], {
    stdio: "inherit",
  });
}

function readDeployedSize(manifest, contractName) {
  const relOutputDir = path.relative(manifest._repoRoot, manifest._outputDir);
  const artifactPath = path.join(
    manifest._repoRoot,
    "artifacts",
    relOutputDir,
    `${contractName}.sol`,
    `${contractName}.json`
  );
  if (!fs.existsSync(artifactPath)) return null;
  const artifact = JSON.parse(fs.readFileSync(artifactPath, "utf8"));
  return (artifact.deployedBytecode.length - 2) / 2;
}

// hardhat-contract-sizer runs in strict mode (see hardhat.config.ts) and
// exits non-zero whenever anything in the whole project is oversized --
// including, deliberately, contracts we haven't fixed yet mid-search. solc
// compilation itself (and artifact writing) still succeeds either way, so
// that exit code is not a real failure here; never work around the size
// check itself, only react to what it reports.
// cleanFirst forces `hardhat clean` before compiling -- found necessary the
// hard way: mid-search incremental compiles occasionally returned a STALE
// artifact for a leaf whose only change was to a shared imported file
// (RenderUtils.sol), reporting a smaller size than the config actually
// compiles to, letting an over-budget config slip through the search
// undetected until a later from-scratch compile caught it. Cheap enough to
// always do on the one compile whose result actually gets reported/relied
// on (the post-finalize verification); the many per-round probe compiles
// during the search itself stay incremental for speed, since a probe that
// slips through gets caught by this final check anyway.
function compile(repoRoot, { cleanFirst = false } = {}) {
  try {
    if (cleanFirst) {
      execFileSync("npx", ["hardhat", "clean"], { cwd: repoRoot, stdio: "inherit" });
    }
    execFileSync("npx", ["hardhat", "compile"], { cwd: repoRoot, stdio: "inherit" });
  } catch (err) {
    // expected while any leaf is still over budget; artifacts are still written
  }
}

async function regenerateAndSplit(manifest, psd, leaf, config, utilsImport, blendFn) {
  await revectorizeOne(psd, manifest, leaf, config);
  const filePath = path.join(manifest._outputDir, `${leaf.contractName}.sol`);
  runScript("convertColors.js", [`--file=${filePath}`]);
  runScript("splitSvgStrings.js", [
    `--file=${filePath}`,
    `--utilsImport=${utilsImport}`,
    `--blendFn=${blendFn}`,
  ]);
}

// Per-leaf state machine: within the current band, "check-max" tests the
// band's most aggressive setting first (confirming there's something in
// this band worth searching, and establishing the precondition a leftmost
// -true binary search needs); "searching" then binary-searches down to the
// most detailed setting in that band that still fits. Falls through to the
// next (coarser) band only when the current band's most aggressive setting
// still doesn't fit.
function initLeafState() {
  return {
    bandIdx: 0,
    phase: "check-max",
    lo: 0,
    hi: null,
    bestInBand: null,
    probe: null,
    done: false,
    ok: null,
  };
}

function advanceBand(s) {
  s.bandIdx += 1;
  s.bestInBand = null;
  if (s.bandIdx >= BANDS.length) {
    s.done = true;
    s.ok = false;
    s.bandIdx = BANDS.length - 1;
    s.finalLevel = BANDS[s.bandIdx].length - 1;
  } else {
    s.phase = "check-max";
  }
}

function nextProbe(s) {
  const band = BANDS[s.bandIdx];
  if (s.phase === "check-max") {
    s.probe = band.length - 1;
  } else {
    s.probe = Math.floor((s.lo + s.hi) / 2);
  }
  return band[s.probe];
}

function applyResult(s, fits) {
  const band = BANDS[s.bandIdx];
  if (s.phase === "check-max") {
    if (fits) {
      s.bestInBand = s.probe;
      s.lo = 0;
      s.hi = band.length - 1;
      s.phase = "searching";
      if (s.lo >= s.hi) {
        s.done = true;
        s.ok = true;
        s.finalLevel = s.bestInBand;
      }
    } else {
      advanceBand(s);
    }
    return;
  }

  // phase === "searching"
  if (fits) {
    s.bestInBand = s.probe;
    s.hi = s.probe;
  } else {
    s.lo = s.probe + 1;
  }
  if (s.lo >= s.hi) {
    s.done = true;
    s.ok = true;
    s.finalLevel = s.bestInBand;
  }
}

async function checkAndFitSizes(
  manifestPath,
  { budgetBytes = DEFAULT_BUDGET_BYTES, brightness = 0, blendFn = "blendHSL" } = {}
) {
  const manifest = loadManifest(manifestPath);
  const utilsImport = "../Renderers/RenderUtils.sol";
  const psd = loadPsd(manifest._psdPath);

  // Filter down to leaves that actually have a PSD layer -- mirrors
  // extractAll's semantics (extract.js): missing optional leaves (e.g. a
  // not-yet-drawn "perfect ship" fore variant) are warned about and
  // skipped rather than probed, since revectorizeOne would just return
  // null and never write a file for them.
  const allLeaves = flattenLeaves(manifest);
  const missing = [];
  const leaves = allLeaves.filter((leaf) => {
    const found = findLayerByName(psd.children, leaf.psdLayerName);
    if (found) return true;
    if (leaf.required === false) {
      console.warn(`[check-sizes] optional layer "${leaf.psdLayerName}" not found, skipping`);
      return false;
    }
    missing.push(leaf.psdLayerName);
    return false;
  });
  if (missing.length) {
    throw new Error(`Missing required PSD layers in ${manifest.psdFile}: ${missing.join(", ")}`);
  }

  const state = {};
  for (const leaf of leaves) state[leaf.contractName] = initLeafState();

  const maxRounds = BANDS.length * (Math.ceil(Math.log2(BANDS[0].length)) + 2);
  for (let round = 1; round <= maxRounds; round++) {
    const active = leaves.filter((leaf) => !state[leaf.contractName].done);
    if (active.length === 0) break;

    console.log(
      `[check-sizes] round ${round}: probing ${active.length} leaf(es) (${leaves.length - active.length} converged)`
    );
    for (const leaf of active) {
      const s = state[leaf.contractName];
      const config = nextProbe(s);
      await regenerateAndSplit(manifest, psd, leaf, config, utilsImport, blendFn);
    }
    compile(manifest._repoRoot);

    for (const leaf of active) {
      const s = state[leaf.contractName];
      const size = readDeployedSize(manifest, leaf.contractName);
      const fits = size !== null && size <= budgetBytes;
      applyResult(s, fits);
    }
  }

  // Finalize: regenerate every leaf at its best-known-fitting level (or the
  // last band's most aggressive level as a last resort if nothing fit), so
  // the files on disk always match what gets reported -- the search above
  // can leave a leaf's last-written probe at a level that didn't fit.
  // brightness is merged in only here, not during the search: it changes
  // fill color values but never hex-string length, so it can't affect
  // which band/level fits and doesn't need to be part of the search itself.
  for (const leaf of leaves) {
    const s = state[leaf.contractName];
    const finalConfig = BANDS[s.bandIdx][s.finalLevel ?? s.bestInBand ?? BANDS[s.bandIdx].length - 1];
    await regenerateAndSplit(
      manifest,
      psd,
      leaf,
      { ...finalConfig, brightness },
      utilsImport,
      blendFn
    );
  }
  compile(manifest._repoRoot, { cleanFirst: true });

  const report = [];
  for (const leaf of leaves) {
    const s = state[leaf.contractName];
    const size = readDeployedSize(manifest, leaf.contractName);
    if (size === null) continue;
    report.push({
      contractName: leaf.contractName,
      size,
      band: s.bandIdx,
      level: s.finalLevel ?? s.bestInBand,
      ok: size <= budgetBytes,
    });
  }
  report.sort((a, b) => b.size - a.size);

  console.log("\n[check-sizes] final report:");
  for (const r of report) {
    const status = r.ok ? "OK" : "STILL OVER -- needs manual art simplification";
    console.log(
      `  ${r.contractName.padEnd(30)} ${r.size} bytes  band ${r.band} (k=${BANDS[r.band][0].k}) level ${r.level}  ${status}`
    );
  }

  const failing = report.filter((r) => !r.ok);
  return { report, failing };
}

function main() {
  const manifestPath = process.argv[2];
  if (!manifestPath) {
    console.error(
      "Usage: node check-sizes.js <manifest.json> [--brightness=15] [--blendFn=blendHSLV2]"
    );
    process.exit(1);
  }
  const brightnessArg = process.argv.find((a) => a.startsWith("--brightness="));
  const brightness = brightnessArg ? Number(brightnessArg.slice("--brightness=".length)) : 0;
  const blendFnArg = process.argv.find((a) => a.startsWith("--blendFn="));
  const blendFn = blendFnArg ? blendFnArg.slice("--blendFn=".length) : "blendHSL";
  checkAndFitSizes(manifestPath, { brightness, blendFn }).then(({ failing }) => {
    if (failing.length) {
      console.error(
        `\n[check-sizes] ${failing.length} leaf(es) still exceed budget even at the most aggressive detail level -- needs manual art simplification (per CLAUDE.md, never bypass the size check).`
      );
      process.exit(1);
    }
  });
}

if (require.main === module) {
  main();
}

module.exports = { checkAndFitSizes };

const fs = require("fs");
const path = require("path");
const { PNG } = require("pngjs");
const { loadPsd, extractLayer } = require("./lib/psd");
const { loadManifest, flattenLeaves } = require("./lib/manifest");

// Extracts every leaf named in the manifest from its PSD file, regardless
// of which single variant happens to be visible per group in the source
// file. Returns a Map<contractName, { width, height, data, leaf }>.
function extractAll(manifestPath, { debugPngDir, extractOverrides = {} } = {}) {
  const manifest = loadManifest(manifestPath);
  const psd = loadPsd(manifest._psdPath);
  const leaves = flattenLeaves(manifest);

  const results = new Map();
  const missing = [];

  for (const leaf of leaves) {
    const extracted = extractLayer(
      psd,
      leaf.psdLayerName,
      manifest.canvasSize,
      extractOverrides[leaf.contractName]
    );
    if (!extracted) {
      if (leaf.required !== false) {
        missing.push(leaf.psdLayerName);
      } else {
        console.warn(
          `[extract] optional layer "${leaf.psdLayerName}" not found in ${manifest.psdFile}, skipping`
        );
      }
      continue;
    }
    results.set(leaf.contractName, { ...extracted, leaf });

    if (debugPngDir) {
      fs.mkdirSync(debugPngDir, { recursive: true });
      const png = new PNG({ width: extracted.width, height: extracted.height });
      png.data.set(extracted.data);
      png
        .pack()
        .pipe(fs.createWriteStream(path.join(debugPngDir, `${leaf.contractName}.png`)));
    }
  }

  if (missing.length) {
    throw new Error(
      `Missing required PSD layers in ${manifest.psdFile}: ${missing.join(", ")}`
    );
  }

  console.log(`[extract] extracted ${results.size} layers from ${manifest.psdFile}`);
  return { manifest, psd, leaves, results };
}

// Re-extracts a single leaf from an already-loaded psd, e.g. for the
// size-fit escalation loop, without re-parsing the whole PSD file each time.
function extractOne(psd, manifest, leaf, extractOpts) {
  return extractLayer(psd, leaf.psdLayerName, manifest.canvasSize, extractOpts);
}

function main() {
  const manifestPath = process.argv[2];
  const debugPngDir = process.argv[3];
  if (!manifestPath) {
    console.error("Usage: node extract.js <manifest.json> [debugPngDir]");
    process.exit(1);
  }
  extractAll(manifestPath, { debugPngDir });
}

if (require.main === module) {
  main();
}

module.exports = { extractAll, extractOne };

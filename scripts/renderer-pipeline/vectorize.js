const fs = require("fs");
const path = require("path");
const { extractAll, extractOne } = require("./extract");
const { vectorizeLayerFragment } = require("./lib/vtrace");
const { BANDS } = require("./lib/tiers");
const { loadManifest } = require("./lib/manifest");

// Traces a layer's full palette (one potrace call per palette color, see
// lib/vtrace.js) and returns the SVG fragment in the "legacy" pre-split
// shape: plain <path> elements with inline hex fills, exactly what
// splitSvgStrings.js expects as input.
async function vectorizeLeaf(layer, traceConfig) {
  return vectorizeLayerFragment(layer, traceConfig);
}

function contractSource(contractName, svgBody, typesImport) {
  return (
    `// SPDX-License-Identifier: UNLICENSED\n` +
    `pragma solidity ^0.8.28;\n\n` +
    `import "${typesImport}";\n\n` +
    `contract ${contractName} {\n` +
    `    string private constant SVG = '${svgBody}';\n` +
    `}\n`
  );
}

function writeContract(manifest, contractName, svgBody) {
  const src = contractSource(contractName, svgBody, manifest.typesImport || "../Types.sol");
  const outPath = path.join(manifest._outputDir, `${contractName}.sol`);
  fs.mkdirSync(manifest._outputDir, { recursive: true });
  fs.writeFileSync(outPath, src);
  return outPath;
}

// Vectorizes every leaf at a given detail level (default: BANDS[0][0], the
// first (largest-k) band's mildest/most-detailed config). Returns the
// extraction results too so callers (e.g. the size-fit binary search) can
// re-vectorize individual leaves at a different level without re-parsing
// the PSD.
async function vectorizeAll(manifestPath, { level = BANDS[0][0] } = {}) {
  const { manifest, psd, results } = extractAll(manifestPath);
  const written = [];
  for (const [contractName, layer] of results) {
    const svgBody = await vectorizeLeaf(layer, level);
    const outPath = writeContract(manifest, contractName, svgBody);
    written.push(outPath);
    console.log(`[vectorize] ${contractName}: ${svgBody.length} svg chars -> ${outPath}`);
  }
  return { manifest, psd, results, written };
}

// Re-vectorizes a single leaf from an already-loaded psd at a given detail
// level, for the size-fit binary search -- avoids re-parsing the whole PSD
// file per probe.
async function revectorizeOne(psd, manifest, leaf, level) {
  const layer = extractOne(psd, manifest, leaf);
  if (!layer) return null;
  const svgBody = await vectorizeLeaf(layer, level);
  const outPath = writeContract(manifest, leaf.contractName, svgBody);
  return { outPath, svgBody, layer };
}

function main() {
  const manifestPath = process.argv[2];
  if (!manifestPath) {
    console.error("Usage: node vectorize.js <manifest.json>");
    process.exit(1);
  }
  vectorizeAll(manifestPath);
}

if (require.main === module) {
  main();
}

module.exports = {
  vectorizeAll,
  vectorizeLeaf,
  revectorizeOne,
  writeContract,
  contractSource,
};

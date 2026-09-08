const fs = require("fs");
const path = require("path");

function loadManifest(manifestPath) {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const repoRoot = path.join(__dirname, "..", "..", "..");
  manifest._repoRoot = repoRoot;
  manifest._psdPath = path.isAbsolute(manifest.psdFile)
    ? manifest.psdFile
    : path.join(repoRoot, manifest.psdFile);
  manifest._outputDir = path.isAbsolute(manifest.outputDir)
    ? manifest.outputDir
    : path.join(repoRoot, manifest.outputDir);
  return manifest;
}

// Flattens every leaf across all categories (including body's
// base/shields/armor split) into one list, each tagged with its category
// and, for body, its subcategory.
function flattenLeaves(manifest) {
  const leaves = [];
  for (const [category, catDef] of Object.entries(manifest.categories)) {
    if (category === "body") {
      leaves.push({ category, subcategory: "base", ...catDef.base });
      for (const l of catDef.shields) {
        leaves.push({ category, subcategory: "shields", ...l });
      }
      for (const l of catDef.armor) {
        leaves.push({ category, subcategory: "armor", ...l });
      }
    } else {
      for (const l of catDef.leaves) {
        leaves.push({ category, ...l });
      }
    }
  }
  return leaves;
}

module.exports = { loadManifest, flattenLeaves };

import hre from "hardhat";
import fs from "fs";
import path from "path";
import { loadPsd, extractLayer } from "../scripts/renderer-pipeline/lib/psd";
import { vectorizeLayerFragment } from "../scripts/renderer-pipeline/lib/vtrace";

const repoRoot = path.join(__dirname, "..");
const outDir = path.join(repoRoot, "contracts", "MedalSweep");
fs.mkdirSync(outDir, { recursive: true });

const CONFIGS: { k: number; epsilon: number }[] = [];
for (const k of [45, 24, 14, 10, 7, 5, 3]) {
  for (const epsilon of [2, 4, 6, 8, 12, 16, 24]) {
    CONFIGS.push({ k, epsilon });
  }
}

function contractName(k: number, epsilon: number) {
  return `MedalSweep_k${k}_e${String(epsilon).replace(".", "_")}`;
}

async function main() {
  const psd = loadPsd(path.join(repoRoot, "shattered-hive-medal.psd"));
  const layer = extractLayer(psd, "shattered-hive", 256);

  const results: { k: number; epsilon: number; name: string; chars: number }[] = [];
  for (const { k, epsilon } of CONFIGS) {
    const name = contractName(k, epsilon);
    const svgBody = await vectorizeLayerFragment(layer as any, { k, epsilon });
    const src =
      `// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.28;\n\n` +
      `contract ${name} {\n` +
      `    function getSVG() external pure returns (string memory) {\n` +
      `        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">${svgBody}</svg>';\n` +
      `    }\n}\n`;
    fs.writeFileSync(path.join(outDir, `${name}.sol`), src);
    results.push({ k, epsilon, name, chars: svgBody.length });
    console.log(`traced ${name}: ${svgBody.length} chars`);
  }

  console.log("compiling...");
  try {
    await hre.run("compile");
  } catch (e) {
    // expected while any config is oversized; artifacts are still written
  }

  console.log("\nresults:");
  for (const r of results) {
    const artifactPath = path.join(repoRoot, "artifacts/contracts/MedalSweep", `${r.name}.sol`, `${r.name}.json`);
    let bytes: number | null = null;
    if (fs.existsSync(artifactPath)) {
      const art = JSON.parse(fs.readFileSync(artifactPath, "utf8"));
      bytes = (art.deployedBytecode.length - 2) / 2;
    }
    const status = bytes && bytes <= 24300 ? "OK" : bytes ? "OVER" : "?";
    console.log(`k=${r.k} eps=${r.epsilon}: ${r.chars} chars -> ${bytes} bytes ${status}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

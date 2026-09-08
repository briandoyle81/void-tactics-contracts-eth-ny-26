import fs from "fs";
import path from "path";
import { Resvg } from "@resvg/resvg-js";
import { loadPsd, extractLayer } from "../scripts/renderer-pipeline/lib/psd";
import { vectorizeLayerFragment } from "../scripts/renderer-pipeline/lib/vtrace";

const repoRoot = path.join(__dirname, "..");
const outDir = "/private/tmp/claude-501/-Users-briandoyle-void-tactics-contracts-eth-ny-26/d7ff2b7d-7241-4f30-bec2-dc23879cebd3/scratchpad/medal-candidates";
fs.mkdirSync(outDir, { recursive: true });

const CANDIDATES = [
  { k: 14, epsilon: 2 },
  { k: 14, epsilon: 4 },
  { k: 7, epsilon: 2 },
];

async function main() {
  const psd = loadPsd(path.join(repoRoot, "shattered-hive-medal.psd"));
  const layer = extractLayer(psd, "shattered-hive", 256);

  for (const { k, epsilon } of CANDIDATES) {
    const svgBody = await vectorizeLayerFragment(layer as any, { k, epsilon });
    const fullSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">${svgBody}</svg>`;
    const resvg = new Resvg(fullSvg);
    const png = resvg.render();
    const name = `medal-k${k}-e${epsilon}`;
    fs.writeFileSync(path.join(outDir, `${name}.png`), png.asPng());
    console.log(`${name}: ${svgBody.length} chars`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

import fs from "fs";
import path from "path";
import { createCanvas, loadImage } from "canvas";
import { Resvg } from "@resvg/resvg-js";
import { vectorizeLayerFragment } from "../scripts/renderer-pipeline/lib/vtrace";

// Same pipeline as scratch/render-medal-v3.ts (potrace stacked masks +
// farthest-point k-means), but against the new simpler claw-medallion PNG
// the user supplied to replace the "shattered debris"-looking
// shattered-hive-medal.psd source, instead of extracting a PSD layer.
const SOURCE_PNG =
  "/Users/briandoyle/.claude/image-cache/b4088d36-823a-431a-aecf-0d92c2648501/1.png";
const outDir = path.join(
  "/private/tmp/claude-501/-Users-briandoyle-void-tactics-contracts-eth-ny-26/b4088d36-823a-431a-aecf-0d92c2648501/scratchpad/medal-candidates",
);
fs.mkdirSync(outDir, { recursive: true });

const CANVAS_SIZE = 256;

const CANDIDATES = [
  { k: 5, epsilon: 2 },
  { k: 5, epsilon: 3 },
  { k: 7, epsilon: 2 },
  { k: 7, epsilon: 3 },
];

async function loadFlatLayer(pngPath: string, size: number) {
  const img = await loadImage(pngPath);
  const canvas = createCanvas(size, size);
  const ctx = canvas.getContext("2d");
  ctx.drawImage(img, 0, 0, size, size);
  const imageData = ctx.getImageData(0, 0, size, size);
  return { data: imageData.data, width: size, height: size };
}

async function main() {
  const layer = await loadFlatLayer(SOURCE_PNG, CANVAS_SIZE);

  for (const { k, epsilon } of CANDIDATES) {
    const svgBody = await vectorizeLayerFragment(layer as any, { k, epsilon });
    const fullSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="${CANVAS_SIZE}" height="${CANVAS_SIZE}" viewBox="0 0 ${CANVAS_SIZE} ${CANVAS_SIZE}">${svgBody}</svg>`;
    const resvg = new Resvg(fullSvg);
    const png = resvg.render();
    const name = `medal-claw-k${k}-e${epsilon}`;
    fs.writeFileSync(path.join(outDir, `${name}.png`), png.asPng());
    fs.writeFileSync(path.join(outDir, `${name}.svg`), fullSvg);
    console.log(`${name}: ${svgBody.length} chars`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

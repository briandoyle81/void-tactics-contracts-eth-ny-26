const fs = require("fs");
const { readPsd, initializeCanvas } = require("ag-psd");
const { createCanvas } = require("canvas");

let canvasInitialized = false;
function ensureCanvas() {
  if (!canvasInitialized) {
    initializeCanvas((w, h) => createCanvas(w, h));
    canvasInitialized = true;
  }
}

function findLayerByName(children, name) {
  if (!children) return null;
  for (const layer of children) {
    if (layer.name === name) return layer;
    if (layer.children) {
      const found = findLayerByName(layer.children, name);
      if (found) return found;
    }
  }
  return null;
}

function loadPsd(psdPath) {
  ensureCanvas();
  const buf = fs.readFileSync(psdPath);
  // Read full layer pixel data for every layer regardless of its visibility
  // flag -- only one variant per trait group is "visible" at a time in the
  // source file, but every variant's pixels are still stored in the PSD.
  return readPsd(buf, { skipThumbnail: true });
}

// Alpha-thresholds edges to fully on/off so downstream tracing gets a clean
// boundary instead of a soft/antialiased one. Color reduction itself is
// left entirely to vtracer (see lib/vtrace.js) -- an earlier version of
// this pipeline also hand-rolled palette quantization plus a blur pass to
// fight per-pixel shading noise, but blurring before quantizing smeared
// away real linework (panel seams, rivets) along with the noise. vtracer's
// hierarchical color clustering handles the same problem correctly because
// it clusters by color similarity across the whole image rather than
// spatial blur, so it preserves edges instead of eroding them.
function alphaThreshold(imageData, threshold = 128) {
  const { data, width, height } = imageData;
  const out = Buffer.alloc(data.length);
  for (let i = 0; i < data.length; i += 4) {
    if (data[i + 3] < threshold) continue;
    out[i] = data[i];
    out[i + 1] = data[i + 1];
    out[i + 2] = data[i + 2];
    out[i + 3] = 255;
  }
  return { data: out, width, height };
}

// Composites a single named layer onto a full canvasSize x canvasSize
// transparent canvas at its absolute PSD position (not cropped to the
// layer's own bounding box). Absolute positioning matters: the deployed
// variant-1 leaf contracts bake absolute canvas coordinates directly into
// their path data with no <g transform>, so coordinates traced here must
// already be in that same space.
function extractLayer(psd, layerName, canvasSize, opts) {
  const layer = findLayerByName(psd.children, layerName);
  if (!layer || !layer.canvas) return null;

  const full = createCanvas(canvasSize, canvasSize);
  const ctx = full.getContext("2d");
  ctx.drawImage(layer.canvas, layer.left, layer.top);
  const imageData = ctx.getImageData(0, 0, canvasSize, canvasSize);
  return alphaThreshold(imageData, opts && opts.alphaThreshold);
}

module.exports = { loadPsd, extractLayer, findLayerByName, alphaThreshold };

# Renderer pipeline (written 2026-08-15)

Automates turning a Photoshop file into a fully on-chain SVG rendering
pipeline, matching the shape of the existing hand-built variant-1 pipeline
(`contracts/Renderers/`, `contracts/ImageRenderer.sol`). Built for variant 2
(faction 2), which currently has no art of its own -- see
`docs/faction-2.md` and `contracts/RenderMetadata.sol`'s `imageRendererV2`
field, which today points at a placeholder (variant 1's `ImageRenderer`)
until this pipeline produces something real.

Describes pipeline mechanics as of this date. Re-verify against the current
`contracts/Renderers/` and `scripts/renderer-pipeline/*.js` before relying on
specifics here (byte budgets, tier settings, manifest shape) if much time has
passed.

## Prerequisites

The source PSD's layers must already be raster/painted (not vector shapes),
one canvas-sized layer per trait/equipment/special value, using the same
naming convention as `variant-1-pixel.psd`: kebab-case layer names inside
category groups (`fore`, `aft`, `weapon`, a `mid` group containing
`shield-armor-0` + `armor`/`shields` subgroups, `special`), regardless of
which single layer happens to be visible when the artist last saved the
file -- every layer's pixels are read regardless of its visibility flag.

## Usage

1. Edit `manifest.variant2.json`: set `psdFile` to the real PSD's path
   (relative to repo root), and adjust each `psdLayerName` to match the
   artist's actual layer names if they differ from the convention above.
2. Run the full pipeline (extraction, tracing, hex->hsl conversion,
   PART/COLOR chunking, compile, size-fit escalation):
   ```
   node scripts/renderer-pipeline/check-sizes.js scripts/renderer-pipeline/manifest.variant2.json
   ```
   This writes leaf contracts into `contracts/RenderersV2/`. Any leaf still
   over budget after all simplification tiers is reported, not silently
   left broken or bypassed (per CLAUDE.md, the 24KB cap is never disabled) --
   simplify that specific PSD layer (flatten shading, reduce detail) and
   re-run.
3. Generate the combiner contracts and `ImageRendererV2.sol`:
   ```
   node scripts/renderer-pipeline/gen-combiners.js scripts/renderer-pipeline/manifest.variant2.json ImageRendererV2
   ```
4. Wire the new `ImageRendererV2` into the deploy module
   (`ignition/modules/DeployAndConfig.ts`): deploy the leaves, combiners,
   and `ImageRendererV2` the same way variant 1's are deployed, then pass
   its address as `RenderMetadata`'s second constructor argument (currently
   a placeholder duplicate of `imageRenderer` -- see the comment there).
5. Run `npx hardhat test`, including `test/RendererV2.test.ts` and
   `test/RendererSizes.test.ts`.

## How it works

- `lib/psd.js` -- reads the PSD (`ag-psd` + `canvas`), composites each named
  layer onto the full 256x256 canvas at its absolute position (matching the
  deployed contracts' convention of baking absolute coordinates directly
  into path data, no `<g transform>`), then alpha-thresholds it to a clean
  binary edge. Color reduction is *not* done here -- an earlier version of
  this pipeline hand-rolled palette quantization plus a spatial blur to
  fight per-pixel shading noise in the source art, but blurring before
  quantizing smeared away real linework (panel seams, rivets) along with
  the noise, producing visibly mushy output. That whole approach was
  replaced with vtracer (see below), which clusters by color similarity
  across the image rather than spatial blur, so it preserves edges instead
  of eroding them.
- `lib/palette.js` -- reduces a layer to a small palette (farthest-point
  -seeded k-means -- see below for why) and quantizes each pixel to its
  single nearest palette color, with no dithering.
- `lib/vtrace.js` -- traces the whole already-quantized layer to SVG in
  **one** call via `@neplex/vectorizer` (a native/napi binding of vtracer),
  with `mode: Polygon` (guarantees straight-line-only output, `M`/`L`/`Z`,
  matching every existing deployed leaf contract -- verified: zero curve
  commands in any of them) and `hierarchical: Cutout` (partitions the
  canvas into non-overlapping regions, so a lower layer never pays bytes
  for geometry a layer drawn on top of it ends up completely covering --
  see Round 6 below for why this matters and why Stacked was tried first).
  `colorPrecision` is maxed and `layerDifference` is 0 so vtracer's own
  clustering doesn't second-guess the palette `lib/palette.js` already
  chose; even so it tends to emit somewhat more distinct output colors than
  requested (region-average color computation isn't perfectly stable), so
  same-color regions get merged into one `<path>` per unique output color
  afterward. vtracer emits each path with a `transform="translate(tx,ty)"`;
  this bakes that into the path's own coordinates and drops the attribute,
  matching the deployed no-transform convention, and rounds coordinates to
  integers to shrink the string.
  Getting this right took several rounds past the initial vtracer switch:
  - Round 2: vtracer's curve-fitting knobs (`cornerThreshold`/
    `lengthThreshold`/`spliceThreshold`) were left at values that smooth
    vertices even in Polygon mode. Verified empirically that all three have
    *zero* effect on output size in Polygon mode (identical output across
    their whole range on a test layer) -- so they're pinned at vtracer's
    own defaults now and never touched by a tier.
  - Round 3: escalation was coarsening `colorPrecision` (bits per RGB
    channel for the *initial* color clustering) too early to hit the size
    budget, in only 4 big steps. That does shrink files, but it degrades
    fidelity faster than pushing `layerDifference` (merges
    already-clustered, perceptually-similar colors further) and
    `filterSpeckle` (drops small regions outright) does: verified
    empirically that `colorPrecision: 6` with a much higher
    `layerDifference` reaches similar or smaller output than
    `colorPrecision: 5`, while keeping noticeably more detail -- the
    underlying clustering stays fine, it's just merged harder afterward,
    which reads better than coarsening the clustering itself.
  - Round 4: a fixed list of hand-picked tiers, even a finer one, still
    either overshoots past the size budget (wasting available detail) or
    undershoots (still too big) depending on how a given piece happens to
    land relative to the tier boundaries -- there's no guarantee any
    hand-picked tier sits close to a piece's actual size ceiling.
    `lib/tiers.js` now exposes `BANDS`: one array per `colorPrecision`
    (7 down to 3, most detail first), each a fine `layerDifference` sweep
    (`filterSpeckle` scaled alongside it) that's monotonically
    non-increasing in output size -- verified empirically. `check-sizes.js`
    binary-searches *within* one band at a time for the most detail that
    still fits, only falling through to the next (coarser) band when the
    current band's most aggressive setting still doesn't fit under budget.
    That flat monotonicity matters: an earlier attempt spanned
    `colorPrecision` values in a single flat array and binary-searched that
    directly, but `colorPrecision: 5` at its *lowest* `layerDifference` can
    be a much *bigger* file than `colorPrecision: 6` at its *highest* --
    confirmed empirically, a 15x jump right at the band boundary -- which
    broke the search's monotonicity assumption and threw off convergence
    entirely. Per-band search fixes that, and (at the time) nearly every
    piece converged within the very first (finest, `colorPrecision: 7`)
    band, using the same color precision throughout and only trading
    `layerDifference` per piece for however much that specific piece
    actually needs to fit.
  - Round 5 (the big one): even the recalibrated result above still lost
    real detail compared to the deployed contracts -- inspecting
    `RenderAft2.sol` directly explained why. It has only **7 unique
    colors** but **662 traced subpaths** (real count -- an earlier,
    case-sensitive `M`-only grep undercounted this badly the first time).
    Texture in the source art comes from *complex per-color shape
    boundaries*, not from many distinct colors -- vtracer's own
    hierarchical color clustering fundamentally can't reproduce that. Push
    it toward few colors and it does what a clustering algorithm should:
    finds smooth regions of similar color, i.e. flat blobs. What the
    original art almost certainly did instead is reduce to a small
    *deliberate* palette and then **dither** onto it (classic
    Floyd-Steinberg-style error diffusion, the same technique retro pixel
    art has always used to fake intermediate tones from a limited palette)
    -- which produces exactly "few colors, many small alternating regions"
    directly, by construction, rather than as an emergent property of
    clustering thresholds. The first version of this fix reduced to a
    palette of `k` colors (k-means) and Floyd-Steinberg **dithered** each
    pixel onto it (deliberate error-diffusion noise, the classic trick for
    faking intermediate tones from a limited palette), then traced each
    palette color as its own exact single-color mask.
  - Round 6: that dithered version still didn't match, per direct user
    feedback -- having actually built the original art pipeline by hand in
    Inkscape, they pointed out the real technique traces "one layer per
    color, larger simpler shapes where possible that are covered by the
    layer above," plus manually removing hidden geometry a layer's shape
    didn't need since a later layer covers it anyway. Dithering is the
    opposite of that: it deliberately scatters many small alternating
    single-pixel regions to fake a smooth gradient, where the real
    technique gets a similar-looking result from far fewer, larger
    regions by *simplifying* a layer's shape and letting whatever's drawn
    on top of it clean up the parts that don't need to be exactly right.
    Fixed by dropping dithering entirely: `lib/palette.js` (renamed from
    `lib/dither.js`, since it no longer dithers) now does plain
    nearest-color quantization -- each pixel becomes exactly its nearest
    palette color, no error diffusion -- which on smooth painted shading
    produces contour-like bands rather than noise: large, contiguous
    regions per color, not scattered speckle. Palette seeding also changed
    to farthest-point sampling (each new centroid is whichever pixel is
    farthest, in RGB space, from every centroid picked so far): the
    previous luminance-sorted seeding never once produced an orange
    centroid across a whole k=7-20 sweep, silently dropping a small but
    visually important accent-light color from the palette entirely, since
    it doesn't fall in the same luminance band as anything else large
    enough to seed a cluster on its own. `lib/vtrace.js` also switched from
    tracing each color in isolation (`Hierarchical.Stacked` semantics, one
    full-shape mask per color, no matter how much of it ends up covered by
    another color) to tracing the whole already-quantized image in **one**
    vtracer call with `Hierarchical.Cutout`: Cutout partitions the canvas
    into non-overlapping regions, so a lower layer never pays bytes for
    geometry a layer on top of it ends up completely hiding -- directly
    reproducing the "covered by the layer above" property instead of
    approximating it. (Cutout was tried and rejected earlier in this
    pipeline's history for a different reason -- tracing a raw,
    non-pre-quantized sparse layer directly, it invented a solid-colored
    "background" region hiding what should stay transparent. That bug did
    not reappear once tracing an already-quantized image with explicitly
    zeroed transparent pixels; worth retesting rather than assuming a
    ruled-out approach stays ruled out once the surrounding pipeline has
    changed.) `lib/tiers.js`'s `BANDS` changed shape again to match: one
    array per palette size `k`, each a `filterSpeckle` sweep within that
    `k` (this now has a real effect, unlike in the per-isolated-mask
    dithered version, since vtracer is doing genuine multi-region
    segmentation again). `K_VALUES` was seeded from a survey of the
    actually-deployed leaves' real `COLOR_n` counts (5-15, averaging ~9),
    then pushed higher once that range turned out not to be a ceiling --
    most self-test leaves now land at the search's current max (`k: 20`,
    later widened to 40) with little to no `filterSpeckle` needed at all,
    meaning the earlier revisions were leaving real headroom on the table,
    not just fidelity.
  - Also fixed while chasing this: an unrelated but real inefficiency in
    `lib/vtrace.js` -- it emitted one `<path>` (and, once split, one
    `COLOR_n` constant plus its own `shiny ? blendHSL(...) : COLOR_n`
    ternary, real bytecode, not just string length) *per traced region*,
    not per unique color. A color reused in 90 disconnected spots paid that
    overhead 90 times. Grouping by color first closes that gap, and is
    still done today (vtracer's own region-average color computation isn't
    perfectly stable even against an already-quantized input, so it still
    emits somewhat more distinct output colors than the requested palette
    size).
- `extract.js` / `vectorize.js` -- glue: extract every manifest leaf, trace
  each into a legacy-format `.sol` file (single string constant, inline hex
  fills) -- i.e. reproduce the *pre-split* shape variant 1's leaves had
  before `scripts/splitSvgStrings.js` ran on them (preserved for reference
  in `Renderers_original/`).
- `scripts/convertColors.js` and `scripts/splitSvgStrings.js` (repo root,
  not this directory) are reused with an added `--dir=`/`--file=` CLI
  option -- they already did exactly the hex->hsl conversion and
  `PART_n`/`COLOR_n` chunking this pipeline's output needs, so this
  pipeline generates their expected input shape rather than reimplementing
  that logic. `splitSvgStrings.js`'s final concatenation was also changed
  to fold all parts into one reassigned `result` accumulator instead of a
  flat `string.concat(chunk1..chunkN)` over many chunk variables -- pieces
  with 100+ traced fragments hit "stack too deep" under the old shape, since
  Solidity's compiler struggles once too many named locals are
  simultaneously alive in one function, regardless of how few arguments any
  single `string.concat` call has.
- `check-sizes.js` -- runs the above, compiles, reads real deployed
  bytecode sizes from the Hardhat artifacts, and binary-searches
  `lib/tiers.js`'s `BANDS` per leaf for the most detail that still fits
  (falling through to a coarser band -- fewer palette colors -- only when
  the current one's most aggressive `filterSpeckle` setting doesn't) before
  giving up and flagging it -- mirroring, automated, the manual "Shrink X"
  commits variant 1's leaves needed by hand. All leaves currently searching
  share one compile per round (a round probes one candidate per active
  leaf, then reads every leaf's real size from that single compile) rather
  than compiling once per leaf per probe, so the whole manifest converges
  in roughly `bands x log2(band size)` compiles total regardless of how
  many leaves it has. The per-leaf budget (`DEFAULT_BUDGET_BYTES`) is
  24300 bytes, not a much more conservative number: several real deployed
  leaves already sit at 95-99.6% of the 24576-byte cap (`RenderArmor3`:
  24484/24576), so a large safety cushion just throws away detail the
  original art already spent that budget on -- 24300 leaves ~1% margin for
  solc/optimizer version drift, which is what the margin actually needs to
  cover.
- `gen-combiners.js` -- manifest-driven codegen for the 5 combiner
  contracts and the top-level `ImageRendererV2`, matching the existing
  combiners' `if`/`else` dispatch shape exactly (see
  `contracts/Renderers/RenderWeapon.sol` etc. for the pattern being
  mirrored).

## Validation

The pipeline was run end-to-end against `variant-1-pixel.psd` (variant 1's
real source art) via `manifest.variant1-test.json`, with output compared
against the actually-deployed `contracts/Renderers/*.sol` contracts both by
eye (rasterized with `@resvg/resvg-js` during development -- essential for
judging fidelity changes quickly without round-tripping through a person
each time) and by size. As of the Cutout + plain-quantization rewrite
(Round 6 above), **all 20 of 20 leaves fit the size budget**, including
`flak-array` (a special-effects layer with 5 separate explosion bursts) --
the one leaf every prior revision of this pipeline had to leave flagged.
`K_VALUES` (the palette-size bands to try, most colors first) was widened
twice, first from the survey-derived `[10..3]` to `[20..3]`, then again to
`[40, 32, 26, 20..3]` once 20 *also* turned out not to be a ceiling: **19
of 20 leaves land in the very first band (`k: 40`) and need no
`filterSpeckle` at all**, well under the 24300-byte budget rather than
pushed right up against it -- e.g. `RenderAft2SelfTest` at 18009/24300
bytes, next to the real deployed `RenderAft2.sol` at 23349/24576. That
headroom is a meaningfully different result from every earlier revision,
not just a smaller number: those all had to spend the *entire* size budget
buying back detail one way or another. `flak-array` is the one exception,
needing `k: 3` to fit -- its per-color Solidity overhead (each surviving
color costs a `PART_n`/`COLOR_n` pair and its own `shiny ? blendHSL(...) :
COLOR_n` ternary, real bytecode) turned out to dominate over its actual
traced-geometry size at this piece's particular structure (five separate,
fairly simple radial-gradient bursts spread across a mostly-empty canvas),
a real but not-yet-fully-understood scaling effect worth investigating
further if this piece's fidelity matters enough to revisit -- flagged
here rather than silently accepted. That validation output was moved to
`scratch/renderer-pipeline-selftest-output-v8/` (kept out of `contracts/`
so it doesn't trip the project's strict contract-size check); the `-v1`
through `-v7` siblings in the same `scratch/` directory are earlier,
lower-fidelity attempts kept only as a before/after record and can all be
deleted once no longer useful as a reference.

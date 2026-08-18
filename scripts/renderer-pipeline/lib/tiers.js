// BANDS: one array per palette size `k` (most colors first), each an
// epsilon sweep (monotonically non-decreasing aggressiveness ->
// monotonically non-increasing output size: Douglas-Peucker simplification
// with a larger max-deviation tolerance can only drop more vertices, never
// fewer). check-sizes.js binary-searches *within* one band (one k) at a
// time for the least-aggressive epsilon that still fits, only falling
// through to the next (smaller-k) band when even the most aggressive
// epsilon at the current k still doesn't fit.
//
// K_VALUES was picked from a survey of the actually-deployed variant-1
// leaves' real COLOR_n counts (contracts/Renderers/*.sol): they range
// 5-15, averaging ~9. A first version of this sweep started as high as 40,
// reasoning that nothing requires stopping at the historical average once
// it's cheap to check whether more headroom is available -- but visually,
// going that high hurt rather than helped: farthest-point k-means seeding
// (lib/palette.js) picks each new centroid as whichever pixel is farthest
// from every existing one, so once the real, distinct materials are
// already claimed, the remaining centroids increasingly chase
// antialiasing/blend-edge outlier pixels instead of anything a person
// would call a separate color, reading as mottled/noisy texture and
// fragmenting small accent colors across several near-duplicate clusters.
// lib/palette.js's buildPalette now merges perceptually-near-duplicate
// k-means clusters back together after the fact (mergeSimilarColors), so
// the *final* color count self-limits to however many colors are actually
// distinct regardless of k -- confirmed empirically: k=18 vs k=80 on the
// same layer converges to within 1-2 of the same final count post-merge,
// where pre-merge it would have been 18 vs 80 real (mostly redundant)
// clusters. That makes a high k ceiling safe again (the failure mode it
// caused no longer exists), and it matters because more of the search's
// budget headroom was going unused than expected -- with merging, nearly
// every leaf now lands at band 0's least-aggressive setting well under
// budget, so a higher ceiling lets genuinely complex pieces claim more of
// that headroom as real additional distinct colors instead of leaving it
// on the table.
//
// epsilon is a Douglas-Peucker max-deviation tolerance in source-canvas
// pixels (see lib/vtrace.js's simplifyClosedPolygon), the analog of
// Inkscape's "Optimize" setting. This replaced an earlier design that used
// potrace's own turdSize (speckle-area threshold) as the per-band search
// dimension: turdSize can only delete an entire small traced region
// outright, never simplify a large one's outline, so once a palette is
// large enough that most colors are inherently small textured patches, a
// turdSize big enough to hit budget deleted nearly all of them rather than
// gracefully reducing detail -- confirmed by a visibly near-blank render.
// epsilon degrades gracefully instead: it smooths every subpath's outline
// by a bounded amount rather than an all-or-nothing keep/discard per
// region.
const K_VALUES = [80, 60, 45, 32, 24, 18, 14, 11, 9, 7, 6, 5, 4, 3];

const EPSILON_SWEEP = [0, 0.5, 1, 1.5, 2, 3, 4, 6, 8, 12, 16, 24];

const BANDS = K_VALUES.map((k) => EPSILON_SWEEP.map((epsilon) => ({ k, epsilon })));

module.exports = { BANDS };

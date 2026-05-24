## Why

The geometry analysis, mass properties, shape analysis, shape fix, shape healing, and shape rebuild functions are powerful but opaque. Users need docstrings to understand parameters for operations like point projection, curve intersection, shape distance, volume/area calculation, shape fixing, and NURBS conversion.

## What Changes

- Add docstrings with `Example:` blocks to all public functions across 6 analysis/healing files
- No functional or API changes — documentation only

Files modified: `src/core/geom-algorithms.lisp`, `src/core/mass-properties.lisp`, `src/core/shape-analysis.lisp`, `src/core/shape-fix.lisp`, `src/core/shape-process.lisp`, `src/core/shape-rebuild.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/geom-algorithms.lisp`: 11 functions — `project-point-on-curve`, `project-point-on-surface`, `intersect-curves`, `intersect-curve-surface`, `intersect-surfaces`, `extrema-curve-curve`, `extrema-curve-surface`, `intersect-curves-2d`, `project-point-on-curve-2d`, `points-to-bspline`, `interpolate-points`
- `src/core/mass-properties.lisp`: 5 functions — `shape-gprops`, `shape-volume`, `shape-area`, `shape-center-of-mass`, `shape-inertia`
- `src/core/shape-analysis.lisp`: 7 functions — `shape-distance`, `shape-distance-extrema`, `point-in-solid-p`, `classify-point-in-solid`, `shape-valid-p`, `shape-check`, `intersect-curve-shape`
- `src/core/shape-fix.lisp`: 9 functions — `fix-shape`, `fix-wire`, `fix-solid`, `fix-edge`, `fix-face`, `shape-analysis-free-edges`, `shape-analysis-check-intersections`, `shape-analysis-wire-contains-p`, `shape-analysis-contents`
- `src/core/shape-process.lisp`: 3 functions — `apply-shape-process`, `apply-healing-pipeline`, `heal-shape`
- `src/core/shape-rebuild.lisp`: 6 functions — `substitute-shape`, `shape-to-nurbs`, `shape-reduce-degree`, `shape-to-rational-bspline`, `shape-split-u`, `shape-upgrade-continuity`
- All existing tests should pass unchanged

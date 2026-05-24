## Why

Curves, surfaces, and 2D geometry are the mathematical foundation of 3D modeling in cl-occt. The 3D curve constructors (line, circle, ellipse, bezier, bspline), surface constructors (plane, cylinder, sphere, torus), and 2D helpers are all undocumented.

## What Changes

- Add docstrings with `Example:` blocks to all public functions in `curves.lisp`, `surfaces.lisp`, and `geom2d.lisp`
- Trivial predicates (`curve-p`, `surface-p`, `geom2d-p`) get docstring description without example
- No functional or API changes — documentation only

Files modified: `src/core/curves.lisp`, `src/core/surfaces.lisp`, `src/core/geom2d.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/curves.lisp`: 13 functions — `curve-p`, `curve-type`, `make-line-3d`, `make-circle-3d`, `make-ellipse`, `make-hyperbola`, `make-parabola`, `make-bezier-curve`, `make-bspline-curve`, `make-gc-line`, `make-gc-arc-of-circle`, `convert-curve-to-bspline`, `curve-bounding-box`
- `src/core/surfaces.lisp`: 11 functions — `surface-p`, `surface-type`, `make-plane`, `make-cylindrical-surface`, `make-conical-surface`, `make-spherical-surface`, `make-toroidal-surface`, `make-bezier-surface`, `make-bspline-surface`, `convert-surface-to-bspline`, `surface-bounding-box`
- `src/core/geom2d.lisp`: 6 functions — `geom2d-p`, `make-pnt2d`, `make-vec2d`, `make-dir2d`, `make-line2d`, `make-circle2d`
- All existing tests should pass unchanged

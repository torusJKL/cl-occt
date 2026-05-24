## Why

The mechanical feature construction functions (fillet, chamfer, blend, draft, sweep, loft, shell, pipe, offset, local ops, holes), face filling, helix, assembly hierarchy, STEP/STL I/O, and error handling are all undocumented. Users must read C wrapper source to understand parameters.

## What Changes

- Add docstrings with `Example:` blocks to all public functions across 17 mechanical, assembly, I/O, and feature files
- No functional or API changes — documentation only

Files modified: `src/core/blend.lisp`, `src/core/chamfer.lisp`, `src/core/draft.lisp`, `src/core/fillet.lisp`, `src/core/helix.lisp`, `src/core/shell.lisp`, `src/core/loft.lisp`, `src/core/pipe-feature.lisp`, `src/core/sweep.lisp`, `src/core/offset.lisp`, `src/core/local-ops.lisp`, `src/core/hole-prism-revol.lisp`, `src/core/face-filling.lisp`, `src/core/assembly.lisp`, `src/core/io.lisp`, `src/core/errors.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/fillet.lisp`: 5 functions — `fillet-edge`, `fillet-edges`, `fillet-edge-variable`, `fillet-wire-corner`, `fillet-wire-all-corners`
- `src/core/chamfer.lisp`: 4 functions — `chamfer-edge`, `chamfer-edges`, `chamfer-edge-asymmetric`, `chamfer-edge-on-face`
- `src/core/blend.lisp`: 2 functions — `blend-faces`, `make-blend`
- `src/core/draft.lisp`: 2 functions — `draft-face`, `make-evolved`
- `src/core/sweep.lisp`: 3 functions — `sweep-profile`, `sweep-sections`, `sweep-with-aux-spine`
- `src/core/loft.lisp`: 1 function — `loft-sections`
- `src/core/pipe-feature.lisp`: 1 function — `make-pipe-feature`
- `src/core/shell.lisp`: 1 function — `shell-shape`
- `src/core/offset.lisp`: 2 functions — `offset-shape`, `offset-wire`
- `src/core/local-ops.lisp`: 3 functions — `local-extrude`, `make-groove`, `make-rib`
- `src/core/hole-prism-revol.lisp`: 3 functions — `make-cylindrical-hole`, `make-prism-feature`, `make-revol-feature`
- `src/core/face-filling.lisp`: 2 functions — `fill-face`, `fill-n-sided-face`
- `src/core/helix.lisp`: 2 functions — `make-helix-curve`, `make-helix-edge`
- `src/core/assembly.lisp`: 4 functions — `make-part`, `make-assembly`, `assembly-leaf-p`, `assembly-branch-p`
- `src/core/io.lisp`: 7 functions — `write-step`, `read-step`, `write-stl`, `read-stl`, `parse-color`, `read-step-assembly`, `write-step-assembly`
- `src/core/errors.lisp`: 1 function — `get-error-message`
- All existing tests should pass unchanged

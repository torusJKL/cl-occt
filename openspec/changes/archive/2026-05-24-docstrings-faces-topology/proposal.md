## Why

The `face` construction and `topology` navigation functions are core to using cl-occt, but lack docstrings and examples. Users need to read source code or tests to understand how to create edges, wires, faces, or traverse shape topology.

## What Changes

- Add docstrings with `Example:` blocks to every public function in `faces.lisp` and `topology.lisp`
- No functional or API changes — documentation only

Files modified: `src/core/faces.lisp`, `src/core/topology.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/faces.lisp`: 7 functions — `make-edge`, `make-edge-3d`, `make-circle-edge`, `make-circular-arc`, `make-wire`, `make-face`, `make-face-on-plane`
- `src/core/topology.lisp`: 9 functions — `map-shape-subshapes`, `count-shape-subshapes`, `dump-shape`, `shape-triangle-count`, `wire-order-check-p`, `edge->curve`, `face->surface`, `make-vertex`, `make-polygon`
- All existing tests should pass unchanged

## Why

Without topology navigation (face→edge→vertex graph traversal) and per-subshape properties, an AI agent cannot reason about which faces, edges, or vertices to select for operations like defeaturing, filleting, or chamfering. The existing `map-shape-subshapes` returns flat lists of anonymous shape pointers — the AI gets a bag of parts, not a navigable structure.

## What Changes

- **Topology graph navigation**: C wrappers + CFFI + CLOS for face→edges, edge→vertices, edge→faces, vertex→edges, face→wires, wire→edges
- **Per-subshape properties**: C wrappers + CFFI + CLOS for face area, edge length, face normal at UV, edge curvature type, face surface type, per-subshape bounding box, center point
- **Documentation**: Update `api-reference.md` with all new function signatures

## Capabilities

### New Capabilities

- `subshape-properties`: Per-face (area, normal, center, surface-type, bounding-box) and per-edge (length, curve-type, bounding-box) geometric queries

### Modified Capabilities

- `topology-navigation`: Add face→edge, edge→vertex, edge→face, vertex→edge traversal; face→wire, wire→edge decomposition; subshape orientation queries

## Impact

- **C wrapper** (`wrap/`): ~12 new `extern "C"` functions for topology traversal + ~10 for per-subshape properties
- **CFFI layer** (`src/ffi/`): ~22 new `defcfun` bindings
- **Core layer** (`src/core/`): new `topology-navigation.lisp` (or augment existing `topology.lisp`) with helper functions and property accessors; new `subshape-properties.lisp`
- **Tests** (`tests/`): Graph traversal tests, property query tests, predicate tests
- **Docs** (`doc/api-reference.md`): Topology Navigation and Subshape Properties sections

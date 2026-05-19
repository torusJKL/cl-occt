## Why

Users need to export multiple shapes (e.g., from `defmodel` evaluations) as a single STL file. Currently `write-stl` accepts only one shape at a time, so exporting a multi-part model requires manual stitching or multiple files. A `make-compound` function that collects shapes into a `TopoDS_Compound` solves this naturally — `StlAPI_Writer` already writes compounds as a single mesh.

## What Changes

- **New `make-compound` function**: Accepts a list of shapes, returns a compound shape (or nil).
- **New `add-to-compound` function**: Adds a shape to an existing compound, returns the updated compound.
- **New `compound-shapes` capability** with spec covering compound creation, nil propagation, empty compound, and compound passed to `write-stl`.
- **C wrapper additions**: `make_compound`, `add_to_compound`, `compound_is_empty` using `BRep_Builder` + `TopoDS_Compound`.
- **No changes to existing `write-stl`** — OCCT `StlAPI_Writer` handles compounds transparently.

## Capabilities

### New Capabilities
- `compound-shapes`: Creating OCCT `TopoDS_Compound` shapes from lists of shapes, adding shapes to compounds, and exporting compounds via `write-stl`.

### Modified Capabilities
- *(none — `write-stl` already works with compounds via OCCT internals)*

## Impact

- `wrap/occt_wrap.cpp` — 3 new C functions: `make_compound`, `add_to_compound`, `compound_is_empty`
- `wrap/occt_wrap.h` — declarations for the 3 new functions
- `src/ffi/bindings.lisp` — 3 new `defcfun` bindings
- `src/core/` — new `compounds.lisp` with `make-compound`, `add-to-compound`, `compound-shape-p`
- `src/package.lisp` — export new symbols
- `t/smoke-tests.lisp` — tests for compound creation, nil propagation, write-stl with compound
- No new dependencies.

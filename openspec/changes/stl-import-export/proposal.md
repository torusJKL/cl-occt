## Why

STL is the de facto standard format for 3D printing, mesh-based visualization, and slicing workflows. Adding STL import/export lets cl-occt users output shapes for fabrication and consume external meshes — closing the gap between parametric CAD and additive manufacturing pipelines.

## What Changes

- **C wrapper library**: Add `write_stl` and `read_stl` functions to `libocctwrap.so`, plus tessellation control via `BRepMesh_IncrementalMesh`
- **CL bindings**: `%write-stl`, `%read-stl` CFFI bindings
- **Core Lisp**: `write-stl` and `read-stl` functions in `src/core/io.lisp`, following the same pattern as `write-step` / `read-step`
- **Tessellation quality parameter**: `write-stl` accepts a `:deflection` keyword argument controlling `BRepMesh_IncrementalMesh` linear deflection (lower = finer mesh)
- **Tests**: STL round-trip and quality-parameter tests

## Capabilities

### New Capabilities

- `stl-io`: Export shapes to binary/ASCII STL files and import STL files into shapes, with configurable tessellation quality

### Modified Capabilities

None — existing capabilities unchanged.

## Impact

- `wrap/occt_wrap.cpp`: add 2 new C functions (`write_stl`, `read_stl`) plus mesh helper
- `wrap/occt_wrap.h`: add 2 new declarations
- `src/ffi/bindings.lisp`: add 2 new `defcfun` forms
- `src/core/io.lisp`: add `write-stl` and `read-stl` functions
- `src/package.lisp`: export new symbols from both packages
- `src/dsl/api.lisp`: update `help` to mention STL I/O
- `t/smoke-tests.lisp`: add STL tests (export, round-trip, nil handling, deflection parameter)
- `justfile`: may need to add `TKSTL` and `TKMesh` to link libraries for `wrap` recipe

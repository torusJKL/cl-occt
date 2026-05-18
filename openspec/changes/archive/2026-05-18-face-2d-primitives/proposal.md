## Why

cl-occt currently has no support for 2D geometry or face construction. Parametric CAD workflows frequently require building faces from 2D profiles (sketches) — extruding or revolving planar faces, defining cross-sections for lofts and sweeps, or creating complex boundary-representation (B-rep) models. Adding OCCT's 2D primitives and BRepBuilderAPI face-construction pipeline enables users to build arbitrary planar faces, which unlocks the full potential of the existing extrusion and revolution primitives.

## What Changes

- Add 2D geometric primitives: point, vector, direction, axis, and coordinate types (wrapping `gp_Pnt2d`, `gp_Vec2d`, `gp_Dir2d`, `gp_Ax2d`, `gp_XY`)
- Add 2D curve construction: line, circle, ellipse (wrapping `Geom2d_Line`, `Geom2d_Circle`, `Geom2d_Ellipse`, and `GC_MakeArcOfEllipse`)
- Add edge construction from 2D/3D points or curves (wrapping `BRepBuilderAPI_MakeEdge`)
- Add wire construction from edges (wrapping `BRepBuilderAPI_MakeWire`)
- Add face construction from a wire, with optional planar surface (wrapping `BRepBuilderAPI_MakeFace`)
- Add corresponding C wrapper functions, CFFI bindings, CLOS public API, package exports, and smoke tests for each

## Capabilities

### New Capabilities
- `2d-geometry`: 2D points (pnt2d), vectors (vec2d), directions (dir2d), axes (ax2d), and coordinate pairs (xy)
- `2d-curves`: 2D line, circle, ellipse construction via OCCT Geom2d
- `face-construction`: Edge, wire, and face construction from 2D geometry and curves via BRepBuilderAPI

### Modified Capabilities
- `extrusion`: Existing `make-prism` and `make-revol` gain relevance since users can now construct arbitrary faces as input, but no spec-level requirement changes

## Impact

- **C wrapper** (`wrap/occt_wrap.h`, `wrap/occt_wrap.cpp`): ~12 new `extern "C"` functions following existing error-handling pattern, new OCCT includes for BRepBuilderAPI, gp, Geom2d, GC
- **CFFI bindings** (`src/ffi/bindings.lisp`): ~12 new `defcfun` forms with `%` prefix
- **Core API** (`src/core/`): new file `faces.lisp` for face construction; optionally new file `geom2d.lisp` for 2D primitives/curves
- **Package exports** (`src/package.lisp`): new symbols in both `cl-occt.impl` and `cl-occt`
- **ASDF** (`cl-occt.asd`): register new source files
- **Tests** (`t/smoke-tests.lisp`): ~15-20 new test functions (valid construction + edge cases)
- No breaking API changes

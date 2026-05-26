## Why

Without low-level topology data access — vertex coordinates, edge parameter ranges, face UV bounds, tolerances, deep copy — both human CAD workflows and AI agents are blind to the numeric geometry of shapes. An AI agent can count faces and edges but cannot answer "where is this vertex?" or "what parameter range does this edge span?" or "what is the UV domain of this face surface?". These are the atomic units of geometric reasoning.

## What Changes

- **Vertex point coordinates**: C wrapper + CFFI + core for `BRep_Tool::Pnt(vertex)` → `(x, y, z)`
- **Edge curve with parameter range**: C wrapper + CFFI + core for `BRep_Tool::Curve(edge, first, last)` returning curve + `(first, last)` parameter bounds
- **Face surface with UV bounds**: C wrapper + CFFI + core for `BRep_Tool::Surface(face)` + `BRepAdaptor_Surface` UV domain (Umin, Umax, Vmin, Vmax)
- **Edge/face tolerance**: C wrapper + CFFI + core for `BRep_Tool::Tolerance(shape)` on edges and faces
- **Deep shape copy**: C wrapper + CFFI + core for `BRepBuilderAPI_Copy`
- **Precision constants**: Expose `Precision::Confusion()`, `Precision::Angular()`, `Precision::Intersection()` as Lisp constants or functions
- **Curve evaluation at parameter**: C wrapper + CFFI + core for `Geom_Curve::Value(param)` → `(x, y, z)`
- **Surface evaluation at UV**: C wrapper + CFFI + core for `Geom_Surface::Value(u, v)` → `(x, y, z)`
- **Face natural restriction**: C wrapper + CFFI + core for `BRep_Tool::NaturalRestriction(face)`
- **Shape orientation reversal**: C wrapper + CFFI + core for `TopoDS::Reversed(shape)` and orientation getter/setter
- **Documentation**: Update `doc/api-reference.md` with all new function signatures

## Capabilities

### New Capabilities
- `topology-data-access`: Low-level BRep_Tool queries — vertex point, edge curve+range, face surface+UV bounds, tolerance, natural restriction, orientation reversal
- `geometry-evaluation`: Curve/surface evaluation at parameter/UV, precision constants
- `shape-copy`: Deep shape copy via BRepBuilderAPI_Copy

### Modified Capabilities
- *(no existing capabilities have requirement changes)*

## Impact

- **C wrapper** (`wrap/`): ~15 new `extern "C"` functions in new `wrap/occt_wrap_brep_tool.cpp` + header, plus additions to existing files
- **CFFI layer** (`src/ffi/`): ~15 new `defcfun` bindings
- **Core layer** (`src/core/`): new `topology-data-access.lisp` and `geometry-evaluation.lisp`, extend `topology.lisp` with orientation reversal
- **Tests** (`tests/`): ~70 new tests across all new functions, edge cases (null shapes, invalid params, zero-tolerance queries)
- **Docs** (`doc/api-reference.md`): New sections for Topology Data Access, Geometry Evaluation, Shape Copy, and Precision Constants

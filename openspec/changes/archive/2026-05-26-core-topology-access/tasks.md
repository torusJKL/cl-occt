## 1. C Wrapper — BRep_Tool Data Access

- [x] 1.1 Create `wrap/occt_wrap_brep_tool.h` with declarations for vertex_point, edge_get_curve, face_get_surface, shape_tolerance, face_natural_restriction
- [x] 1.2 Create `wrap/occt_wrap_brep_tool.cpp` with includes for `<BRep_Tool.hxx>`, `<BRepAdaptor_Curve.hxx>`, `<BRepAdaptor_Surface.hxx>`, `<TopExp.hxx>`, `<gp_Pnt.hxx>`
- [x] 1.3 Implement `vertex_point(vertex, out_x, out_y, out_z)` returning coordinates via `BRep_Tool::Pnt`
- [x] 1.4 Implement `edge_get_curve(edge, out_first, out_last)` returning `Geom_Curve` + parameter range via `BRep_Tool::Curve`
- [x] 1.5 Implement `face_get_surface(face, out_umin, out_umax, out_vmin, out_vmax)` returning `Geom_Surface` + UV bounds via `BRep_Tool::Surface` + `BRepAdaptor_Surface`
- [x] 1.6 Implement `shape_tolerance(shape)` returning tolerance via `BRep_Tool::Tolerance`
- [x] 1.7 Implement `face_natural_restriction(face)` returning boolean via `BRep_Tool::NaturalRestriction`
- [x] 1.8 Implement `shape_reversed(shape)` returning reversed shape via `TopoDS::Reversed`
- [x] 1.9 Add error handling: null checks, try/catch, set_error on failure for all functions

## 2. C Wrapper — Geometry Evaluation

- [x] 2.1 Create `wrap/occt_wrap_geom_eval.h` with declarations for curve_value and surface_value
- [x] 2.2 Create `wrap/occt_wrap_geom_eval.cpp` with includes for `<Geom_Curve.hxx>`, `<Geom_Surface.hxx>`, `<gp_Pnt.hxx>`
- [x] 2.3 Implement `curve_value(curve, t, out_x, out_y, out_z)` evaluating point via `Geom_Curve::Value(t)`
- [x] 2.4 Implement `surface_value(surface, u, v, out_x, out_y, out_z)` evaluating point via `Geom_Surface::Value(u, v)`

## 3. C Wrapper — Shape Copy

- [x] 3.1 Create `wrap/occt_wrap_shape_copy.h` with declaration for `shape_copy`
- [x] 3.2 Create `wrap/occt_wrap_shape_copy.cpp` with include for `<BRepBuilderAPI_Copy.hxx>`
- [x] 3.3 Implement `shape_copy(shape)` performing deep copy via `BRepBuilderAPI_Copy`

## 4. C Wrapper — Precision Constants

- [x] 4.1 Create `wrap/occt_wrap_precision.h` with declarations for precision_confusion, precision_angular, precision_intersection
- [x] 4.2 Create `wrap/occt_wrap_precision.cpp` with include for `<Precision.hxx>`
- [x] 4.3 Implement functions returning `Precision::Confusion()`, `Precision::Angular()`, `Precision::Intersection()`

## 5. CFFI Bindings

- [x] 5.1 Create `src/ffi/bindings-brep-tool.lisp` with `defcfun` for `%vertex-point`, `%edge-get-curve`, `%face-get-surface`, `%shape-tolerance`, `%face-natural-restriction`, `%shape-reversed`
- [x] 5.2 Create `src/ffi/bindings-geom-eval.lisp` with `defcfun` for `%curve-value`, `%surface-value`
- [x] 5.3 Create `src/ffi/bindings-shape-copy.lisp` with `defcfun` for `%shape-copy`
- [x] 5.4 Create `src/ffi/bindings-precision.lisp` with `defcfun` for `%precision-confusion`, `%precision-angular`, `%precision-intersection`

## 6. Core CLOS Wrappers — Topology Data Access

- [x] 6.1 Create `src/core/topology-data-access.lisp` with `vertex-point` returning three values (x, y, z), nil on null
- [x] 6.2 Implement `edge-curve-range` returning curve + first + last as multiple values
- [x] 6.3 Implement `edge-curve` (alias returning only curve for convenience)
- [x] 6.4 Implement `face-surface-uv-bounds` returning surface + umin + umax + vmin + vmax
- [x] 6.5 Implement `face-surface` (alias returning only surface for convenience)
- [x] 6.6 Implement `shape-tolerance` returning tolerance value
- [x] 6.7 Implement `face-natural-restriction-p` returning boolean
- [x] 6.8 Implement `reverse-orientation` returning reversed shape
- [x] 6.9 Implement `shape-orientation` returning orientation keyword

## 7. Core CLOS Wrappers — Geometry Evaluation

- [x] 7.1 Create `src/core/geometry-evaluation.lisp` with `curve-value` returning point (x, y, z) at parameter t
- [x] 7.2 Implement `surface-value` returning point (x, y, z) at UV (u, v)
- [x] 7.3 Add precision constants `+precision-confusion+`, `+precision-angular+`, `+precision-intersection+` as defparameters

## 8. Core CLOS Wrappers — Shape Copy

- [x] 8.1 Create `src/core/shape-copy.lisp` with `copy-shape` performing deep copy
- [x] 8.2 Implement nil propagation and type checking

## 9. System Integration

- [x] 9.1 Add new C wrapper `.cpp` files to `wrap/Makefile` compilation
- [x] 9.2 Register new core files in `cl-occt.asd`
- [x] 9.3 Export new public symbols in `src/package.lisp` under `cl-occt` and `cl-occt.impl`
- [x] 9.4 Rebuild `lib/libocctwrap.so` and verify no compilation errors

## 10. Tests

- [x] 10.1 Add vertex-point tests: box vertex coordinates, null vertex
- [x] 10.2 Add edge-curve-range tests: box edge line+range, circular edge, null edge
- [x] 10.3 Add face-surface-uv-bounds tests: box face plane+UV, cylinder face, null face
- [x] 10.4 Add shape-tolerance tests: edge tolerance positive, face tolerance positive
- [x] 10.5 Add face-natural-restriction tests: box face true, trimmed face false
- [x] 10.6 Add reverse-orientation and shape-orientation tests
- [x] 10.7 Add curve-value tests: line, circle, null curve, out-of-range
- [x] 10.8 Add surface-value tests: plane, cylinder, null surface
- [x] 10.9 Add copy-shape tests: independence, geometry preservation, GC independence
- [x] 10.10 Add precision-constants tests: positive values, specific magnitudes
- [x] 10.11 Register all new tests in the test runner

## 11. Documentation

- [x] 11.1 Add "Topology Data Access" section to `doc/api-reference.md` covering vertex-point, edge-curve-range, face-surface-uv-bounds, shape-tolerance, face-natural-restriction-p, reverse-orientation, shape-orientation
- [x] 11.2 Add "Geometry Evaluation" section to `doc/api-reference.md` covering curve-value, surface-value, precision constants
- [x] 11.3 Add "Shape Copy" section to `doc/api-reference.md` covering copy-shape

## 12. Build & Verify

- [x] 12.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 12.2 Run `just test-all` to verify all new and existing tests pass
- [x] 12.3 Fix any compilation or test failures

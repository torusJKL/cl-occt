## 1. C Wrapper — Uniform Point Distribution (GCPnts)

- [x] 1.1 Create `wrap/occt_wrap_gcpnts.h` with declarations for `uniform_abscissa_points` and `uniform_deflection_points`
- [x] 1.2 Create `wrap/occt_wrap_gcpnts.cpp` with includes for `<GCPnts_UniformAbscissa.hxx>`, `<GCPnts_UniformDeflection.hxx>`, `<GeomAdaptor_Curve.hxx>`
- [x] 1.3 Implement `uniform_abscissa_points(curve, first, last, num_points, out_coords)` returning array of (x,y,z) triples
- [x] 1.4 Implement `uniform_deflection_points(curve, first, last, deflection, out_coords)` returning array of (x,y,z) triples
- [x] 1.5 Add error handling: null checks, try/catch, set_error

## 2. C Wrapper — Assembly Location (TopLoc_Location)

- [x] 2.1 Create `wrap/occt_wrap_location.h` with declarations for location creation, compose, invert, shape get/set/move
- [x] 2.2 Create `wrap/occt_wrap_location.cpp` with includes for `<TopLoc_Location.hxx>`, `<gp_Trsf.hxx>`
- [x] 2.3 Implement `location_from_translation(dx, dy, dz)` creating location
- [x] 2.4 Implement `location_multiply(loc1, loc2)` composing locations
- [x] 2.5 Implement `location_inverted(loc)` inverting location
- [x] 2.6 Implement `shape_get_location(shape)` returning location
- [x] 2.7 Implement `shape_moved(shape, loc)` returning new shape at location

## 3. C Wrapper — Edge Finding (BRepLib_FindEdges)

- [x] 3.1 Create `wrap/occt_wrap_find_edges.h` with declarations
- [x] 3.2 Create `wrap/occt_wrap_find_edges.cpp` with includes for `<BRepLib_FindEdges.hxx>`
- [x] 3.3 Implement `find_edges_by_type(shape, curve_type, out_count)` returning edge array
- [x] 3.4 Implement `find_edges_by_radius(shape, radius, out_count)` returning edge array

## 4. C Wrapper — Normal Projection (BRepAlgo_NormalProjection)

- [x] 4.1 Create `wrap/occt_wrap_normal_project.h` with declaration
- [x] 4.2 Create `wrap/occt_wrap_normal_project.cpp` with include for `<BRepAlgo_NormalProjection.hxx>`
- [x] 4.3 Implement `normal_project(shape, face)` projecting shape onto face

## 5. C Wrapper — Transfer Parameters (ShapeAnalysis_TransferParameters)

- [x] 5.1 Create `wrap/occt_wrap_transfer_params.h` with declaration
- [x] 5.2 Create `wrap/occt_wrap_transfer_params.cpp` with include for `<ShapeAnalysis_TransferParameters.hxx>`
- [x] 5.3 Implement `transfer_params(source_edge, target_curve, param)` mapping parameter

## 6. C Wrapper — BREP Native I/O (BRepTools)

- [x] 6.1 Create `wrap/occt_wrap_brep_io.h` with declarations
- [x] 6.2 Create `wrap/occt_wrap_brep_io.cpp` with includes for `<BRepTools.hxx>`
- [x] 6.3 Implement `brep_write_shape(shape, filename)` writing .brep file
- [x] 6.4 Implement `brep_read_shape(filename)` reading .brep file

## 7. C Wrapper — Wedge Primitive (BRepPrimAPI_MakeWedge)

- [x] 7.1 Create `wrap/occt_wrap_wedge.h` with declarations
- [x] 7.2 Create `wrap/occt_wrap_wedge.cpp` with include for `<BRepPrimAPI_MakeWedge.hxx>`
- [x] 7.3 Implement `make_wedge_full(dx, dy, dz, ltx)` for full wedge
- [x] 7.4 Implement `make_wedge_corner(dx, dy, dz, xmin, zmin, xmax, zmax)` for corner wedge

## 8. C Wrapper — Drafted Prism (BRepFeat_MakeDPrism)

- [x] 8.1 Create `wrap/occt_wrap_dprism.h` with declaration
- [x] 8.2 Create `wrap/occt_wrap_dprism.cpp` with include for `<BRepFeat_MakeDPrism.hxx>`
- [x] 8.3 Implement `make_drafted_prism(shape, face, profile, height, angle, operation)` returning new shape

## 9. C Wrapper — Remove Features (BRepAlgoAPI_RemoveFeatures)

- [x] 9.1 Create `wrap/occt_wrap_remove_features.h` with declaration
- [x] 9.2 Create `wrap/occt_wrap_remove_features.cpp` with include for `<BRepAlgoAPI_RemoveFeatures.hxx>`
- [x] 9.3 Implement `remove_features(shape, faces, num_faces)` returning shape without features

## 10. C Wrapper — Fix Small Faces (ShapeFix_FixSmallFace)

- [x] 10.1 Create `wrap/occt_wrap_small_faces.h` with declaration
- [x] 10.2 Create `wrap/occt_wrap_small_faces.cpp` with include for `<ShapeFix_FixSmallFace.hxx>`
- [x] 10.3 Implement `fix_small_faces(shape)` returning fixed shape

## 11. C Wrapper — Shape Tolerance Tools (ShapeFix_ShapeTolerance)

- [x] 11.1 Create `wrap/occt_wrap_shape_tolerance.h` with declarations
- [x] 11.2 Create `wrap/occt_wrap_shape_tolerance.cpp` with include for `<ShapeFix_ShapeTolerance.hxx>`
- [x] 11.3 Implement `set_shape_tolerance(shape, tolerance, shape_type)` setting tolerance on subshapes

## 12. C Wrapper — RWStl

- [x] 12.1 Create `wrap/occt_wrap_rwstl.h` with declarations
- [x] 12.2 Create `wrap/occt_wrap_rwstl.cpp` with include for `<RWStl.hxx>`, `<Poly_Triangulation.hxx>`
- [x] 12.3 Implement `rwstl_read_file(filename)` returning triangulation
- [x] 12.4 Implement `rwstl_write_file(triangulation, filename)` writing STL

## 13. CFFI Bindings

- [x] 13.1 Create `src/ffi/bindings-gcpnts.lisp` with defcfun for uniform abscissa and deflection
- [x] 13.2 Create `src/ffi/bindings-location.lisp` with defcfun for location operations
- [x] 13.3 Create `src/ffi/bindings-find-edges.lisp` with defcfun for edge finding
- [x] 13.4 Create `src/ffi/bindings-normal-project.lisp` with defcfun for normal projection
- [x] 13.5 Create `src/ffi/bindings-transfer-params.lisp` with defcfun for transfer parameters
- [x] 13.6 Create `src/ffi/bindings-brep-io.lisp` with defcfun for BREP I/O
- [x] 13.7 Create `src/ffi/bindings-wedge.lisp` with defcfun for wedge
- [x] 13.8 Create `src/ffi/bindings-dprism.lisp` with defcfun for drafted prism
- [x] 13.9 Create `src/ffi/bindings-remove-features.lisp` with defcfun for remove features
- [x] 13.10 Create `src/ffi/bindings-small-faces.lisp` with defcfun for fix small faces
- [x] 13.11 Create `src/ffi/bindings-shape-tolerance.lisp` with defcfun for tolerance tools
- [x] 13.12 Create `src/ffi/bindings-rwstl.lisp` with defcfun for RWStl

## 14. Core CLOS Wrappers

- [x] 14.1 Create `src/core/gcpnts-points.lisp` with `uniform-abscissa-points` and `uniform-deflection-points`
- [x] 14.2 Create `src/core/assembly-location.lisp` with `make-location`, `compose-locations`, `invert-location`, `shape-location`, `move-shape`
- [x] 14.3 Create `src/core/find-edges.lisp` with `find-edges-by-type` and `find-edges-by-radius`
- [x] 14.4 Create `src/core/normal-project.lisp` with `normal-project`
- [x] 14.5 Create `src/core/transfer-params.lisp` with `transfer-parameter`
- [x] 14.6 Create `src/core/brep-io.lisp` with `write-brep` and `read-brep`
- [x] 14.7 Create `src/core/wedge-primitive.lisp` with `make-wedge`
- [x] 14.8 Create `src/core/drafted-prism.lisp` with `make-drafted-prism`
- [x] 14.9 Create `src/core/remove-features.lisp` with `remove-features`
- [x] 14.10 Create `src/core/small-faces.lisp` with `fix-small-faces`
- [x] 14.11 Create `src/core/shape-tolerance.lisp` with `set-shape-tolerance`
- [x] 14.12 Create `src/core/rwstl-io.lisp` with `read-stl-triangulation` and `write-stl-triangulation`

## 15. System Integration

- [x] 15.1 Add all new C wrapper files to `wrap/Makefile` compilation (auto via wildcard)
- [x] 15.2 Register all new core files in `cl-occt.asd`
- [x] 15.3 Export all new public symbols in `src/package.lisp`

## 16. Tests

- [x] 16.1 Add uniform abscissa/deflection tests: line, circle, null curve
- [x] 16.2 Add location tests: create, compose, invert, get, move shape
- [x] 16.3 Add find-edges tests: find by type on box/cylinder, find by radius
- [x] 16.4 Add normal-project tests: project edge onto plane, null input
- [x] 16.5 Add brep-io tests: round-trip box, invalid path
- [x] 16.6 Add wedge tests: full wedge, corner wedge, invalid dimensions
- [x] 16.7 Add drafted-prism tests: additive/subtractive on shape
- [x] 16.8 Add remove-features tests: remove hole, multiple features
- [x] 16.9 Add fix-small-faces tests (if test fixture available)
- [x] 16.10 Add set-shape-tolerance tests: set on vertices, edges, faces
- [x] 16.11 Add rwstl tests: read valid STL, write triangulation, round-trip
- [x] 16.12 Register all new tests in the test runner

## 17. Documentation

- [x] 17.1 Add "Uniform Point Distribution" section to `doc/api-reference.md`
- [x] 17.2 Add "Assembly Location" section to `doc/api-reference.md`
- [x] 17.3 Add "Edge Finding" section to `doc/api-reference.md`
- [x] 17.4 Add "Normal Projection" section to `doc/api-reference.md`
- [x] 17.5 Add "BREP Native I/O" section to `doc/api-reference.md`
- [x] 17.6 Add "Wedge Primitive" section to `doc/api-reference.md`
- [x] 17.7 Add "Drafted Prism" section to `doc/api-reference.md`
- [x] 17.8 Add "Remove Features" section to `doc/api-reference.md`
- [x] 17.9 Add "Fix Small Faces" section to `doc/api-reference.md`
- [x] 17.10 Add "Shape Tolerance Tools" section to `doc/api-reference.md`
- [x] 17.11 Add "RWStl I/O" section to `doc/api-reference.md`

## 18. Build & Verify

- [x] 18.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 18.2 Run `just test-core` to verify all new tests pass
- [x] 18.3 Fix any compilation or test failures

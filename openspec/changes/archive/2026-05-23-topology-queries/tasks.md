## 1. C Bridge: mass properties (BRepGProp)

- [x] 1.1 Add `shape_volume` C bridge: GProp_GProps + BRepGProp::VolumeProperties
- [x] 1.2 Add `shape_area` C bridge: BRepGProp::SurfaceProperties
- [x] 1.3 Add `shape_center_of_mass` C bridge: returns 3 doubles via out-params
- [x] 1.4 Add `shape_inertia` C bridge: returns inertia matrix (6 components) + principal moments (3) + principal axes (9) via out-param array

## 2. C Bridge: shape analysis queries

- [x] 2.1 Add `shape_distance` C bridge: BRepExtrema_DistShapeShape, returns distance
- [x] 2.2 Add `shape_distance_extrema` C bridge: returns distance + closest points on both shapes via out-params
- [x] 2.3 Add `classify_point_in_solid` C bridge: BRepClass3d_SolidClassifier, returns state + optional face pointer via out-params
- [x] 2.4 Add `shape_is_valid` C bridge: BRepCheck_Analyzer, returns 1/0
- [x] 2.5 Add `shape_analysis_report` C bridge: returns detailed validity issues as a string
- [x] 2.6 Add `intersect_curve_shape` C bridge: BRepIntCurveSurface_Inter, returns list of (point face u v parameter) results

## 3. C Bridge: topology navigation

- [x] 3.1 Add `map_subshapes` C bridge: TopExp_Explorer with shape type filter and optional stop-at type, returns array of shape pointers
- [x] 3.2 Add `count_subshapes` C bridge: TopExp_Explorer, returns count only
- [x] 3.3 Add `dump_shape` C bridge: BRepTools::Dump, returns string
- [x] 3.4 Add `shape_triangle_count` C bridge: BRepTools::Triangulation / mesh query
- [x] 3.5 Add `wire_order_check` C bridge: BRepTools_WireChecker / wire order verification
- [x] 3.6 Add `edge_to_curve` C bridge: BRepAdaptor_Curve, returns occt_curve
- [x] 3.7 Add `face_to_surface` C bridge: BRepAdaptor_Surface, returns occt_surface
- [x] 3.8 Add `make_vertex` C bridge: BRepBuilderAPI_MakeVertex
- [x] 3.9 Add `make_polygon` C bridge: BRepBuilderAPI_MakePolygon from array of points

## 4. CFFI Bindings (bindings.lisp)

- [x] 4.1 Add `%`-prefixed defcfun bindings for all mass properties bridge functions
- [x] 4.2 Add `%`-prefixed defcfun bindings for all shape analysis bridge functions
- [x] 4.3 Add `%`-prefixed defcfun bindings for all topology navigation bridge functions

## 5. CLOS wrappers: mass properties (src/core/mass-properties.lisp)

- [x] 5.1 Create `src/core/mass-properties.lisp` with `gprops` CLOS class (%volume %area %center-of-mass %inertia-matrix %principal-moments %principal-axes)
- [x] 5.2 Implement `shape-gprops` (batch compute all properties, return gprops instance)
- [x] 5.3 Implement convenience functions: `shape-volume`, `shape-area`, `shape-center-of-mass`, `shape-inertia`
- [x] 5.4 Add nil propagation and shape validation

## 6. CLOS wrappers: shape analysis (src/core/shape-analysis.lisp)

- [x] 6.1 Create `src/core/shape-analysis.lisp`
- [x] 6.2 Implement `shape-distance` (single-value) and `shape-distance-extrema` (returns extrema CLOS with distance + points)
- [x] 6.3 Implement `point-in-solid-p` (keyword result), `classify-point-in-solid` (keyword + optional face)
- [x] 6.4 Implement `shape-valid-p` and `shape-check` (detailed report)
- [x] 6.5 Implement `intersect-curve-shape`

## 7. CLOS wrappers: topology navigation (src/core/topology.lisp)

- [x] 7.1 Create `src/core/topology.lisp`
- [x] 7.2 Implement `map-shape-subshapes` with type keywords (`:face :edge :vertex :shell :solid :wire :shape`) and `:stop-at` option
- [x] 7.3 Implement `count-shape-subshapes`, `dump-shape`
- [x] 7.4 Implement `shape-triangle-count`, `wire-order-check-p`
- [x] 7.5 Implement `edge->curve` (returns curve if curve type available, else raw pointer plist)
- [x] 7.6 Implement `face->surface` (returns surface if surface type available, else raw pointer plist)
- [x] 7.7 Implement `make-vertex` (x y z) → shape
- [x] 7.8 Implement `make-polygon` (list of point triples, :closed keyword)

## 8. Package exports

- [x] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [x] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [x] 9.1 Write tests for mass properties (volume, area, COM, inertia on known shapes)
- [x] 9.2 Write tests for shape analysis (distance between known shapes, point classification, validity)
- [x] 9.3 Write tests for topology navigation (explorer counts, vertex and polygon construction, shape dump)
- [x] 9.4 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [x] 10.1 Update README with mass properties API documentation
- [x] 10.2 Update README with shape analysis API documentation
- [x] 10.3 Update README with topology navigation API documentation

## 1. C Wrapper — BRepExtrema Proximity & Overlap

- [ ] 1.1 Add includes for `BRepExtrema_ShapeProximity.hxx`, `BRepExtrema_OverlapTool.hxx`, `BRepExtrema_SelfIntersection.hxx` to new `wrap/occt_wrap_extrema.cpp`
- [ ] 1.2 Implement `shape_proximity` in `occt_wrap_extrema.cpp`: accept two shapes + tolerance, run BRepExtrema_ShapeProximity, return array of proximity results (distance + subshapes)
- [ ] 1.3 Implement `shape_overlap_p` in `occt_wrap_extrema.cpp`: accept two shapes, run BRepExtrema_OverlapTool, return boolean
- [ ] 1.4 Implement `shape_overlap_detail` in `occt_wrap_extrema.cpp`: accept two shapes, return overlapping subshape pairs
- [ ] 1.5 Implement `shape_self_intersect` in `occt_wrap_extrema.cpp`: accept one shape, run BRepExtrema_SelfIntersection, return intersection points + faces
- [ ] 1.6 Implement `face_distance` in `occt_wrap_extrema.cpp`: accept two faces, compute min/max distance via BRepExtrema
- [ ] 1.7 Declare all new functions in new `wrap/occt_wrap_extrema.h`

## 2. C Wrapper — BRepLProp Local Properties

- [ ] 2.1 Add includes for `BRepLProp_CLProps.hxx`, `BRepLProp_SLProps.hxx`, `GeomAdaptor_Curve.hxx`, `GeomAdaptor_Surface.hxx` to new `wrap/occt_wrap_lprop.cpp`
- [ ] 2.2 Implement `curve_tangent_at` in `occt_wrap_lprop.cpp`: accept curve + parameter, compute tangent via BRepLProp_CLProps, return tx ty tz
- [ ] 2.3 Implement `curve_curvature_at` in `occt_wrap_lprop.cpp`: accept curve + parameter, compute curvature value
- [ ] 2.4 Implement `surface_normal_at` in `occt_wrap_lprop.cpp`: accept surface + UV, compute normal via BRepLProp_SLProps
- [ ] 2.5 Implement `surface_curvature_at` in `occt_wrap_lprop.cpp`: accept surface + UV, compute min/max curvature
- [ ] 2.6 Declare all new functions in new `wrap/occt_wrap_lprop.h`

## 3. CFFI Bindings

- [ ] 3.1 Add CFFI `defcfun` bindings for all BRepExtrema C functions in new `src/ffi/bindings-extrema.lisp`
- [ ] 3.2 Add CFFI `defcfun` bindings for all BRepLProp C functions in new `src/ffi/bindings-lprop.lisp`

## 4. Core CLOS Wrappers

- [ ] 4.1 Implement `shape-proximity` in `src/core/shape-analysis.lisp`: call `%shape-proximity`, parse proximity zones into Lisp data
- [ ] 4.2 Implement `shape-overlap-p` in `src/core/shape-analysis.lisp`: call `%shape-overlap-p`, return boolean
- [ ] 4.3 Implement `shape-overlap` in `src/core/shape-analysis.lisp`: call `%shape-overlap-detail`, return overlapping subshapes
- [ ] 4.4 Implement `shape-self-intersect-p` in `src/core/shape-analysis.lisp`: call `%shape-self-intersect`, return list of intersection locations
- [ ] 4.5 Implement `face-distance` in `src/core/shape-analysis.lisp`: call `%face-distance`, return two values (min-dist max-dist)
- [ ] 4.6 Create `src/core/surface-curve-local-props.lisp` with `curve-tangent-at`: call `%curve-tangent-at`, return three values
- [ ] 4.7 Implement `curve-curvature-at`: call `%curve-curvature-at`, return curvature value
- [ ] 4.8 Implement `surface-normal-at`: call `%surface-normal-at`, return three values
- [ ] 4.9 Implement `surface-curvature-at`: call `%surface-curvature-at`, return two values (min-curv max-curv)
- [ ] 4.10 Implement `face-normal-at`: accept face + UV, extract surface, call `%surface-normal-at`
- [ ] 4.11 Implement `face-curvature-at`: accept face + UV, extract surface, call `%surface-curvature-at`

## 5. System Integration

- [ ] 5.1 Add new core files to `cl-occt.asd`
- [ ] 5.2 Add new wrap files to `wrap/Makefile`
- [ ] 5.3 Export new public symbols from `src/package.lisp`

## 6. Tests

- [ ] 6.1 Add proximity tests: near boxes return zones, touching shapes, far shapes return nil
- [ ] 6.2 Add overlap tests: overlapping shapes, non-overlapping, nil input
- [ ] 6.3 Add self-intersection tests: valid shape returns nil, folded shape returns intersections
- [ ] 6.4 Add face-distance tests: parallel faces, touching faces
- [ ] 6.5 Add curve-tangent tests: line tangent, circle tangent at 0
- [ ] 6.6 Add curve-curvature tests: line curvature = 0, circle curvature = 1/r
- [ ] 6.7 Add surface-normal tests: plane normal, sphere normal at pole
- [ ] 6.8 Add surface-curvature tests: sphere equal curvature, cylinder one zero curvature
- [ ] 6.9 Register all new tests in the test runner function

## 7. Documentation

- [ ] 7.1 Add proximity/overlap/self-intersection sections to `doc/api-reference.md` under Analysis
- [ ] 7.2 Add "Curve Local Properties" section with `curve-tangent-at`, `curve-curvature-at`
- [ ] 7.3 Add "Surface Local Properties" section with `surface-normal-at`, `surface-curvature-at`
- [ ] 7.4 Add "Face Local Properties" section with `face-normal-at`, `face-curvature-at`

## 8. Build & Verify

- [ ] 8.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [ ] 8.2 Run `just test-all` to verify all new and existing tests pass

## 1. C Wrapper — BRepExtrema Proximity & Overlap

- [x] 1.1 Add includes for `BRepExtrema_ShapeProximity.hxx`, `BRepExtrema_OverlapTool.hxx`, `BRepExtrema_SelfIntersection.hxx` to new `wrap/occt_wrap_extrema.cpp`
- [x] 1.2 Implement `shape_proximity` in `occt_wrap_extrema.cpp`: accept two shapes + tolerance, run BRepExtrema_ShapeProximity, return array of proximity results (distance + subshapes)
- [x] 1.3 Implement `shape_overlap_p` in `occt_wrap_extrema.cpp`: accept two shapes, run BRepExtrema_OverlapTool, return boolean
- [x] 1.4 Implement `shape_overlap_detail` in `occt_wrap_extrema.cpp`: accept two shapes, return overlapping subshape pairs
- [x] 1.5 Implement `shape_self_intersect` in `occt_wrap_extrema.cpp`: accept one shape, run BRepExtrema_SelfIntersection, return intersection points + faces
- [x] 1.6 Implement `face_distance` in `occt_wrap_extrema.cpp`: accept two faces, compute min/max distance via BRepExtrema
- [x] 1.7 Declare all new functions in new `wrap/occt_wrap_extrema.h`

## 2. C Wrapper — BRepLProp Local Properties

- [x] 2.1 Add includes for `BRepLProp_CLProps.hxx`, `BRepLProp_SLProps.hxx`, `GeomAdaptor_Curve.hxx`, `GeomAdaptor_Surface.hxx` to new `wrap/occt_wrap_lprop.cpp`
- [x] 2.2 Implement `curve_tangent_at` in `occt_wrap_lprop.cpp`: accept curve + parameter, compute tangent via BRepLProp_CLProps, return tx ty tz
- [x] 2.3 Implement `curve_curvature_at` in `occt_wrap_lprop.cpp`: accept curve + parameter, compute curvature value
- [x] 2.4 Implement `surface_normal_at` in `occt_wrap_lprop.cpp`: accept surface + UV, compute normal via BRepLProp_SLProps
- [x] 2.5 Implement `surface_curvature_at` in `occt_wrap_lprop.cpp`: accept surface + UV, compute min/max curvature
- [x] 2.6 Declare all new functions in new `wrap/occt_wrap_lprop.h`

## 3. CFFI Bindings

- [x] 3.1 Add CFFI `defcfun` bindings for all BRepExtrema C functions in new `src/ffi/bindings-extrema.lisp`
- [x] 3.2 Add CFFI `defcfun` bindings for all BRepLProp C functions in new `src/ffi/bindings-lprop.lisp`

## 4. Core CLOS Wrappers

- [x] 4.1 Implement `shape-proximity` in `src/core/shape-analysis.lisp`: call `%shape-proximity`, parse proximity zones into Lisp data
- [x] 4.2 Implement `shape-overlap-p` in `src/core/shape-analysis.lisp`: call `%shape-overlap-p`, return boolean
- [x] 4.3 Implement `shape-overlap` in `src/core/shape-analysis.lisp`: call `%shape-overlap-detail`, return overlapping subshapes
- [x] 4.4 Implement `shape-self-intersect-p` in `src/core/shape-analysis.lisp`: call `%shape-self-intersect`, return list of intersection locations
- [x] 4.5 Implement `face-distance` in `src/core/shape-analysis.lisp`: call `%face-distance`, return two values (min-dist max-dist)
- [x] 4.6 Create `src/core/surface-curve-local-props.lisp` with `curve-tangent-at`: call `%curve-tangent-at`, return three values
- [x] 4.7 Implement `curve-curvature-at`: call `%curve-curvature-at`, return curvature value
- [x] 4.8 Implement `surface-normal-at`: call `%surface-normal-at`, return three values
- [x] 4.9 Implement `surface-curvature-at`: call `%surface-curvature-at`, return two values (min-curv max-curv)
- [x] 4.10 Implement `face-normal-at`: accept face + UV, extract surface, call `%surface-normal-at`
- [x] 4.11 Implement `face-curvature-at`: accept face + UV, extract surface, call `%surface-curvature-at`

## 5. System Integration

- [x] 5.1 Add new core files to `cl-occt.asd`
- [x] 5.2 Add new wrap files to `wrap/Makefile`
- [x] 5.3 Export new public symbols from `src/package.lisp`

## 6. Tests

- [x] 6.1 Add proximity tests: near boxes return zones, touching shapes, far shapes return nil
- [x] 6.2 Add overlap tests: overlapping shapes, non-overlapping, nil input
- [x] 6.3 Add self-intersection tests: valid shape returns nil, folded shape returns intersections
- [x] 6.4 Add face-distance tests: parallel faces, touching faces
- [x] 6.5 Add curve-tangent tests: line tangent, circle tangent at 0
- [x] 6.6 Add curve-curvature tests: line curvature = 0, circle curvature = 1/r
- [x] 6.7 Add surface-normal tests: plane normal, sphere normal at pole
- [x] 6.8 Add surface-curvature tests: sphere equal curvature, cylinder one zero curvature
- [x] 6.9 Register all new tests in the test runner function

## 7. Documentation

- [x] 7.1 Add proximity/overlap/self-intersection sections to `docs/api-reference.md` under Analysis
- [x] 7.2 Add "Curve Local Properties" section with `curve-tangent-at`, `curve-curvature-at`
- [x] 7.3 Add "Surface Local Properties" section with `surface-normal-at`, `surface-curvature-at`
- [x] 7.4 Add "Face Local Properties" section with `face-normal-at`, `face-curvature-at`

## 8. Build & Verify

- [x] 8.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 8.2 Run `just test-all` to verify all new and existing tests pass

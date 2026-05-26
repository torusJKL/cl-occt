## 1. C Wrapper — FairCurve

- [x] 1.1 Add includes for `FairCurve_Batten.hxx`, `FairCurve_MinimalVariation.hxx` to new `wrap/occt_wrap_faircurve.cpp`
- [x] 1.2 Implement `fair_curve_batten` in `occt_wrap_faircurve.cpp`: accept points array + count + options (free-end, free-slide, tangents), run FairCurve_Batten, return curve pointer
- [x] 1.3 Implement `fair_curve_minvar` in `occt_wrap_faircurve.cpp`: accept points array + count + options (slopes), run FairCurve_MinimalVariation, return curve pointer
- [x] 1.4 Declare new functions in new `wrap/occt_wrap_faircurve.h`

## 2. C Wrapper — GeomPlate

- [x] 2.1 Add includes for `GeomPlate_BuildAveragePlate.hxx`, `GeomPlate_CurveConstraint.hxx` to new `wrap/occt_wrap_geomplate.cpp`
- [x] 2.2 Implement `fill_surface_from_curves` in `occt_wrap_geomplate.cpp`: accept curve array + count + continuity code + optional support face array, run GeomPlate pipeline, return surface pointer
- [x] 2.3 Declare new function in new `wrap/occt_wrap_geomplate.h`

## 3. CFFI Bindings

- [x] 3.1 Add CFFI `defcfun` bindings for FairCurve functions in new `src/ffi/bindings-faircurve.lisp`
- [x] 3.2 Add CFFI `defcfun` bindings for GeomPlate function in new `src/ffi/bindings-geomplate.lisp`

## 4. Core CLOS Wrappers

- [x] 4.1 Create `src/core/fair-curve.lisp` with `fair-curve-batten`: accept points list + keyword options, wrap result with `make-curve`
- [x] 4.2 Implement `fair-curve-minvar`: accept points list + keyword options, wrap result with `make-curve`
- [x] 4.3 Create `src/core/advanced-surface-filling.lisp` with `fill-surface-from-curves`: accept curve list + continuity + support faces, wrap result with `make-surface`

## 5. System Integration

- [x] 5.1 Add new core files to `cl-occt.asd`
- [x] 5.2 Add new wrap files to `wrap/Makefile`
- [x] 5.3 Export new public symbols from `src/package.lisp`

## 6. Tests

- [x] 6.1 Add FairCurve batten tests: 3-point batten, batten with tangents, batten with free ends, nil input
- [x] 6.2 Add FairCurve minvar tests: 3-point minvar, with slopes, nil input
- [x] 6.3 Add GeomPlate tests: fill from 4 curves, fill with G1 continuity, fewer than 3 curves returns nil
- [x] 6.4 Register all new tests in the test runner function

## 7. Documentation

- [x] 7.1 Add "Fair Curve" section to `doc/api-reference.md` with `fair-curve-batten` and `fair-curve-minvar`
- [x] 7.2 Add "Advanced Surface Filling" section with `fill-surface-from-curves`

## 8. Build & Verify

- [x] 8.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 8.2 Run `just test-core` to verify all new and existing tests pass

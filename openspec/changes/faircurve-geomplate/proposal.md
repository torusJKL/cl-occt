## Why

Current curve creation tools (line, circle, ellipse, Bezier, BSpline) produce mathematically precise curves but not aesthetically pleasing ones. FairCurve produces curves that minimize strain energy (physical spline behavior) — essential for automotive/industrial design. GeomPlate provides advanced surface filling from boundary curves with continuity constraints, going beyond the existing MakeFilling API.

## What Changes

- **FairCurve Batten**: `FairCurve_Batten` — create a curve that minimizes strain energy through given points
- **FairCurve Minimal Variation**: `FairCurve_MinimalVariation` — create a curve minimizing curvature variation
- **GeomPlate Surface Fill**: `GeomPlate_BuildAveragePlate` + `GeomPlate_CurveConstraint` — fill a surface from boundary curves with continuity constraints
- **Documentation**: Update `api-reference.md` with all new function signatures

## Capabilities

### New Capabilities

- `fair-curve`: Energy-minimizing curves (FairCurve_Batten, FairCurve_MinimalVariation) for aesthetic/industrial design
- `advanced-surface-filling`: Surface filling from boundary curves via GeomPlate, with G1/G2 continuity constraints

### Modified Capabilities

(none — complementary to existing face-filling capability)

## Impact

- **C wrapper** (`wrap/`): ~5 new `extern "C"` functions
- **CFFI layer** (`src/ffi/`): ~5 new `defcfun` bindings
- **Core layer** (`src/core/`): New `fair-curve.lisp`, new `advanced-surface-filling.lisp`
- **Tests** (`tests/`): FairCurve tests, GeomPlate tests
- **Docs** (`doc/api-reference.md`): FairCurve and Advanced Surface Filling sections

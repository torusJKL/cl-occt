## Context

cl-occt currently has `fill-face` and `fill-n-sided-face` using `BRepOffsetAPI_MakeFilling`. This change adds FairCurve (aesthetic curve design) and GeomPlate (lower-level surface filling from geometric curves rather than topological edges/wires). These are independent but grouped because both deal with creating smooth geometry from constraints.

FairCurve lives in `TKGeomAlgo`. GeomPlate also lives in `TKGeomAlgo` with `NLPlate` (non-linear plate) support.

## Goals / Non-Goals

**Goals:**
- FairCurve_Batten with support points, free ends, tangency constraints
- FairCurve_MinimalVariation with slope constraints
- GeomPlate surface filling from 3+ boundary curves with G1/G2 continuity
- Return curves/surfaces compatible with existing `curve` and `surface` CLOS classes

**Non-Goals:**
- No changes to existing face-filling API
- No viewer changes

## Decisions

### 1. FairCurve returns curve objects
FairCurve generates `Geom_BSplineCurve` internally. The C wrapper extracts this and wraps it as a `curve` CLOS object, compatible with `curve-type`, `convert-curve-to-bspline`, etc.

### 2. GeomPlate returns surface objects
GeomPlate generates a `Geom_BSplineSurface`. The C wrapper returns a `surface` CLOS object.

### 3. File layout

| What | Where |
|------|-------|
| C FairCurve | New `wrap/occt_wrap_faircurve.cpp` |
| C GeomPlate | New `wrap/occt_wrap_geomplate.cpp` |
| CFFI | New `src/ffi/bindings-faircurve.lisp`, `src/ffi/bindings-geomplate.lisp` |
| Core fair curve | New `src/core/fair-curve.lisp` |
| Core surface fill | New `src/core/advanced-surface-filling.lisp` |

## Risks / Trade-offs

- **FairCurve may fail for degenerate point sets.** Collinear or near-collinear points can cause the minimization to fail. Returns nil in that case.
- **GeomPlate surface filling is slower than MakeFilling** but provides more control over continuity. For simple hole-filling, the existing `fill-n-sided-face` should be preferred.

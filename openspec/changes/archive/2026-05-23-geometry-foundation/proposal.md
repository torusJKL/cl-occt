## Why

CL-OCCT currently has no bindings for OCCT's 3D geometry types (curves, surfaces) or geometric algorithms (projection, intersection, approximation). Building parametric CAD models often requires constructing or querying curves and surfaces directly — creating a spline through points, projecting a point onto a surface, finding curve-curve intersections, or building a helix. Without these, the library is limited to primitive solids and boolean operations.

Adding the 3D geometry layer unlocks the full OCCT geometric kernel for Lisp users. Every downstream feature operation (fillet, sweep, loft, offset) and topology query indirectly depends on these types.

## What Changes

This change introduces **3 new capability areas**, each backed by a spec. Every spec follows the same three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each spec includes unit tests.

**New capabilities:**
- `3d-curves-and-surfaces` — all `Geom_*` curve and surface types with CLOS wrappers
- `geometric-algorithms` — projection, intersection, approximation, interpolation APIs
- `helix` — helix geometry construction and BRep creation

No breaking changes to existing APIs. Extends the existing `geom2d` discriminated-union pattern to 3D geometry.

## Capabilities

### New Capabilities
- `3d-curves-and-surfaces`: CLOS wrappers for OCCT 3D curve and surface types (Geom_Line, Geom_Circle, Geom_Ellipse, Geom_BezierCurve, Geom_BSplineCurve, Geom_Plane, Geom_CylindricalSurface, Geom_SphericalSurface, Geom_ToroidalSurface, Geom_BezierSurface, Geom_BSplineSurface, GCE2d/GC constructors, Convert routines, BndLib/GeomBndLib bounding boxes). Discriminated-union C types `occt_curve` and `occt_surface` with `tg:finalize` GC, following the existing `geom2d` pattern.
- `geometric-algorithms`: GeomAPI/Geom2dAPI projection (point on curve, point on surface), intersection (curve-curve, curve-surface, surface-surface), extrema (curve-curve, curve-surface), BSpline fitting (PointsToBSpline, Interpolate). Returns curves/surfaces as `occt_curve`/`occt_surface`.
- `helix`: HelixGeom (parametric curve definition) and HelixBRep (BRep edge/wire construction from helix parameters — radius, pitch, height, angle).

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: New `occt_curve` and `occt_surface` opaque types (struct with kind tag + Handle). ~40 new `extern "C"` bridge functions across all 3 specs.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/curves.lisp` — CLOS wrappers for curve types
  - `src/core/surfaces.lisp` — CLOS wrappers for surface types
  - `src/core/geom-algorithms.lisp` — projection, intersection, approximation
  - `src/core/helix.lisp` — helix construction
- **src/core/geom2d.lisp**: May be extended with new Geom2d curve types for parity.
- **src/package.lisp**: ~60+ new exported symbols across both packages.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with geometry API documentation.
- **Dependencies**: No new external dependencies; OCCT Geom headers already available.

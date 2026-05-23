## Why

CL-OCCT can construct shapes and perform boolean operations, but cannot analyze or inspect them. Users cannot query mass properties (volume, area, center of mass), check if a point lies inside a solid, find the distance between two shapes, validate shape integrity, or walk the BRep topology tree. These are fundamental CAD operations — without them the library is a one-way construction pipeline.

This change adds the topology query and analysis layer, making shapes introspectable and verifiable.

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `mass-properties` — volume, area, center of mass, inertia via BRepGProp
- `shape-analysis-queries` — distance/extrema, point-in-solid classification, shape validity checking, curve-surface intersection
- `topology-navigation` — TopExp_Explorer for walking sub-shapes, BRepTools utilities (wire ordering, triangulation, shape dump), BRepAdaptor for geometric queries on edges/faces, BRepBuilderAPI_MakeVertex and MakePolygon

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `mass-properties`: Compute volume, surface area, center of mass, and inertia tensor of a solid shape via `BRepGProp`. Returns structured results via a `gprops` CLOS class.
- `shape-analysis-queries`: Distance/extremum between shapes (`BRepExtrema`), point-in-solid classification (`BRepClass3d`), shape validity checking (`BRepCheck_Analyzer`), curve-surface intersection on BRep shapes (`BRepIntCurveSurface`).
- `topology-navigation`: Walk sub-shapes of a given type via `TopExp_Explorer`, access BRepTools utilities (wire ordering, triangulation, shape dump text representation), BRepAdaptor for extracting curves/surfaces from edges/faces, construct vertices from points (`MakeVertex`) and polygons from point sequences (`MakePolygon`).

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~25 new C bridge functions. New struct types for mass properties results and extrema results.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/mass-properties.lisp` — BRepGProp wrappers, `gprops` CLOS class
  - `src/core/shape-analysis.lisp` — extrema, classification, validity, curve-surface intersection
  - `src/core/topology.lisp` — explorer, BRepTools, BRepAdaptor, vertex/polygon builders
- **src/package.lisp**: ~40+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with topology query API documentation.
- **Dependencies**: Uses the `curve`/`surface` types from `geometry-foundation` (BRepAdaptor returns curves from edges). If not yet implemented, stub with raw pointer returns.

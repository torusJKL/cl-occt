## Why

Shapes imported from STEP/STL or constructed via boolean/sweep operations can have topological defects: gaps in wires, self-intersecting faces, non-manifold edges, or incorrect orientation. Without shape healing, these defects propagate through the DAG and cause downstream operations to fail silently or produce invalid geometry.

OCCT provides a comprehensive shape healing toolkit: `ShapeFix` for fixing common defects, `ShapeAnalysis` for diagnosing problems, `ShapeBuild_ReShape` for substituting/replacing sub-shapes, `ShapeCustom` for NURBS conversion, `ShapeUpgrade` for splitting and surface upgrades, and `ShapeProcess` for scriptable healing pipelines.

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `shape-fix` — ShapeFix_Shape/Wire/Solid/Edge/Face for topological repair, plus ShapeAnalysis queries
- `shape-rebuild` — ShapeBuild_ReShape (substitute sub-shapes), ShapeCustom (NURBS conversion, degree reduction), ShapeUpgrade (surface splitting, continuity upgrade)
- `shape-process-pipeline` — ShapeProcess and ShapeProcessAPI for scriptable, multi-step healing pipelines

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `shape-fix`: Fix common shape problems — `ShapeFix_Shape` (general repair), `ShapeFix_Wire` (wire gaps, self-intersections, orientation), `ShapeFix_Solid` (solid validity), `ShapeFix_Edge`/`ShapeFix_Face` (edge/face fixing). Includes `ShapeAnalysis` queries for diagnosing geometry/topology issues.
- `shape-rebuild`: Substitute sub-shapes within a shape (`ShapeBuild_ReShape`), convert elementary curves/surfaces to NURBS and reduce degree (`ShapeCustom`), split faces along U/V isoparams and upgrade surface continuity (`ShapeUpgrade`).
- `shape-process-pipeline`: Define and run scriptable healing sequences via `ShapeProcess` operators and `ShapeProcessAPI` for applying healing templates to shapes.

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~25 new C bridge functions across 3 specs.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/shape-fix.lisp` — ShapeFix wrappers and ShapeAnalysis queries
  - `src/core/shape-rebuild.lisp` — ShapeBuild_ReShape, ShapeCustom, ShapeUpgrade
  - `src/core/shape-process.lisp` — ShapeProcess and pipeline
- **src/package.lisp**: ~25+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with shape healing API documentation.

## Why

Current shape analysis covers basic distance between shapes and point-in-solid classification. For real-world CAD validation, an AI needs to detect shape proximity (clearance checking), overlap (interference detection), self-intersection (model quality), and local surface properties (curvature, tangents for surface continuity assessment). These are essential for quality assurance workflows and for an AI to programmatically inspect models.

## What Changes

- **Shape Proximity**: `BRepExtrema_ShapeProximity` — compute proximity zones between shapes with tolerance
- **Overlap Detection**: `BRepExtrema_OverlapTool` — detect overlapping regions between shapes
- **Self-Intersection**: `BRepExtrema_SelfIntersection` — detect where a shape self-intersects
- **Local Curve Properties**: `BRepLProp_CLProps` — curve tangent, curvature, normal at a parameter
- **Local Surface Properties**: `BRepLProp_SLProps` — surface normal, curvature (min/max), tangent plane at UV
- **Documentation**: Update `api-reference.md` with all new function signatures

## Capabilities

### New Capabilities

- `surface-curve-local-props`: Local geometric properties at parameters/UVs: curve tangent/curvature, surface normal/curvature/tangent plane

### Modified Capabilities

- `shape-analysis-queries`: Add proximity detection, overlap detection, and self-intersection analysis

## Impact

- **C wrapper** (`wrap/`): ~8 new `extern "C"` functions for BRepExtrema + BRepLProp
- **CFFI layer** (`src/ffi/`): ~8 new `defcfun` bindings
- **Core layer** (`src/core/`): Extend `shape-analysis.lisp` + new `surface-curve-local-props.lisp`
- **Tests** (`tests/`): Proximity, overlap, self-intersection, curvature tests
- **Docs** (`doc/api-reference.md`): Analysis and Local Properties sections

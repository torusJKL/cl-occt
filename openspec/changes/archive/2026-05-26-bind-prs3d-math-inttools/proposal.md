## Why

cl-occt lacks bindings for key OCCT utilities: Prs3d_Tool* helpers for parametric mesh generation (cylinder, sphere, torus, disk), Prs3d_Arrow/Text/BndBox for AIS primitive display, math optimization algorithms (BFGS, FRPR, PSO, GlobOptMin), and IntTools for edge-edge/edge-face/face-face intersection queries. These are needed for visualization helpers, numerical optimization, and low-level geometric intersection — gaps in the current binding coverage.

## What Changes

Add CFFI bindings and CLOS wrappers for ~15 OCCT classes across 4 capability areas:

- **Prs3d_Tool* (parametric mesh generators)**: `Prs3d_ToolCylinder`, `Prs3d_ToolSphere`, `Prs3d_ToolTorus`, `Prs3d_ToolDisk` — generate triangulations for parametric surfaces
- **Prs3d AIS Primitives**: `Prs3d_Arrow`, `Prs3d_Text`, `Prs3d_BndBox` — compute display primitives for arrows, 3D text, and bounding boxes
- **math Optimization**: `math_BFGS`, `math_FRPR`, `math_PSO`, `math_GlobOptMin` — multi-variate function minimization algorithms
- **IntTools Intersection**: `IntTools_EdgeEdge`, `IntTools_EdgeFace`, `IntTools_FaceFace` — low-level geometric intersection between topological entities
- **API Reference**: Update `api-reference.md` with all new function signatures for AI agent consumption

## Capabilities

### New Capabilities

- `prs3d-tools`: Prs3d_ToolCylinder/Sphere/Torus/Disk — generate `Graphic3d_ArrayOfTriangles` from parametric surfaces with configurable tessellation
- `prs3d-primitives`: Prs3d_Arrow (compute arrow triangulation), Prs3d_Text (compute text triangulation), Prs3d_BndBox (compute bounding box display) — AIS primitive display computation
- `math-optimization`: math_BFGS, math_FRPR, math_PSO, math_GlobOptMin — multivariate function minimization with Lisp callback functions
- `inttools-intersection`: IntTools_EdgeEdge, IntTools_EdgeFace, IntTools_FaceFace — low-level topological intersection queries between edges and faces
- `api-reference-docs`: Update api-reference.md with documentation of all new bindings

### Modified Capabilities

*(None — all are new capabilities)*

## Impact

- **C wrapper** (`wrap/occt_wrap.h|cpp`): ~15 new `extern "C"` functions across 4 groups
- **CFFI layer** (`src/ffi/`): New `defcfun` bindings (`%`-prefixed)
- **Core layer** (`src/core/`): New CLOS wrapper functions for each capability, with GC-managed pointers and nil-on-null-pointer semantics
- **Tests** (`tests/`): New test files/sections for each capability
- **Docs** (`docs/api-reference.md`): Updated with all new functions

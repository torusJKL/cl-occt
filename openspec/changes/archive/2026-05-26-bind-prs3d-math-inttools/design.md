## Context

cl-occt currently wraps ~250 OCCT functions with a three-layer architecture: C wrapper (`wrap/occt_wrap.h|cpp`), CFFI (`src/ffi/bindings.lisp`), and CLOS wrappers (`src/core/`). The user requests bindings for 4 new capability areas covering Prs3d_Tool* parametric mesh generators, Prs3d AIS display primitives, math optimization algorithms, and IntTools geometric intersection queries.

Existing architecture conventions:
- **C wrapper**: `extern "C"` functions with `try/catch(Standard_Failure)`, thread-local error state, `occt_shape`/`occt_geom2d`/`occt_curve`/`occt_surface` opaque pointer typedefs
- **CFFI** (`src/ffi/bindings.lisp`): `defcfun` with `%`-prefixed names, appended at end of file
- **Core** (`src/core/`): CLOS wrappers with `make-shape`/`make-*` factory, `tg:finalize` GC, nil-on-null propagation
- **Tests** (`tests/`): Custom `deftest` framework with `assert-true`/`assert-shape`/`assert-nil`
- **Docs** (`docs/api-reference.md`): Per-section markdown tables with signature and example

## Goals / Non-Goals

**Goals:**

| # | OCCT Class | C function(s) | Lisp function(s) | Capability |
|---|-----------|--------------|------------------|------------|
| 1 | `Prs3d_ToolCylinder` | `prs3d_tool_cylinder` | `make-prs3d-cylinder-mesh` | prs3d-tools |
| 2 | `Prs3d_ToolSphere` | `prs3d_tool_sphere` | `make-prs3d-sphere-mesh` | prs3d-tools |
| 3 | `Prs3d_ToolTorus` | `prs3d_tool_torus` | `make-prs3d-torus-mesh` | prs3d-tools |
| 4 | `Prs3d_ToolDisk` | `prs3d_tool_disk` | `make-prs3d-disk-mesh` | prs3d-tools |
| 5 | `Prs3d_Arrow` | `prs3d_arrow` | `make-prs3d-arrow` | prs3d-primitives |
| 6 | `Prs3d_Text` | `prs3d_text` | `make-prs3d-text` | prs3d-primitives |
| 7 | `Prs3d_BndBox` | `prs3d_bndbox` | `make-prs3d-bndbox` | prs3d-primitives |
| 8 | `math_BFGS` | `math_bfgs_create/free/solve` | `bfgs-minimize` | math-optimization |
| 9 | `math_FRPR` | `math_frpr_create/free/solve` | `frpr-minimize` | math-optimization |
| 10 | `math_PSO` | `math_pso_create/free/solve` | `pso-minimize` | math-optimization |
| 11 | `math_GlobOptMin` | `math_globoptmin_create/free/solve` | `globoptmin-minimize` | math-optimization |
| 12 | `IntTools_EdgeEdge` | `inttools_edge_edge` | `intersect-edge-edge` | inttools-intersection |
| 13 | `IntTools_EdgeFace` | `inttools_edge_face` | `intersect-edge-face` | inttools-intersection |
| 14 | `IntTools_FaceFace` | `inttools_face_face` | `intersect-face-face` | inttools-intersection |

**Non-Goals:**
- No viewer/rendering changes to existing code
- No changes to the build system or project structure
- No BREAKING changes to existing APIs
- Prs3d_Tool* bindings expose triangulation arrays, not AIS objects — integration with AIS display is left to callers
- math optimization bindings expose a simplified callback interface (Lisp function → C function pointer), not the full OCCT math_MultipleVarFunction hierarchy

## Decisions

### 1. Prs3d_Tool*: Return Graphic3d_ArrayOfTriangles handles

`Prs3d_ToolCylinder/Sphere/Torus/Disk` generate `Handle(Graphic3d_ArrayOfTriangles)` with vertex positions and normals. The C wrapper will return an opaque pointer to the array handle. The Lisp wrapper will provide accessors for vertices/normals and a destructive `free` function. These are low-level mesh generators, distinct from BRep primitives (`make-cylinder`, `make-sphere`, etc.) which create topological shapes.

### 2. Prs3d_Arrow as triangulation

`Prs3d_Arrow` computes vertex/normal arrays for an arrow (shaft + cone head) given start/end points, shaft radius, cone length/radius. The C wrapper will accept parameters and return an array handle. The Lisp wrapper follows the same pattern as Prs3d_Tool*.

### 3. Prs3d_BndBox via Bnd_Box + Prs3d

`Prs3d_BndBox` computes wireframe display of a bounding box. The C wrapper will accept min/max corners and return an array handle for the box edges. The Lisp wrapper will compute the bounding box from a shape via `BRepBndLib` and return the display mesh.

### 4. math_* optimizers: Lisp function callbacks via C function pointer

`math_BFGS`/`math_FRPR`/`math_PSO`/`math_GlobOptMin` require a `math_MultipleVarFunction` subclass to evaluate the objective. Since CFFI cannot pass CLOS instances to C++, the pattern will be:
- C wrapper accepts a C function pointer for the objective function
- Lisp registers a callback via `cffi:callback` (a lambda wrapping the user's function)
- The solver calls the C function pointer, which calls back into Lisp

This is the standard pattern for numerical optimization in CFFI. Each solver will have `create`/`free`/`solve` functions.

### 5. IntTools: Results as Lisp-friendly structures

`IntTools_EdgeEdge`/`EdgeFace`/`FaceFace` return sets of intersection points and curves. The C wrapper will:
- Accept two shape pointers (edges/faces) 
- Return intersection results as arrays of point coordinates and curve handles
- Lisp wrapper parses into plists of `(:points (...) :curves (...))`

### 6. File organization per existing convention

- New C functions appended at end of `occt_wrap.cpp` and declared in `occt_wrap.h`
- CFFI bindings appended at end of `src/ffi/bindings.lisp`
- Each new capability gets its own core file: `src/core/prs3d-tools.lisp`, `src/core/prs3d-primitives.lisp`, `src/core/math-optimization.lisp`, `src/core/inttools.lisp`
- Each capability gets its own test file/section
- System integration: add new files to `cl-occt.asd`, export symbols from `src/package.lisp`

## Risks / Trade-offs

- **math callbacks via C function pointer are limited**: Lisp closures cannot be passed as C function pointers. Users will need to pass a plain function (symbol) or use `cffi:callback`. The design will accept a lambda and internally register it. Multiple concurrent solver calls with different callbacks are safe because each call passes its own function pointer.
- **Prs3d_Tool* triangulations are raw vertex arrays**: They generate `Graphic3d_ArrayOfTriangles` but don't create `TopoDS_Shape`. Users wanting to display them will need to use `Graphic3d_Group` or `AIS_Triangulation`. This is intentional — the tool classes are low-level mesh generators.
- **IntTools may return empty results**: Intersection queries with disjoint entities return nil/empty. The C wrapper handles this gracefully with thread-local error state.
- **Prs3d_Text requires font handling**: `Prs3d_Text` needs an existing font. The design will require a `brep-font` handle as input, reusing the existing font system.

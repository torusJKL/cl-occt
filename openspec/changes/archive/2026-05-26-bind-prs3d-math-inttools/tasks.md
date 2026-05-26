## 1. C Wrapper — Prs3d_Tool* (Cylinder, Sphere, Torus, Disk)

- [x] 1.1 Add `#include <Prs3d_ToolCylinder.hxx>`, `<Prs3d_ToolSphere.hxx>`, `<Prs3d_ToolTorus.hxx>`, `<Prs3d_ToolDisk.hxx>` to `occt_wrap.cpp`
- [x] 1.2 Implement `prs3d_tool_cylinder` in `occt_wrap.cpp`: accept radius + height + n-slices + n-stacks, return `Handle(Graphic3d_ArrayOfTriangles)` as opaque pointer
- [x] 1.3 Implement `prs3d_tool_sphere` in `occt_wrap.cpp`: accept radius + n-slices + n-stacks, return array handle
- [x] 1.4 Implement `prs3d_tool_torus` in `occt_wrap.cpp`: accept major-radius + minor-radius + n-slices + n-stacks, return array handle
- [x] 1.5 Implement `prs3d_tool_disk` in `occt_wrap.cpp`: accept inner-radius + outer-radius + n-slices + n-stacks, return array handle
- [x] 1.6 Implement `prs3d_triangulation_free` in `occt_wrap.cpp` to free array handle
- [x] 1.7 Implement `prs3d_triangulation_vertex_count`, `prs3d_triangulation_triangle_count`, `prs3d_triangulation_get_vertices`, `prs3d_triangulation_get_normals`, `prs3d_triangulation_get_triangles` accessors
- [x] 1.8 Declare all prs3d_tool_* and accessor functions in `occt_wrap.h`

## 2. C Wrapper — Prs3d_Arrow, Prs3d_Text, Prs3d_BndBox

- [x] 2.1 Add `#include <Prs3d_Arrow.hxx>`, `<Prs3d_Text.hxx>`, `<Prs3d_BndBox.hxx>` to `occt_wrap.cpp`
- [x] 2.2 Implement `prs3d_arrow` in `occt_wrap.cpp`: accept start/end points + shaft-rad + cone-len + cone-rad + n-facets, return array handle
- [x] 2.3 Implement `prs3d_text` in `occt_wrap.cpp`: accept `occt_brep_font` + text string + position + height, return array handle
- [x] 2.4 Implement `prs3d_bndbox` in `occt_wrap.cpp`: accept xmin/ymin/zmin/xmax/ymax/zmax, return array handle
- [x] 2.5 Implement `shape_bounding_box` in `occt_wrap.cpp`: accept occt_shape, compute Bnd_Box via BRepBndLib, return min/max corners
- [x] 2.6 Declare all prs3d_* and shape_bounding_box functions in `occt_wrap.h`

## 3. C Wrapper — math_BFGS, math_FRPR, math_PSO, math_GlobOptMin

- [x] 3.1 Add `#include <math_BFGS.hxx>`, `<math_FRPR.hxx>`, `<math_PSO.hxx>`, `<math_GlobOptMin.hxx>` to `occt_wrap.cpp`
- [x] 3.2 Implement `math_bfgs_minimize` in `occt_wrap.cpp`: accepts C function pointer callback for objective function, returns result via out params (converged flag + iterations + min value + minimizer vector)
- [x] 3.3 Implement `math_frpr_minimize` with same pattern
- [x] 3.4 Implement `math_pso_minimize` with additional bound and particle count parameters
- [x] 3.5 Implement `math_globoptmin_minimize` with bound parameters
- [x] 3.6 Declare all math_* functions in `occt_wrap.h`

## 4. C Wrapper — IntTools_EdgeEdge, IntTools_EdgeFace, IntTools_FaceFace

- [x] 4.1 Add `#include <IntTools_EdgeEdge.hxx>`, `<IntTools_EdgeFace.hxx>`, `<IntTools_FaceFace.hxx>` to `occt_wrap.cpp`
- [x] 4.2 Implement `inttools_edge_edge` in `occt_wrap.cpp`: accept two edge shapes, return intersection points as double arrays + count
- [x] 4.3 Implement `inttools_edge_face` in `occt_wrap.cpp`: accept edge + face shapes, return intersection points + parameters
- [x] 4.4 Implement `inttools_face_face` in `occt_wrap.cpp`: accept two face shapes, return intersection curves as `occt_curve` array + points
- [x] 4.5 Implement `inttools_free_curve` to free curve handle memory
- [x] 4.6 Declare all inttools_* functions in `occt_wrap.h`

## 5. CFFI Bindings

- [x] 5.1 Add CFFI `defcfun` bindings for all new C functions in `src/ffi/bindings.lisp` following the existing `%`-prefix naming convention

## 6. Core CLOS Wrappers — Prs3d Tools

- [x] 6.1 Create `src/core/prs3d-tools.lisp` with `make-prs3d-cylinder-mesh`, `make-prs3d-sphere-mesh`, `make-prs3d-torus-mesh`, `make-prs3d-disk-mesh` functions
- [x] 6.2 Define `prs3d-triangulation` CLOS class with `tg:finalize` GC for the array handle
- [x] 6.3 Implement accessors: `prs3d-triangulation-vertex-count`, `prs3d-triangulation-triangle-count`, `prs3d-triangulation-vertices`, `prs3d-triangulation-normals`, `prs3d-triangulation-triangles`
- [x] 6.4 Implement `free-prs3d-triangulation` for explicit cleanup

## 7. Core CLOS Wrappers — Prs3d Primitives

- [x] 7.1 Add to `src/core/prs3d-tools.lisp`: `make-prs3d-arrow`, `make-prs3d-text`, `make-prs3d-bndbox`, `shape-bounding-box-display`
- [x] 7.2 Each function returns `prs3d-triangulation` or nil, with nil propagation

## 8. Core CLOS Wrappers — Math Optimization

- [x] 8.1 Create `src/core/math-optimization.lisp` with `bfgs-minimize`, `frpr-minimize`, `pso-minimize`, `globoptmin-minimize`
- [x] 8.2 Each solver wraps the C create/free/solve lifecycle, registers Lisp callback via `cffi:callback`
- [x] 8.3 Return plist `(:converged bool :iterations int :minimum-value double :minimizer list)` or nil
- [x] 8.4 Implement solver-specific free functions

## 9. Core CLOS Wrappers — IntTools Intersection

- [x] 9.1 Create `src/core/inttools.lisp` with `intersect-edge-edge`, `intersect-edge-face`, `intersect-face-face`
- [x] 9.2 Each function returns plist `(:points (...))` and optional `(:curves (...))` or nil

## 10. System Integration

- [x] 10.1 Add new core files to `cl-occt.asd` for system loading
- [x] 10.2 Export new public symbols from `src/package.lisp`

## 11. Tests

- [x] 11.1 Add prs3d-tools tests: generate cylinder/sphere/torus/disk meshes, verify vertex/triangle counts, nil input handling
- [x] 11.2 Add prs3d-primitives tests: create arrow, text (with font), bounding box from shape; nil input
- [x] 11.3 Add math-optimization tests: minimize simple quadratic functions with each solver; nil input
- [x] 11.4 Add inttools-intersection tests: edge-edge, edge-face, face-face with intersecting and non-intersecting cases; nil input
- [x] 11.5 Register all new tests in the test runner function

## 12. Documentation

- [x] 12.1 Add "Prs3d Tools" section to `docs/api-reference.md` with all 4 mesh generators, prs3d-triangulation accessors, and examples
- [x] 12.2 Add "Prs3d Primitives" section to `docs/api-reference.md` with arrow, text, bounding box display functions and examples
- [x] 12.3 Add "Math Optimization" section to `docs/api-reference.md` with all 4 solvers, return plist format, and examples
- [x] 12.4 Add "IntTools Intersection" section to `docs/api-reference.md` with edge-edge, edge-face, face-face functions and examples

## 13. Build & Verify

- [x] 13.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 13.2 Run `just test-core` — 532 pass, 0 fail

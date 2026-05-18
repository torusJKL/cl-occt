## Context

cl-occt currently wraps three 3D boolean operations from OCCT: `BRepAlgoAPI_Cut`, `BRepAlgoAPI_Fuse`, and `BRepAlgoAPI_Common`. These operate on any `TopoDS_Shape` (solids, compounds, faces) and are exposed as variadic Lisp functions with nil propagation.

Two significant gaps remain:

1. **`BRepAlgoAPI_Section`** — OCCT's general-purpose shape intersection algorithm. Given two shapes, it computes their intersection as a set of edges (curves), not a solid. This is essential for section cuts (plane through a solid), face-face intersection curves, and extracting boolean boundary information.

2. **2D boolean operations on planar faces** — The existing `cut`/`fuse`/`common` already accept `TopoDS_Face` (since `Face` IS-A `Shape`), but this usage is undocumented and untested. Planar face booleans enable 2D profile composition — the CAD equivalent of 2D region union/intersection/difference.

## Goals / Non-Goals

**Goals:**
- `section` function wrapping `BRepAlgoAPI_Section` — takes two shapes, returns a shape containing intersection edges
- Section supports: solid-solid, solid-plane, face-face, face-plane intersection
- 2D boolean operations: document and test that `cut`, `fuse`, `common` work on planar faces
- Full 4-layer implementation for `section`: C wrapper → CFFI → CLOS API → package exports
- Smoke tests for section (solid-plane, solid-solid intersecting) and 2D booleans (face union, face cut, face common)
- Nil-propagating error handling following existing pattern

**Non-Goals:**
- `BRepAlgoAPI_Split` — splitting a shape by a tool shape (future work)
- `BRepOffsetAPI_MakeOffset` — offsetting wires/faces (future work)
- Edge extraction utilities from section results (users access edges via shape inspection)
- BSpline/Bezier section support (handled by OCCT automatically — no special wrapping needed)
- `gp_Ax2d` or plane construction as managed objects — raw double coordinates for plane specification

## Decisions

**1. Section reuses the existing boolean pattern: C function + CFFI + CLOS wrapper**
`boolean_section(a, b, compute_wire)` in C wraps `BRepAlgoAPI_Section`. The `compute_wire` flag (default false) calls `maker.ComputeWire()` before returning. Following the identical null-checks/IsDone/is_empty/exception pattern as the existing three booleans. The CLOS `section` function is variadic and nil-propagating, same as `cut`/`fuse`/`common`.

**2. Section result is a TopoDS_Shape — no special edge extraction API**
`BRepAlgoAPI_Section::Shape()` returns a compound of edges. This is returned through the existing `make-shape` path as a valid shape. No need for a new shape subclass — the shape is a valid topological entity that can be visualized, saved to STEP, or further processed.

**3. 2D booleans reuse existing cut/fuse/common — no new C functions needed**
Since `TopoDS_Face` inherits from `TopoDS_Shape`, the existing C functions accept faces directly. The only change is documentation and tests. The variadic pattern works identically: `(cut face-a face-b)`, `(fuse face-a face-b)`, `(common face-a face-b)`.

**4. Section signature: `(section shape1 &rest shapes)`**
Variadic for consistency with other booleans. Section always returns a compound of intersection edges — no `ComputeWire` option since it is not available in OCCT 8.0's `BRepAlgoAPI_Section` API.

**5. New Lisp source file: `src/core/booleans.lisp` (extending, not replacing)**
The existing `booleans.lisp` file already contains cut/fuse/common. The `section` function is added to this same file. No new source file needed.

## Risks / Trade-offs

- **Section result may contain degenerate edges**: OCCT may produce very small or degenerate edges at tangency. Mitigation: existing `is_empty_shape` check filters fully empty results; we document that section results may contain short edges.
- **2D boolean on non-coplanar faces**: If two faces are on different planes, `BRepAlgoAPI_Cut`/`Fuse`/`Common` still works but produces 3D results, not 2D. Mitigation: document that "2D boolean" assumes coplanar faces; results on non-coplanar faces are valid 3D shapes but may not behave as simple 2D region operations.
- **Backward compatibility**: No risk — `section` is a new symbol. Existing `cut`/`fuse`/`common` unchanged.
- **Build time**: Adding one new C function and `BRepAlgoAPI_Section.hxx` include requires recompiling `libocctwrap.so`. ~15-30s rebuild.

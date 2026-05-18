## Context

cl-occt currently wraps only 3D solid primitives and operations. There is no support for 2D geometry (points, vectors, curves) or boundary-representation construction (edges, wires, faces). The existing `make-prism` and `make-revol` functions operate on any shape but are most useful when given a planar face — which users currently have no way to construct. Adding 2D primitives and the BRepBuilderAPI pipeline closes this gap.

OCCT provides three layers for 2D/face work:
- **gp_***: lightweight 2D geometry types (gp_Pnt2d, gp_Vec2d, gp_Dir2d, gp_Ax2d, gp_XY)
- **Geom2d_***: handle-based 2D curves (Geom2d_Line, Geom2d_Circle, Geom2d_Ellipse)
- **BRepBuilderAPI**: edge/wire/face construction from 2D geometry

The gp_* types are value types (stack-allocated) — unlike TopoDS_Shape which is heap-allocated via `new`. For simplicity, the initial API passes coordinate pairs directly rather than wrapping gp_* as managed objects.

## Goals / Non-Goals

**Goals:**
- Edge construction from 2-point lines (2D and 3D)
- Edge construction from 2D full circles (center + radius)
- Edge construction from 2D circular arcs (3-point)
- Wire construction from a list of edges
- Planar face construction from a closed wire
- Face construction on a user-specified plane
- Full 4-layer implementation for each function: C wrapper → CFFI → CLOS API → package exports
- Smoke tests for valid construction and nil-on-error

**Non-Goals:**
- 3D curves (Geom_Curve) — 2D-only for now
- BSpline/Bezier curves — future work
- Surface construction beyond planar (cylindrical, spherical, etc.) — future work
- 2D Boolean operations
- Managed gp_Pnt2d/gp_Vec2d/gp_Dir2d objects — coordinate pairs passed directly
- Vertex construction as a separate type (edges implicitly create vertices)
- Offset, trimming, or projection operations

## Decisions

**1. Managed 2D geometry objects for gp_Pnt2d, gp_Vec2d, gp_Dir2d; edge functions accept raw doubles**
gp_Pnt2d/gp_Vec2d/gp_Dir2d are OCCT value types. They are heap-allocated as `void*` with a new type tag `occt_geom2d` and freed via `free_geom2d`. Each returns a CLOS `geom2d` instance with `tg:finalize` GC, following the existing `shape` pattern. Edge construction functions accept raw `(x y)` or `(x y z)` double arguments for ergonomics — users don't need to create managed point objects just to draw a line segment.

**2. Wire construction via edge pointer array**
`BRepBuilderAPI_MakeWire::Add()` is incremental, but the C wrapper exposes a single-shot `make_wire(occt_shape* edges, int count)`. The Lisp side allocates a CFFI foreign pointer array from a `&rest` edges list. This avoids per-edge C function calls while keeping the Lisp API idiomatic with `(make-wire e1 e2 e3)`.

**3. Planar face: face from wire auto-detects plane**
`BRepBuilderAPI_MakeFace(wire)` automatically computes the planar surface from the wire's edges. A separate `make-face-on-plane` variant accepts origin + normal vector for explicit plane specification. Both produce a TopoDS_Face.

**4. Face construction signature: `make-face wire`**
A single wire argument. The face is always planar. For non-planar faces, we add a separate path when needed. The function returns a shape (face) suitable for passing to `make-prism` or `make-revol`.

**5. New Lisp source file: `src/core/faces.lisp`**
Unlike the 3D primitives which all live in `primitives.lisp`, the 2D/face API is substantial enough to warrant its own file. Edge, wire, and face functions co-locate in `faces.lisp`. Helper function `%ptr` (extracting the C pointer from a shape) is already defined in the shape class.

**6. Managed 2D curve objects for Geom2d_Line, Geom2d_Circle**
2D curves (Geom2d_Line, Geom2d_Circle) are OCCT Handle types. They are heap-allocated as `void*` and returned as CLOS `geom2d` instances with `tg:finalize` GC. This enables users to construct curves programmatically and reuse them in edge construction (via an `edge-from-curve` function added later if needed).

**7. C function naming: snake_case, prefixed with `make_`**
Following existing convention: `make_pnt2d`, `make_vec2d`, `make_dir2d`, `make_line_2d`, `make_circle_2d`, `make_edge_line_2d`, `make_edge_circle_2d`, `make_edge_arc_2d`, `make_edge_line_3d`, `make_wire`, `make_face`, `make_face_on_plane`.

## Risks / Trade-offs

- **Wire validity depends on edge topology**: If edges don't form a closed chain, `BRepBuilderAPI_MakeFace` may return an invalid or null shape. Existing nil-propagation handles this (null pointer → Lisp sees nil). Mitigation: document that face construction expects a closed wire.
- **make-wire requires at least one edge**: An empty edge list produces nil. Mitigation: validate count > 0 in C wrapper.
- **3-point arc degeneracy**: If the three points are collinear, OCCT may fail. Mitigation: rely on existing error-handling pattern.
- **Backward compatibility**: No risk — all new symbols. Existing code unaffected.
- **Build time**: Adding ~100 lines of C++ and new OCCT includes requires recompiling `libocctwrap.so`. New includes: `BRepBuilderAPI_MakeEdge.hxx`, `BRepBuilderAPI_MakeWire.hxx`, `BRepBuilderAPI_MakeFace.hxx`, `gp_Pnt2d.hxx`, `GC_MakeArcOfCircle.hxx`, `Geom2d_Circle.hxx`, `GC_MakeSegment.hxx`, `gce_MakeCirc.hxx`.
- **CFFI pointer array for make-wire**: Uses `cffi:with-foreign-object` — standard CFFI technique, no additional dependencies.
- **Two managed type systems**: The 2D geometry objects (geom2d) and TopoDS_Shape objects have different OCCT types but share the same `tg:finalize` pattern. Both return nil on nullptr. geom2d objects are NOT shapes — they are a separate CLOS class `geom2d` with its own `%free-geom2d` CFFI function and `finalize` finalizer.
- **2D direction requires normalization**: `gp_Dir2d` constructor throws if given a zero vector. The C wrapper validates magnitude and returns nullptr if the input is degenerate.

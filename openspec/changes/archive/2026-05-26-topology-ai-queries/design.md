## Context

cl-occt currently exposes `map-shape-subshapes` and `count-shape-subshapes` via `TopExp_Explorer`, and `edge->curve`/`face->surface` via `BRepAdaptor`. This gives flat enumeration of subshapes but no graph traversal (face→edges, edge→vertices, adjacency) and no per-subshape geometric properties. An AI agent inspecting a shape gets anonymous shape pointers with no ability to distinguish "the top face" from "the side face."

New functions will follow the existing architecture:
- C wrappers in `occt_wrap_topology.cpp` (add to existing file)
- CFFI bindings appended to `src/ffi/bindings-topology.lisp`
- Core CLOS wrappers in `src/core/topology.lisp` (extend existing file) + new `src/core/subshape-properties.lisp`
- Tests in existing test files or new test files

## Goals / Non-Goals

**Goals:**
- Expose face→edge, edge→vertex, vertex→edge, edge→face, face→wire, wire→edge navigation
- Expose per-face (area, normal, center, surface-type, bounding-box) and per-edge (length, curve-type, bounding-box) properties
- Expose subshape orientation and type queries
- Update api-reference.md with all new signatures

**Non-Goals:**
- No viewer/rendering changes
- No changes to existing `map-shape-subshapes` API (backward compatible)
- No parametric naming (that's ocaf-parametric-foundation change)
- No curvature/tangent analysis beyond face normal (that's brep-analysis-tools change)

## Decisions

### 1. Topology navigation using TopExp_Explorer + TopExp
`TopExp_Explorer` already handles type-filtered traversal. For face→edges, use `TopExp_Explorer` with `TopAbs_EDGE` on a face. For edge→vertices, use `TopExp::Vertices`. For vertex→edges, use `TopExp_Explorer` with `TopAbs_EDGE` on the vertex's shape context. For edge→faces, iterate the owning shape's faces and check containment.

### 2. Per-subshape properties use BRepGProp + BRepAdaptor + BRepLProp
- Face area: `BRepGProp_Face` (or `BRepGProp::SurfaceProperties` on a single face)
- Edge length: `BRepGProp::LinearProperties` on a single edge
- Face normal: `BRepLProp_SLProps` at face center (UV = 0.5, 0.5 in normalized parametric space)
- Surface/curve type: `BRepAdaptor_Surface`/`BRepAdaptor_Curve` then `GetType()`
- Bounding box: `BRepBndLib::Add` on individual subshape
- Face center: evaluate `BRepAdaptor_Surface` at UV midpoint

### 3. File layout

| What | Where |
|------|-------|
| C face→edges, edge→vertices, etc. | `wrap/occt_wrap_topology.cpp` (extend existing file) |
| C face-area, edge-length, etc. | New `wrap/occt_wrap_props.cpp` |
| CFFI topology | `src/ffi/bindings-topology.lisp` (extend) |
| CFFI properties | New `src/ffi/bindings-properties.lisp` |
| Core navigation | `src/core/topology.lisp` (extend) |
| Core properties | New `src/core/subshape-properties.lisp` |
### 4. Return convention
- Face→edges returns a list of edge shapes (nil if no edges)
- Edge→vertices returns two values: start-vertex, end-vertex
- Vertex→edges returns a list of edge shapes
- Edge→faces returns a list of face shapes
- Property queries return the computed value or nil
- Orientation returns keyword or nil

### 5. API surface (preliminary)

```lisp
;; Topology navigation
(face-edges face)               → list of edges
(edge-vertices edge)            → start-vertex, end-vertex
(vertex-edges vertex)           → list of edges
(edge-faces edge shape)         → list of faces sharing edge
(face-wires face)               → list of wires (outer + holes)
(wire-edges wire)               → list of edges in order
(shape-type shape)              → :solid :face :edge :vertex :wire :shell :compound

;; Subshape properties
(face-area face)                → double-float or nil
(edge-length edge)              → double-float or nil
(face-normal-at-center face)    → nx, ny, nz
(face-surface-type face)        → keyword or nil
(edge-curve-type edge)          → keyword or nil
(face-bounding-box face)        → xmin, ymin, zmin, xmax, ymax, zmax
(edge-bounding-box edge)        → xmin, ymin, zmin, xmax, ymax, zmax
(face-center face)              → x, y, z
(subshape-orientation shape)    → :forward :reversed :internal :external
(subshape-bounding-box shape)   → xmin, ymin, zmin, xmax, ymax, zmax
(shape-extent-along shape dx dy dz) → min-proj, max-proj
```

## Risks / Trade-offs

- **Face→edges on a box returns 4 edges for each of 6 faces = 24 edge references, but only 12 unique edges.** OCCT uses shared topology so the same edge pointer will appear in two faces. This is correct (the edge IS shared) but callers need to be aware.
- **Face normal at center on a non-planar face** — the center UV is a heuristic. For cylindrical faces the normal is radial; for spherical faces it's radial from sphere center. This is the natural behavior of `BRepLProp_SLProps`.
- **Edge→faces requires a parent shape context.** An edge alone doesn't know which faces reference it. The API will take the edge and optionally a parent shape. Without a parent shape, the result is limited.
- **Performance:** computing face area for all 6 faces of a box involves 6 `BRepGProp_Face` calls. For shapes with thousands of faces, this will be slow. Callers should use targeted queries when possible.

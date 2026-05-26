## 1. C Wrapper — Topology Navigation

- [x] 1.1 Add `#include <TopExp.hxx>` and `#include <TopExp_Explorer.hxx>` and `#include <TopTools_IndexedMapOfShape.hxx>` to `occt_wrap_topology.cpp`
- [x] 1.2 Implement `face_edges` in `occt_wrap_topology.cpp`: accept face shape, return array of edge pointers + count via output params
- [x] 1.3 Implement `edge_vertices` in `occt_wrap_topology.cpp`: accept edge, output start and end vertex pointers, return success flag
- [x] 1.4 Implement `vertex_edges` in `occt_wrap_topology.cpp`: accept vertex, return array of incident edge pointers + count
- [x] 1.5 Implement `edge_faces` in `occt_wrap_topology.cpp`: accept edge + parent shape, return array of face pointers + count
- [x] 1.6 Implement `face_wires` in `occt_wrap_topology.cpp`: accept face, return array of wire pointers + count
- [x] 1.7 Implement `wire_edges` in `occt_wrap_topology.cpp`: accept wire, return ordered array of edge pointers + count using BRepTools_WireExplorer
- [x] 1.8 Implement `shape_type_int` in `occt_wrap_topology.cpp`: accept shape, return integer shape type (TopAbs enum)
- [x] 1.9 Implement `shape_orientation_int` in `occt_wrap_topology.cpp`: accept shape, return integer orientation (TopAbs enum)
- [x] 1.10 Declare all new functions in `occt_wrap_topology.h`

## 2. C Wrapper — Subshape Properties

- [x] 2.1 Add `#include <BRepGProp.hxx>`, `#include <BRepGProp_Face.hxx>`, `#include <BRepLProp_SLProps.hxx>`, `#include <BRepAdaptor_Surface.hxx>`, `#include <BRepAdaptor_Curve.hxx>`, `#include <BRepBndLib.hxx>`, `#include <Bnd_Box.hxx>` to new `wrap/occt_wrap_props.cpp`
- [x] 2.2 Implement `face_area` in `occt_wrap_props.cpp`: accept face, return area via BRepGProp_Face
- [x] 2.3 Implement `edge_length` in `occt_wrap_props.cpp`: accept edge, return length via BRepGProp::LinearProperties
- [x] 2.4 Implement `face_normal_at_center` in `occt_wrap_props.cpp`: accept face, compute center UV via BRepAdaptor_Surface, evaluate normal via BRepLProp_SLProps, return nx ny nz
- [x] 2.5 Implement `face_surface_type` in `occt_wrap_props.cpp`: accept face, return integer surface type from BRepAdaptor_Surface::GetType
- [x] 2.6 Implement `edge_curve_type` in `occt_wrap_props.cpp`: accept edge, return integer curve type from BRepAdaptor_Curve::GetType
- [x] 2.7 Implement `subshape_bounding_box` in `occt_wrap_props.cpp`: accept any shape, return bounding box via BRepBndLib::Add
- [x] 2.8 Implement `face_center` in `occt_wrap_props.cpp`: accept face, compute UV midpoint and evaluate 3D point
- [x] 2.9 Implement `shape_extent_along` in `occt_wrap_props.cpp`: accept shape + direction, compute min/max projection of bounding box onto axis
- [x] 2.10 Declare all new functions in new `wrap/occt_wrap_props.h`

## 3. CFFI Bindings

- [x] 3.1 Add CFFI `defcfun` bindings for all 10 topology navigation C functions in `src/ffi/bindings-topology.lisp`
- [x] 3.2 Add CFFI `defcfun` bindings for all 8 subshape properties C functions in new `src/ffi/bindings-properties.lisp`
- [x] 3.3 Add type mapping helpers (TopAbs enum to keyword, GeomAbs enum to keyword) in the CFFI layer

## 4. Core CLOS Wrappers — Topology Navigation

- [x] 4.1 Implement `face-edges` in `src/core/topology.lisp`: call `%face-edges`, wrap C pointers with `make-shape`, nil propagation
- [x] 4.2 Implement `edge-vertices` in `src/core/topology.lisp`: call `%edge-vertices`, return two values
- [x] 4.3 Implement `vertex-edges` in `src/core/topology.lisp`: call `%vertex-edges`, wrap C pointers
- [x] 4.4 Implement `edge-faces` in `src/core/topology.lisp`: call `%edge-faces` with parent shape, wrap C pointers
- [x] 4.5 Implement `face-wires` in `src/core/topology.lisp`: call `%face-wires`, wrap C pointers
- [x] 4.6 Implement `wire-edges` in `src/core/topology.lisp`: call `%wire-edges`, wrap C pointers
- [x] 4.7 Implement `shape-type` in `src/core/topology.lisp`: call `%shape-type-int`, map integer to keyword via `*shape-type-map*`
- [x] 4.8 Implement `subshape-orientation` in `src/core/topology.lisp`: call `%shape-orientation-int`, add orientation keyword map
## 5. Core CLOS Wrappers — Subshape Properties

- [x] 5.1 Create `src/core/subshape-properties.lisp` with `face-area`: call `%face-area`, nil propagation
- [x] 5.2 Implement `edge-length`: call `%edge-length`, nil propagation
- [x] 5.3 Implement `face-normal-at-center`: call `%face-normal-at-center`, return three values
- [x] 5.4 Implement `face-surface-type`: call `%face-surface-type`, map integer to keyword via surface-kind->keyword
- [x] 5.5 Implement `edge-curve-type`: call `%edge-curve-type`, map integer to keyword via curve-kind->keyword
- [x] 5.6 Implement `face-bounding-box`: call `%subshape-bounding-box`, return six values
- [x] 5.7 Implement `edge-bounding-box`: call `%subshape-bounding-box`, return six values
- [x] 5.8 Implement `subshape-bounding-box`: generic wrapper accepting any shape
- [x] 5.9 Implement `face-center`: call `%face-center`, return three values
- [x] 5.10 Implement `shape-extent-along`: call `%shape-extent-along`, return two values

## 6. System Integration

- [x] 7.1 Add new core files (`subshape-properties.lisp`) to `cl-occt.asd`
- [x] 7.2 Add new wrap files (`occt_wrap_props.cpp`, `occt_wrap_props.h`) to `wrap/Makefile`
- [x] 7.3 Export new public symbols from `src/package.lisp` (`cl-occt` and `cl-occt.impl`)

## 8. Tests

- [x] 8.1 Add topology navigation tests: face->edges, edge->vertices, vertex->edges, edge->faces, face->wires, wire->edges on a box
- [x] 8.2 Add shape-type tests: box returns :solid, wire returns :wire
- [x] 8.3 Add orientation tests: forward/reversed on box faces and edges
- [x] 8.4 Add face-area tests: known areas on a box, nil on nil
- [x] 8.5 Add edge-length tests: known lengths on a box, nil on nil
- [x] 8.6 Add face-normal tests: outward normals on box faces
- [x] 8.7 Add surface/curve type tests: planar faces, linear edges on box
- [x] 8.8 Add bounding-box tests: per-face, per-edge, per-vertex
- [x] 8.9 Add face-center and extent-along tests
- [x] 8.10 Register all new tests in the test runner function

## 9. Documentation

- [x] 9.1 Add "Topology Navigation" section to `doc/api-reference.md` covering face-edges, edge-vertices, vertex-edges, edge-faces, face-wires, wire-edges, shape-type, subshape-orientation
- [x] 9.2 Add "Subshape Properties" section to `doc/api-reference.md` covering face-area, edge-length, face-normal-at-center, face-surface-type, edge-curve-type, face-bounding-box, edge-bounding-box, subshape-bounding-box, face-center, shape-extent-along

## 10. Build & Verify

- [x] 10.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 10.2 Run `just test-all` to verify all new and existing tests pass

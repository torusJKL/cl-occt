## 1. C Wrapper — Header declarations

- [x] 1.1 Add `make_pnt2d`, `make_vec2d`, `make_dir2d`, `free_geom2d` to `wrap/occt_wrap.h`
- [x] 1.2 Add `make_line_2d`, `make_circle_2d` to `wrap/occt_wrap.h`
- [x] 1.3 Add `make_edge_line_2d`, `make_edge_line_3d`, `make_edge_circle_2d`, `make_edge_arc_2d` to `wrap/occt_wrap.h`
- [x] 1.4 Add `make_wire`, `make_face`, `make_face_on_plane` to `wrap/occt_wrap.h`

## 2. C Wrapper — 2D geometry implementations

- [x] 2.1 Add OCCT includes for gp_Pnt2d, gp_Vec2d, gp_Dir2d, gp_Ax2d, gp_XY, Geom2d, GC, BRepBuilderAPI to `wrap/occt_wrap.cpp`
- [x] 2.2 Implement `make_pnt2d(x, y)` with `new gp_Pnt2d(x, y)`, returning `void*`
- [x] 2.3 Implement `make_vec2d(x, y)` with `new gp_Vec2d(x, y)`, returning `void*`
- [x] 2.4 Implement `make_dir2d(x, y)` with `new gp_Dir2d(x, y)`, validating non-zero magnitude
- [x] 2.5 Implement `free_geom2d(ptr)` via tagged Geom2dObj struct deleting the inner object by kind

## 3. C Wrapper — 2D curve implementations

- [x] 3.1 Implement `make_line_2d(x, y, dx, dy)` creating Geom2d_Line via Handle, returning as `void*`
- [x] 3.2 Implement `make_circle_2d(x, y, radius)` creating Geom2d_Circle via Handle, validating positive radius, returning as `void*`

## 4. C Wrapper — Edge construction implementations

- [x] 4.1 Implement `make_edge_line_2d(x1, y1, x2, y2)` via BRepBuilderAPI_MakeEdge with two gp_Pnt2d, returning occt_shape
- [x] 4.2 Implement `make_edge_line_3d(x1, y1, z1, x2, y2, z2)` via BRepBuilderAPI_MakeEdge with two gp_Pnt, returning occt_shape
- [x] 4.3 Implement `make_edge_circle_2d(x, y, radius)` via BRepBuilderAPI_MakeEdge with Geom2d_Circle, returning occt_shape
- [x] 4.4 Implement `make_edge_arc_2d(x1, y1, x2, y2, x3, y3)` via GC_MakeArcOfCircle + BRepBuilderAPI_MakeEdge, returning occt_shape

## 5. C Wrapper — Wire and face construction implementations

- [x] 5.1 Implement `make_wire(occt_shape* edges, int count)` via BRepBuilderAPI_MakeWire with Add loop, returning occt_shape
- [x] 5.2 Implement `make_face(occt_shape wire)` via BRepBuilderAPI_MakeFace, returning occt_shape
- [x] 5.3 Implement `make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz)` via BRepBuilderAPI_MakeFace with explicit gp_Pln, returning occt_shape

## 6. CFFI Bindings

- [x] 6.1 Add `%make-pnt2d`, `%make-vec2d`, `%make-dir2d`, `%free-geom2d` to `src/ffi/bindings.lisp`
- [x] 6.2 Add `%make-line-2d`, `%make-circle-2d` to `src/ffi/bindings.lisp`
- [x] 6.3 Add `%make-edge-line-2d`, `%make-edge-line-3d`, `%make-edge-circle-2d`, `%make-edge-arc-2d` to `src/ffi/bindings.lisp`
- [x] 6.4 Add `%make-wire`, `%make-face`, `%make-face-on-plane` to `src/ffi/bindings.lisp`

## 7. Core API — geom2d class and 2D primitives

- [x] 7.1 Create `src/core/geom2d.lisp` with `geom2d` CLOS class, `geom2d-p` predicate, `%ptr` reader, and `tg:finalize` that calls `%free-geom2d`
- [x] 7.2 Implement `make-geom2d` helper (wraps pointer in geom2d instance, returns nil on null)
- [x] 7.3 Implement `make-pnt2d`, `make-vec2d`, `make-dir2d` in geom2d.lisp

## 8. Core API — 2D curves

- [x] 8.1 Implement `make-line2d`, `make-circle2d` in geom2d.lisp

## 9. Core API — Face construction

- [x] 9.1 Create `src/core/faces.lisp` with face construction functions
- [x] 9.2 Implement `make-edge` (2-point 2D), `make-edge-3d` (2-point 3D) using `make-shape` from primitives.lisp
- [x] 9.3 Implement `make-circle-edge`, `make-circular-arc` using `make-shape`
- [x] 9.4 Implement `make-wire` with `&rest edges`, using `cffi:with-foreign-object` for pointer array
- [x] 9.5 Implement `make-face`, `make-face-on-plane` using `make-shape`

## 10. Package exports

- [x] 10.1 Export new `%` symbols from `cl-occt.impl` in `src/package.lisp`
- [x] 10.2 Export new public symbols (`geom2d`, `geom2d-p`, `make-pnt2d`, `make-vec2d`, `make-dir2d`, `make-line2d`, `make-circle2d`, `make-edge`, `make-edge-3d`, `make-circle-edge`, `make-circular-arc`, `make-wire`, `make-face`, `make-face-on-plane`) from `cl-occt` in `src/package.lisp`

## 11. ASDF update

- [x] 11.1 Register `src/core/geom2d.lisp` and `src/core/faces.lisp` in `cl-occt.asd`

## 12. Smoke tests

- [x] 12.1 Add 2D geometry tests: pnt2d valid, vec2d valid, dir2d valid, dir2d zero vector
- [x] 12.2 Add 2D curve tests: line2d valid, circle2d valid, circle2d zero radius
- [x] 12.3 Add edge tests: make-edge valid, make-edge-3d valid, make-circle-edge valid, make-circular-arc valid, make-circular-arc collinear
- [x] 12.4 Add wire tests: make-wire valid, make-wire empty
- [x] 12.5 Add face tests: make-face from square wire, make-face nil, face-on-plane
- [x] 12.6 Register all new tests in `run-tests` list

## 13. README update

- [x] 13.1 Add `geom2d` and `geom2d-p` to the type/class section
- [x] 13.2 Add face construction API table: `make-edge`, `make-edge-3d`, `make-circle-edge`, `make-circular-arc`, `make-wire`, `make-face`, `make-face-on-plane`
- [x] 13.3 Add 2D geometry API: `make-pnt2d`, `make-vec2d`, `make-dir2d`, `make-line2d`, `make-circle2d`
- [x] 13.4 Update function counts in architecture/structure sections
- [x] 13.5 Update file list: add `geom2d.lisp` and `faces.lisp`

## 14. Build & verify

- [x] 14.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 14.2 Run smoke tests with `(cl-occt::run-tests)`

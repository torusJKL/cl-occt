## 1. C Wrapper — Header Declarations

- [x] 1.1 Add `#include` directives for all 13 AIS classes in `occt_wrap.cpp`
- [x] 1.2 Add `extern "C"` function declarations in `occt_wrap.h` for all new wrapper functions

## 2. C Wrapper — AIS_ColoredShape

- [x] 2.1 Implement `ais_create_colored_shape(occt_shape shape)` — wraps `AIS_ColoredShape(shape)`
- [x] 2.2 Implement `ais_colored_shape_set_color(obj, occt_shape sub, double r, double g, double b)` — set color for a sub-shape

## 3. C Wrapper — AIS_Manipulator

- [x] 3.1 Implement `ais_create_manipulator()` — construct `AIS_Manipulator`
- [x] 3.2 Implement `ais_manipulator_attach(obj, occt_shape)` — `Attach(shape)`
- [x] 3.3 Implement `ais_manipulator_set_position(obj, double x, double y, double z)` — `SetPosition(gp_Pnt)`
- [x] 3.4 Implement `ais_manipulator_set_size(obj, double size)` — `SetSize(size)`
- [x] 3.5 Implement `ais_manipulator_set_active_axes(obj, int translate, int rotate, int scale)` — `SetActiveModes`

## 4. C Wrapper — AIS_ConnectedInteractive, AIS_MultipleConnectedInteractive

- [x] 4.1 Implement `ais_create_connected(void* src)` — construct `AIS_ConnectedInteractive`, `Connect(src)`
- [x] 4.2 Implement `ais_create_multiple_connected()` — construct `AIS_MultipleConnectedInteractive`
- [x] 4.3 Implement `ais_multiple_connected_connect(void* obj, void* src)` — `Connect(src)`

## 5. C Wrapper — AIS_PointCloud & AIS_Triangulation

- [x] 5.1 Implement `ais_create_point_cloud(double* verts, int count)` — construct from flat double array of (x,y,z) triples
- [x] 5.2 Implement `ais_point_cloud_set_colors(obj, double* colors, int count)` — per-point RGB colors
- [x] 5.3 Implement `ais_point_cloud_set_size(obj, double size)` — point size in pixels
- [x] 5.4 Implement `ais_create_triangulation(double* verts, int vcount, int* tris, int tcount, double* colors)` — construct colored triangulation

## 6. C Wrapper — Construction Geometry (AIS_Plane, AIS_Axis, AIS_Line, AIS_Circle)

- [x] 6.1 Implement `ais_create_plane(double ox, double oy, double oz, double nx, double ny, double nz, double size)`
- [x] 6.2 Implement `ais_create_axis(double ox, double oy, double oz, double dx, double dy, double dz)`
- [x] 6.3 Implement `ais_create_line(double x1, double y1, double z1, double x2, double y2, double z2)`
- [x] 6.4 Implement `ais_create_circle(double cx, double cy, double cz, double nx, double ny, double nz, double radius)`

## 7. C Wrapper — AIS_TexturedShape, AIS_ViewCube, AIS_ColorScale, AIS_LightSource

- [x] 7.1 Implement `ais_create_textured_shape(occt_shape shape, const char* filename)` — texture from file
- [x] 7.2 Implement `ais_textured_shape_set_repeat(obj, double u, double v)` — texture repeat
- [x] 7.3 Implement `ais_textured_shape_set_origin(obj, double u, double v)` — texture origin
- [x] 7.4 Implement `ais_create_view_cube()` — construct `AIS_ViewCube`
- [x] 7.5 Implement `ais_view_cube_set_size(obj, double size)` — cube size
- [x] 7.6 Implement `ais_view_cube_set_box_color(obj, double r, double g, double b)` — face color
- [x] 7.7 Implement `ais_view_cube_set_corner(obj, int corner)` — corner position
- [x] 7.8 Implement `ais_create_color_scale()` — construct `AIS_ColorScale`
- [x] 7.9 Implement `ais_color_scale_set_range(obj, double min, double max)` — value range
- [x] 7.10 Implement `ais_color_scale_set_size(obj, double w, double h)` — widget dimensions
- [x] 7.11 Implement `ais_color_scale_set_title(obj, const char* title)` — title text
- [x] 7.12 Implement `ais_color_scale_set_intervals(obj, int n)` — color intervals
- [x] 7.13 Implement `ais_create_light_source(void* light)` — wrap a viewer light in AIS_LightSource

## 8. CFFI Bindings

- [x] 8.1 Add `defcfun` forms in `src/ffi/bindings.lisp` for all new C wrapper functions (all `%`-prefixed)

## 9. Package Exports

- [x] 9.1 Add `%`-prefixed CFFI symbols to `cl-occt.impl` package exports in `src/package.lisp`
- [x] 9.2 Add public API symbols to `cl-occt` package exports in `src/package.lisp`

## 10. Core Lisp — Viewer AIS Types File

- [x] 10.1 Create `src/core/viewer-ais-types.lisp` with `(in-package :cl-occt)` header
- [x] 10.2 Add `make-colored-shape` constructor (CLOS wrapper around `%ais-create-colored-shape`)
- [x] 10.3 Add `make-manipulator`, `set-manipulator-position`, `set-manipulator-size`, `attach-manipulator`, `set-manipulator-active-axes`
- [x] 10.4 Add `make-connected-interactive`
- [x] 10.5 Add `make-point-cloud`, `set-point-cloud-colors`, `set-point-cloud-size`
- [x] 10.6 Add `make-ais-plane`, `make-ais-axis`, `make-ais-line`, `make-ais-circle`
- [x] 10.7 Add `make-textured-shape`, `set-texture-repeat`, `set-texture-origin`
- [x] 10.8 Add `make-view-cube`, `set-view-cube-size`, `set-view-cube-box-color`, `set-view-cube-corner`
- [x] 10.9 Add `make-ais-triangulation`
- [x] 10.10 Add `make-color-scale`, `set-color-scale-range`, `set-color-scale-size`, `set-color-scale-title`, `set-color-scale-intervals`
- [x] 10.11 Add `make-light-source`
- [x] 10.12 Add `make-multiple-connected`, `connect-to-multiple`

## 11. Build Verification

- [x] 11.1 Rebuild `lib/libocctwrap.so` with `just wrap` — verify no compiler errors
- [x] 11.2 Load system with `just start` or `just repl` — verify no reader/package errors

## 12. Unit Tests

- [x] 12.1 Add `make-colored-shape` creation and display test
- [x] 12.2 Add manipulator creation, position, size, attach tests
- [x] 12.3 Add connected-interactive creation and display test
- [x] 12.4 Add point cloud creation and property tests
- [x] 12.5 Add construction geometry (plane/axis/line/circle) creation and display test
- [x] 12.6 Add textured shape creation test
- [x] 12.7 Add view cube creation and property tests
- [x] 12.8 Add triangulation creation and display test
- [x] 12.9 Add color scale creation and property tests
- [x] 12.10 Add light source creation and display test
- [x] 12.11 Add multiple-connected creation and connect test
- [x] 12.12 Run `just test-core` to verify all new tests pass

## 13. Documentation

- [x] 13.1 Add "AIS Interactive Types" section to `docs/api-reference.md` with function signatures and descriptions for all new types
- [x] 13.2 Add Lisp REPL usage examples for each new AIS type

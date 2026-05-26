## 1. C Wrapper — Graphic3d_ClipPlane

- [x] 1.1 Add `#include <Graphic3d_ClipPlane.hxx>` to `wrap/occt_wrap.cpp`
- [x] 1.2 Write C wrapper functions: `graphic3d_clip_plane_new`, `graphic3d_clip_plane_free`, `graphic3d_clip_plane_set_equation`, `graphic3d_clip_plane_get_equation`, `graphic3d_clip_plane_set_on`, `graphic3d_clip_plane_is_on`, `graphic3d_clip_plane_set_capping`, `graphic3d_clip_plane_set_cap_color`

## 2. C Wrapper — Graphic3d_ShaderProgram

- [x] 2.1 Add `#include <Graphic3d_ShaderProgram.hxx>` to `wrap/occt_wrap.cpp`
- [x] 2.2 Write C wrapper functions: `graphic3d_shader_program_new`, `graphic3d_shader_program_free`, `graphic3d_shader_program_set_vertex_source`, `graphic3d_shader_program_set_fragment_source`, `graphic3d_shader_program_set_header`

## 3. C Wrapper — Graphic3d Aspects (FillArea, Line, Marker, Text)

- [x] 3.1 Add includes: `Graphic3d_AspectFillArea3d.hxx`, `Graphic3d_AspectLine3d.hxx`, `Graphic3d_AspectMarker3d.hxx`, `Graphic3d_AspectText3d.hxx`
- [x] 3.2 Write C wrappers for `Graphic3d_AspectFillArea3d`: create/free, interior style, color, edge color, edge line type
- [x] 3.3 Write C wrappers for `Graphic3d_AspectLine3d`: create/free, color, type, width
- [x] 3.4 Write C wrappers for `Graphic3d_AspectMarker3d`: create/free, color, marker type, scale
- [x] 3.5 Write C wrappers for `Graphic3d_AspectText3d`: create/free, color, font, style

## 4. C Wrapper — Graphic3d_Structure

- [x] 4.1 Add `#include <Graphic3d_Structure.hxx>` to `wrap/occt_wrap.cpp`
- [x] 4.2 Write C wrapper functions: create/free, set visible, set transform, remove transform, add child, remove child, display in viewer, erase

## 5. C Wrapper — Graphic3d_Group

- [x] 5.1 Add `#include <Graphic3d_Group.hxx>` and `Graphic3d_ArrayOfPrimitives.hxx` includes
- [x] 5.2 Write C wrapper functions: create group, free group, set visible, add triangles, add lines, add points, add text, set aspect, set line aspect
- [x] 5.3 Add primitive array creation helpers: `graphic3d_array_triangles_new`, `graphic3d_array_lines_new`, `graphic3d_array_points_new` with vertex/normal/color data

## 6. C Wrapper — Graphic3d_RenderingParams

- [x] 6.1 Add `#include <Graphic3d_RenderingParams.hxx>` include
- [x] 6.2 Write C wrapper functions: get params from view, get/set rendering method, get/set ray-tracing depth, enable/disable shadows/reflections/AA, get/set gamma

## 7. C Wrapper — Declarations in Header

- [x] 7.1 Add all new C wrapper function declarations to `wrap/occt_wrap.h`

## 8. CFFI Bindings

- [x] 8.1 Add `%`-prefixed `defcfun` declarations in `src/ffi/bindings.lisp` for all new clip-plane wrapper functions
- [x] 8.2 Add `defcfun` declarations for shader-program wrapper functions
- [x] 8.3 Add `defcfun` declarations for all four aspect wrapper functions
- [x] 8.4 Add `defcfun` declarations for structure wrapper functions
- [x] 8.5 Add `defcfun` declarations for group and array primitive wrapper functions
- [x] 8.6 Add `defcfun` declarations for rendering-params wrapper functions

## 9. CLOS Wrappers — Core Lisp Modules

- [x] 9.1 Create `src/core/graphic3d-clip-plane.lisp` with `clip-plane` class, `make-clip-plane`, `free-clip-plane`, `clip-plane-p`, equation/on/capping accessors
- [x] 9.2 Create `src/core/graphic3d-shader-program.lisp` with `shader-program` class, `make-shader-program`, `free-shader-program`, `shader-program-p`, source/header setters
- [x] 9.3 Create `src/core/graphic3d-aspects.lisp` with four CLOS classes, constructors, predicates, property accessors, and keyword-enum maps for interior styles, line types, marker types, text styles
- [x] 9.4 Create `src/core/graphic3d-structure.lisp` with `graphic-structure` class, `make-graphic-structure`, `free-graphic-structure`, visibility, transform, hierarchy, display/erase
- [x] 9.5 Create `src/core/graphic3d-group.lisp` with `graphic-group` class, `make-graphic-group`, predicate, visibility, primitive append functions, aspect setters
- [x] 9.6 Create `src/core/graphic3d-rendering-params.lisp` with `rendering-params` class, `viewer-rendering-params`, method/depth/shadows/reflections/AA/gamma accessors

## 10. Package Exports and System Registration

- [x] 10.1 Add all public API symbols to `src/package.lisp` in the `cl-occt` package
- [x] 10.2 Add new source files to `cl-occt.asd` system definition

## 11. Tests

- [x] 11.1 Add clip-plane unit tests (create/free, equation, on/off, capping)
- [x] 11.2 Add shader-program unit tests (create/free, set sources)
- [x] 11.3 Add aspect unit tests (create all four aspect types, get/set properties)
- [x] 11.4 Add structure unit tests (create/free, visibility, transform, hierarchy)
- [x] 11.5 Add group unit tests (create, add primitives, set aspect)
- [x] 11.6 Add rendering-params unit tests (get from view, set/get params)

## 12. API Reference Documentation

- [x] 12.1 Add clip-plane API function table to `docs/api-reference.md`
- [x] 12.2 Add shader-program API function table to `docs/api-reference.md`
- [x] 12.3 Add aspect-fill-area, aspect-line, aspect-marker, aspect-text API function tables to `docs/api-reference.md`
- [x] 12.4 Add graphic-structure API function table to `docs/api-reference.md`
- [x] 12.5 Add graphic-group API function table to `docs/api-reference.md`
- [x] 12.6 Add rendering-params API function table to `docs/api-reference.md`

## 13. Verification

- [x] 13.1 Compile C wrapper (`just wrap`)
- [x] 13.2 Run core tests (`just test-core`) — 497 pass, 1 pre-existing fail
- [x] 13.3 Run all tests (`just test-all`)
- [x] 13.4 Verify api-reference.md renders correctly

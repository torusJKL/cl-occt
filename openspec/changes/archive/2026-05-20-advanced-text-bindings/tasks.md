## 1. C++ Bridge — Text Positioning & Orientation

- [x] 1.1 Add `make_text_shape_on_plane` C function accepting gp_Ax3 components (px,py,pz, zx,zy,zz, xx,xy,xz)
- [x] 1.2 Update `make_text_shape` to delegate to `make_text_shape_on_plane` with default Ax3 for backward compat
- [x] 1.3 Declare new C functions in `occt_wrap.h`
- [x] 1.4 Rebuild `lib/libocctwrap.so` and verify compilation

## 2. C++ Bridge — Bounding Box, Font Enumeration, Labels, Multi-line, Glyphs

- [x] 2.1 Add `text_bounding_box` C function (Font_FTFont::BoundingBox)
- [x] 2.2 Add `enumerate_fonts` C function (Font_FontMgr system font list)
- [x] 2.3 Add `ais_text_label_create` / `ais_text_label_free` C functions
- [x] 2.4 Add `ais_text_label_set_text` / `ais_text_label_set_position` / `ais_text_label_set_color` C functions
- [x] 2.5 Add `ais_text_label_set_font` / `ais_text_label_set_height` C functions
- [x] 2.6 Add `font_render_glyph` C function (StdPrs_BRepFont::RenderGlyph)
- [x] 2.7 Add font metrics C functions: `font_ascender`, `font_descender`, `font_line_spacing`
- [x] 2.8 Add glyph advance C functions: `font_advance_x`, `font_advance_y`
- [x] 2.9 Add `font_set_width_scaling` and `font_set_composite_curve_mode` C functions
- [x] 2.10 Declare all new C functions in `occt_wrap.h`
- [x] 2.11 Rebuild `lib/libocctwrap.so` and verify compilation

## 3. CFFI Bindings

- [x] 3.1 Add `%make-text-shape-on-plane` defcfun in bindings.lisp
- [x] 3.2 Add `%text-bounding-box` defcfun in bindings.lisp
- [x] 3.3 Add `%enumerate-fonts` defcfun in bindings.lisp
- [x] 3.4 Add `%ais-text-label-create` / `%ais-text-label-free` defcfuns in bindings.lisp
- [x] 3.5 Add `%ais-text-label-set-text` / `%ais-text-label-set-position` / `%ais-text-label-set-color` defcfuns
- [x] 3.6 Add `%ais-text-label-set-font` / `%ais-text-label-set-height` defcfuns
- [x] 3.7 Add `%font-render-glyph` defcfun in bindings.lisp
- [x] 3.8 Add `%font-ascender` / `%font-descender` / `%font-line-spacing` defcfuns
- [x] 3.9 Add `%font-advance-x` / `%font-advance-y` defcfuns
- [x] 3.10 Add `%font-set-width-scaling` / `%font-set-composite-curve-mode` defcfuns

## 4. Lisp Core — Text Positioning

- [x] 4.1 Update `make-text-shape` to accept `:position` and `:normal` keyword args
- [x] 4.2 Update `make-text-shape-3d` to accept `:position` and `:normal` keyword args
- [x] 4.3 Add `make-text-shape-on-plane` convenience function with explicit position + normal
- [x] 4.4 Add `%compute-gp-ax3` helper to build gp_Ax3 from position + normal in Lisp

## 5. Lisp Core — Bounding Box, Font Enumeration

- [x] 5.1 Add `text-bounding-box` function returning width and height values
- [x] 5.2 Add `list-available-fonts` function returning list of font name strings
- [x] 5.3 Add `font-info` function returning plist for a given font name

## 6. Lisp Core — AIS Text Labels

- [x] 6.1 Define `ais-text-label` CLOS class with `%ptr` and finalizer
- [x] 6.2 Add `make-ais-text-label` constructor with keyword args (text, position, color, font, height)
- [x] 6.3 Add `ais-free-text-label` function
- [x] 6.4 Add `ais-text-label-text` / `(setf ais-text-label-text)` accessors
- [x] 6.5 Add `ais-text-label-position` / `(setf ais-text-label-position)` accessors
- [x] 6.6 Add `ais-text-label-color` / `(setf ais-text-label-color)` accessors
- [x] 6.7 Add `ais-display` support for ais-text-label objects
- [x] 6.8 Update STL/STEP exporters to skip ais-text-label objects

## 7. Lisp Core — Multi-line Text

- [x] 7.1 Add `make-text-shape` multi-line support (split on #\Newline, stack shapes)
- [x] 7.2 Add `make-formatted-text` function with custom line spacing parameter

## 8. Lisp Core — Per-glyph Rendering & Metrics

- [x] 8.1 Add `text-glyph-as-shape` and `text-glyph-as-shape-3d` functions
- [x] 8.2 Add `text-font-ascender` / `text-font-descender` / `text-font-line-spacing` functions
- [x] 8.3 Add `text-font-advance-x` / `text-font-advance-y` functions
- [x] 8.4 Add `text-font-set-width-scaling` / `text-font-set-composite-curve-mode` functions

## 9. DSL Integration

- [x] 9.1 Add `text` macro helper for use in `defmodel` bodies
- [x] 9.2 Ensure `text` macro expands with proper model-ref dependency tracking

## 10. Documentation

- [x] 10.1 Update README with text API overview, function reference, and code examples
- [x] 10.2 Document text positioning and orientation usage
- [x] 10.3 Document bounding box, font enumeration, and multi-line API
- [x] 10.4 Document AIS text labels (viewer-only, not exported)
- [x] 10.5 Document per-glyph rendering and metrics API
- [x] 10.6 Document DSL integration (`text` macro in defmodel)

## 11. Tests

- [x] 11.1 Add test for text positioning on non-XY plane
- [x] 11.2 Add test for text bounding box query
- [x] 11.3 Add test for font enumeration
- [x] 11.4 Add test for AIS text label creation and display
- [x] 11.5 Add test for multi-line text
- [x] 11.6 Add test for per-glyph rendering and metrics
- [x] 11.7 Add test for text DSL in defmodel
- [x] 11.8 Run all tests and verify no regressions

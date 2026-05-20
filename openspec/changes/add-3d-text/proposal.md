## Why

Users need to create 3D text from TrueType fonts as part of parametric CAD models. OCCT 8.0 includes `StdPrs_BRepFont` and `StdPrs_BRepTextBuilder` for rendering glyphs as BRep shapes, but these are not yet exposed through the C wrapper or CLOS API. Adding this unlocks text engraving, labeling, signage, and decorative elements in parametric models.

## What Changes

- New `brep-font` CLOS type wrapping OCCT `StdPrs_BRepFont`
- New `make-brep-font-from-file` function (load TTF by file path)
- New `make-brep-font-from-name` function (look up system font by name)
- New `make-text-shape` function (render text as a flat BRep face compound on XY plane)
- New `make-text-shape-3d` convenience function (flat text + extrusion)
- New C wrapper functions in `wrap/occt_wrap.h`/`.cpp`
- New CFFI bindings in `src/ffi/bindings.lisp`
- New source file `src/core/text.lisp`
- New unit tests in `t/smoke-tests.lisp`
- README update with usage examples

## Capabilities

### New Capabilities

- `font-text`: Loading TrueType/OpenType fonts and rendering text strings as 2D and 3D BRep shapes. Supports font file path and system font name lookup, font aspect (regular/bold/italic/bold-italic), text alignment (horizontal and vertical), UTF-8 input, and extrusion into 3D.

### Modified Capabilities

_(none — all other capabilities unchanged)_

## Impact

- `wrap/occt_wrap.h` — add `occt_brep_font` type and 4 function declarations
- `wrap/occt_wrap.cpp` — add `#include` for font headers, implement 4 functions
- `src/ffi/bindings.lisp` — add 4 `defcfun` forms, export symbols
- `src/core/text.lisp` — **new file** with `brep-font` class and text API functions
- `src/package.lisp` — export new symbols from both packages
- `t/smoke-tests.lisp` — add font/text unit tests
- `README.md` — add usage section for 3D text
- `justfile` — no change needed (TKService already linked)
- No new native dependencies (OCCT + FreeType already present)

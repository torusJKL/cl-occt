## Context

OCCT 8.0 provides `StdPrs_BRepFont` (aliased as `Font_BRepFont`) for loading TrueType/OpenType fonts and rendering individual glyphs as BRep shapes, and `StdPrs_BRepTextBuilder` (aliased as `Font_BRepTextBuilder`) for composing glyphs into positioned text strings. Both are in the `TKService` module, already linked by the project. Internally they use FreeType via `Font_FTFont`.

The existing project architecture follows a three-layer pattern:
- `wrap/occt_wrap.cpp` — thin `extern "C"` bridge returning opaque pointers
- `src/ffi/bindings.lisp` — CFFI `defcfun` bindings
- `src/core/` — CLOS wrappers with `tg:finalize` for GC

## Goals / Non-Goals

**Goals:**
- Load fonts by file path (TTF/OTF) and by system font name
- Render text strings as flat BRep shapes on the XY plane
- Support font aspect (regular/bold/italic/bold-italic)
- Support horizontal alignment (left/center/right) and vertical alignment (bottom/center/top)
- Accept UTF-8 encoded text
- Provide `make-text-shape-3d` convenience that extrudes flat text via existing `make-prism`
- Proper lifecycle management via `tg:finalize`
- Comprehensive unit tests and README documentation

**Non-Goals:**
- Individual glyph manipulation (RenderGlyph is not exposed at CLOS level — use BRepTextBuilder for whole strings)
- Text on curved surfaces or arbitrary planes (gp_Ax3 defaulted to XY plane)
- Multi-line text or rich formatting (Font_TextFormatter not exposed — single-line only)
- Font enumeration or discovery beyond name lookup
- Text input via GUI or interactive editing

## Decisions

### 1. Layer boundary: flat text shape from C, extrusion in CLOS

The C wrapper returns a flat compound shape from `make_text_shape()`. The `make-text-shape-3d` CLOS function calls `make-text-shape` then `make-prism`, reusing the existing extrusion capability.

Rationale: Keeps the C wrapper focused on the novel operation (font → glyphs → positioned faces), reuses proven code, and lets users compose differently (e.g., extrude on a different axis, or use the flat shape for engraving via boolean cut).

### 2. Font stored as `Handle(StdPrs_BRepFont)*` in C wrapper

`StdPrs_BRepFont` inherits from `Standard_Transient` (reference-counted). The C wrapper stores it as a heap-allocated `Handle` pointer, same pattern as the existing viewer/trihedron code.

### 3. TextBuilder is stateless, constructed per call

`StdPrs_BRepTextBuilder` has no persistent state relevant to our use case. A new instance is created inside `make_text_shape()` each time. No CLOS wrapper needed.

### 4. Font file path vs system font name: both exposed

| Approach | Pro | Con |
|---|---|---|
| File path | Portable, no OS font config dependency | User must know the file path |
| System name | Convenient, works across OS font variations | Depends on Font_FontMgr + fontconfig |
Decision: Expose both. The file path constructor is more predictable for cross-platform scripts; the name constructor is friendlier for interactive use.

### 5. Size in model units, not typographic points

OCCT's BRepFont takes size in model units (e.g., millimeters). The doc comment in `StdPrs_BRepFont.hxx:92` provides the conversion: `0.0254 * pt / 72.0`. The user passes model units directly; a documentation note explains the conversion.

### 6. Alignment enum mapping

```
Horizontal: :left (0), :center (1), :right (2)
Vertical:   :bottom (0), :center (1), :top (2), :top-first-line (3)
```

Mapped to OCCT `Graphic3d_HorizontalTextAlignment` and `Graphic3d_VerticalTextAlignment` in the CLOS layer.

### 7. UTF-8 text passes directly through C wrapper

`NCollection_String` is a typedef for `NCollection_UtfString<char>`, which accepts a UTF-8 `const char*`. The CLOS `:string` type in CFFI passes a C string pointer directly.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Font file not found at path | Returns nil; error message via `(get-error-message)` |
| System font name not found | Returns nil; Font_FontMgr fallback limited by `Font_StrictLevel` |
| Glyph not renderable (missing char) | OCCT returns null shape for individual glyphs, Builder handles gracefully |
| Large text strings could be slow | Glyphs are cached internally by BRepFont; compound construction is O(n) |
| Memory: font file stays loaded until `free-brep-font` | CLOS `tg:finalize` ensures release; font is typically small (metrics + cached glyph outlines) |
| Linking: need TKService | Already linked in justfile — no change needed |

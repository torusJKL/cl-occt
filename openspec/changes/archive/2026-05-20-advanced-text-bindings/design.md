## Context

Current text support is limited to `make-text-shape` and `make-text-shape-3d`, which render flat text on the XY plane (`gp_Ax3()`) and optionally extrude it. Font loading supports file path and system name lookup. There is no bounding-box query, no annotation/label support, no font enumeration, no multi-line formatting, and no per-glyph access.

## Goals / Non-Goals

**Goals:**
- Arbitrary text placement on any plane/orientation
- Text bounding-box query without rendering
- Interactive 3D text labels (`AIS_TextLabel`) in the viewer
- System font discovery and enumeration
- Multi-line / formatted text
- Per-glyph rendering and metrics
- High-level DSL integration with `defmodel`

**Non-Goals:**
- Text along arbitrary curves (path-following text) — requires `Font_TextFormatter` on a curve, deferred to future work
- Text-to-curve (converting glyph outlines to parametric curves) — deferred
- Font subsetting or embedding — out of scope

## Decisions

- **C-level gp_Ax3 exposure**: New C function `make_text_shape_on_plane` that accepts `gp_Ax3` components (position xyz + Z-direction + X-direction). Lisp-level convenience wrappers accept `:position` and `:normal` (Z-direction), computing the full frame.
- **Bounding box as C function**: `text_bounding_box(font, text) → (width, height)` using `Font_FTFont::BoundingBox`. Returns via output pointer parameters. Pure query, no shape allocation.
- **AIS_TextLabel as separate CLOS class**: `ais-text-label` class distinct from `shape`. Stores `Handle(AIS_TextLabel)*`. Displayed via existing `ais-context-display`. Exporters (STL/STEP) skip non-shape objects via `typep` check.
- **Font enumeration**: `enumerate_fonts()` C function returns JSON-like string of available font names queried from `Font_FontMgr`. Lisp parses into a list.
- **Multi-line**: Expose `Font_TextFormatter` at C level. At Lisp level, a `format-text` function takes a string with `#\Newline` separators and returns a compound shape.
- **Per-glyph**: Add methods directly to the existing `%brep-font` pointer: `text-glyph-as-shape`, `text-glyph-as-shape-3d`, `text-font-ascender`, `text-font-descender`, `text-font-line-spacing`, `text-font-advance-x`, `text-font-advance-y`, `text-font-set-width-scaling`, `text-font-set-composite-curve-mode`.
- **DSL**: Follow existing `defmodel` pattern. New `text-model` helper that expands to `(model-ref ...)` wired through `make-text-shape` with proper dependency tracking.

## Risks / Trade-offs

- **AIS_TextLabel vs shape export**: Since `ais-text-label` is an AIS interactive object, not a `TopoDS_Shape`, the existing STL/STEP exporters naturally skip it. Risk is negligible.
- **Font_TextFormatter complexity**: OCCT's formatter is geared toward 2D screen layout. Applying it to 3D BRep may require per-line position offset computation. Mitigation: start with simple `#\Newline` splitting, compute line heights from `Ascender + Descender + LineSpacing`, stack glyph shapes manually.
- **Performance of per-glyph rendering**: Calling `RenderGlyph` for each character in a long string may be slow. Mitigation: batch approach in `make-text-shape` already uses `StdPrs_BRepTextBuilder` which handles this internally. Per-glyph is opt-in for special cases only.

## Open Questions

None.

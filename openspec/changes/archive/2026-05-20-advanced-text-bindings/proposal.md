## Why

Text in 3D CAD is far richer than simple flat labels on the XY plane. To support real-world annotation, labeling, and engraving workflows, the system needs multi-plane text placement, bounding-box queries for layout, interactive non-exported labels, font discovery, multi-line formatting, and per-glyph metrics/control.

## What Changes

- **Multi-plane/orientation text**: `Perform()` currently hardcoded to `gp_Ax3()` (XY plane). Expose position + orientation so text can sit on angled faces, follow paths, or lie on any arbitrary plane.
- **Text bounding-box query**: Expose `Font_FTFont::BoundingBox(string)` for layout computation without rendering.
- **Interactive 3D text labels (AIS_TextLabel)**: Lightweight annotation objects that display in the viewer but are never exported to STL or STEP.
- **Font system management**: Discover available system fonts via `Font_FontMgr` / `Font_SystemFont`.
- **Multi-line / formatted text**: `Font_TextFormatter` for multi-line layout.
- **Per-glyph control**: Low-level access to individual glyph metrics and rendering via `StdPrs_BRepFont` — `RenderGlyph`, `SetWidthScaling`, `SetCompositeCurveMode`, `Ascender`, `Descender`, `LineSpacing`, `AdvanceX`, `AdvanceY`.

## Capabilities

### New Capabilities

- `text-positioning`: Arbitrary position/orientation for text shapes, including placement on faces and along curves. `text-multi-plane`
- `text-bounding-box`: Query text extent (width, height) without rendering.
- `text-labels`: Interactive 3D text annotations (`AIS_TextLabel`) viewable in the AIS context but excluded from STL/STEP export.
- `font-system-mgmt`: Discover and enumerate system-installed fonts.
- `text-multi-line`: Multi-line and formatted text layout via `Font_TextFormatter`.
- `text-glyph-metrics`: Per-glyph rendering, width scaling, composite curve mode, and advance/metric queries.
- `text-dsl`: High-level Lisp DSL macros for declarative text definitions in the reactive DAG, integrating with `defmodel`.
- `text-documentation`: Updated README with new API surfaces, examples, and usage patterns for all text capabilities.

### Modified Capabilities

*(None — no existing specs have requirement changes.)*

## Impact

- **`wrap/occt_wrap.cpp`**: New C++ bridge functions for each new capability; modify existing `make_text_shape` to accept `gp_Ax3` (position + orientation).
- **`src/ffi/bindings.lisp`**: New `%`-prefixed CFFI `defcfun` declarations.
- **`src/core/text.lisp`**: Major expansion — new CLOS classes, `make-instance` constructors, optional arguments for position/orientation.
- **`src/core/viewer.lisp`**: AIS label display support (separate from shape display).
- **`src/core/`**: New files for labels, glyphs, font management if warranted.
- **`src/dag/`**: Optional integration with reactive DAG for text parameters.
- **`src/dsl/`**: New macros for text in `defmodel` bodies.
- **`t/smoke-tests.lisp`**: Tests for each new capability.
- **`README.md`**: Updated with API docs, usage examples, and function reference for all new text features.

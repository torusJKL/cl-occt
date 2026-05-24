## Why

The text and font system in cl-occt is rich — brep fonts, text shapes, 3D extruded text, text labels, glyph metrics, multi-line text — but none of it is documented. Users need examples to understand the interplay between font creation, text shaping, and display.

## What Changes

- Add docstrings with `Example:` blocks to all public functions in `text.lisp`
- Trivial predicates (`brep-font-p`, `ais-text-label-p`) get docstring description without example
- No functional or API changes — documentation only

File modified: `src/core/text.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/text.lisp`: 26 functions — `brep-font-p`, `ais-text-label-p`, `make-brep-font-from-file`, `make-brep-font-from-name`, `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `text-bounding-box`, `list-available-fonts`, `font-info`, `make-ais-text-label`, `ais-free-text-label`, `(setf ais-text-label-text)`, `(setf ais-text-label-position)`, `(setf ais-text-label-color)`, `text-glyph-as-shape`, `text-glyph-as-shape-3d`, `text-font-ascender`, `text-font-descender`, `text-font-line-spacing`, `text-font-advance-x`, `text-font-advance-y`, `text-font-set-width-scaling`, `text-font-set-composite-curve-mode`, `make-multi-line-text`, `make-formatted-text`
- All existing tests should pass unchanged

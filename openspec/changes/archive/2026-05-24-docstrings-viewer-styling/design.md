## Context

Seven files covering the visual styling layer: colors (named, hex, HLS, delta), viewer defaults, lighting (ambient/directional/positional), object properties (material, transparency, selection, tesselation), drawer settings (line/shading/point/text appearance), dimensions, and text labels.

## Goals / Non-Goals

**Goals:**
- Every public function gets docstring with example
- Add missing `Example:` blocks to `ais-selected-objects` and `ais-selected-shapes` (existing docstrings)
- Trivial predicates (`viewer-color-p`, `viewer-light-p`, `material-p`) get docstring only
- Selection management functions form a natural group for `See also:` cross-references

**Non-Goals:**
- No functional or API changes

## Decisions

- **Color system** should show `make-color` with all three construction modes: `:keyword`, `:rgb`, `:hls`
- **Lighting examples** must show the full lifecycle: `make-light` → `viewer-add-light` → `viewer-light-on`
- **Object property examples** should work on a displayed AIS object
- **Selection examples** use the context's selection functions (`ais-set-selection-mode`, `ais-is-selected`, etc.) as a group
- **Drawer examples** should show setting multiple attributes on one object
- **Dimension examples** need an edge and a viewer context — show the setup chain

## Risks / Trade-offs

- **Lighting and dimension examples** are the most complex, requiring viewer setup. Examples should be self-contained but reference the standard viewer setup pattern.
- **Selection functions** have internal iteration state — examples must show `init-selected` → `more-selected` → `next-selected` loop pattern.

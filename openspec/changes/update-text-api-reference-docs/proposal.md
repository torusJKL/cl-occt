## Why

Commit f4b7c68 exposed `x-direction` control for text on arbitrary planes and fixed `make-text-shape-3d` to extrude along the plane normal, but these changes are not fully reflected in the user-facing API reference docs. The source docstrings are correct, but `docs/api-reference.md` omits the extrusion-follows-normal behavior, and `doc/api-reference.md` is entirely missing the text API section. Users reading the docs get an incomplete picture of the text positioning API.

## What Changes

- **`docs/api-reference.md`**: Update `make-text-shape-3d` description to explicitly state that extrusion follows the plane normal (not just "same args as `make-text-shape`")
- **`doc/api-reference.md`**: Add the full text API section (font loading, text shape creation, multi-line text, glyph metrics, font rendering controls, AIS text labels) — currently this file has no text API content at all
- **Source docstrings**: Already complete from the commit — no changes needed

## Capabilities

### New Capabilities

*(None — no new behavioral capabilities; this is a documentation-only change.)*

### Modified Capabilities

- `api-reference-docs`: The `docs/api-reference.md` description of `make-text-shape-3d` SHALL state that extrusion follows the plane normal. The `doc/api-reference.md` file SHALL include the text API section matching public functions.

## Impact

- **`docs/api-reference.md`** — 1-line description change for `make-text-shape-3d`
- **`doc/api-reference.md`** — new ~80-line text API section added (mirroring `docs/api-reference.md`)
- No code, tests, or behavior changes

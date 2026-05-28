## Why

`make-text-shape-3d` accepts `:position` and `:normal` keyword arguments to place text on an arbitrary plane, but always extrudes along global Z regardless of the specified normal. For any plane other than XY, the extrusion goes through the text plane rather than perpendicular to it, producing a sheared shape instead of proper thickness.

## What Changes

- **`make-text-shape-3d`**: Fix extrusion direction to follow the `:normal` plane normal when provided, instead of always extruding along Z.
- **Tests for `text-shape-3d-on-rotated-plane`**: Replace the weak `assert-shape` check with a test that verifies extrusion direction using `shape-extent-along`.
- **`text-glyph-as-shape-3d`**: Not modified — no `:normal` parameter added; the simpler function remains for single-glyph use.

## Capabilities

### New Capabilities
*(none)*

### Modified Capabilities
- `font-text`: The "Render 3D text" requirement currently specifies extrusion "in the Z direction." Update to specify extrusion follows the plane normal when `:normal` is provided.
- `text-positioning`: The "make-text-shape-3d accepts optional position/orientation" requirement exists but has no scenario verifying correct extrusion direction. Add a scenario that validates extrusion follows the normal.

## Impact

- `src/core/text.lisp` line 170: one-line change in `make-text-shape-3d`
- `t/font-text-tests.lisp`: strengthen `text-shape-3d-on-rotated-plane` test
- `openspec/specs/font-text/spec.md`: update extrusion direction wording
- `openspec/specs/text-positioning/spec.md`: add validation scenario
- No C/C++ wrapper changes needed

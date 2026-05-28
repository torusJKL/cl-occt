## Context

`make-text-shape-3d` places flat text on an arbitrary plane via `make-text-shape` → `%make-text-shape-on-plane` (OCCT's `StdPrs_BRepTextBuilder::Perform` with `gp_Ax3`), but then always extrudes along `(0, 0, depth)` regardless of the specified `:normal`. For non-XY planes, the extrusion goes through the text plane rather than perpendicular to it, producing a sheared shape.

The fix is straightforward: when `:normal` is provided, use it as the extrusion direction scaled by `depth`. When omitted, default to `(0, 0, 1)` — preserving full backward compatibility.

## Goals / Non-Goals

**Goals:**
- Fix `make-text-shape-3d` so extrusion follows the plane normal when `:normal` is specified
- Add a test that verifies extrusion direction (not just shape non-nil)
- Update spec documentation to reflect correct behavior

**Non-Goals:**
- No C/C++ wrapper changes needed (everything is in Lisp)
- No API signature changes
- `text-glyph-as-shape-3d` is not modified — it remains a simple per-glyph function without plane orientation support

## Decisions

### Decision 1: Scale normal by depth for extrusion vector

When `:normal` is provided as `(nx ny nz)`, the extrusion vector becomes `(nx*depth, ny*depth, nz*depth)`. When omitted, the default `(0 0 1)` produces `(0 0 depth)` — identical to current behavior.

**Alternatives considered:**

| Approach | Pros | Cons |
|----------|------|------|
| Scale normal by depth | One-line change, no C code, backward compatible | None |
| Add C wrapper variant | Would mirror `make_text_shape_on_plane` more closely | Unnecessary complexity, no benefit over Lisp-only fix |
| Transform result after extrusion | Would avoid touching extrusion direction | Convoluted, would rotate the whole solid |

**Rationale:** The normal is already a unit direction vector passed to `make-text-shape` for plane placement. Reusing it as the extrusion direction is mathematically exact and requires zero new machinery. `make-text-shape-3d` always creates the flat text first, then extrudes — so the extrusion vector naturally follows the text plane.

### Decision 2: Use `shape-extent-along` for test verification

The existing test `text-shape-3d-on-rotated-plane` only checks that a non-nil shape is returned. To catch this bug, we project the extruded shape's bounding box onto both Y and Z axes using `shape-extent-along`.

**Scenario:** `(make-text-shape-3d font "Deep" 3.0 :position '(0 0 0) :normal '(0 1 0))`
- `shape-extent-along` with direction `(0 1 0)` → max ≈ 3.0 (extrusion along Y)
- `shape-extent-along` with direction `(0 0 1)` → max ≈ 0 (extrusion NOT along Z)

If the extent-along-Y were ≈ 0 and extent-along-Z ≈ 3.0, the bug is present (extrusion went along global Z).

## Risks / Trade-offs

- **Degenerate normal** `(0 0 0)` — would produce a zero-thickness extrusion. This would be caught by `make-prism`'s existing zero-vector check. User error, not a concern for the fix.
- **Non-unit normal** — if a user passes an unnormalized vector like `(0 2 0)`, the extrusion depth would be `2*depth`. This is consistent with how `make-text-shape` handles normals (OCCT normalizes for plane placement; the extrusion uses the raw vector). Known and acceptable.

## Context

Shell, offset, and draft operations modify existing solids by adding or removing material. OCCT's `BRepOffsetAPI_*` classes are all shape-in, shape-out operations following the same pattern as existing boolean operations.

MakeThickSolid is the most complex: it needs to identify which faces to remove, set a thickness, and optionally control the offset direction. DraftAngle needs a pull direction and neutral plane/element. MakeOffsetShape is a simpler single-parameter offset.

## Goals / Non-Goals

**Goals:**
- Shell/hollow a solid by removing faces
- Offset a 3D shape inward/outward with join type control
- Offset a planar wire in 2D
- Apply draft angle to selected faces
- Evolved solid from profile + spine

**Non-Goals:**
- No local face removal beyond shell faces (shell removes entire faces)
- No parametric draft evolution

## Decisions

### Decision 1: Faces-to-remove as list of face shapes
**Chosen:** `(shell-shape solid '(face1 face2) :thickness 2.0)` — faces are shape references obtained from explorer.

**Rationale:** Consistent with edge selection in fillet/chamfer. Users must use `map-shape-subshapes` to find face references.

### Decision 2: Draft as single function with direction vectors
**Chosen:** `(draft-face solid face angle pull-direction neutral-plane)` where pull-direction and neutral-plane are 3D vectors/points.

**Rationale:** DraftAngle.SetDirection and SetAngle take gp_Dir/double. Neutral plane can be a face or a plane defined by point+normal.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| MakeThickSolid may fail with thin walls on complex geometry | Return nil; document that shell works best with simple geometry |
| DraftAngle requires neutral plane perpendicular to pull direction | Validate inputs in C bridge and return nil on invalid combinations |
| MakeOffsetShape may produce self-intersecting offset on concave shapes | Return nil when IsDone() fails; document limitation |

## Migration Plan

All new APIs are additive.

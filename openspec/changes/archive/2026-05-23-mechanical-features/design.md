## Context

BRepFeat features are positional: they are defined relative to a specific face of a solid, with a profile (face or wire), an extrusion/revolve direction or axis, and a depth/angle. They can either cut into the solid (depression) or add material (protrusion).

This is distinct from the existing `make-prism` and `make-revol` which operate on any shape without positional context. BRepFeat features understand which face they're on and can fuse/cut accordingly.

LocOpe provides lower-level local operations on individual faces — extruding a single face, creating grooves and ribs.

## Goals / Non-Goals

**Goals:**
- Cylindrical holes (through and blind) at face positions
- Prismatic features (extrude profile from face, cut or add)
- Revolve features (rotate profile around axis from face)
- Pipe features (sweep profile along path from face)
- Local extrusion, groove, and rib operations

**Non-Goals:**
- No parametric feature history (CL-OCCT's DAG handles recomputation)
- No sketch plane abstraction (user provides the face and profile directly)

## Decisions

### Decision 1: Operation type as keyword
**Chosen:** `:operation :cut` or `:operation :add` keyword argument on all BRepFeat wrappers.

**Rationale:** BRepFeat_MakePrism and similar accept a boolean "remove" flag. A keyword is clearer and extensible.

### Decision 2: Profile passed as shape (face or wire)
**Chosen:** Profile is a face or wire shape (the feature's cross-section), positioned on or relative to the base face.

**Rationale:** Consistent with OCCT's own API. Users construct the profile using existing edge/wire/face builders.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| BRepFeat requires precise profile positioning | Document that profile must be positioned on the base face's surface |
| LocOpe operations are fragile on complex geometry | Return nil on IsDone() failure |
| Through-hole needs to know which face to exit at | Document option for through vs. blind; through holes auto-detect the exit face |

## Migration Plan

All new APIs are additive.

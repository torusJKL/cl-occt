## Context

Fillets and chamfers modify existing solids by rounding or beveling edges. OCCT's `BRepFilletAPI_MakeFillet` and `BRepFilletAPI_MakeChamfer` are multi-step construction APIs: create the algorithm, add edges with radii/distances, then build. Surface blending (`FilletSurf`, `BlendFunc`) creates new surfaces between faces.

The existing CL-OCCT boolean operations (cut/fuse/common/section) follow a single-function-call pattern. Fillet/chamfer need a similar convenience pattern while exposing the underlying multi-step API for advanced use.

## Goals / Non-Goals

**Goals:**
- Single-function convenience for common cases: `(fillet-edge box edge radius)`, `(chamfer-edge box edge distance)`
- Multi-edge and variable-radius support
- 2D wire fillet for planar profiles
- Surface blending between adjacent faces
- All functions return shape or nil (no exceptions)

**Non-Goals:**
- No topological exploration for finding edge references (user is expected to provide edges — use TopExp_Explorer from topology-queries)
- No parametric/variable-radius surface blending via law functions in this spec (constant radius only for surface blend)

## Decisions

### Decision 1: Convenience functions, not algorithm objects
**Chosen:** `(fillet-edge shape edge radius)` creates the BRepFilletAPI_MakeFillet internally, calls `Add(edge, radius)`, `Build()`, returns Shape(). Advanced operations use extended keyword signatures.

**Rationale:** Matches the existing Lisp-idiomatic "function call, not object construction" pattern (e.g., `cut`, `fuse`, `translate`). Users don't want to think about algorithm lifecycle.

**Alternatives considered:**
- Expose MakeFillet as a CLOS object — rejected: adds complexity for uncommon use case

### Decision 2: Edges identified by shape reference
**Chosen:** Users pass edge shapes (obtained via `map-shape-subshapes` or `topology-queries`'s explorer).

**Rationale:** Edges are shapes. The existing `%ptr` mechanism works. No need for edge index or topology path syntax.

### Decision 3: Variable radius via list of (parameter radius) pairs
**Chosen:** `(fillet-edge-variable box edge '((0.0 5.0) (0.5 3.0) (1.0 8.0)))` — parameter is in [0,1] along the edge.

**Rationale:** Lisp-native representation. The C bridge unpacks the list to call `Add(radius, parameter)` or the spine-based variant.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| BRepFilletAPI can fail silently on complex topology | Check `IsDone()` after Build(), return nil on failure |
| Edge selection via shape pointer may match wrong edge after previous modifications | User must pass edges from the original shape, not from intermediate fillet/chamfer results |
| Surface blend (FilletSurf/BlendFunc) is complex — may not support all face configurations | Start with adjacent faces only; document limitation |

## Migration Plan

All new APIs are additive.

## Open Questions

- Should fillet accept edge indices (1-based) as an alternative to passing edge shape references?
- For 2D fillet, should the wire be modified in-place or should a new wire shape be returned?

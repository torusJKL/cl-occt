## Context

Sweep, pipe, and loft operations create shapes from 2D profiles and 1D spines. OCCT provides several API classes:
- `BRepPrimAPI_MakePipe` — simple profile+spine sweep
- `BRepPrimAPI_MakePipeShell` — multi-section sweep with evolution, auxiliary spines, tangency
- `BRepOffsetAPI_ThruSections` — lofting through wire sections
- `BRepFill_Filling` — N-sided face filling with continuity constraints

These are all shape-in, shape-out operations that fit the existing `make-shape` pattern.

## Goals / Non-Goals

**Goals:**
- Sweep a profile (face/wire) along a spine → solid/shell
- Sweep with multiple evolving sections at specified parameters
- Loft through multiple wires → solid or shell
- Fill an N-sided face from boundary edges with continuity constraints
- Support mode flags: sliding/fixed, ruled/smooth, solid/shell

**Non-Goals:**
- No surface law functions for sweeps (constant radius only in this change)
- No shape healing on degenerate sweep/loft results

## Decisions

### Decision 1: Sections passed as wire lists, positions as parameter list
**Chosen:** `(sweep-sections spine sections positions)` where `sections` is a list of wire shapes and `positions` is a list of doubles in [0,1].

**Rationale:** Clean Lisp representation. The C bridge iterates the arrays.

### Decision 2: ThruSections as single function with keyword args
**Chosen:** `(loft-sections wires :solid t :ruled nil :smooth nil :initial-tangent nil :final-tangent nil)`.

**Rationale:** Multiple modes are flags on a single algorithm, not separate algorithms. Keyword args make the call readable.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| MakePipeShell requires careful section-spine matching | Document that sections must be wire shapes discretized along the spine |
| BRepFill_Filling may fail on complex boundaries | Return nil on IsDone() failure; document constraint limits |
| Loft with many sections may be slow | O(n) algorithmic complexity; document performance characteristics |

## Migration Plan

All new APIs are additive.

## Open Questions

- Should MakePipe accept both face and wire profiles, or only wire?
- Should loft support non-planar section wires?

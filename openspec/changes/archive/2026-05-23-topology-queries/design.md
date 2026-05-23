## Context

Existing CL-OCCT can construct and boolean shapes but has no introspection or analysis capabilities. The topology query layer adds the ability to inspect shapes from the outside (mass properties, classification) and from the inside (explorer, adaptor).

Key architectural points:
- `BRepGProp` returns struct-like results (volume, area, COM, inertia) — need a new result CLOS type or multiple return values
- `BRepExtrema` returns distance + closest point pairs — needs a result type
- `TopExp_Explorer` is an iterator pattern — needs Lisp-friendly collection interface
- `BRepAdaptor` extracts `Geom_Curve`/`Geom_Surface` from topological entities — depends on curve/surface types from `geometry-foundation`

## Goals / Non-Goals

**Goals:**
- Compute mass properties (volume, area, COM, inertia) for any solid
- Compute distance/extremum between any two shapes
- Classify point vs solid (inside/outside/on)
- Validate shape topological integrity
- Intersect a curve with a BRep shape
- Walk sub-shapes by type, with optional stop-at type filter
- Extract curves from edges and surfaces from faces
- Build vertices and polygons from coordinates

**Non-Goals:**
- No modification to existing shape or boolean code
- No shape healing or repair (separate change)
- No local operations or feature creation (separate changes)

## Decisions

### Decision 1: gprops and extrema results as CLOS classes
**Chosen:** `gprops` CLOS class with `%volume`, `%area`, `%center-of-mass`, `%inertia-matrix` slots. `shape-extrema` CLOS class with `%distance`, `%point-on-shape1`, `%point-on-shape2` slots.

**Rationale:** Multiple return values are idiomatic for simple results (like projection queries), but mass properties and extrema have 5-10 values each. A CLOS class provides named access, discoverability in SLIME, and can be extended later.

**Alternatives considered:**
- Multiple return values — rejected: too many values, fragile positional access
- Plist or alist — rejected: no type safety, harder to document

### Decision 2: Explorer as list collection, not streaming iterator
**Chosen:** `(map-shape-subshapes shape :face)` returns a list of all faces. `count-shape-subshapes` returns the count.

**Rationale:** Lisp programmers expect `mapcar`/`loop` over lists. A streaming iterator would require maintaining state and a special iteration protocol. For typical CAD usage (hundreds to low thousands of sub-shapes), building a list is fine.

**Alternatives considered:**
- DO/LOOP iteration macro — rejected: over-engineering for this use case
- Generator pattern — rejected: uncommon in Common Lisp

### Decision 3: BRepAdaptor gracefully degrades when curve/surface types unavailable
**Chosen:** If the `curve` and `surface` CLOS types from `geometry-foundation` are not yet loaded, `edge->curve` and `face->surface` return raw `(:ptr occt-curve-ptr)` plists instead.

**Rationale:** This change may be implemented before or after `geometry-foundation`. Graceful degradation allows flexible ordering. Document the dependency clearly.

**Alternatives considered:**
- Hard dependency — rejected: blocks this change
- Return nil when types unavailable — rejected: unhelpful

### Decision 4: Point-in-solid returns keyword + optional face
**Chosen:** `(classify-point-in-solid point shape)` returns two values: `:inside`, `:outside`, or `:on`, and (if `:on`) the face shape.

**Rationale:** The classification state is a simple enumeration (3 values) — a keyword is perfect. The face is an additional return value when relevant.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| BRepGProp inertia tensor has 6 components + 3 axes — complex C out-params | Return as flat double array from C, parse into structured CLOS slots in Lisp |
| BRepExtrema with non-touching shapes may fail silently | All distance functions check `IsDone()` and return nil on failure |
| TopExp_Explorer on large assemblies could be slow | List building is O(n); cap at 100K sub-shapes or document limitation |
| BRepAdaptor depends on Geom types that may not exist yet | Document as soft dependency; return raw plist as fallback |

## Migration Plan

All new APIs are additive — no migration needed.

## Open Questions

- Should `shape-volume`, `shape-area`, `shape-center-of-mass` be individual functions or unified into one `shape-gprops` that returns everything?
- For MakePolygon, should it accept 3D points as triples or as separate x/y/z args?

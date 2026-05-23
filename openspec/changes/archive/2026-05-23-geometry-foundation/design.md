## Context

The existing CL-OCCT bridge handles shapes (`occt_shape`/`shape`) and 2D geometry (`occt_geom2d`/`geom2d`) as opaque pointers with discriminated-union type tags. 3D curves and surfaces (`Geom_Curve`, `Geom_Surface` and their subclasses) are a parallel hierarchy of handles that need the same treatment. Geometric algorithms (`GeomAPI_*`, `Geom2dAPI_*`) consume and produce these handles. Helix types sit at the intersection of geometry and topology.

Current state:
- `occt_geom2d` C struct: `{ kind, void* obj }` for gp_Pnt2d/gp_Vec2d/gp_Dir2d/Geom2d_Line/Geom2d_Circle
- CLOS `geom2d` wraps it with `tg:finalize`
- No 3D curve/surface types exist at any layer

## Goals / Non-Goals

**Goals:**
- Define `occt_curve` and `occt_surface` C types following the `geom2d` discriminated-union pattern
- CLOS wrappers `curve` and `surface` with `tg:finalize` GC and `curve-type`/`surface-type` accessors
- Bridge functions for all major Geom_Curve and Geom_Surface constructors
- GeomAPI/Geom2dAPI query functions returning curves/surfaces and scalar results
- HelixGeom parametric curve + HelixBRep edge construction
- Full test coverage: construction, round-trip, query, and invalid-input per type

**Non-Goals:**
- No modification to existing `shape` or `geom2d` CLOS classes (except adding new Geom2d curve types for parity)
- No new OCCT build dependencies
- No shape healing or topology repair (separate change)
- No feature operations (fillet, chamfer, sweep — separate changes)

## Decisions

### Decision 1: Discriminated-union C struct for curve and surface
**Chosen:** `occt_curve` and `occt_surface` follow the exact pattern of `occt_geom2d`:
```cpp
enum GeomCurveKind { CURVE_LINE, CURVE_CIRCLE, CURVE_ELLIPSE, ... };
struct OccctCurve { GeomCurveKind kind; void* handle; };
```
Same for `OccctSurface`.

**Rationale:** Consistent with existing code. The `geom2d` pattern is proven. Downside is a switch statement at free time, but this is negligible.

**Alternatives considered:**
- Individual typed functions per subtype — rejected: too many C bridge functions, defeats the purpose of the Geom_Handle base class
- C++ templates in extern "C" — rejected: extern "C" can't template

### Decision 2: CLOS class hierarchy for curve and surface
**Chosen:** Single `curve` CLOS class with `%kind` slot and `curve-type` accessor. Same for `surface`. No subclassing per curve type.

**Rationale:** The existing `geom2d` uses this pattern and it works well. Subclassing per curve type (e.g., `line`, `circle`, `bspline-curve`) would require CLOS class registration in CFFI and complicate the finalize/free dispatch. Keep it simple — the kind tag is sufficient for type dispatch.

### Decision 3: GeomAPI results as Lisp values
**Chosen:** Functions like `project-point-on-curve` return multiple values: `(point distance parameter)` or `(point u v distance)`. Intersection functions return lists. The C bridge passes results through pointer parameters (like `xde_get_color_at`).

**Rationale:** Multiple return values are idiomatic Common Lisp. Returning a struct would require defining a new CLOS type for every query result. Out-params in C map cleanly to CFFI `:pointer` arguments.

### Decision 4: Helix as both curve and edge
**Chosen:** Helix gets two construction paths:
- `make-helix-curve` → returns `curve` (parametric definition)
- `make-helix-edge` → returns `shape` (BRep edge usable in wire/face)

**Rationale:** HelixGeom is a `Geom_Curve` subclass, so it fits naturally in the `curve` type. HelixBRep produces a `TopoDS_Edge`, which is just a `shape`. Two separate bridge functions, one for each family.

### Decision 5: GC/copy semantics for curve and surface
**Chosen:** `make-shape` / `make-geom2d` pattern duplicated: `make-curve` and `make-surface` internal functions that wrap a raw `occt_curve`/`occt_surface` pointer in a CLOS instance with `tg:finalize`. The C bridge allocates a new `OccctCurve` struct (containing a new Handle copy) each time.

**Rationale:** Follows existing pattern exactly. Handles are reference-counted in OCCT; copying the Handle increases the refcount. Finalize decrements it / frees the struct.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Geom_Curve has ~20 subclasses — bridge scope creep | Implement the 7 most common (Line, Circle, Ellipse, Hyperbola, Parabola, Bezier, BSpline); add others on demand |
| GeomAPI returns multiple result types (points, curves, params) | Use Lisp multiple-values for scalar results; return lists of curves for IntSS / PointsToBSpline |
| HelixGeom is an extension package — may not be in all OCCT builds | Guard with `#ifdef` in C bridge or document as optional. OCCT 8.0 includes it. |
| Handle null-pointer in deep accessor chains | Every CLOS accessor checks `%ptr` for null before calling CFFI; return nil instead of crashing |
| Geom2d curve types extend existing `geom2d` — may conflict | Add new kind tags to existing `Geom2dKind` enum; `free_geom2d` switch handles new types automatically |

## Migration Plan

All new APIs are additive — no migration needed. Existing code continues unchanged.

## Open Questions

- Should `make-pnt` (3D point) be added as a simple gp_Pnt wrapper alongside curves/surfaces, or use (x y z) lists everywhere?
- Should Geom2d_Line/Geom2d_Circle constructors be moved from the existing bare pointer style to the discriminated-union `geom2d` style for consistency? (Currently they bypass the struct and store raw `Handle(Geom2d_*)` pointers.)

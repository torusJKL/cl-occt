## Context

The current viewer system (`src/core/viewer.lisp`, `wrap/occt_wrap.cpp`, `src/ffi/bindings.lisp`) follows a three-layer pattern:

```
Lisp (CLOS) → CFFI (%) → C (extern "C") → C++ (OCCT)
```

The `viewer` CLOS class bundles three OCCT handles (graphic driver, V3d_Viewer, V3d_View). The `ais-object` class wraps any `Handle(AIS_InteractiveObject)*`. Functions follow a convention: check for null handles, coerce types, delegate to `%`-prefixed CFFI calls.

**What exists today:**
- Viewer lifecycle: make/free, fit-all, must-be-resized, invalidate
- AIS context: create, display, erase, remove, color, display-mode
- Trihedron: create, size, corner, arrows, datum mode
- Styling: background color, projection orientation, MSAA, AA, grid on/off

**What's missing:** Everything else — camera control, lighting, background variants, grid properties, deep trihedron customization, per-object materials/transparency/tessellation, the full Prs3d_Drawer aspect tree, dimensions, named colors, text label enhancements, rendering quality knobs, and viewer-level defaults.

## Goals / Non-Goals

**Goals:**

- Expose every visual element OCCT's viewer API offers, organized by capability area
- Two-tier API: convenience keyword-driven functions AND first-class CLOS objects
- Maintain the existing three-layer pattern — no architectural rewrites
- Each capability is independently implementable (modular specs, independent bridge functions)
- Full test coverage: round-trip, error-case, and idempotency tests per capability
- Update README with documented viewer API

**Non-Goals:**

- No GUI toolkit integration (no Qt, no SDL, no window system bindings)
- No changes to the reactive DAG or DSL systems (these are pure viewer controls)
- No new OCCT build dependencies (all headers already available)
- No multi-view or viewport layout management
- No picking/selection ray-casting (separate concern)
- No animation or camera tweening (separate concern)

## Decisions

### Decision 1: Dedicated files per capability area (not one monolithic file)

**Chosen:** One `.lisp` file per capability spec, e.g. `src/core/viewer-camera.lisp`, `src/core/viewer-lighting.lisp`.

**Rationale:** The viewer file is already 340 lines. Adding 12 capability areas would make it unmanageable. Each file is focused, testable, and can be loaded independently for development. Cross-cutting concerns (e.g., both camera and rendering access `%view`) are handled via accessor methods on the `viewer` class.

**Alternatives considered:**
- A single `src/core/viewer.lisp` — rejected: would exceed 2000 lines
- One file per bridge layer (all CFFI in one file, all CLOS in another) — rejected: doesn't group by feature, harder to parallelize implementation

### Decision 2: New CLOS classes for complex OCCT handles

**Chosen:** Create CLOS wrapper classes for entities that carry state beyond a single handle:
- `viewer-light` — wraps `Handle(V3d_Light)*` with type dispatch
- `viewer-drawer` — wraps `Handle(Prs3d_Drawer)*` with sub-aspect accessors
- `viewer-material` — wraps `Graphic3d_MaterialAspect` (value type, not handle)
- `viewer-color` — wraps `Quantity_Color` with named color lookup
- `viewer-dimension` — base class for length/angle/diameter dimensions

**Rationale:** Convenience functions cover 80% of use cases, but power users need to hold, inspect, and modify these objects. First-class CLOS objects with `tg:finalize` for GC follow the existing pattern (`shape`, `ais-object`, `brep-font`).

**Alternatives considered:**
- Passing opaque pointers everywhere — rejected: Lisp-idiomatic means CLOS objects, not pointer soup
- Using structs — rejected: CLOS gives us type predicates, finalizers, and slot access

### Decision 3: Incremental enum maps for OCCT integer constants

**Chosen:** Continue the existing pattern of `defparameter *map* '((:keyword . int-value) ...)` with a shared `%lookup` utility.

**Rationale:** Already proven in `viewer.lisp` for orientation, display-mode, grid, trihedron enums. Avoids a big C enum-to-Lisp translation layer. Each spec defines its own maps.

For the named color system (~260 values), generate the map programmatically — the OCCT `Quantity_NameOfColor` enum is stable and well-known.

### Decision 4: Bridge functions use opaque `void*` handles, not typed structs

**Chosen:** Continue passing `void*` as in the existing bridge. The C++ side casts to the correct `Handle<>*` type.

**Rationale:** Changing to typed structs would require restructuring all existing bridge functions. `void*` works fine as long as CFFI and C++ agree on what's behind the pointer. Each bridge function's signature already documents the expected handle type.

### Decision 5: Light management via factory functions, not `set-light` on viewer

**Chosen:** Create individual light objects and then add them to the viewer:

```lisp
(let ((light (make-light :directional :color :white :direction '(0 0 -1))))
  (viewer-add-light viewer light)
  (viewer-light-on viewer light))
```

**Rationale:** Lights are independent entities that can be created, configured, toggled, and modified separately. A monolithic `set-viewer-lights` would be inflexible. This mirrors OCCT's own API (SetLight, SetLightOn/Off return handles).

**Alternatives considered:**
- `set-viewer-lights viewer :ambient ... :directional ...` — rejected: conflates creation and assignment, awkward for multiple lights of same type

### Decision 6: Named colors as Lisp keywords

**Chosen:** Every `Quantity_NOC_*` constant maps to a Lisp keyword (e.g., `:red`, `:sky-blue`, `:steel-blue`). The color system accepts:
- Keywords → named color lookup
- `(r g b)` lists → RGB triple [0,1] (existing behavior)
- Strings → `#RRGGBB` or `#RGB` hex parsing
- `viewer-color` instances → pass through

```lisp
(set-background view :sky-blue)
(ais-set-color ctx obj :goldenrod)
(set-background view "#4A90D9")
```

**Rationale:** Keywords are idiomatic Lisp for enumeration. Hex strings are web-standard and familiar. The dispatch is simple: `(typecase color (keyword (lookup-named-color color)) (string (parse-hex-color color)) ...)`.

### Decision 7: Material system — presets first, custom second

**Chosen:** Two-tier:
- `(ais-set-material obj :gold)` — applies one of ~50 named presets
- `(ais-set-material obj (make-material :ambient '(0.2 0.2 0.2) :diffuse '(0.8 0.6 0.4) :shininess 0.8))` — custom material

**Rationale:** Material presets are the most common need ("make it look like gold"). Custom materials are for advanced users. This keeps the common case simple without limiting the uncommon case.

### Decision 8: Prs3d_Drawer exposure via accessor chain, not flat API

**Chosen:** The drawer is a CLOS object whose slots are themselves CLOS objects:

```lisp
(let ((drawer (ais-drawer obj)))
  (setf (line-color drawer) :red)
  (setf (line-width drawer) 2.0))
;; or via shorthand:
(ais-set-line-aspect obj :color :red :width 2.0)
```

**Rationale:** Flat API would need 50+ functions for every combination of sub-aspect × property. The accessor chain is composable, discoverable via SLIME, and mirrors OCCT's own structure.

### Decision 9: Dimensions as AIS objects displayed in context

**Chosen:** Dimensions follow the same pattern as shapes and trihedrons — they are `ais-object` instances displayed via `ais-display`:

```lisp
(let ((dim (make-length-dimension edge :x-offset 20)))
  (ais-display ctx dim))
```

**Rationale:** Dimensions ARE interactive objects in OCCT (subclasses of `AIS_InteractiveObject`). They display, erase, remove, and color the same way. Reusing `ais-object` and `ais-display` is architecturally clean.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Bridge function count grows large (~150 new functions over 12 specs) | Group by spec, implement spec-by-spec. Each spec's bridge additions are modest (5-15 functions). |
| OCCT handle null-pointer crashes in deep accessor chains | Every CLOS accessor checks for null pointer before calling CFFI. Return nil instead of crashing. |
| Named color map (~260 entries) is tedious to maintain | Auto-generate from `Quantity_NameOfColor.hxx` header via script, or write once and verify. |
| Material presets may differ subtly between OCCT versions | Pin OCCT 8.0. Document exact preset names and their visual appearance. |
| Dimensions spec is large (3 dimension types × styling) | Split into a separate change if it blocks other specs. Listed as the largest/trickiest spec. |
| Prs3d_Drawer exposes ~20+ sub-aspects with ~5 properties each | Implement sub-aspects incrementally: start with LineAspect and ShadingAspect, add the rest in later phases. |
| Lisp camera control may need coordinate system conventions | Document convention: Z-up, right-handed. `(look-at view :from '(10 10 10) :target '(0 0 0))` sets eye to (10,10,10) looking at origin. |

## Migration Plan

No migration needed — all new APIs are additive. Existing code continues to work unchanged.

Implementation order (recommended):
1. `viewer-colors` — foundation for all other specs (named colors used everywhere)
2. `viewer-camera` — core camera control, high-value
3. `viewer-trihedron` — small extension of existing code, immediate visual payoff
4. `viewer-object-props` — transparency + materials, high visual impact
5. `viewer-lighting` — dramatic visual improvement, moderate complexity
6. `viewer-grid` — small, extends existing grid
7. `viewer-background` — moderate complexity, nice-to-have
8. `viewer-rendering` — small, quality-of-life knobs
9. `viewer-text-labels` — moderate extension of existing text labels
10. `viewer-defaults` — small, utility
11. `viewer-drawer` — large, deep aspect exposure
12. `viewer-dimensions` — largest, full feature area

## Open Questions

- Should `viewer-drawer` be implemented incrementally (start with LineAspect + ShadingAspect only) or all at once?
- Should dimensions spec be scoped to just length/angle/diameter, or include radius and chamfer too?
- Do we need `viewer-defaults` as a standalone spec, or should it be folded into `viewer-lighting` (default lights) and other specs?
- Should the named color map live in a separate data file (JSON/EDN) or inline in Lisp?

## Context

The codebase follows a three-layer architecture: C wrapper (`wrap/occt_wrap.h/.cpp`, opaque `void*` pointers, `extern "C"`), CFFI bindings (`src/ffi/bindings.lisp`, `%`-prefixed `defcfun`), and CLOS wrappers (classes with `%ptr` slot, `tg:finalize` for GC).

The archived change (2026-05-21-add-selection-bindings) added programmatic selection, mouse detection, highlight, and configuration — but explicitly listed filter and entity-owner wrapping as future non-goals. This change picks up that deferred work.

OCCT's selection filtering classes:
- `StdSelect_EdgeFilter` — filters selection to edges only
- `StdSelect_FaceFilter` — filters selection to faces only  
- `StdSelect_ShapeTypeFilter` — filters selection by configurable shape type(s)
- `StdSelect_BRepOwner` — entity owner holding a `TopoDS_Shape` reference, used by AIS shapes
- `SelectMgr_EntityOwner` — base entity owner with priority, selection mode, and custom detection

All filters inherit from `SelectMgr_Filter`. They are activated via `AIS_InteractiveContext::AddFilter` / `RemoveFilter`. Entity owners are obtained from `AIS_InteractiveContext::SelectedOwner()` during selection iteration.

## Goals / Non-Goals

**Goals:**
- C wrapper functions for constructing and configuring `StdSelect_EdgeFilter`, `StdSelect_FaceFilter`, `StdSelect_ShapeTypeFilter`
- C wrapper functions to add/remove filters to/from an AIS context
- C wrapper functions for `StdSelect_BRepOwner` shape extraction and property queries
- C wrapper functions for `SelectMgr_EntityOwner` priority and selection-mode queries
- CFFI `defcfun` bindings for all new C functions
- CLOS classes with `tg:finalize` GC for filter and entity-owner types
- CLOS wrapper functions for all operations
- Export new symbols from `src/package.lisp`
- Tests in existing test framework
- Update `docs/api-reference.md` with new filter and entity-owner API surface

**Non-Goals:**
- Wrapping other `SelectMgr_Filter` subclasses beyond the three StdSelect filters
- Implementing custom detection logic on entity owners (delegates to OCCT defaults)
- `AIS_ExclusionFilter` or compound filter logic
- Per-object filter configuration (filters are global to context)

## Decisions

1. **Heap-allocate filter instances, manage with `tg:finalize`.**
   - Filters are `Handle(SelectMgr_Filter)` objects owned by the context after `AddFilter`.
   - C wrapper returns `new Handle(SelectMgr_Filter)`, CLOS class wraps it with finalizer.
   - Safe because `AddFilter` increments the ref count; deleting the wrapper only decrements it.

2. **Filter classes share a common `selection-filter` base CLOS class.**
   - `selection-filter` has a `%ptr` slot and finalizer.
   - `edge-filter`, `face-filter`, `shape-type-filter` inherit from it.
   - Predicates: `selection-filter-p`, `edge-filter-p`, `face-filter-p`, `shape-type-filter-p`.

3. **`ShapeTypeFilter` exposes `set-shape-type` and `set-allowed-types` for configuration.**
   - OCCT's `StdSelect_ShapeTypeFilter::SetAllowedType` accepts `TopAbs_ShapeEnum`.
   - C wrapper takes an integer shape type enum.
   - CLOS wrapper accepts keywords (`:edge`, `:face`, `:wire`, `:vertex`, `:shell`, `:solid`) and converts to `TopAbs_ShapeEnum` ints.
   - `set-allowed-types` accepts a list of keywords for batch configuration.

4. **Entity owners use a common `entity-owner` CLOS base class.**
   - `entity-owner` has a `%ptr` slot and finalizer.
   - `brep-owner` inherits from it, adds shape extraction.
   - Predicates: `entity-owner-p`, `brep-owner-p`.

5. **`SelectedOwner` is exposed via a new CLOS wrapper accessor.**
   - During selection iteration, `ais-selected-owner` returns an `entity-owner` instance.
   - Returns nil if no owner is available (backward compatible).
   - The existing `ais-has-selected-shape` / `ais-selected-shape` can be reimplemented to use `brep-owner` internally.

6. **Filter activation is done via `(ais-add-filter ctx filter)` / `(ais-remove-filter ctx filter)`.**
   - Naming matches existing `ais-*` convention.
   - Both accept `selection-filter` instances.

7. **New file `src/core/selection-filters.lisp` for CLOS wrappers.**
   - Keeps filter/owner code separate from the existing `viewer-object-props.lisp` which already handles display/property operations.
   - Follows the pattern of other dedicated source files (e.g., `text.lisp`, `colors.lisp`).

## Risks / Trade-offs

- **Handle ownership**: Filters added to the context via `AddFilter` are ref-counted. If the Lisp user frees the filter wrapper while the context still holds it, the context retains the filter. This is safe but the Lisp object becomes stale (predicates and getters return nil). Mitigation: document that filter wrappers should be kept alive while the filter is in use.
- **No exclusive selection with filters**: OCCT's filter system only restricts what can be selected — it does not force exclusive selection. Users who want "select edges only" must also configure selection mode via `ais-set-selection-mode`. Mitigation: document this interaction.
- **API surface growth**: ~10 new C functions, ~10 CFFI bindings, ~15 CLOS functions. The `wrap/occt_wrap.cpp` file is already large (~8400 lines). Mitigation: no refactoring of existing code, just additive changes.
- **Entity owner stale pointers**: `SelectedOwner()` returns a reference to an owner that may be invalidated. The C wrapper must heap-copy the handle, similar to how `SelectedInteractive` works.

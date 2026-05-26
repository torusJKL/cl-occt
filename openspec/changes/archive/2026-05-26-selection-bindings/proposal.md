## Why

The archived selection-bindings change (2026-05-21) delivered programmatic selection, mouse detection, highlight, and configuration — but explicitly deferred filter and entity-owner wrapping. Users who need picking restricted to specific shape types (edges only, faces only, etc.) have no way to do so. Entity owners (`SelectMgr_EntityOwner`, `StdSelect_BRepOwner`) are needed for advanced selection workflows: per-owner priority, custom detection logic, and shape-type-aware selection handling.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h/.cpp` for:
  - `StdSelect_EdgeFilter`, `StdSelect_FaceFilter`, `StdSelect_ShapeTypeFilter` — construct, configure, assign to context
  - `StdSelect_BRepOwner` — query owner properties (shape, selection priority, etc.)
  - `SelectMgr_EntityOwner` — query entity owner properties (priority, selection mode, etc.)
- Add CFFI `defcfun` bindings in `src/ffi/bindings.lisp`
- Add CLOS wrapper functions in `src/core/viewer-object-props.lisp` (or new file)
- Add new classes with `tg:finalize` GC for filter/owner types
- Export all new symbols from `src/package.lisp`
- Add tests in `t/smoke-tests.lisp`
- Update `docs/api-reference.md` with new filter and entity-owner API surface

## Capabilities

### New Capabilities
- `selection-filters`: Selection filter types (`StdSelect_EdgeFilter`, `StdSelect_FaceFilter`, `StdSelect_ShapeTypeFilter`) with construction, type checking, and context activation
- `selection-entity-owners`: Entity owner access (`SelectMgr_EntityOwner`, `StdSelect_BRepOwner`) with property queries (priority, selection mode, shape extraction)

### Modified Capabilities
- `selection-management`: Existing spec amended to note that `ais-has-selected-shape` / `ais-selected-shape` now also returns the underlying `StdSelect_BRepOwner` information

## Impact

- `wrap/occt_wrap.h` — ~10 new function declarations
- `wrap/occt_wrap.cpp` — ~10 new function implementations
- `src/ffi/bindings.lisp` — ~10 new `defcfun` bindings
- `src/core/` — new file `selection.lisp` (preferred) or additions to `viewer-object-props.lisp` for filter/owner CLOS classes + wrappers
- `src/package.lisp` — ~10 new impl symbols + ~12 new public symbols
- `t/smoke-tests.lisp` — new test functions for filters and entity owners
- `docs/api-reference.md` — new "Selection Filters" and "Entity Owners" subsections under the existing "Selection" section

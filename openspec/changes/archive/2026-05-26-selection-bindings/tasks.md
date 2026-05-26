## 1. C Wrapper Layer — Entity Owners

- [x] 1.1 Add owner function declarations to `wrap/occt_wrap.h` (`ais_context_selected_owner`, `owner_priority`, `owner_selection_mode`, `brep_owner_shape`, `owner_location`, `free_owner`)
- [x] 1.2 Add owner function implementations to `wrap/occt_wrap.cpp`

## 2. C Wrapper Layer — Filters

- [x] 2.1 Add filter function declarations to `wrap/occt_wrap.h` (`make_edge_filter`, `make_face_filter`, `make_shape_type_filter`, `ais_context_add_filter`, `ais_context_remove_filter`, `filter_set_shape_type`, `filter_set_allowed_types`, `free_filter`)
- [x] 2.2 Add filter function implementations to `wrap/occt_wrap.cpp`

## 3. CFFI Bindings

- [x] 3.1 Add `%owner-*` and `%filter-*` defcfun bindings to `src/ffi/bindings.lisp`
- [x] 3.2 Add `%ais-context-add-filter`, `%ais-context-remove-filter`, `%ais-context-selected-owner` bindings to `src/ffi/bindings.lisp`

## 4. CLOS Wrapper Layer — Classes

- [x] 4.1 Create `src/core/selection.lisp` with `entity-owner`, `brep-owner`, `selection-filter`, `edge-filter`, `face-filter`, `shape-type-filter` CLOS classes and finalizers
- [x] 4.2 Add predicate functions: `entity-owner-p`, `brep-owner-p`, `selection-filter-p`, `edge-filter-p`, `face-filter-p`, `shape-type-filter-p`

## 5. CLOS Wrapper Layer — Functions

- [x] 5.1 Add entity owner accessors: `ais-selected-owner`, `owner-priority`, `owner-selection-mode`, `brep-owner-shape`, `owner-location`
- [x] 5.2 Add filter constructors: `make-edge-filter`, `make-face-filter`, `make-shape-type-filter`
- [x] 5.3 Add filter context operations: `ais-add-filter`, `ais-remove-filter`
- [x] 5.4 Add filter configuration: `set-filter-shape-type`, `set-filter-allowed-types`
- [x] 5.5 Add explicit free functions: `free-filter`, `free-owner`

## 6. Package Exports

- [x] 6.1 Add IMPL exports for all new `%`-prefixed symbols to `src/package.lisp`
- [x] 6.2 Add public exports for all CLOS functions, predicates, and classes to `src/package.lisp`

## 7. Tests

- [x] 7.1 Add filter creation and type predicate tests to `t/smoke-tests.lisp`
- [x] 7.2 Add filter context activation tests to `t/smoke-tests.lisp`
- [x] 7.3 Add entity owner access and shape extraction tests to `t/smoke-tests.lisp`

## 8. Documentation

- [x] 8.1 Update `docs/api-reference.md` with new Selection Filters and Entity Owners sections under the existing Selection heading

## 9. Build & Verify

- [x] 9.1 Rebuild `libocctwrap.so` and run `just test-all`

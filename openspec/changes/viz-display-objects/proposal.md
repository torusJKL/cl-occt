## Why

A blank viewport is useless — users need to see their shapes. This phase adds the AIS (Application Interactive Services) layer: the rendering context that manages display/erase/lifetime of interactive objects, and the AIS_Shape wrapper that makes any TopoDS_Shape visible.

## What Changes

- **C wrapper**: 9 new functions for AIS_InteractiveContext and AIS_Shape lifecycle and display/erase operations
- **CFFI bindings**: 9 new `defcfun` forms
- **CLOS wrappers**: `ais-context` and `ais-object` classes with `tg:finalize`
- **Lisp API**: `ais-create-context`, `ais-display`, `ais-erase`, `ais-remove`, `ais-remove-all`, `ais-displayed-p`, `ais-free`
- **Extends `viewer` class from Phase 1**: each viewer can have an associated AIS context

## Capabilities

### New Capabilities

- `display`: Display any shape in the 3D viewport, with optional color. Return an `ais-object` handle for later manipulation.

### Modified Capabilities

None — this builds on Phase 1 but is independent if Phase 1 is already in place.

## Impact

- `wrap/occt_wrap.cpp`: add includes for `AIS_InteractiveContext`, `AIS_Shape`; add 9 new functions
- `wrap/occt_wrap.h`: add 9 new declarations
- `src/ffi/bindings.lisp`: add 9 new `defcfun` forms
- `src/core/viewer.lisp`: add `ais-context` and `ais-object` classes, display/erase API (extend existing file)
- `src/package.lisp`: export new symbols
- `t/smoke-tests.lisp`: add display/erase tests

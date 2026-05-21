## Why

The viewer system can display and style objects, but lacks any way to programmatically select or query selection state. This blocks interactive picking, batch operations on selected objects, and any UI-driven workflows. OCCT's AIS_InteractiveContext provides a rich selection API — we need bindings for it.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h/.cpp` for selection iteration, management, mouse detection, and highlight control
- Add CFFI `defcfun` bindings in `src/ffi/bindings.lisp`
- Add CLOS wrapper functions in `src/core/viewer-object-props.lisp`
- Add enum keyword maps for selection schemes and status codes in `src/core/viewer.lisp`
- Export all new symbols from `src/package.lisp`
- Add tests in `t/smoke-tests.lisp`
- Update README with new selection API surface

## Capabilities

### New Capabilities
- `selection-management`: Programmatic selection of displayed AIS objects (set, add/remove, clear, query), selection iteration (init/more/next), and shape extraction from selection
- `mouse-detection`: Mouse-driven picking via MoveTo, SelectDetected, and SelectPoint with selection scheme support
- `selection-highlight`: Manual control of selection highlight (hilight/unhilight selected objects)
- `selection-configuration`: Pixel tolerance, selection sensitivity, automatic highlight toggles, and fit-to-selected

### Modified Capabilities

None.

## Impact

- `wrap/occt_wrap.h` — ~24 new function declarations
- `wrap/occt_wrap.cpp` — ~24 new function implementations
- `src/ffi/bindings.lisp` — ~24 new `defcfun` bindings
- `src/core/viewer.lisp` — 3 new enum keyword maps
- `src/core/viewer-object-props.lisp` — ~24 new CLOS wrapper functions
- `src/package.lisp` — ~24 new impl symbols + ~28 new public symbols
- `t/smoke-tests.lisp` — new test functions for selection
- `README.md` — document new selection API

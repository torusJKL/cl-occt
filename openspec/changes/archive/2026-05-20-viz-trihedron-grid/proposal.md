## Why

Without a visual reference for the coordinate axes, users lose spatial orientation when orbiting a 3D view. A trihedron (3D axis indicator) fixed in the corner provides immediate orientation feedback. This is the final piece of a practical viewer — all other core viewing features are built in Phases 1-3.

## What Changes

- **C wrapper**: 6 new functions for AIS_Trihedron creation, styling (datum mode, arrows, size), and transform persistence (fixed corner position)
- **CFFI bindings**: matching defcfun forms
- **Lisp API**: `make-trihedron`, `set-trihedron-mode`, `set-trihedron-arrows`, `set-trihedron-size`, `set-trihedron-corner`, `show-trihedron` convenience function
- **Reuses `ais-object` class** from Phase 2 — trihedron is just another `ais-object` with extra setters

## Capabilities

### New Capabilities

- `trihedron`: Create a 3D axis indicator (red=X, green=Y, blue=Z) with configurable appearance and fixed screen-corner persistence

### Modified Capabilities

None.

## Impact

- `wrap/occt_wrap.h`: add 6 function declarations
- `wrap/occt_wrap.cpp`: add 6 implementations + includes for `AIS_Trihedron`, `Geom_Axis2Placement`, `gp_Pnt`, `gp_Dir`, `Graphic3d_TransformPers`, `Prs3d_DatumMode`
- `src/ffi/bindings.lisp`: add 6 defcfun forms
- `src/core/viewer.lisp` or new `src/core/trihedron.lisp`: add trihedron API
- `src/package.lisp`: export new symbols
- `t/smoke-tests.lisp`: add trihedron tests

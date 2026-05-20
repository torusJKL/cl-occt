## Why

cl-occt can compute parametric shapes but has no way to look at them. Users must export to STEP/STL and view in a separate tool — breaking the rapid-iteration feedback loop. A minimal viewer infrastructure provides a 3D viewport inside the REPL, enabling interactive inspection of computed geometry.

## What Changes

- **C wrapper library**: Add 8 new `extern "C"` functions to `occt_wrap.cpp` for graphic driver creation, V3d viewer/view lifecycle, and neutral window wrapping
- **Link visualization libraries**: Add `-lTKV3d -lTKOpenGl -lTKService` to the `justfile` wrap recipe
- **CFFI bindings**: 8 new `defcfun` forms in `src/ffi/bindings.lisp`
- **CLOS wrappers**: `driver`, `viewer`, `view` classes with `tg:finalize` + explicit free in `src/core/viewer.lisp`
- **Lisp API**: `make-viewer`, `fit-all`, `with-viewer` macro — idiomatic high-level entry point that hides the driver→viewer→view plumbing

## Capabilities

### New Capabilities

- `viewer`: Create and manage a 3D viewport backed by OCCT's OpenGL renderer, with automatic cleanup

### Modified Capabilities

None.

## Impact

- `wrap/occt_wrap.h`: add 8 new function declarations
- `wrap/occt_wrap.cpp`: add 8 new C functions + includes for `OpenGl_GraphicDriver`, `V3d_Viewer`, `V3d_View`, `Aspect_NeutralWindow`, `Aspect_DisplayConnection`
- `justfile`: add `-lTKV3d -lTKOpenGl -lTKService` to wrap link line
- `src/ffi/bindings.lisp`: add 8 new `defcfun` forms
- `src/core/viewer.lisp`: new file — CLOS classes, factories, `with-viewer`
- `src/package.lisp`: export new symbols from both packages
- `t/smoke-tests.lisp`: add viewer creation and cleanup tests

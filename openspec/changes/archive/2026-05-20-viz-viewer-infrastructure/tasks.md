## 1. Build System — Link Visualization Libraries

- [x] 1.1 Add `-lTKV3d -lTKOpenGl -lTKService` to the `justfile` wrap recipe's g++ link line

## 2. C Wrapper — Header Declarations

- [x] 2.1 Add to `wrap/occt_wrap.h`:
  - `void* create_graphic_driver(void);`
  - `void  free_graphic_driver(void*);`
  - `void* v3d_create_viewer(void* driver);`
  - `void  v3d_free_viewer(void*);`
  - `void* v3d_create_view(void* viewer);`
  - `void  v3d_free_view(void*);`
  - `void* create_neutral_window(void* native_handle);`
  - `void  free_neutral_window(void*);`

## 3. C Wrapper — Implementation

- [x] 3.1 Add includes:
  - `#include <OpenGl_GraphicDriver.hxx>`
  - `#include <Aspect_DisplayConnection.hxx>`
  - `#include <Aspect_NeutralWindow.hxx>`
  - `#include <V3d_Viewer.hxx>`
  - `#include <V3d_View.hxx>`
- [x] 3.2 Implement `create_graphic_driver` — create `Aspect_DisplayConnection`, then `OpenGl_GraphicDriver`, return as `Handle(OpenGl_GraphicDriver)*`
- [x] 3.3 Implement `free_graphic_driver` — delete the Handle pointer
- [x] 3.4 Implement `v3d_create_viewer` — deref driver Handle, create `V3d_Viewer`, return Handle*
- [x] 3.5 Implement `v3d_free_viewer` — delete Handle pointer
- [x] 3.6 Implement `v3d_create_view` — call `viewer->CreateView()`, return Handle*
- [x] 3.7 Implement `v3d_free_view` — delete Handle pointer
- [x] 3.8 Implement `create_neutral_window` — create `Aspect_NeutralWindow`, call `SetNativeHandle(native_handle)`, return Handle*
- [x] 3.9 Implement `free_neutral_window` — delete Handle pointer
- [x] 3.10 Verify: rebuild with `just wrap`, check no compilation errors

## 4. CFFI Bindings

- [x] 4.1 Add defcfun forms to `src/ffi/bindings.lisp`:
  - `%create-graphic-driver` → `:pointer`
  - `%free-graphic-driver` → `:void` (driver :pointer)
  - `%v3d-create-viewer` → `:pointer` (driver :pointer)
  - `%v3d-free-viewer` → `:void` (viewer :pointer)
  - `%v3d-create-view` → `:pointer` (viewer :pointer)
  - `%v3d-free-view` → `:void` (view :pointer)
  - `%create-neutral-window` → `:pointer` (native-handle :pointer)
  - `%free-neutral-window` → `:void` (window :pointer)

## 5. Core — Viewer Module

- [x] 5.1 Create `src/core/viewer.lisp` with:

  ```lisp
  (defclass viewer ()
    ((%driver :initarg :driver :reader %driver)
     (%viewer :initarg :viewer :reader %viewer)
     (%view   :initarg :view   :reader %view)))
  ```

- [x] 5.2 Implement `make-viewer` factory — creates driver + viewer + view, wraps in `viewer` instance with `tg:finalize`
- [x] 5.3 Implement `free-viewer` — frees view, viewer, driver handles in reverse order
- [x] 5.4 Implement `fit-all` — calls `v3d_fit_all` on the view handle
- [x] 5.5 Implement `must-be-resized` — calls `v3d_view_must_be_resized` on the view handle
- [x] 5.6 Implement `with-viewer` macro:

  ```lisp
  (defmacro with-viewer ((var) &body body)
    `(let ((,var (make-viewer)))
       (unwind-protect (progn ,@body)
         (free-viewer ,var))))
  ```

## 6. Package Exports

- [x] 6.1 Export from `cl-occt.impl`: `%create-graphic-driver`, `%free-graphic-driver`, `%v3d-create-viewer`, `%v3d-free-viewer`, `%v3d-create-view`, `%v3d-free-view`, `%create-neutral-window`, `%free-neutral-window`
- [x] 6.2 Export from `cl-occt`: `viewer`, `viewer-p`, `make-viewer`, `free-viewer`, `fit-all`, `must-be-resized`, `with-viewer`

## 7. Smoke Tests

- [x] 7.1 Add test: `make-viewer` returns a viewer instance (may skip if no display available)
- [x] 7.2 Add test: `with-viewer` creates and cleans up
- [x] 7.3 Add test: `free-viewer` on already-freed viewer is safe (double-free check)
- [x] 7.4 Register all new tests in `run-tests` list

## 8. README — Viewer Documentation

- [x] 8.1 Update the top description to mention visualization: `"Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O, a reactive DAG engine, a parametric DSL, and a 3D viewer."`
- [x] 8.2 In Build section, change "No Visualization (TKV3d, TKOpenGl)" to note that Visualization is enabled and TKV3d/TKOpenGl/TKService are linked
- [x] 8.3 Add "Viewer" section to API Reference table:
- [x] 8.4 Add viewer quickstart example after the parametric DAG example:
- [x] 8.5 Update Project Structure: add `viewer.lisp` to `src/core/` list, update `wrap/occt_wrap.h` declaration count (44 → 52), update test count (101 → ~104)
- [x] 8.6 Update Architecture section: add viewer module to the layer description, update C function count (57 → 65)
- [x] 8.7 Update the diagram to show the viewer module

## 9. Build & Verify

- [x] 9.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 9.2 Load in SBCL, verify package exports visible
- [x] 9.3 Run `(cl-occt::run-tests)` — all tests pass

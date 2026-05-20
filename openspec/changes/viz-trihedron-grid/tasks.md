## 1. C Wrapper — Header Declarations

- [x] 1.1 Add to `wrap/occt_wrap.h`:
  - `void* ais_create_trihedron(double ox, double oy, double oz, double dx, double dy, double dz, double ux, double uy, double uz);`
  - `void  ais_trihedron_set_datum_mode(void* obj, int mode);`
  - `void  ais_trihedron_set_draw_arrows(void* obj, int on);`
  - `void  ais_trihedron_set_size(void* obj, double size);`
  - `void  ais_trihedron_set_transform_pers(void* obj, int corner, int xOff, int yOff);`

## 2. C Wrapper — Implementation

- [x] 2.1 Add includes:
  - `#include <AIS_Trihedron.hxx>`
  - `#include <Geom_Axis2Placement.hxx>`
  - `#include <gp_Pnt.hxx>`
  - `#include <gp_Dir.hxx>`
  - `#include <Graphic3d_TransformPers.hxx>`
  - `#include <Prs3d_DatumMode.hxx>`
  - `#include <Aspect_TypeOfTriedronPosition.hxx>`
- [x] 2.2 Implement `ais_create_trihedron` — construct `gp_Pnt`, `gp_Dir`, `Geom_Axis2Placement`, then `AIS_Trihedron`; return `Handle(AIS_InteractiveObject)*`
- [x] 2.3 Implement `ais_trihedron_set_datum_mode` — call `obj->SetDatumDisplayMode(static_cast<Prs3d_DatumMode>(mode))`
- [x] 2.4 Implement `ais_trihedron_set_draw_arrows` — call `obj->SetDrawArrows(on != 0)`
- [x] 2.5 Implement `ais_trihedron_set_size` — call `obj->SetSize(size)`
- [x] 2.6 Implement `ais_trihedron_set_transform_pers` — construct `Graphic3d_TransformPers` with `Graphic3d_TMF_TriedronPers`, corner enum, and offsets; call `obj->SetTransformPersistence(pers)`
- [x] 2.7 Validate zero-vector inputs for `gp_Dir` in `ais_create_trihedron` — return nullptr with error if normal or x-direction is zero
- [x] 2.8 Verify: rebuild with `just wrap`, check no compilation errors

## 3. CFFI Bindings

- [x] 3.1 Add defcfun forms to `src/ffi/bindings.lisp`:
  - `%ais-create-trihedron` → `:pointer` (ox oy oz dx dy dz ux uy uz :double)
  - `%ais-trihedron-set-datum-mode` → `:void` (obj :pointer mode :int)
  - `%ais-trihedron-set-draw-arrows` → `:void` (obj :pointer on :int)
  - `%ais-trihedron-set-size` → `:void` (obj :pointer size :double)
  - `%ais-trihedron-set-transform-pers` → `:void` (obj :pointer corner :int x-off :int y-off :int)

## 4. Lisp API — Trihedron

- [x] 4.1 Implement `make-trihedron` — wraps `%ais-create-trihedron`, returns `ais-object` with tg:finalize

  ```lisp
  (defun make-trihedron (&key (origin '(0 0 0)) (normal '(0 0 1)) (x-direction '(1 0 0)))
    ...)
  ```

- [x] 4.2 Implement `set-trihedron-mode` — translates keyword `:wireframe`/`:shaded` to int, calls `%ais-trihedron-set-datum-mode`
- [x] 4.3 Implement `set-trihedron-arrows` — calls `%ais-trihedron-set-draw-arrows` with 1/0
- [x] 4.4 Implement `set-trihedron-size` — calls `%ais-trihedron-set-size`
- [x] 4.5 Implement `set-trihedron-corner` — translates keyword to int, calls `%ais-trihedron-set-transform-pers`
- [x] 4.6 Implement `show-trihedron` — creates trihedron, configures corner + size, displays in context, returns ais-object

  ```lisp
  (defun show-trihedron (context viewer &key (corner :lower-left) (size 50))
    (let ((tri (make-trihedron)))
      (set-trihedron-corner tri corner :x-offset 50 :y-offset 50)
      (set-trihedron-size tri size)
      (ais-display context tri)
      tri))
  ```

## 5. Package Exports

- [x] 5.1 Export new `%` symbols from `cl-occt.impl`
- [x] 5.2 Export new public symbols from `cl-occt`: `make-trihedron`, `set-trihedron-mode`, `set-trihedron-arrows`, `set-trihedron-size`, `set-trihedron-corner`, `show-trihedron`

## 6. Smoke Tests

- [x] 6.1 Add test: `make-trihedron` with defaults returns ais-object
- [x] 6.2 Add test: `make-trihedron` with zero normal returns nil
- [x] 6.3 Add test: `set-trihedron-mode` with `:shaded` does not error
- [x] 6.4 Add test: `set-trihedron-arrows` nil does not error
- [x] 6.5 Add test: `set-trihedron-size` to 100 does not error
- [x] 6.6 Add test: `set-trihedron-corner` with `:lower-right` does not error
- [x] 6.7 Add test: `show-trihedron` in context returns ais-object
- [x] 6.8 Register all new tests in `run-tests` list

## 7. README — Trihedron Documentation

- [x] 7.1 Add "Trihedron" section to API Reference table:

  ```
  ### Trihedron
  | `(make-trihedron &key origin normal x-direction)` | Create a 3D axis indicator |
  | `(set-trihedron-mode obj mode)` | Set datum mode (`:wireframe` or `:shaded`) |
  | `(set-trihedron-arrows obj bool)` | Show/hide arrowheads |
  | `(set-trihedron-size obj size)` | Set visual size |
  | `(set-trihedron-corner obj corner &key x-offset y-offset)` | Pin to screen corner (`:lower-left`, `:upper-right`, etc.) |
  | `(show-trihedron ctx viewer &key corner size)` | Create, configure, and display a trihedron in one call |
  ```

- [x] 7.2 Update the viewer quickstart example to include `show-trihedron`:

  ```lisp
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (ais-display ctx (make-box 10 20 30))
      (show-trihedron ctx v :corner :lower-left)
      (fit-all v)))
  ```

- [x] 7.3 Update C function count in Architecture section (86 → 91)
- [x] 7.4 Update test count
- [x] 7.5 Update Project Structure: ensure `viewer.lisp` or trihedron file is listed
- [x] 7.6 Finalize the top description: `"Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O, a reactive DAG engine, a parametric DSL, and a full 3D viewer with object display, styling, camera control, and a trihedron orientation aid."`

## 8. Build & Verify

- [x] 8.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 8.2 Run `(cl-occt::run-tests)` — all tests pass

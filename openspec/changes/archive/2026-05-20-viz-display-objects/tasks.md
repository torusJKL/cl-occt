## 1. C Wrapper — Header Declarations

- [x] 1.1 Add to `wrap/occt_wrap.h`:
  - `void* ais_create_context(void* viewer);`
  - `void  ais_free_context(void*);`
  - `void* ais_create_shape(void* shape);`
  - `void  ais_free_shape(void*);`
  - `void  ais_context_display(void* ctx, void* obj, int update);`
  - `void  ais_context_erase(void* ctx, void* obj, int update);`
  - `void  ais_context_remove(void* ctx, void* obj, int update);`
  - `void  ais_context_remove_all(void* ctx, int update);`
  - `int   ais_context_is_displayed(void* ctx, void* obj);`

## 2. C Wrapper — Implementation

- [x] 2.1 Add includes:
  - `#include <AIS_InteractiveContext.hxx>`
  - `#include <AIS_Shape.hxx>`
  - `#include <AIS_InteractiveObject.hxx>`
- [x] 2.2 Implement `ais_create_context` — `Handle(AIS_InteractiveContext)*` from V3d_Viewer handle
- [x] 2.3 Implement `ais_free_context` — delete Handle pointer
- [x] 2.4 Implement `ais_create_shape` — `Handle(AIS_Shape)*` from TopoDS_Shape pointer
- [x] 2.5 Implement `ais_free_shape` — delete Handle pointer
- [x] 2.6 Implement `ais_context_display` — call `context->Display(obj, update)`
- [x] 2.7 Implement `ais_context_erase` — call `context->Erase(obj, update)`
- [x] 2.8 Implement `ais_context_remove` — call `context->Remove(obj, update)`
- [x] 2.9 Implement `ais_context_remove_all` — call `context->RemoveAll(update)`
- [x] 2.10 Implement `ais_context_is_displayed` — call `context->IsDisplayed(obj)`, return 1/0
- [x] 2.11 Verify: rebuild with `just wrap`, check no compilation errors

## 3. CFFI Bindings

- [x] 3.1 Add defcfun forms to `src/ffi/bindings.lisp`:
  - `%ais-create-context` → `:pointer` (viewer :pointer)
  - `%ais-free-context` → `:void` (ctx :pointer)
  - `%ais-create-shape` → `:pointer` (shape :pointer)
  - `%ais-free-shape` → `:void` (obj :pointer)
  - `%ais-context-display` → `:void` (ctx :pointer obj :pointer update :int)
  - `%ais-context-erase` → `:void` (ctx :pointer obj :pointer update :int)
  - `%ais-context-remove` → `:void` (ctx :pointer obj :pointer update :int)
  - `%ais-context-remove-all` → `:void` (ctx :pointer update :int)
  - `%ais-context-is-displayed` → `:int` (ctx :pointer obj :pointer)

## 4. Core — Extend viewer.lisp with AIS classes

- [x] 4.1 Add to `src/core/viewer.lisp`:

  ```lisp
  (defclass ais-context ()
    ((%ptr :initarg :ptr :reader %ptr)))

  (defclass ais-object ()
    ((%ptr :initarg :ptr :reader %ptr)))
  ```

- [x] 4.2 Implement `ais-create-context` — wraps `%ais-create-context`, returns `ais-context` instance with tg:finalize
- [x] 4.3 Implement `ais-free-context` — calls `%ais-free-context`, nulls pointer
- [x] 4.4 Implement `ais-create-shape` — wraps `%ais-create-shape`, returns `ais-object` instance with tg:finalize
- [x] 4.5 Implement `ais-free` — calls `%ais-free-shape`, nulls pointer
- [x] 4.6 Implement `ais-display` — dispatches on `shape` vs `ais-object` input; auto-creates AIS_Shape for shape inputs; returns ais-object
- [x] 4.7 Implement `ais-erase` — calls `%ais-context-erase`
- [x] 4.8 Implement `ais-remove` — calls `%ais-context-remove`
- [x] 4.9 Implement `ais-remove-all` — calls `%ais-context-remove-all`
- [x] 4.10 Implement `ais-displayed-p` — calls `%ais-context-is-displayed`

## 5. Package Exports

- [x] 5.1 Export from `cl-occt.impl`: `%ais-create-context`, `%ais-free-context`, `%ais-create-shape`, `%ais-free-shape`, `%ais-context-display`, `%ais-context-erase`, `%ais-context-remove`, `%ais-context-remove-all`, `%ais-context-is-displayed`
- [x] 5.2 Export from `cl-occt`: `ais-context`, `ais-context-p`, `ais-object`, `ais-object-p`, `ais-create-context`, `ais-free-context`, `ais-create-shape`, `ais-free`, `ais-display`, `ais-erase`, `ais-remove`, `ais-remove-all`, `ais-displayed-p`

## 6. Smoke Tests

- [x] 6.1 Add test: `ais-create-context` from a viewer returns ais-context
- [x] 6.2 Add test: `ais-create-shape` from a box returns ais-object
- [x] 6.3 Add test: `ais-display` shape in context returns ais-object
- [x] 6.4 Add test: `ais-displayed-p` returns true after display
- [x] 6.5 Add test: `ais-erase` hides without removing
- [x] 6.6 Add test: `ais-remove` removes from context
- [x] 6.7 Add test: `ais-free` on nil is safe
- [x] 6.8 Add test: `ais-create-shape` with nil shape returns nil
- [x] 6.9 Register all new tests in `run-tests` list

## 7. README — Display Documentation

- [x] 7.1 Add "Display" section to API Reference table:

  ```
  ### Display
  | `(ais-create-context viewer)` | Create an AIS interactive context from a viewer |
  | `(ais-free-context ctx)` | Destroy an AIS context |
  | `(ais-create-shape shape)` | Create an interactive shape object from a geometry shape |
  | `(ais-display ctx shape-or-obj &key update)` | Display a shape or ais-object; returns ais-object |
  | `(ais-erase ctx obj &key update)` | Hide an object (remains in context) |
  | `(ais-remove ctx obj &key update)` | Permanently remove an object from context |
  | `(ais-remove-all ctx &key update)` | Remove all objects from context |
  | `(ais-displayed-p ctx obj)` | Check if an object is currently displayed |
  | `(ais-free obj)` | Free an ais-object's C handle |
  ```

- [x] 7.2 Add display quickstart example after the viewer quickstart:

  ```lisp
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (ais-display ctx (make-box 10 20 30))
      (fit-all v)))
  ```

- [x] 7.3 Update Architecture section: add `ais-context` and `ais-object` types to layer description, update C function count (65 → 74)
- [x] 7.4 Update Project Structure: update `viewer.lisp` description to mention AIS classes, update test count, update function counts
- [x] 7.5 Update top description if it doesn't already mention display

## 8. Build & Verify

- [x] 8.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 8.2 Run `(cl-occt::run-tests)` — all tests pass

## Context

The visualization layer needs a platform-specific graphic driver (OpenGL context), a viewer that manages lights and coordinate systems, one or more views (viewports), and a native window to render into.

What the C wrapper provides:
- Platform-agnostic factory for the graphic driver (uses X11 on Linux, abstracted by OCCT's `Aspect_DisplayConnection`)
- Window wrapping from a native handle (opaque `void*` that the caller obtains from Qt/GLFW/etc.)
- Viewer and view creation/deletion

What Lisp provides:
- Composition: wiring driver → viewer → view → window into a single `make-viewer` call
- Resource management: `tg:finalize` as safety net, explicit free as primary
- Idiomatic DSL: `with-viewer` macro ensuring setup/teardown

## Goals / Non-Goals

**Goals:**
- C functions for creating/freeing `OpenGl_GraphicDriver`, `V3d_Viewer`, `V3d_View`, `Aspect_NeutralWindow`
- Lisp `driver`, `viewer`, `view` CLOS classes with `%ptr` slot and `tg:finalize`
- `make-viewer` high-level factory creating all three internally
- `with-viewer` macro: `(with-viewer (v) ...)`, auto-teardown on exit
- `fit-all` to zoom to extents
- `must-be-resized` for window resize events
- Justfile links `-lTKV3d -lTKOpenGl -lTKService`

**Non-Goals:**
- AIS context or shape display (Phase 2)
- Color, camera orientation, grid (Phase 3)
- Multiple views per viewer
- Offscreen rendering / headless mode
- Anything beyond blank viewport creation

## Decisions

### C Wrapper: Minimal platform abstraction

The graphic driver is the most platform-sensitive piece. OCCT uses:

```
Linux/X11:   OpenGl_GraphicDriver(new Xw_DisplayConnection(displayName))
macOS:       OpenGl_GraphicDriver(new Cocoa_DisplayConnection())
Windows:     OpenGl_GraphicDriver(new Win32_DisplayConnection())
```

Solution: Provide `create_graphic_driver()` that takes no argument and uses platform-appropriate defaults (null display name = default connection on all platforms). This keeps the C signature platform-independent and defers platform-specific window handle passing to the `create_neutral_window(void*)` function.

```cpp
// wrap/occt_wrap.cpp

void* create_graphic_driver() {
    // Platform: X11 on Linux, Cocoa on macOS, Win32 on Windows
    Handle(OpenGl_GraphicDriver)* h = new Handle(OpenGl_GraphicDriver);
    Handle(Aspect_DisplayConnection) display = new Aspect_DisplayConnection();
    *h = new OpenGl_GraphicDriver(display);
    if (!h->IsNull()) {
        h->ChangeOptions().contextType = Aspect_GraphicsContextType::Aspect_GC_Output;
    }
    return h;
}
```

### Lisp API: compose, don't expose the driver

The end user should not care about graphic drivers or display connections. `make-viewer` creates everything:

```lisp
(defun make-viewer (&optional (native-window-handle (cffi:null-pointer)))
  (let* ((driver (%create-graphic-driver))
         (viewer  (%v3d-create-viewer driver))
         (view    (%v3d-create-view view))
         (wrapped (make-instance 'viewer
                   :driver driver :viewer viewer :view view)))
    (tg:finalize wrapped (lambda () (free-viewer wrapped)))
    (when (not (cffi:null-pointer-p native-window-handle))
      (%v3d-view-set-window view native-window-handle))
    wrapped))
```

Wait — this creates one CLOS class `viewer` that owns all three handles. This avoids forcing the user to track three separate objects. The alternative (three separate classes) is more flexible but more complex for the common case. Decision: single `viewer` class that owns the composite.

```lisp
(defclass viewer ()
  ((%driver :initarg :driver :reader %driver)
   (%viewer :initarg :viewer :reader %viewer)
   (%view   :initarg :view   :reader %view)))
```

The `with-viewer` macro becomes trivially safe:

```lisp
(defmacro with-viewer ((var) &body body)
  `(let ((,var (make-viewer)))
     (unwind-protect (progn ,@body)
       (free-viewer ,var))))
```

### Allocation pattern: heap-allocated Handle<T>*, same as XDE docs

```
void* v3d_create_viewer(void* driver_ptr) {
    auto* driver = static_cast<Handle(OpenGl_GraphicDriver)*>(driver_ptr);
    Handle(V3d_Viewer)* h = new Handle(V3d_Viewer);
    *h = new V3d_Viewer(**driver);
    return h;
}
```

Matching XDE exactly. `free` functions delete the Handle* pointer.

### Window: opaque native handle

`create_neutral_window(void* nativeHandle)` takes a platform window pointer and wraps it in an `Aspect_NeutralWindow`. On Qt, this would be `(cffi:pointer-to-int (widget-win-id widget))`.

```cpp
void* create_neutral_window(void* native_handle) {
    Handle(Aspect_NeutralWindow)* h = new Handle(Aspect_NeutralWindow)(new Aspect_NeutralWindow());
    (**h)->SetNativeHandle(native_handle);  // or SetNativeWindow on newer OCCT
    return h;
}
```

(OCCT 8.0 API note: verify `SetNativeHandle` vs `SetNativeWindow`.)

### Link libraries

Add to justfile wrap recipe:
```
-lTKV3d -lTKOpenGl -lTKService
```

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `Aspect_DisplayConnection` constructor differs across OCCT versions | Check OCCT 8.0 API; fallback to `new Aspect_DisplayConnection(nullptr)` which works on all platforms |
| `SetNativeHandle` API may differ between OCCT 8.0 releases | Test against the specific `.local/` build; document required version |
| Window handle type varies by GUI framework (Qt WId, GLFW GLFWwindow*, etc.) | Accept `void*` in C wrapper; caller casts appropriately. Document for Qt (`cffi:pointer-to-int`) |
| No headless/offscreen mode in V1 | Acceptable — V1 requires a display. Offscreen can be added later via `Aspect_NeutralWindow` with FBO |

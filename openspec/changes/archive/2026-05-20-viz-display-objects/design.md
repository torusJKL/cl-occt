## Context

Phase 1 created the rendering infrastructure (driver → viewer → view → window). Phase 2 adds the AIS layer that knows how to turn geometry into renderable objects.

OCCT's AIS has a clear separation:
- `AIS_InteractiveContext` — the rendering controller. Created from a `V3d_Viewer`. Manages collections of interactive objects, selection, highlight, display modes.
- `AIS_InteractiveObject` — abstract base for anything displayable. `AIS_Shape` is the concrete subclass that wraps `TopoDS_Shape`.

The Lisp API wraps `AIS_InteractiveContext` in an `ais-context` CLOS class, and any interactive object (AIS_Shape for now) in an `ais-object` CLOS class.

## Goals / Non-Goals

**Goals:**
- C function to create `AIS_InteractiveContext` from a `V3d_Viewer` handle
- C functions to Display, Erase, Remove, RemoveAll, and query IsDisplayed
- C function to create `AIS_Shape` from a `TopoDS_Shape` handle
- CLOS `ais-context` and `ais-object` classes with explicit free + tg:finalize
- `ais-display` dispatches on shape vs ais-object input
- `ais-display` returns the ais-object for later manipulation
- Error handling: null pointer → nil, C errors via `get-error-message`

**Non-Goals:**
- Color/material/transparency (Phase 3)
- Selection (future)
- Highlight modes (future)
- DAG integration (explicit manual push only)

## Decisions

### ais-object: single CLOS class for all AIS interactive objects

```lisp
(defclass ais-object ()
  ((%ptr :initarg :ptr :reader %ptr)))
```

Even though we only have `AIS_Shape` now, using `Handle(AIS_InteractiveObject)*` as the C representation means future AIS types (AIS_Trihedron, etc.) reuse the same class without Lisp changes. The C wrapper casts up to `AIS_InteractiveObject` on creation.

### ais-display: dispatch on input type

```lisp
(defun ais-display (context shape-or-obj &key color update)
  (let ((obj (if (typep shape-or-obj 'ais-object)
                 shape-or-obj
                 (ais-create-shape shape-or-obj))))
    (when color
      (ais-set-color obj color))               ;; Phase 3
    (%ais-context-display (%ptr context)
                          (%ptr obj)
                          (if update 1 0))
    obj))                                       ;; return the ais-object
```

This lets users write either:

```lisp
;; Automatic: shape → ais-object created internally
(let ((obj (ais-display ctx (make-box 10 20 30))))
  ;; save obj for later
  )

;; Explicit: create ais-object first
(let ((obj (ais-create-shape (make-box 10 20 30))))
  (ais-display ctx obj)
  (ais-erase ctx obj)
  (ais-free obj))
```

### ais-erase vs ais-remove

OCCT distinguishes:
- **Erase**: hide from view. Object stays in context, can be re-displayed.
- **Remove**: destroy from context. Object gone permanently.

Both exposed as separate Lisp functions. Neither frees the ais-object handle — the user must call `ais-free` (or wait for GC) for that. The context's remove drops its reference, but the Handle* on the heap holds one more reference until freed.

### Ownership diagram

```
┌─────────────────────────────┐
│      Lisp ais-object        │  ←─ explicit ais-free or tg:finalize
│  Handle(AIS_Interactive)*───┼── ref 1 ──→ AIS_Shape (heap)
└─────────────────────────────┘
                                            ↑
┌─────────────────────────────┐             │
│   AIS_InteractiveContext    │── ref 2 ────┘  (after Display)
│                             │── ref drops ── (after Remove/Erase)
└─────────────────────────────┘
```

If Lisp GCs the ais-object = ref 1 drops. If context still holds ref 2, shape lives on. If context removed it earlier, shape is freed.

### C wrapper notes

`ais_create_context` takes the V3d_Viewer handle (from Phase 1) and creates the context:

```cpp
void* ais_create_context(void* viewer_ptr) {
    auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
    Handle(AIS_InteractiveContext)* h = new Handle(AIS_InteractiveContext);
    *h = new AIS_InteractiveContext(**viewer);
    return h;
}
```

`ais_create_shape` takes a TopoDS_Shape handle and creates the AIS_Shape:

```cpp
void* ais_create_shape(void* shape_ptr) {
    auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
    Handle(AIS_Shape)* h = new Handle(AIS_Shape)(new AIS_Shape(*shape));
    return h;  // returned as Handle(AIS_InteractiveObject)* via cast
}
```

The display function receives `Handle(AIS_InteractiveContext)*` and `Handle(AIS_InteractiveObject)*`, dereferences, and calls:

```cpp
void ais_context_display(void* ctx_ptr, void* obj_ptr, int update) {
    auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
    auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
    (*ctx)->Display(**obj, update != 0);
}
```

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| User might forget to call `ais-free` before removing ais-object handles | `tg:finalize` provides safety net; explicit `ais-free` satisfies deterministic cleanup |
| AIS_Shape references stale TopoDS_Shape | AIS_Shape copies the shape internally; original can be GC'd independently |
| Accessing ais-object after context removal | ais-object handle still alive but context doesn't know about it. ais-free still works; re-displaying would fail silently |

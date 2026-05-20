## Context

OCCT's `AIS_Trihedron` provides a 3D coordinate axes indicator. It takes a `Geom_Axis2Placement` (origin + normal direction + X-direction) and displays colored arrows/labels for X (red), Y (green), and Z (blue).

`Graphic3d_TransformPers` makes the trihedron stay in a fixed screen location (e.g., lower-left corner) regardless of camera orbit — critical for an orientation aid.

## Goals / Non-Goals

**Goals:**
- C function to create `AIS_Trihedron` from 9 doubles (origin xyz, normal xyz, x-direction xyz)
- C function to set datum display mode (wireframe vs shaded)
- C function to toggle arrows on/off
- C function to set size
- C function to attach `Graphic3d_TransformPers` for fixed corner placement
- Lisp `show-trihedron` convenience: creates, configures corner persistence, displays in context
- Reuse existing `ais-object` class — trihedron is a subtype of interactive object
- Reuse existing `ais-free` for cleanup

**Non-Goals:**
- Multiple trihedra per view (single orientation indicator is standard)
- Trihedron label customization (defer to future)
- Grid plane offset/origin control (deferred)
- `V3d_View::SetAxis` / `V3d_Viewer::SetPrivilegedPlane` (future)

## Decisions

### Trihedron constructor: raw doubles, not gp_Pnt/gp_Dir wrappers

Rather than wrapping `gp_Pnt` and `gp_Dir` as separate C types (which would need their own free functions and CLOS classes), the trihedron C constructor takes all 9 doubles directly:

```cpp
void* ais_create_trihedron(double ox, double oy, double oz,
                            double dx, double dy, double dz,
                            double ux, double uy, double uz) {
    gp_Pnt origin(ox, oy, oz);
    gp_Dir normal(dx, dy, dz);
    gp_Dir xDir(ux, uy, uz);
    Handle(Geom_Axis2Placement) axis = new Geom_Axis2Placement(origin, normal, xDir);
    Handle(AIS_Trihedron)* h = new Handle(AIS_Trihedron)(new AIS_Trihedron(axis));
    return h;  // returned as Handle(AIS_InteractiveObject)*
}
```

Lisp side:

```lisp
(defun make-trihedron (&key (origin '(0 0 0)) (normal '(0 0 1)) (x-direction '(1 0 0)))
  (let ((tri (%ais-create-trihedron (coerce (first origin) 'double-float)
                                     (coerce (second origin) 'double-float)
                                     (coerce (third origin) 'double-float)
                                     (coerce (first normal) 'double-float)
                                     (coerce (second normal) 'double-float)
                                     (coerce (third normal) 'double-float)
                                     (coerce (first x-direction) 'double-float)
                                     (coerce (second x-direction) 'double-float)
                                     (coerce (third x-direction) 'double-float))))
    (if (cffi:null-pointer-p tri)
        nil
        (let ((obj (make-instance 'ais-object :ptr tri)))
          (tg:finalize obj (lambda () (%ais-free obj)))
          obj))))
```

### Transform persistence: fixed corner via single C function

`Graphic3d_TransformPers` configuration is complex in C++. Expose a convenience C function that accepts the corner enum value + pixel offset:

```cpp
void ais_trihedron_set_transform_pers(void* obj_ptr, int corner, int xOff, int yOff) {
    auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
    Handle(Graphic3d_TransformPers) pers =
        new Graphic3d_TransformPers(Graphic3d_TMF_TriedronPers,
                                     (Aspect_TypeOfTriedronPosition)corner,
                                     xOff, yOff);
    (**obj)->SetTransformPersistence(pers);
}
```

Lisp side:

```lisp
(defun set-trihedron-corner (tri corner &key (x-offset 50) (y-offset 50))
  (%ais-trihedron-set-transform-pers (%ptr tri)
                                     (ecase corner
                                       (:lower-left  0) (:upper-left  1)
                                       (:lower-right 2) (:upper-right 3)
                                       (:center      4))
                                     x-offset y-offset))
```

### Enum mappings (Lisp keywords → C ints)

**Aspect_TypeOfTriedronPosition:**

| Keyword | C value |
|---------|---------|
| `:lower-left` | 0 |
| `:upper-left` | 1 |
| `:lower-right` | 2 |
| `:upper-right` | 3 |
| `:center` | 4 |

**Prs3d_DatumMode:**

| Keyword | C value |
|---------|---------|
| `:wireframe` | 0 |
| `:shaded` | 1 |

### show-trihedron: convenience function

```lisp
(defun show-trihedron (context viewer &key (corner :lower-left) (size 50))
  (let ((tri (make-trihedron)))
    (set-trihedron-corner tri corner)
    (set-trihedron-size tri size)
    (ais-display context tri)
    tri))
```

This is the primary user-facing API. A single call to put a trihedron in the viewport.

### No new CLOS class

`AIS_Trihedron` inherits from `AIS_InteractiveObject`. The existing `ais-object` class handles it. The trihedron-specific setters downcast internally in C. This keeps the Lisp type system simple: one `ais-object` type for everything displayable.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `gp_Dir` constructor throws on zero-vector normal/x-direction | Validate in C wrapper before constructing; return nullptr on zero vectors |
| Downcast to `AIS_Trihedron` fails silently on wrong object type | Document that trihedron setters only work on trihedron objects; checks are best-effort in V1 |
| `Graphic3d_TransformPers` constructor signature varies by OCCT version | Test against `.local/` build (OCCT 8.0); document version constraint |
| Calling set-transform-pers after display may not update | Call before display, or invalidate view after changing |

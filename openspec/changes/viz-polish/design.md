## Context

Phase 1-2 built the rendering pipeline (driver → viewer → view → context → display). Phase 3 adds visual control over the scene. The viewer, view, and AIS context all expose property setters that OCCT provides through their C++ API.

The core tension: OCCT uses enums and structs in C++ (e.g., `V3d_TypeOfOrientation`, `Quantity_Color`). The C wrapper flattens these to primitive types (int, double). Lisp converts back to meaningful symbols.

## Goals / Non-Goals

**Goals:**
- Set viewer background color (RGB doubles)
- Set object color via context (works for any `AIS_InteractiveObject`)
- Unset object color (revert to default)
- Set display mode: wireframe or shaded
- Set camera projection: orthographic or perspective
- Set view orientation via keyword enum (front, top, right, iso, etc.)
- Configure MSAA samples (0, 2, 4, 8)
- Toggle anti-aliasing on/off
- Activate/deactivate grid with type (rectangular/circular) and draw mode (lines/points)
- `invalidate` for manual redraw
- All setters have getter counterparts

**Non-Goals:**
- Trihedron / 3D axis indicator (Phase 4)
- Transform persistence (Phase 4)
- Material properties (future)
- Transparency (future)
- Selection highlighting (future)

## Decisions

### Color passed through context, not through the object

OCCT provides `AIS_InteractiveContext::SetColor(interactiveObj, color)` which applies color to any interactive object without requiring a downcast. This is simpler than calling `AIS_Shape::SetColor` directly and works for future AIS types.

```cpp
void ais_context_set_color(void* ctx_ptr, void* obj_ptr, double r, double g, double b) {
    auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
    auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
    (*ctx)->SetColor(**obj, Quantity_Color(r, g, b, Quantity_TOC_RGB), false);
}
```

The Lisp `ais-set-color` function wraps this:

```lisp
(defun ais-set-color (context obj color)
  (destructuring-bind (r g b) color
    (%ais-context-set-color (%ptr context) (%ptr obj)
                            (coerce r 'double-float)
                            (coerce g 'double-float)
                            (coerce b 'double-float))))
```

### Enum mapping in Lisp

OCCT enums become keyword symbols. The Lisp layer translates to C ints. This keeps the C wrapper simple (int parameters) and the Lisp API expressive.

**V3d_TypeOfOrientation → keywords:**

| Keyword | C value | Description |
|---------|---------|-------------|
| `:x-pos` | 0 | View from +X |
| `:y-pos` | 1 | View from +Y |
| `:z-pos` | 2 | View from +Z |
| `:x-neg` | 3 | View from -X |
| `:y-neg` | 4 | View from -Y |
| `:z-neg` | 5 | View from -Z |
| `:iso-pers` | 10 | Isometric perspective |

**AIS_DisplayMode:**

| Keyword | C value |
|---------|---------|
| `:wireframe` | 0 |
| `:shaded` | 1 |

**Aspect_GridType:**

| Keyword | C value |
|---------|---------|
| `:rectangular` | 0 |
| `:circular` | 1 |

**Aspect_GridDrawMode:**

| Keyword | C value |
|---------|---------|
| `:lines` | 0 |
| `:points` | 1 |

The translation tables live in a closure or a simple alist lookup. Define them once, use everywhere.

```lisp
(defparameter *v3d-orientation-map*
  '((:x-pos . 0) (:y-pos . 1) (:z-pos . 2)
    (:x-neg . 3) (:y-neg . 4) (:z-neg . 5)
    (:iso-pers . 10)))
```

### Setter chaining pattern

Since these are property setters on viewer/view/context, the natural pattern is to make them return the object for possible chaining, or just return the set value:

```lisp
(set-background v 0.1 0.1 0.2)   ;; returns (0.1 0.1 0.2)
```

No setf expansion needed for V1 — plain function calls are clear enough.

### Invalidate vs MustBeResized vs FitAll

OCCT has three distinct view update mechanisms:
- `MustBeResized` — call on window resize (Phase 1)
- `FitAll` — zoom to fit all displayed objects (Phase 1)
- `Invalidate` — mark view for redraw (Phase 3, useful after changing properties)

All three exposed as separate functions since they serve different purposes.

### C functions (new in Phase 3)

```c
// Background
void v3d_viewer_set_bg_color(void* viewer, double r, double g, double b);

// Object color (via context)
void ais_context_set_color(void* ctx, void* obj, double r, double g, double b);
void ais_context_unset_color(void* ctx, void* obj);

// Display mode (via context)  
void ais_context_set_display_mode(void* ctx, void* obj, int mode);

// Camera projection
void v3d_view_set_proj(void* view, int orientation);  // V3d_TypeOfOrientation

// MSAA
void v3d_view_set_msaa(void* view, int samples);
int  v3d_view_get_msaa(void* view);

// Antialiasing
void v3d_view_set_antialiasing(void* view, int on);
int  v3d_view_get_antialiasing(void* view);

// Grid
void v3d_viewer_activate_grid(void* viewer, int gridType, int drawMode);
void v3d_viewer_deactivate_grid(void* viewer);

// Invalidate
void v3d_view_invalidate(void* view);
```

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `V3d_TypeOfOrientation` values may differ between OCCT versions | Document values clearly; test against `.local/` build |
| MSAA requires OpenGL context with multisample support | `v3d_view_set_msaa` silently ignored if driver doesn't support it — no crash |
| Grid requires viewer-level setup (grid plane) | Activate with sensible default (XY plane at origin). Advanced grid plane config deferred. |
| `Quantity_Color` constructor may throw on out-of-range values | Clamp inputs to [0,1] in Lisp layer before passing to C |

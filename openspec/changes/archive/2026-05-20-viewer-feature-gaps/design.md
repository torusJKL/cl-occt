## Context

The comprehensive viewer controls change covered 159 tasks across 12 specs. An audit revealed remaining gaps: 4 truly missing features and 7 API name/behavior mismatches. This change closes those gaps with minimal effort — most are one-liner aliases or small convenience wrappers.

## Goals / Non-Goals

**Goals:**
- Match the spec API surface exactly (alias functions where implementation exists under different names)
- Add the 4 genuinely missing features
- Add keyword map for selection modes (`:face` → 1, `:edge` → 2, etc.)

**Non-Goals:**
- No new Prs3d_Drawer CLOS hierarchy (intentionally replaced with convenience functions)
- No new C bridge functions except `ais_trihedron_set_wireframe_color` (one function)
- No architectural changes

## Decisions

### Decision 1: Alias functions for spec conformance

Where a function exists with a different name than the spec requires, add a thin alias:
```
set-cube-map         → calls set-background-cubemap
set-transparent-shading    → calls set-transparency-method
set-default-gradient       → calls set-default-bg-gradient
set-dimension-text         → calls set-dimension-custom-value
```

Getters stub with nil return (no OCCT query API):
```
grid-color → returns nil (setter exists, no getter in OCCT)
grid-size  → returns nil
grid-offset → returns nil
```

### Decision 2: `viewer-camera` as a value object (no C handle)

The `viewer-camera` class stores camera settings as Lisp data (eye/target/up/FOV/projection-type). It does NOT wrap a `Graphic3d_Camera` handle to avoid the handle management segfaults that plagued the drawer CLOS hierarchy. It serves as a snapshot/transfer object:
```
(viewer-camera view)       → reads from view, returns viewer-camera instance
(set-viewer-camera view c) → applies from viewer-camera instance to view
```

### Decision 3: Light enumeration via viewer pointer tracking

`viewer-lights` and `viewer-active-lights` are not trivial — OCCT has no direct "list all lights" API on the Lisp side since lights are identified by CLOS handles, not by viewer. The simplest approach: store a weak list of lights in the viewer object, or iterate active lights via OCCT's `InitActiveLights()`/`NextActiveLight()` API with a C bridge.

For now, implement `viewer-lights` and `viewer-active-lights` as functions that track lights via a hash table mapping viewer-pointer → list-of-light-pointers, updated when `viewer-add-light` and `viewer-remove-light` are called.

## Risks / Trade-offs

- Light enumeration requires either OCCT iteration C bridge or Lisp-side tracking. Lisp-side tracking is simpler but can get out of sync if lights are added/removed behind the scenes.
- `set-default-drawer` is blocked — `V3d_Viewer` has no such method in OCCT 8.0. Can be done via `AIS_InteractiveContext::DefaultDrawer()` → `SetAttribute()` chain but complex. Mark as blocked.

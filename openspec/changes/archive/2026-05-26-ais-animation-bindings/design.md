## Context

cl-occt currently has no animation support. The viewer system supports display, camera control, selection, lighting, and styling via AIS, but cannot animate objects or cameras over time. OCCT provides `AIS_Animation` as a base class with three concrete subclasses:

- `AIS_AnimationObject` — animates an interactive object's local transformation via `gp_Trsf`
- `AIS_AnimationCamera` — animates camera between two `viewer-camera` states
- `AIS_AnimationAxisRotation` — animates rotation of an object around an arbitrary axis

These follow OCCT's `Handle<>` pattern already used throughout cl-occt for AIS objects.

## Goals / Non-Goals

**Goals:**
- Full C wrapper for all four animation classes in `wrap/occt_wrap.h/cpp`
- CFFI `defcfun` bindings in `src/ffi/bindings.lisp`
- CLOS wrapper in `src/core/animation.lisp` with `tg:finalize` GC, following `ais-object` patterns
- Unit tests in `t/smoke-tests.lisp`
- API documentation in `docs/api-reference.md`

**Non-Goals:**
- No gui or playback UI — animation is driven programmatically
- No easing curves or custom interpolation beyond OCCT defaults
- No animation event callbacks

## Decisions

1. **New CLOS class `ais-animation` instead of reusing `ais-object`** — `AIS_Animation` is not an `AIS_InteractiveObject`, it's a separate OCCT class hierarchy. A dedicated CLOS class avoids confusion with the display/selection API.

2. **Typed subclasses for concrete animation types** — `ais-animation-object`, `ais-animation-camera`, `ais-animation-axis-rotation` extend `ais-animation` with specific constructor and accessor functions, mirroring the OCCT class hierarchy.

3. **Animation tree via parent-child** — `AIS_Animation` supports child animations via `AddAnimation`/`RemoveAnimation`. The Lisp wrapper exposes this as `add-animation`/`remove-animation` on any `ais-animation` instance.

4. **C wrapper uses opaque `void*` handles** — consistent with all existing `wrap/occt_wrap.h` patterns. Animation handles are distinct from shape/ais-object handles.

5. **GC via `tg:finalize`** — same pattern as existing `ais-object` and `shape` classes, with explicit `ais-animation-free` for immediate teardown and finalizer as safety net.

## Risks / Trade-offs

- **OCCT 8.0 API stability**: Animation classes are stable but header changes in future OCCT versions could require wrapper updates. Mitigation: keep wrappers thin with no business logic.
- **Camera animation requires `viewer-camera` value objects**: Already implemented in `src/core/viewer-camera.lisp`. Animation camera constructor takes start/end camera value objects.
- **`gp_Trsf` not yet wrapped**: `AIS_AnimationObject` and `AIS_AnimationAxisRotation` require `gp_Trsf` for transformation. Need to decide: pass raw transformation components and build `gp_Trsf` in C wrapper, or wrap `gp_Trsf` separately. Decision: Build `gp_Trsf` in C wrapper from simple components (translation vector + rotation angle + axis) to avoid adding another OCCT type wrapper.

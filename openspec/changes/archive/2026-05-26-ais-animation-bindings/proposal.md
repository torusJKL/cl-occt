## Why

Animation of objects and camera in the 3D viewer is a fundamental capability for CAD applications — walkthroughs, exploded views, assembly sequences, and guided inspections all require the ability to animate scene elements over time. OCCT provides `AIS_Animation` and its subclasses for this purpose, but none of these are currently exposed in cl-occt.

## What Changes

- Add C bridge functions in `wrap/occt_wrap.h/cpp` for `AIS_Animation`, `AIS_AnimationObject`, `AIS_AnimationCamera`, and `AIS_AnimationAxisRotation`
- Add CFFI `%`-prefixed bindings in `src/ffi/`
- Add core CLOS wrappers in `src/core/` with `tg:finalize` GC management
- Add unit tests for all animation functions
- Add animation sections to `docs/api-reference.md`

## Capabilities

### New Capabilities
- `ais-animation`: AIS_Animation base class — creation, timer control (start, stop, set-duration, set-start-pause, is-playing), hierarchical animation tree with `add-animation` / `remove-animation`, and timeline navigation (set/current progress).
- `ais-animation-object`: AIS_AnimationObject — animate an interactive object's local transformation (translate, rotate, scale) over time using a `gp_Trsf`.
- `ais-animation-camera`: AIS_AnimationCamera — animate camera movement between two `viewer-camera` states with smooth interpolation.
- `ais-animation-axis-rotation`: AIS_AnimationAxisRotation — animate rotation of an object around an arbitrary axis by a target angle.

### Modified Capabilities
- `docs-publishing`: Add animation API reference to `docs/api-reference.md`.

## Impact

New files:
- `src/ffi/animation.lisp` — CFFI bindings
- `src/core/animation.lisp` — CLOS wrappers
- `tests/animation.lisp` — unit tests

Modified files:
- `wrap/occt_wrap.h` — C function declarations
- `wrap/occt_wrap.cpp` — C function implementations
- `docs/api-reference.md` — API documentation

No breaking changes to existing APIs.

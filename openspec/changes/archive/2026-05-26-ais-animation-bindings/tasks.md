## 1. C Wrapper — Animation Headers

- [x] 1.1 Add `void*` typedef for animation and function declarations to `wrap/occt_wrap.h`
- [x] 1.2 Implement `ais_animation_create` in `wrap/occt_wrap.cpp` — wraps `new AIS_Animation(name)` + `new Handle(AIS_Animation)`
- [x] 1.3 Implement `ais_animation_free` — deletes the handle
- [x] 1.4 Implement `ais_animation_start`, `ais_animation_stop`, `ais_animation_is_playing`
- [x] 1.5 Implement `ais_animation_set_duration`, `ais_animation_duration`, `ais_animation_set_progress`, `ais_animation_progress`
- [x] 1.6 Implement `ais_animation_set_start_pause`, `ais_animation_add`, `ais_animation_remove`

## 2. C Wrapper — Animation Subclasses

- [x] 2.1 Implement `ais_animation_object_create` — wraps `new AIS_AnimationObject(name, objHandle, trsf)`. Build `gp_Trsf` from `gp_Vec` and `gp_Quat` in C side
- [x] 2.2 Implement `ais_animation_object_get_object` — returns the ais-object handle
- [x] 2.3 Implement `ais_animation_camera_create` — wraps `new AIS_AnimationCamera(name, viewHandle, startCam, endCam)`. Accept camera components as `(eye, target, up)` vectors
- [x] 2.4 Implement `ais_animation_axis_rotation_create` — wraps `new AIS_AnimationAxisRotation(name, objHandle, origin, direction, angleDeg)`. Build `gp_Ax1` and `gp_Trsf` in C side

## 3. CFFI Bindings

- [x] 3.1 Add `%ais-animation-create`, `%ais-animation-free`, `%ais-animation-start`, `%ais-animation-stop`, `%ais-animation-is-playing` to `src/ffi/bindings.lisp`
- [x] 3.2 Add `%ais-animation-duration`, `%ais-animation-set-duration`, `%ais-animation-progress`, `%ais-animation-set-progress` to `src/ffi/bindings.lisp`
- [x] 3.3 Add `%ais-animation-set-start-pause`, `%ais-animation-add`, `%ais-animation-remove` to `src/ffi/bindings.lisp`
- [x] 3.4 Add `%ais-animation-object-create`, `%ais-animation-object-get-object` to `src/ffi/bindings.lisp`
- [x] 3.5 Add `%ais-animation-camera-create` to `src/ffi/bindings.lisp`
- [x] 3.6 Add `%ais-animation-axis-rotation-create` to `src/ffi/bindings.lisp`

## 4. Core Lisp Wrappers

- [x] 4.1 Create `src/core/animation.lisp` — define `ais-animation` CLOS class with `ptr` slot + `tg:finalize`
- [x] 4.2 Implement `make-animation` constructor and `ais-animation-p` predicate
- [x] 4.3 Implement `ais-animation-start`, `ais-animation-stop`, `ais-animation-playing-p`
- [x] 4.4 Implement `ais-animation-duration` (reader + `setf`), `ais-animation-progress` (reader + `setf`), `ais-animation-start-pause` (`setf`)
- [x] 4.5 Implement `add-animation`, `remove-animation` for animation tree
- [x] 4.6 Implement `ais-animation-free` with double-free safety
- [x] 4.7 Define `ais-animation-object` subclass with `make-animation-object` constructor and `animation-object` accessor
- [x] 4.8 Define `ais-animation-camera` subclass with `make-animation-camera` constructor
- [x] 4.9 Define `ais-animation-axis-rotation` subclass with `make-animation-axis-rotation` constructor
- [x] 4.10 Add `ais-animation-object-p`, `ais-animation-camera-p`, `ais-animation-axis-rotation-p` predicates
- [x] 4.11 Export all public symbols from `cl-occt` package in `src/package.lisp`

## 5. Tests

- [x] 5.1 Add test for `make-animation` creation and nil input
- [x] 5.2 Add test for start/stop/playing-p lifecycle
- [x] 5.3 Add test for duration and progress get/set
- [x] 5.4 Add test for animation tree (add/remove child)
- [x] 5.5 Add test for `ais-animation-free` and double-free safety
- [x] 5.6 Add test for `make-animation-object` creation with nil guards
- [x] 5.7 Add test for `make-animation-camera` creation with nil guards (skipped - needs viewer)
- [x] 5.8 Add test for `make-animation-axis-rotation` creation with nil guards

## 6. API Reference Documentation

- [x] 6.1 Add Animation section to `docs/api-reference.md` with all animation functions, descriptions, and code examples

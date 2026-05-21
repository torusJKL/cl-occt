## Context

The codebase follows a three-layer architecture: C wrapper (opaque `void*` pointers, `extern "C"`), CFFI bindings (`%`-prefixed `defcfun`), and CLOS wrappers (classes with `%ptr` slot, finalizers for GC). Selection bindings must follow this same pattern.

OCCT's selection API lives on `AIS_InteractiveContext` and includes:
- **Iteration**: `InitSelected/MoreSelected/NextSelected`, `NbSelected`, `SelectedInteractive`, `SelectedShape`
- **Management**: `SetSelected`, `AddOrRemoveSelected`, `ClearSelected`, `IsSelected`
- **Detection**: `MoveTo`, `SelectDetected`, `SelectPoint`
- **Highlight**: `HilightSelected`, `UnhilightSelected`
- **Configuration**: `FitSelected`, `PixelTolerance`, `SelectionSensitivity`, `AutomaticHilight`, `ToHilightSelected`

The existing `ais-object` class wraps `Handle(AIS_InteractiveObject)*`. Since OCCT's `Handle` is ref-counted, handles obtained from selection queries can be safely wrapped with the same class and finalizer — deleting the handle wrapper only decrements the ref count, the context retains ownership.

## Goals / Non-Goals

**Goals:**
- Full programmatic selection API (set, add/remove, clear, query, iterate)
- Mouse-driven detection pipeline (MoveTo → SelectDetected)
- Selection highlight control (hilight/unhilight selected)
- Selection configuration (tolerance, sensitivity, automatic modes)
- Fit camera to selected objects
- All status returns exposed as integers with keyword maps for decoding

**Non-Goals:**
- Wrapping `SelectMgr_Filter` or selection filter system (future concern)
- Wrapping `AIS_SelectionScheme` beyond the enum keyword map
- Wrapping `SelectMgr_EntityOwner` directly (working at `AIS_InteractiveObject` level is sufficient)
- Viewer-independent selection (the context always requires a viewer)

## Decisions

1. **Return `int` for status values, provide keyword maps for decoding.**
   - `MoveTo` → returns `AIS_StatusOfDetection` as `int`
   - `SelectDetected`/`SelectPoint` → return `AIS_StatusOfPick` as `int`
   - Maps: `*selection-scheme-map*`, `*status-of-detection-map*`, `*status-of-pick-map*`
   - Gives callers flexibility: compare integers directly or decode with `(cdr (assoc val *status-of-detection-map*))`
   - Consistent with existing pattern where maps accept keywords as input

2. **Use existing `ais-object` class for selected/detected objects.**
   - `SelectedInteractive()` and `DetectedInteractive()` return handles to objects owned by the context
   - Heap-allocate a new `Handle(AIS_InteractiveObject)` copy and wrap with `make-instance 'ais-object` + finalizer
   - Safe because Handle is ref-counted: deleting the wrapper only decrements the count, the context keeps the object alive
   - No new CLOS class needed

3. **`SelectedShape()` requires heap copy.**
   - Returns `TopoDS_Shape` by value in OCCT
   - C wrapper allocates `new TopoDS_Shape(copy)` on heap
   - Lisp side wraps with existing `make-shape` (which finalizes with `free_shape` → `delete TopoDS_Shape*`)
   - Consistent with how all shapes are handled in the codebase

4. **`SelectPoint` constructs `NCollection_Vec2<int>` in C wrapper.**
   - Simple struct — construct inline on stack from `(x, y)` parameters
   - No need to expose `NCollection_Vec2` in the FFI

5. **Short naming for CLOS functions, context argument disambiguates.**
   - `(ais-set-selected ctx obj)` not `(ais-context-set-selected ctx obj)`
   - Matches existing convention: `ais-display`, `ais-erase`, `ais-remove` all take context as first arg

6. **Convenience functions for list collection.**
   - `ais-selected-objects` collects all `ais-object` instances into a list
   - `ais-selected-shapes` collects all extracted shapes into a list
   - Built on top of `InitSelected/MoreSelected/NextSelected` iteration

## Risks / Trade-offs

- **No filter wrapping**: Filters (`SelectMgr_Filter`, `AIS_ExclusionFilter`) are not included. Users who need picking restricted to specific shape types will need to wait for a follow-up change.
- **`ais-move-to` and `ais-select-point` require viewer access**: These functions need the underlying `%view` pointer from a `viewer` object. The CLOS wrapper extracts it from the viewer argument.
- **Handle wrapper identity**: Each call to `ais-selected-interactive` creates a new Lisp `ais-object` wrapping a new Handle allocation. `eq` comparison will not work across calls. Users needing identity must compare shapes or use `equalp` on the underlying objects.

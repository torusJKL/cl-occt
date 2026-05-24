## Why

The viewer infrastructure — viewer creation/destruction, AIS context, object display/erase, trihedron, grid, background, camera controls, and rendering settings — constitutes the largest and most complex API surface in cl-occt. Users need docstrings and examples to navigate viewer setup, camera manipulation, and display modes.

## What Changes

- Add docstrings with `Example:` blocks to all public functions across 5 viewer files
- Trivial predicates (`viewer-p`, `ais-context-p`, `ais-object-p`, `viewer-camera-p`) get docstring description without example
- No functional or API changes — documentation only

Files modified: `src/core/viewer.lisp`, `src/core/viewer-grid.lisp`, `src/core/viewer-background.lisp`, `src/core/viewer-camera.lisp`, `src/core/viewer-rendering.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/viewer.lisp`: 38 functions + 1 macro (`with-viewer`) — `viewer-p`, `make-viewer`, `free-viewer`, `fit-all`, `must-be-resized`, `ais-context-p`, `ais-create-context`, `ais-free-context`, `ais-object-p`, `ais-create-shape`, `ais-free`, `ais-display`, `ais-erase`, `ais-remove`, `ais-remove-all`, `ais-displayed-p`, `set-background`, `ais-set-color`, `ais-unset-color`, `ais-set-display-mode`, `set-view-projection`, `set-msaa`, `msaa`, `set-antialiasing`, `antialiasing-p`, `activate-grid`, `deactivate-grid`, `invalidate-view`, `with-viewer`, `make-trihedron`, `set-trihedron-mode`, `set-trihedron-arrows`, `set-trihedron-size`, `set-trihedron-corner`, `set-trihedron-axis-colors`, `set-trihedron-text-color`, `set-trihedron-wireframe-color`, `show-trihedron`
- `src/core/viewer-grid.lisp`: 10 functions
- `src/core/viewer-background.lisp`: 5 functions
- `src/core/viewer-camera.lisp`: 12 functions — `viewer-camera-p`, `viewer-camera`, `set-viewer-camera`, `set-camera`, `set-perspective`, `perspective-p`, `set-fov`, `set-clip-planes`, `pan-camera`, `zoom-camera`, `rotate-camera`, `reset-view`
- `src/core/viewer-rendering.lisp`: 8 functions
- All existing tests should pass unchanged

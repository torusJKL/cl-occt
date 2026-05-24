## 1. Viewer lifecycle and AIS (`viewer.lisp`)

- [x] 1.1 Add docstring to `viewer-p` (docstring only)
- [x] 1.2 Add docstring + example to `make-viewer`
- [x] 1.3 Add docstring + example to `free-viewer`
- [x] 1.4 Add docstring + example to `fit-all`
- [x] 1.5 Add docstring + example to `must-be-resized`
- [x] 1.6 Add docstring to `ais-context-p` (docstring only)
- [x] 1.7 Add docstring + example to `ais-create-context`
- [x] 1.8 Add docstring + example to `ais-free-context`
- [x] 1.9 Add docstring to `ais-object-p` (docstring only)
- [x] 1.10 Add docstring + example to `ais-create-shape`
- [x] 1.11 Add docstring + example to `ais-free`
- [x] 1.12 Add docstring + example to `ais-display`
- [x] 1.13 Add docstring + example to `ais-erase`
- [x] 1.14 Add docstring + example to `ais-remove`
- [x] 1.15 Add docstring + example to `ais-remove-all`
- [x] 1.16 Add docstring + example to `ais-displayed-p`
- [x] 1.17 Add docstring + example to `with-viewer` (macro)

## 2. Viewer styling and display mode (`viewer.lisp`)

- [x] 2.1 Add docstring + example to `set-background`
- [x] 2.2 Add docstring + example to `ais-set-color`
- [x] 2.3 Add docstring + example to `ais-unset-color`
- [x] 2.4 Add docstring + example to `ais-set-display-mode`
- [x] 2.5 Add docstring + example to `set-view-projection`
- [x] 2.6 Add docstring + example to `set-msaa`
- [x] 2.7 Add docstring + example to `msaa`
- [x] 2.8 Add docstring + example to `set-antialiasing`
- [x] 2.9 Add docstring + example to `antialiasing-p`
- [x] 2.10 Add docstring + example to `activate-grid`
- [x] 2.11 Add docstring + example to `deactivate-grid`
- [x] 2.12 Add docstring + example to `invalidate-view`

## 3. Trihedron (`viewer.lisp`)

- [x] 3.1 Add docstring + example to `make-trihedron`
- [x] 3.2 Add docstring + example to `set-trihedron-mode`
- [x] 3.3 Add docstring + example to `set-trihedron-arrows`
- [x] 3.4 Add docstring + example to `set-trihedron-size`
- [x] 3.5 Add docstring + example to `set-trihedron-corner`
- [x] 3.6 Add docstring + example to `set-trihedron-axis-colors`
- [x] 3.7 Add docstring + example to `set-trihedron-text-color`
- [x] 3.8 Add docstring + example to `set-trihedron-wireframe-color`
- [x] 3.9 Add docstring + example to `show-trihedron`

## 4. Grid (`viewer-grid.lisp`)

- [x] 4.1 Add docstring + example to `grid-active-p`
- [x] 4.2 Add docstring + example to `set-grid-xy-size`
- [x] 4.3 Add docstring + example to `set-grid-offset`
- [x] 4.4 Add docstring + example to `set-rectangular-grid-values`
- [x] 4.5 Add docstring + example to `grid-display`
- [x] 4.6 Add docstring + example to `set-grid-color`
- [x] 4.7 Add docstring + example to `set-grid-size`
- [x] 4.8 Add docstring + example to `grid-color`
- [x] 4.9 Add docstring + example to `grid-size`
- [x] 4.10 Add docstring + example to `grid-offset`

## 5. Background (`viewer-background.lisp`)

- [x] 5.1 Add docstring + example to `set-gradient-background`
- [x] 5.2 Add docstring + example to `set-background-cubemap`
- [x] 5.3 Add docstring + example to `set-image-background`
- [x] 5.4 Add docstring + example to `reset-background`
- [x] 5.5 Add docstring + example to `set-cube-map`

## 6. Camera (`viewer-camera.lisp`)

- [x] 6.1 Add docstring to `viewer-camera-p` (docstring only)
- [x] 6.2 Add docstring + example to `viewer-camera`
- [x] 6.3 Add docstring + example to `set-viewer-camera`
- [x] 6.4 Add docstring + example to `set-camera`
- [x] 6.5 Add docstring + example to `set-perspective`
- [x] 6.6 Add docstring + example to `perspective-p`
- [x] 6.7 Add docstring + example to `set-fov`
- [x] 6.8 Add docstring + example to `set-clip-planes`
- [x] 6.9 Add docstring + example to `pan-camera`
- [x] 6.10 Add docstring + example to `zoom-camera`
- [x] 6.11 Add docstring + example to `rotate-camera`
- [x] 6.12 Add docstring + example to `reset-view`

## 7. Rendering (`viewer-rendering.lisp`)

- [x] 7.1 Add docstring + example to `set-computed-mode`
- [x] 7.2 Add docstring + example to `computed-mode-p`
- [x] 7.3 Add docstring + example to `set-back-face-model`
- [x] 7.4 Add docstring + example to `set-transparency-method`
- [x] 7.5 Add docstring + example to `set-frustum-culling`
- [x] 7.6 Add docstring + example to `redraw-view`
- [x] 7.7 Add docstring + example to `set-immediate-update`
- [x] 7.8 Add docstring + example to `set-transparent-shading`

## 8. Verification

- [x] 8.1 Run `just test-all` to verify no breakage

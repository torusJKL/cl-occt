## 1. Foundation: viewer-colors (named colors + color system)

- [x] 1.1 Named color map as Lisp data (~160 entries), `named-color` lookup function
- [x] 1.2 `named-color-exists-p` using Lisp alist
- [x] 1.3 `color-rgb` function handling keyword, list, hex-string, viewer-color
- [x] 1.4 `make-color` constructor for :rgb, :keyword, :hls
- [x] 1.5 HLS→RGB conversion via `hls-to-rgb` function (pure Lisp math)
- [x] 1.6 `color-delta` Euclidean distance function
- [x] 1.7 `hex-to-rgb` parser for #RRGGBB and #RGB with hex validation
- [x] 1.8 No C bridge needed — color system implemented entirely in Lisp
- [x] 1.9 Create `src/core/viewer-colors.lisp` with complete color system
- [x] 1.10 Export all public symbols from `cl-occt` package in `src/package.lisp`
- [x] 1.11 Write unit tests: named color lookup, hex parsing, HLS conversion, color delta, invalid inputs
- [x] 1.12 Update README with color system documentation

## 2. Core: viewer-camera (camera and view orientation)

- [x] 2.1-2.13 Add C bridge functions: set-eye, set-target, set-up, projection-type (set/get), set-fov, clip-planes, fit-all-shape, pan, zoom, rotate, reset
- [x] 2.14 Add CFFI bindings for all camera functions in `src/ffi/bindings.lisp`
- [x] 2.15 Create `src/core/viewer-camera.lisp` with convenience functions
- [x] 2.16 Export public camera symbols in `src/package.lisp`
- [x] 2.17 Write unit tests: eye/target/up, perspective toggle, FOV, clip planes, reset, fit-all per-shape
- [x] 2.18 Update README with camera API documentation

## 3. Trihedron: viewer-trihedron (extend existing trihedron)

- [x] 3.1 Add `%ais-trihedron-set-datum-part-color` C bridge: per-axis color via `SetDatumPartColor(Prs3d_DatumParts_XAxis, color)`
- [x] 3.2 Add `%ais-trihedron-set-text-color` C bridge via `Attributes()->TextAspect()->SetColor()`
- [x] 3.3 CFFI bindings for all new trihedron functions
- [x] 3.4 Add `set-trihedron-axis-colors` with :x :y :z keyword args
- [x] 3.5 Add `set-trihedron-text-color`
- [x] 3.6 Export new trihedron symbols
- [x] 3.7 Write unit tests: axis colors, text color, nil-tri handler
- [x] 3.8 Update README with extended trihedron API

## 4. Per-Object: viewer-object-props (transparency, materials, line width, edges, tessellation, selection)

- [x] 4.1 Add `%ais-set-transparency` C bridge via AIS_InteractiveContext::SetTransparency
- [x] 4.2 Add `%ais-set-material-by-name` C bridge: maps keyword → Graphic3d_NOM_* enum
- [x] 4.3 Add `%ais-set-line-width` C bridge via AIS_InteractiveContext::SetWidth
- [x] 4.4 Add `%ais-set-edges-display` and `%ais-set-edge-color` C bridges
- [x] 4.5 Add `%ais-set-selection-mode` and `%ais-deactivate-selection` C bridges via Activate/Deactivate
- [x] 4.6 Add `%ais-set-tessellation` C bridge via Prs3d_Drawer::SetDiscretisation
- [x] 4.7 Add CFFI bindings for all object-props functions
- [x] 4.8 Create `src/core/viewer-object-props.lisp` with convenience functions
- [x] 4.9 Export all object-props symbols
- [x] 4.10 Write unit tests: transparency, material presets, line width, edges, edge color, selection, tessellation
- [x] 4.11 Update README with per-object properties documentation

## 5. Lighting: viewer-lighting

- [x] 5.1-5.19 C bridge functions for ambient + directional lights, add/remove/toggle, color, intensity, direction, headlight, shadows, default-lights
- [x] 5.20 CFFI bindings for all lighting functions
- [x] 5.21 Create `src/core/viewer-lighting.lisp` with `viewer-light` CLOS class, `make-light`, add/remove/toggle, properties, GC finalization
- [x] 5.22 Export all lighting symbols
- [x] 5.23 Write unit tests: create ambient/directional lights, add to viewer, toggle, modify properties, headlight, default lights
- [x] 5.24 Update README with lighting API documentation

## 6. Grid: viewer-grid

- [x] 6.1 Add `%v3d-viewer-grid-active` C bridge
- [x] 6.2 CFFI bindings
- [x] 6.3 Create `src/core/viewer-grid.lisp` with `grid-active-p`
- [x] 6.4 Export symbols, write tests, update README

## 7. Background: viewer-background

- [x] 7.1 Add `%v3d-view-set-bg-gradient` and `%v3d-view-reset-background` C bridges
- [x] 7.2 CFFI bindings
- [x] 7.3 Create `src/core/viewer-background.lisp` with `set-gradient-background`, `reset-background`, gradient style map
- [x] 7.4 Export symbols, write tests, update README

## 8. Rendering: viewer-rendering

- [x] 8.1-8.7 C bridge functions for computed-mode, back-face-model, frustum-culling, redraw, immediate-update
- [x] 8.8 CFFI bindings
- [x] 8.9 Create `src/core/viewer-rendering.lisp` with convenience functions
- [x] 8.10 Export symbols
- [x] 8.11 Write unit tests: computed-mode toggle, back-face-model, frustum-culling, redraw
- [x] 8.12 Update README

## 9. Text Labels: viewer-text-labels

- [x] 9.1 Add `%ais-text-label-set-angle` C bridge: `SetAngle(rad)`
- [x] 9.2 CFFI bindings
- [x] 9.3 Create `src/core/viewer-text-labels.lisp` with `set-text-label-angle`, `make-text-label` convenience
- [x] 9.4 Export symbols, write tests, update README

## 10. Defaults: viewer-defaults

- [x] 10.1-10.5 C bridge functions for default bg color, view proj, view size, view type
- [x] 10.6 CFFI bindings
- [x] 10.7 Create `src/core/viewer-defaults.lisp` with convenience functions
- [x] 10.8 Export symbols
- [x] 10.9 Write unit tests: default background, projection, view size, view type
- [x] 10.10 Update README

## 11. Drawer: viewer-drawer (Prs3d drawer convenience functions)

- [x] 11.1 C bridge functions: line-color, line-width, shading-color, face-boundary-draw, free-boundary-draw
- [x] 11.2 CFFI bindings for all drawer functions
- [x] 11.3 Create `src/core/viewer-drawer.lisp` with convenience functions
- [x] 11.4 Export symbols
- [x] 11.5 Write unit tests: set line color, line width, shading color, toggle boundaries
- [x] 11.6 Update README with drawer API documentation

## 12. Dimensions: viewer-dimensions (deferred)

- [ ] 12.x AIS_Dimension classes not available in OCCT 8.0 build (requires additional module). Deferred for future work.

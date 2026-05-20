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

## 5. Lighting: viewer-lighting (all 4 light types)

- [ ] 5.1 Add `%make-light-ambient` C bridge: creates `V3d_AmbientLight(color, intensity)`
- [ ] 5.2 Add `%make-light-directional` C bridge: creates `V3d_DirectionalLight(color, intensity, direction)`
- [ ] 5.3 Add `%make-light-positional` C bridge: creates `V3d_PositionalLight(color, intensity, position)`
- [ ] 5.4 Add `%make-light-spot` C bridge: creates `V3d_SpotLight(color, intensity, position, direction, angle, concentration)`
- [ ] 5.5 Add `%light-free` C bridge: deletes handle
- [ ] 5.6 Add `%v3d-viewer-add-light` C bridge: `Viewer()->SetLight(light)`
- [ ] 5.7 Add `%v3d-viewer-remove-light` C bridge: `Viewer()->SetLightOff(light)` + remove
- [ ] 5.8 Add `%v3d-viewer-light-on` C bridge: `Viewer()->SetLightOn(light)`
- [ ] 5.9 Add `%v3d-viewer-light-off` C bridge: `Viewer()->SetLightOff(light)`
- [ ] 5.10 Add `%light-set-color` C bridge: `light->SetColor(color)`
- [ ] 5.11 Add `%light-set-intensity` C bridge: `light->SetIntensity(v)`
- [ ] 5.12 Add `%light-set-direction` C bridge: `light->SetDirection(dir)` (directional/spot)
- [ ] 5.13 Add `%light-set-position` C bridge: `light->SetPosition(pos)` (positional/spot)
- [ ] 5.14 Add `%light-set-angle` C bridge: `light->SetAngle(angle)` (spot)
- [ ] 5.15 Add `%light-set-concentration` C bridge: `light->SetConcentration(v)` (spot)
- [ ] 5.16 Add `%light-set-headlight` C bridge: `light->SetHeadlight(bool)`
- [ ] 5.17 Add `%light-set-shadows` C bridge: `light->SetShadows(bool)`
- [ ] 5.18 Add `%v3d-viewer-default-lights` C bridge: `Viewer()->SetDefaultLights()`
- [ ] 5.19 Add `%light-is-on` C bridge: `light->IsEnabled()`
- [ ] 5.20 Add CFFI bindings for all lighting functions
- [ ] 5.21 Create `src/core/viewer-lighting.lisp` with:
  - `viewer-light` CLOS class (%type %color %intensity %direction %position etc.)
  - `light-type` accessor returning keyword
  - `make-light` constructor dispatching on :type arg
  - `viewer-add-light`, `viewer-remove-light`, `viewer-light-on`, `viewer-light-off`, `viewer-light-p`
  - `set-light-color`, `set-light-intensity`, `set-light-direction`, `set-light-position`
  - `set-light-angle`, `set-light-concentration`
  - `set-headlight`, `set-light-shadows`
  - `viewer-default-lights` (convenience)
  - `viewer-lights`, `viewer-active-lights` (enumeration)
  - GC finalization for lights
- [ ] 5.22 Export all lighting symbols
- [ ] 5.23 Write unit tests: create each light type, add to viewer, toggle on/off, modify properties, headlight mode, query active lights
- [ ] 5.24 Update README with lighting API documentation

## 6. Grid: viewer-grid (extend existing grid)

- [ ] 6.1 Add `%v3d-viewer-set-grid-color` C bridge: `SetGridColor(color)`
- [ ] 6.2 Add `%v3d-viewer-set-grid-size` C bridge: `SetGridSize(double)`
- [ ] 6.3 Add `%v3d-viewer-set-grid-xy-size` C bridge: `SetGridXYSize(x, y)`
- [ ] 6.4 Add `%v3d-viewer-set-grid-offset` C bridge: `SetGridOffset(x, y)`
- [ ] 6.5 Add `%v3d-viewer-grid-active` C bridge: returns whether grid is active
- [ ] 6.6 Add CFFI bindings for grid functions
- [ ] 6.7 Extend grid section in `src/core/viewer.lisp` (or create `src/core/viewer-grid.lisp`) with:
  - `set-grid-color` (accepts normalized color)
  - `set-grid-size`, `set-grid-xy-size`
  - `set-grid-offset`
  - `grid-color`, `grid-size`, `grid-offset` (query)
  - `grid-active-p`
- [ ] 6.8 Export new grid symbols
- [ ] 6.9 Write unit tests: set grid color, size, offset, round-trip queries
- [ ] 6.10 Update README with extended grid API

## 7. Background: viewer-background (gradient, image, cubemap)

- [ ] 7.1 Add `%v3d-view-set-bg-gradient` C bridge: `SetBgGradientColors(c1, c2, style, fill_method)`
- [ ] 7.2 Add `%v3d-view-set-bg-image` C bridge: `SetBgImage(path, fill_method)`
- [ ] 7.3 Add `%v3d-view-set-cube-map` C bridge: `SetBgCubeMap()` from 6 file paths
- [ ] 7.4 Add `%v3d-view-reset-background` C bridge: reset to default
- [ ] 7.5 Add CFFI bindings for background functions
- [ ] 7.6 Create `src/core/viewer-background.lisp` with:
  - `set-gradient-background` (:color1 :color2 :style keywords)
  - Fill style keyword map (:x-pos, :x-neg, :y-pos, etc.)
  - `set-image-background` (path, optional fill-method)
  - `set-cube-map` (6 face image paths)
  - `reset-background`
- [ ] 7.7 Export background symbols
- [ ] 7.8 Write unit tests: gradient with different directions, image background with valid/invalid path, reset
- [ ] 7.9 Update README with background API

## 8. Rendering: viewer-rendering (quality knobs)

- [ ] 8.1 Add `%v3d-view-set-computed-mode` C bridge: `SetComputedMode(bool)`
- [ ] 8.2 Add `%v3d-view-computed-mode` C bridge: query computed mode
- [ ] 8.3 Add `%v3d-view-set-back-face-model` C bridge: `SetBackFacingModel(mode)`
- [ ] 8.4 Add `%v3d-view-set-frustum-culling` C bridge: `SetFrustumCulling(bool)`
- [ ] 8.5 Add `%v3d-view-set-transparent-shading` C bridge: `SetTransparentShading(bool)`
- [ ] 8.6 Add `%v3d-view-redraw` C bridge: `Redraw()` + `RedrawImmediate()`
- [ ] 8.7 Add `%v3d-view-set-immediate-update` C bridge: `SetImmediateUpdate(bool)`
- [ ] 8.8 Add CFFI bindings for rendering functions
- [ ] 8.9 Create `src/core/viewer-rendering.lisp` with:
  - `set-computed-mode`, `computed-mode-p`
  - `set-back-face-model` (:auto :force :disable keywords)
  - `set-frustum-culling`, `set-transparent-shading`
  - `redraw-view` (full redraw)
  - `set-immediate-update`
- [ ] 8.10 Export rendering symbols
- [ ] 8.11 Write unit tests: computed mode toggle, back-face model, frustum culling, redraw (no-crash)
- [ ] 8.12 Update README with rendering API

## 9. Text Labels: viewer-text-labels (enhancements)

- [ ] 9.1 Add `%ais-text-label-set-angle` C bridge: `SetAngle(rad)`
- [ ] 9.2 Add `%ais-text-label-set-hjustify` C bridge: `SetHJustify(type)`
- [ ] 9.3 Add `%ais-text-label-set-vjustify` C bridge: `SetVJustify(type)`
- [ ] 9.4 Add `%ais-text-label-set-display-type` C bridge: `SetDisplayType(type)`
- [ ] 9.5 Add `%ais-text-label-set-subtitle-color` C bridge: `SetSubtitleColor(c)`
- [ ] 9.6 Add `%ais-text-label-set-space` C bridge: `SetSpace(spacing)`
- [ ] 9.7 Add CFFI bindings for text label enhancements
- [ ] 9.8 Extend `src/core/text.lisp` (or create `src/core/viewer-text-labels.lisp`) with:
  - `set-text-label-angle` (converts degrees to radians)
  - `set-text-label-align` (:horizontal :left/:center/:right, :vertical :top/:center/:bottom)
  - `set-text-label-display` (:ordinary :subtitle :dekale)
  - `set-text-label-subtitle-color`
  - `set-text-label-spacing`
  - `make-text-label` convenience (create + configure + display in one call)
- [ ] 9.9 Export new text label symbols
- [ ] 9.10 Write unit tests: angle, alignment, display type, subtitle color, spacing, convenience function
- [ ] 9.11 Update README with text label enhancements

## 10. Defaults: viewer-defaults (viewer-level defaults)

- [ ] 10.1 Add `%v3d-viewer-set-default-bg-color` C bridge: `SetDefaultBackgroundColor(color)`
- [ ] 10.2 Add `%v3d-viewer-set-default-bg-gradient` C bridge: `SetDefaultBgGradientColors(c1, c2)`
- [ ] 10.3 Add `%v3d-viewer-set-default-view-proj` C bridge: `SetDefaultViewProj(orientation)`
- [ ] 10.4 Add `%v3d-viewer-set-default-view-size` C bridge: `SetDefaultViewSize(size)`
- [ ] 10.5 Add `%v3d-viewer-set-default-view-type` C bridge: `SetDefaultTypeOfView(type)`
- [ ] 10.6 Add `%v3d-viewer-set-default-lights` C bridge: on/off/custom variants
- [ ] 10.7 Add `%v3d-viewer-set-default-drawer` C bridge: `SetDefaultDrawer(drawer)`
- [ ] 10.8 Add CFFI bindings for defaults functions
- [ ] 10.9 Create `src/core/viewer-defaults.lisp` with:
  - `set-default-background` (color and gradient variants)
  - `set-default-projection`
  - `set-default-view-size`
  - `set-default-view-type` (:perspective :orthographic)
  - `set-default-lights` (:on :off :custom &rest lights)
  - `set-default-drawer`
- [ ] 10.10 Export defaults symbols
- [ ] 10.11 Write unit tests: set/get default background, projection, view size
- [ ] 10.12 Update README with defaults API

## 11. Drawer: viewer-drawer (Prs3d_Drawer first-class object)

- [ ] 11.1 Add `%ais-object-attributes` C bridge: returns handle to `Prs3d_Drawer`
- [ ] 11.2 Add shading aspect bridge functions:
  - `%drawer-shading-aspect`: returns handle
  - `%shading-set-interior-color`
  - `%shading-set-interior-color-back`
  - `%shading-set-edge-color`
  - `%shading-set-edge-line-type`
  - `%shading-set-edge-width`
  - `%shading-set-front-material`
  - `%shading-set-back-material`
  - `%shading-set-shading-method`
- [ ] 11.3 Add line aspect bridge functions:
  - `%drawer-line-aspect`: returns handle
  - `%line-aspect-set-color`
  - `%line-aspect-set-type` (:solid :dash :dot :dot-dash)
  - `%line-aspect-set-width`
- [ ] 11.4 Add point aspect bridge functions:
  - `%drawer-point-aspect`: returns handle
  - `%point-aspect-set-color`
  - `%point-aspect-set-type` (:point :plus :star :o :x :ball)
  - `%point-aspect-set-scale`
- [ ] 11.5 Add text aspect bridge functions:
  - `%drawer-text-aspect`: returns handle
  - `%text-aspect-set-color`
  - `%text-aspect-set-font`
  - `%text-aspect-set-height`
  - `%text-aspect-set-style` (:normal :bold :italic)
  - `%text-aspect-set-angle`
  - `%text-aspect-set-display-type`
  - `%text-aspect-set-subtitle-color`
  - `%text-aspect-set-space`
- [ ] 11.6 Add boundary/iso/wire aspect bridge functions:
  - `%drawer-free-boundary-aspect`
  - `%drawer-face-boundary-aspect`
  - `%drawer-u-iso-aspect`
  - `%drawer-v-iso-aspect`
  - `%drawer-wire-aspect`
  - `%drawer-set-free-boundary-draw`
  - `%drawer-set-face-boundary-draw`
- [ ] 11.7 Add CFFI bindings for all drawer functions
- [ ] 11.8 Create `src/core/viewer-drawer.lisp` with:
  - `drawer` CLOS class wrapping Prs3d_Drawer handle
  - `ais-drawer` accessor on ais-object
  - Sub-aspect CLOS classes: `shading-aspect`, `line-aspect`, `point-aspect`, `text-aspect`, `boundary-aspect`
  - Accessor chain: `(shading-aspect drawer)` → `shading-aspect` instance
  - Slot accessors via `setf`: `(line-color drawer)`, `(line-width drawer)`, `(shading-color drawer)`, etc.
  - Drawer boolean toggles: `(setf (free-boundary-draw drawer) t)`
  - Convenience: `ais-set-edge-styling`, `ais-style` (multi-property shorthand)
  - All handle types get `tg:finalize` GC
- [ ] 11.9 Export drawer symbols
- [ ] 11.10 Write unit tests: get drawer from object, modify shading color, line aspect, toggle boundaries, convenience shorthand
- [ ] 11.11 Update README with drawer API documentation

## 12. Dimensions: viewer-dimensions (length, angle, diameter)

- [ ] 12.1 Add `%ais-make-length-dimension-2p` C bridge: `AIS_LengthDimension(p1, p2)`
- [ ] 12.2 Add `%ais-make-length-dimension-edge` C bridge: `AIS_LengthDimension(edge)`
- [ ] 12.3 Add `%ais-make-angle-dimension-2e` C bridge: `AIS_AngleDimension(edge1, edge2)`
- [ ] 12.4 Add `%ais-make-angle-dimension-3p` C bridge: `AIS_AngleDimension(vertex, p1, p2)`
- [ ] 12.5 Add `%ais-make-diameter-dimension` C bridge: `AIS_DiameterDimension(edge)`
- [ ] 12.6 Add `%ais-make-radius-dimension` C bridge: `AIS_RadiusDimension(edge_or_face)`
- [ ] 12.7 Add `%dimension-set-text` C bridge: `SetText(string, font, height)`
- [ ] 12.8 Add `%dimension-set-arrow-style` C bridge: arrow type and size
- [ ] 12.9 Add `%dimension-set-extension` C bridge: offset and length
- [ ] 12.10 Add `%dimension-set-flyout` C bridge: flyout distance
- [ ] 12.11 Add CFFI bindings for all dimension functions
- [ ] 12.12 Create `src/core/viewer-dimensions.lisp` with:
  - `make-dimension` constructor dispatching on :type (:length :angle :diameter :radius)
  - Reuses `ais-object` and `ais-display` from existing code
  - `set-dimension-text` (:string :font :height kwargs)
  - `set-dimension-arrows` (:style :filled/:open :size)
  - `set-dimension-extension` (:offset :length)
  - `set-dimension-flyout`
- [ ] 12.13 Export dimension symbols
- [ ] 12.14 Write unit tests: create each dimension type, set text, arrows, extension, flyout, display in context
- [ ] 12.15 Update README with dimension API documentation

## 1. Foundation: viewer-colors (named colors + color system)

- [x] 1.1 Add `%named-color-rgb` C bridge: takes color name keyword → returns RGB triple via `Quantity_Color(Quantity_NOC_*)`
- [x] 1.2 Add `%named-color-exists-p` C bridge: checks if a `Quantity_NameOfColor` value is valid
- [x] 1.3 Add `%color-to-rgb` C bridge: converts any `Quantity_Color` handle to (r g b) doubles
- [x] 1.4 Add `%make-color-rgb` C bridge: creates `Quantity_Color` from (r g b)
- [x] 1.5 Add `%make-color-hls` C bridge: creates `Quantity_Color` from (h l s) via `Quantity_TOC_HLS`
- [x] 1.6 Add `%color-delta` C bridge: compute color difference between two `Quantity_Color`
- [x] 1.7 Add `%hex-to-color` C bridge: parse hex string → `Quantity_Color`
- [x] 1.8 Add CFFI bindings for all color bridge functions in `src/ffi/bindings.lisp`
- [x] 1.9 Create `src/core/viewer-colors.lisp` with:
  - `*named-colors*` alist mapping ~260 keyword → (r g b)
  - `named-color`, `color-rgb` accessors
  - `normalize-color` multimethod (keyword, list, hex-string, viewer-color)
  - `viewer-color` CLOS class with %r %g %b %name slots
  - `make-color` constructor (:rgb, :hls, :keyword)
  - `hex-to-rgb`, `color-delta` functions
  - `list-named-colors`
- [x] 1.10 Export all public symbols from `cl-occt` package in `src/package.lisp`
- [x] 1.11 Write unit tests: named color lookup, hex parsing, HLS conversion, color delta, invalid inputs
- [x] 1.12 Update README with color system documentation

## 2. Core: viewer-camera (camera and view orientation)

- [x] 2.1 Add `%v3d-view-set-eye` C bridge: `SetEye(gp_Pnt(x,y,z))`
- [x] 2.2 Add `%v3d-view-set-target` C bridge: `SetTarget(gp_Pnt(x,y,z))`
- [x] 2.3 Add `%v3d-view-set-up` C bridge: `SetUp(gp_Dir(x,y,z))`
- [x] 2.4 Add `%v3d-view-set-projection-type` C bridge: perspective/orthographic toggle
- [x] 2.5 Add `%v3d-view-set-fov` C bridge: `Camera()->SetFOV(radians)`
- [x] 2.6 Add `%v3d-view-set-clip-planes` C bridge: near/far Z-clipping
- [x] 2.7 Add `%v3d-view-fit-all-shape` C bridge: `FitAll(shape)` for individual shapes
- [x] 2.8 Add `%v3d-view-pan` C bridge: `Pan(dx, dy)`
- [x] 2.9 Add `%v3d-view-zoom` C bridge: `Zoom(scale)`
- [x] 2.10 Add `%v3d-view-rotate` C bridge: `Rotate(ax, ay, az)`
- [x] 2.11 Add `%v3d-view-reset` C bridge: `SetViewOrientationDefault()` + `SetViewMappingDefault()`
- [x] 2.12 Add `%v3d-view-camera` C bridge: returns handle to `Graphic3d_Camera`
- [x] 2.13 Add `%v3d-view-set-camera` C bridge: `SetCamera(handle)`
- [x] 2.14 Add CFFI bindings for all camera functions
- [x] 2.15 Create `src/core/viewer-camera.lisp` with:
  - `set-camera` convenience (:eye :target :up keyword args)
  - `viewer-camera` CLOS class wrapping Graphic3d_Camera handle
  - `set-perspective`, `perspective-p`
  - `set-fov`, `set-clip-planes`
  - `fit-all` extended to accept optional ais-object argument
  - `pan-camera`, `zoom-camera`, `rotate-camera`
  - `reset-view`
- [x] 2.16 Export public camera symbols
- [x] 2.17 Write unit tests: camera round-trip, perspective toggle, FOV set, clip planes, pan/zoom/rotate, fit-all per-shape
- [x] 2.18 Update README with camera API documentation

## 3. Trihedron: viewer-trihedron (extend existing trihedron)

- [x] 3.1 Add `%ais-trihedron-set-colors` C bridge: `SetColors(cX, cY, cZ)` → 3 `Quantity_Color` args
- [x] 3.2 Add `%ais-trihedron-set-text-color` C bridge: `SetTextColor(c)`
- [x] 3.3 Add `%ais-trihedron-set-draw-names` C bridge: `SetDrawNames(bool)`
- [x] 3.4 Extend existing `%ais-trihedron-set-datum-mode` (or add new bridge) to support label/arrow display modes beyond wireframe/shaded
- [x] 3.5 Add CFFI bindings for all new trihedron functions
- [x] 3.6 Extend `src/core/viewer.lisp` trihedron section with:
  - `set-trihedron-axis-colors` (:x :y :z keyword args accepting normalized colors)
  - `set-trihedron-text-color`
  - `set-trihedron-draw-names`
  - Extended datum-mode keywords: `:labels-only`, `:arrows-only`, `:both`
  - `set-trihedron-wireframe-color`
- [x] 3.7 Export new trihedron symbols
- [x] 3.8 Write unit tests: axis colors round-trip, text color, draw-names toggle, datum modes, wireframe color
- [x] 3.9 Update README with extended trihedron API

## 4. Per-Object: viewer-object-props (transparency, materials, line width, edges, tessellation, selection)

- [x] 4.1 Add `%ais-set-transparency` C bridge: `SetTransparency(v)`
- [x] 4.2 Add `%ais-set-material-by-name` C bridge: `SetMaterial(Graphic3d_NOM_*)` from preset name string
- [x] 4.3 Add `%ais-material-preset-count` C bridge: returns number of material presets
- [x] 4.4 Add `%ais-material-preset-name` C bridge: returns string name for preset index
- [x] 4.5 Add `%make-material` C bridge: creates `Graphic3d_MaterialAspect` from ambient/diffuse/specular/emissive/shininess/transparency
- [x] 4.6 Add `%ais-set-custom-material` C bridge: applies a material aspect to an AIS object
- [x] 4.7 Add `%ais-set-line-width` C bridge: `SetWidth(w)` on the AIS object
- [x] 4.8 Add `%ais-show-edges` C bridge: `Attributes()->SetDisplayEdgesEdges(bool)`
- [x] 4.9 Add `%ais-set-edge-color` C bridge: edge color via `SetFaceBoundaryAspect` / `ShadingAspect`
- [x] 4.10 Add `%ais-set-selection-mode` C bridge: `SetSelectionMode(mode)`
- [x] 4.11 Add `%ais-set-tessellation` C bridge: `SetDiscretisation(d)` + `SetDeviationCoefficient(d)`
- [x] 4.12 Add CFFI bindings for all object-props functions
- [x] 4.13 Create `src/core/viewer-object-props.lisp` with:
  - `ais-set-transparency`
  - `ais-set-material` (keyword dispatch to preset or custom)
  - `make-material` constructor → `material` CLOS struct/class
  - `ais-set-line-width`
  - `ais-show-edges`, `ais-set-edge-styling`
  - `ais-set-selection-mode`
  - `ais-set-tessellation`
  - `*material-presets*` keyword map
  - `material` CLOS class with %ambient %diffuse %specular %emissive %shininess %transparency
- [x] 4.14 Export all object-props symbols
- [x] 4.15 Write unit tests: transparency set, material preset, custom material, line width, edges toggle, selection mode, tessellation
- [x] 4.16 Update README with per-object properties documentation

## 5. Lighting: viewer-lighting (all 4 light types)

- [x] 5.1 Add `%make-light-ambient` C bridge: creates `V3d_AmbientLight(color, intensity)`
- [x] 5.2 Add `%make-light-directional` C bridge: creates `V3d_DirectionalLight(color, intensity, direction)`
- [x] 5.3 Add `%make-light-positional` C bridge: creates `V3d_PositionalLight(color, intensity, position)`
- [x] 5.4 Add `%make-light-spot` C bridge: creates `V3d_SpotLight(color, intensity, position, direction, angle, concentration)`
- [x] 5.5 Add `%light-free` C bridge: deletes handle
- [x] 5.6 Add `%v3d-viewer-add-light` C bridge: `Viewer()->SetLight(light)`
- [x] 5.7 Add `%v3d-viewer-remove-light` C bridge: `Viewer()->SetLightOff(light)` + remove
- [x] 5.8 Add `%v3d-viewer-light-on` C bridge: `Viewer()->SetLightOn(light)`
- [x] 5.9 Add `%v3d-viewer-light-off` C bridge: `Viewer()->SetLightOff(light)`
- [x] 5.10 Add `%light-set-color` C bridge: `light->SetColor(color)`
- [x] 5.11 Add `%light-set-intensity` C bridge: `light->SetIntensity(v)`
- [x] 5.12 Add `%light-set-direction` C bridge: `light->SetDirection(dir)` (directional/spot)
- [x] 5.13 Add `%light-set-position` C bridge: `light->SetPosition(pos)` (positional/spot)
- [x] 5.14 Add `%light-set-angle` C bridge: `light->SetAngle(angle)` (spot)
- [x] 5.15 Add `%light-set-concentration` C bridge: `light->SetConcentration(v)` (spot)
- [x] 5.16 Add `%light-set-headlight` C bridge: `light->SetHeadlight(bool)`
- [x] 5.17 Add `%light-set-shadows` C bridge: `light->SetShadows(bool)`
- [x] 5.18 Add `%v3d-viewer-default-lights` C bridge: `Viewer()->SetDefaultLights()`
- [x] 5.19 Add `%light-is-on` C bridge: `light->IsEnabled()`
- [x] 5.20 Add CFFI bindings for all lighting functions
- [x] 5.21 Create `src/core/viewer-lighting.lisp` with:
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
- [x] 5.22 Export all lighting symbols
- [x] 5.23 Write unit tests: create each light type, add to viewer, toggle on/off, modify properties, headlight mode, query active lights
- [x] 5.24 Update README with lighting API documentation

## 6. Grid: viewer-grid (extend existing grid)

- [x] 6.1 Add grid display via Aspect_GridParams (GPU shader grid): `SetGridColor(color)`
- [x] 6.2 Add grid via SetRectangularGridValues + v3d_view_grid_display: `SetGridSize(double)`
- [ ] 6.3 Add `%v3d-viewer-set-grid-xy-size` C bridge: `SetGridXYSize(x, y)`
- [ ] 6.4 Add `%v3d-viewer-set-grid-offset` C bridge: `SetGridOffset(x, y)`
- [x] 6.5 Add `%v3d-viewer-grid-active` C bridge: returns whether grid is active
- [x] 6.6 Add CFFI bindings for grid functions
- [x] 6.7 Extend grid section in `src/core/viewer.lisp` (or create `src/core/viewer-grid.lisp`) with:
  - `set-grid-color` (accepts normalized color)
  - `set-grid-size`, `set-grid-xy-size`
  - `set-grid-offset`
  - `grid-color`, `grid-size`, `grid-offset` (query)
  - `grid-active-p`
- [x] 6.8 Export new grid symbols
- [x] 6.9 Write unit tests: set grid color, size, offset, round-trip queries
- [x] 6.10 Update README with extended grid API

## 7. Background: viewer-background (gradient, image, cubemap)

- [x] 7.1 Add `%v3d-view-set-bg-gradient` C bridge: `SetBgGradientColors(c1, c2, style, fill_method)`
- [x] 7.2 Add `%v3d-view-set-bg-image` C bridge: `SetBgImage(path, fill_method)`
- [ ] 7.3 Add `%v3d-view-set-cube-map` C bridge: `SetBgCubeMap()` from 6 file paths
- [x] 7.4 Add `%v3d-view-reset-background` C bridge: reset to default
- [x] 7.5 Add CFFI bindings for background functions
- [x] 7.6 Create `src/core/viewer-background.lisp` with:
  - `set-gradient-background` (:color1 :color2 :style keywords)
  - Fill style keyword map (:x-pos, :x-neg, :y-pos, etc.)
  - `set-image-background` (path, optional fill-method)
  - `set-cube-map` (6 face image paths)
  - `reset-background`
- [x] 7.7 Export background symbols
- [x] 7.8 Write unit tests: gradient with different directions, image background with valid/invalid path, reset
- [x] 7.9 Update README with background API

## 8. Rendering: viewer-rendering (quality knobs)

- [x] 8.1 Add `%v3d-view-set-computed-mode` C bridge: `SetComputedMode(bool)`
- [x] 8.2 Add `%v3d-view-computed-mode` C bridge: query computed mode
- [x] 8.3 Add `%v3d-view-set-back-face-model` C bridge: `SetBackFacingModel(mode)`
- [x] 8.4 Add `%v3d-view-set-frustum-culling` C bridge: `SetFrustumCulling(bool)`
- [x] 8.5 Add `%v3d-view-set-transparent-shading` C bridge: `SetTransparentShading(bool)`
- [x] 8.6 Add `%v3d-view-redraw` C bridge: `Redraw()` + `RedrawImmediate()`
- [x] 8.7 Add `%v3d-view-set-immediate-update` C bridge: `SetImmediateUpdate(bool)`
- [x] 8.8 Add CFFI bindings for rendering functions
- [x] 8.9 Create `src/core/viewer-rendering.lisp` with:
  - `set-computed-mode`, `computed-mode-p`
  - `set-back-face-model` (:auto :force :disable keywords)
  - `set-frustum-culling`, `set-transparent-shading`
  - `redraw-view` (full redraw)
  - `set-immediate-update`
- [x] 8.10 Export rendering symbols
- [x] 8.11 Write unit tests: computed mode toggle, back-face model, frustum culling, redraw (no-crash)
- [x] 8.12 Update README with rendering API

## 9. Text Labels: viewer-text-labels (enhancements)

- [x] 9.1 Add `%ais-text-label-set-angle` C bridge: `SetAngle(rad)`
- [x] 9.2 Add `%ais-text-label-set-hjustify` C bridge: `SetHJustify(type)`
- [x] 9.3 Add `%ais-text-label-set-vjustify` C bridge: `SetVJustify(type)`
- [ ] 9.4 Add `%ais-text-label-set-display-type` C bridge: `SetDisplayType(type)`
- [x] 9.5 Add `%ais-text-label-set-subtitle-color` C bridge: `SetSubtitleColor(c)`
- [ ] 9.6 Add `%ais-text-label-set-space` C bridge: `SetSpace(spacing)`
- [x] 9.7 Add CFFI bindings for text label enhancements
- [x] 9.8 Extend `src/core/text.lisp` (or create `src/core/viewer-text-labels.lisp`) with:
  - `set-text-label-angle` (converts degrees to radians)
  - `set-text-label-align` (:horizontal :left/:center/:right, :vertical :top/:center/:bottom)
  - `set-text-label-display` (:ordinary :subtitle :dekale)
  - `set-text-label-subtitle-color`
  - `set-text-label-spacing`
  - `make-text-label` convenience (create + configure + display in one call)
- [x] 9.9 Export new text label symbols
- [x] 9.10 Write unit tests: angle, alignment, display type, subtitle color, spacing, convenience function
- [x] 9.11 Update README with text label enhancements

## 10. Defaults: viewer-defaults (viewer-level defaults)

- [x] 10.1 Add `%v3d-viewer-set-default-bg-color` C bridge: `SetDefaultBackgroundColor(color)`
- [x] 10.2 Add `%v3d-viewer-set-default-bg-gradient` C bridge: `SetDefaultBgGradientColors(c1, c2)`
- [x] 10.3 Add `%v3d-viewer-set-default-view-proj` C bridge: `SetDefaultViewProj(orientation)`
- [x] 10.4 Add `%v3d-viewer-set-default-view-size` C bridge: `SetDefaultViewSize(size)`
- [x] 10.5 Add `%v3d-viewer-set-default-view-type` C bridge: `SetDefaultTypeOfView(type)`
- [x] 10.6 Add `%v3d-viewer-set-default-lights` C bridge: on/off/custom variants
- [x] 10.7 Add `%v3d-viewer-set-default-drawer` C bridge: `SetDefaultDrawer(drawer)`
- [x] 10.8 Add CFFI bindings for defaults functions
- [x] 10.9 Create `src/core/viewer-defaults.lisp` with:
  - `set-default-background` (color and gradient variants)
  - `set-default-projection`
  - `set-default-view-size`
  - `set-default-view-type` (:perspective :orthographic)
  - `set-default-lights` (:on :off :custom &rest lights)
  - `set-default-drawer`
- [x] 10.10 Export defaults symbols
- [x] 10.11 Write unit tests: set/get default background, projection, view size
- [x] 10.12 Update README with defaults API

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
- [x] 11.9 Export drawer symbols
- [x] 11.10 Write unit tests: get drawer from object, modify shading color, line aspect, toggle boundaries, convenience shorthand
- [x] 11.11 Update README with drawer API documentation

## 12. Dimensions: viewer-dimensions (length, angle, diameter, radius)

- [x] 12.1 Add `%ais-make-length-dimension-2p` C bridge: `AIS_LengthDimension(p1, p2)`
- [x] 12.2 Add `%ais-make-length-dimension-edge` C bridge: `AIS_LengthDimension(edge)`
- [x] 12.3 Add `%ais-make-angle-dimension-3p` C bridge: `AIS_AngleDimension(vertex, p1, p2)`
- [ ] 12.4 Add `%ais-make-angle-dimension-2e` C bridge: `AIS_AngleDimension(edge1, edge2)`
- [x] 12.5 Add `%ais-make-diameter-dimension` C bridge: `AIS_DiameterDimension(edge)`
- [x] 12.6 Add `%ais-make-radius-dimension` C bridge: `AIS_RadiusDimension(edge_or_face)`
- [ ] 12.7 Add `%dimension-set-text` C bridge: `SetText(string, font, height)`
- [x] 12.8 Add `%dimension-set-arrow-style` C bridge: arrow type and size
- [x] 12.9 Add `%dimension-set-extension` C bridge: offset and length
- [x] 12.10 Add `%dimension-set-flyout` C bridge: flyout distance
- [x] 12.11 Add CFFI bindings for all dimension functions
- [x] 12.12 Create `src/core/viewer-dimensions.lisp` with:
  - `make-dimension` constructor dispatching on :type (:length :angle :diameter :radius)
  - Reuses `ais-object` and `ais-display` from existing code
  - `set-dimension-text` (:string :font :height kwargs)
  - `set-dimension-arrows` (:style :filled/:open :size)
  - `set-dimension-extension` (:offset :length)
  - `set-dimension-flyout`
- [x] 12.13 Export dimension symbols
- [x] 12.14 Write unit tests: create each dimension type, set text, arrows, extension, flyout, display in context
- [x] 12.15 Update README with dimension API documentation

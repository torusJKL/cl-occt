## 1. Camera: viewer-camera CLOS class

- [x] 1.1 Add `viewer-camera` CLOS class with `%eye`, `%target`, `%up`, `%projection-type`, `%fov` slots in `src/core/viewer-camera.lisp`
- [x] 1.2 Add `viewer-camera-p` predicate
- [x] 1.3 Add `viewer-camera` function: reads camera state from V3d_View via Graphic3d_Camera getter CFFI calls, returns viewer-camera instance
- [x] 1.4 Add `set-viewer-camera` function: applies viewer-camera slots to a view
- [x] 1.5 Export viewer-camera symbols from package
- [x] 1.6 Write tests: capture camera, apply camera, predicate, round-trip

## 2. Lighting: light enumeration

- [x] 2.1 Add viewer→lights hash table tracking in `viewer-lighting.lisp` (%light-registry hash table keyed by viewer pointer)
- [x] 2.2 Update `viewer-add-light` to register light in the table
- [x] 2.3 Update `viewer-remove-light` to deregister from the table
- [x] 2.4 Add `viewer-lights` function that returns registered lights for a viewer
- [x] 2.5 Add `viewer-active-lights` function that filters to lights where `viewer-light-active-p` is true
- [x] 2.6 Export symbols + write tests

## 3. Trihedron: wireframe color

- [x] 3.1 Add `%ais-trihedron-set-wireframe-color` C bridge: sets wireframe aspect color on trihedron's attributes drawer
- [x] 3.2 Add CFFI binding
- [x] 3.3 Add `set-trihedron-wireframe-color` Lisp function in `src/core/viewer.lisp`
- [x] 3.4 Export symbol + write tests

## 4. Defaults: set-default-gradient, set-default-lights modes

- [x] 4.1 Add `set-default-gradient` alias that calls `set-default-bg-gradient`
- [x] 4.2 Add `set-default-lights` with `:on`/`:off`/`:custom` keyword dispatch
- [x] 4.3 Export symbols + write tests

## 5. Grid: convenience functions

- [x] 5.1 Add `set-grid-color` convenience wrapping `grid-display` with color only
- [x] 5.2 Add `set-grid-size` convenience wrapping `set-grid-xy-size` (uniform size)
- [x] 5.3 Add stub getters: `grid-color`, `grid-size`, `grid-offset` returning nil
- [x] 5.4 Export symbols + write tests

## 6. Dimensions: edge keywords + styling conveniences

- [x] 6.1 Add `:edge` keyword to `make-dimension` for length dimensions
- [x] 6.2 Add `:edge1`/`:edge2` keywords to `make-dimension` for angle dimensions
- [x] 6.3 Add `set-dimension-text` alias calling `set-dimension-custom-value`
- [x] 6.4 Add `set-dimension-arrows` convenience with `:style` and `:size` keywords
- [x] 6.5 Add `set-dimension-extension` convenience with `:offset` and `:length` keywords
- [x] 6.6 Export symbols + write tests

## 7. Selection mode: keyword map

- [x] 7.1 Add `*selection-mode-map*` mapping `(:shape . 0) (:face . 1) (:edge . 2) (:vertex . 3)` in `viewer-object-props.lisp`
- [x] 7.2 Update `ais-set-selection-mode` to accept keywords and dispatch via the map
- [x] 7.3 Write tests: :shape, :face, :edge, :vertex keywords

## 8. Text labels: set-text-label-align convenience

- [x] 8.1 Add `set-text-label-align` with `:horizontal` and `:vertical` keyword dispatch
- [x] 8.2 Export symbol + write tests

## 9. Alias functions (thin wrappers)

- [x] 9.1 Add `set-cube-map` alias → `set-background-cubemap` in `viewer-background.lisp`
- [x] 9.2 Add `set-transparent-shading` alias → `set-transparency-method` in `viewer-rendering.lisp`
- [x] 9.3 Export symbols + write tests

## 10. Documentation

- [x] 10.1 Update README with all new convenience functions and aliases
- [x] 10.2 Note `set-default-drawer` as blocked in both README and spec

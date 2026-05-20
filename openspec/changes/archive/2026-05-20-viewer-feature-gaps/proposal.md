## Why

The comprehensive viewer controls change left several gaps between the spec requirements and the actual API surface. 4 features are completely missing, and 7 have name/API differences where a function exists but doesn't match the spec signature. This change closes those gaps by adding aliases, convenience wrappers, and the missing features.

## What Changes

- **4 missing features**: `viewer-camera` CLOS class, light enumeration, trihedron wireframe color, default drawer
- **7 API harmonizations**: alias functions, keyword→int maps, convenience wrappers for grid/dimensions/text-labels
- No breaking changes — all new additions, no removals

## Capabilities

### New Capabilities

- `viewer-gaps`: Aggregated spec for the remaining gap-closing features across all viewer areas

### Modified Capabilities

No existing specs change — this is additive aliasing and gap filling.

## Impact

- `src/core/viewer-camera.lisp`: Add `viewer-camera` CLOS class
- `src/core/viewer-lighting.lisp`: Add `viewer-lights`, `viewer-active-lights`
- `src/core/viewer.lisp`: Add `set-trihedron-wireframe-color`
- `src/core/viewer-defaults.lisp`: Add `set-default-drawer`, `set-default-gradient`, `set-default-lights :on/:off/:custom`
- `src/core/viewer-grid.lisp`: Add `set-grid-color`, `set-grid-size`, `grid-color`, `grid-size`, `grid-offset`
- `src/core/viewer-dimensions.lisp`: Add `set-dimension-text`, `set-dimension-arrows`, `set-dimension-extension`, `:edge`/`:edge1`/`:edge2` keywords to `make-dimension`
- `src/core/viewer-object-props.lisp`: Add selection mode keyword map
- `src/core/viewer-text-labels.lisp`: Add `set-text-label-align` convenience
- `src/core/viewer-background.lisp`: Add `set-cube-map` alias
- `src/core/viewer-rendering.lisp`: Add `set-transparent-shading` alias
- `src/ffi/bindings.lisp`: Add `%ais-trihedron-set-wireframe-color` C bridge
- `wrap/occt_wrap.h` + `.cpp`: Add trihedron wireframe color C bridge
- `src/package.lisp`: New exports
- `t/smoke-tests.lisp`: Tests for new features
- `README.md`: Document new functions

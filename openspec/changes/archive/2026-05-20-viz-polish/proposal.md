## Why

Displaying grey shapes on a grey background is functional but not pleasant. Users need visual polish: colored objects, background customization, anti-aliasing for clean edges, grid for spatial reference, and camera control for inspection. These are table-stakes for any 3D viewer.

## What Changes

- **C wrapper**: ~12 new functions for background color, object color, display mode, camera projection, MSAA, antialiasing, grid, and `V3d_View::Invalidate`
- **CFFI bindings**: matching defcfun forms
- **Lisp API**: `set-background`, `set-color`, `set-display-mode`, camera DSL (`set-view-projection`, `set-view-direction`), `set-msaa`, `set-antialiasing`, `activate-grid` / `deactivate-grid`, all with keyword-based enums
- **Enum mappings**: Lisp-side keyword → C int translation tables for `V3d_TypeOfOrientation`, `AIS_DisplayMode`, `Aspect_GridType`, `Aspect_GridDrawMode`

## Capabilities

### New Capabilities

- `styling`: Set background color, object color, display mode (wireframe/shaded), MSAA level, anti-aliasing toggle
- `camera`: Set view projection (orthographic/perspective), view orientation (front/top/right/iso/etc.)
- `grid`: Activate/deactivate rectangular or circular grid with line or point draw mode

### Modified Capabilities

None.

## Impact

- `wrap/occt_wrap.h`: add ~12 function declarations
- `wrap/occt_wrap.cpp`: add ~12 implementations + `#include <Quantity_Color.hxx>`
- `src/ffi/bindings.lisp`: add ~12 defcfun forms
- `src/core/viewer.lisp` or `src/core/display.lisp`: add styling, camera, grid functions
- `src/package.lisp`: export new symbols
- `t/smoke-tests.lisp`: add styling/camera/grid tests

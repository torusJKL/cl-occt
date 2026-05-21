## Why

The current viewer exposes only the bare minimum: create/destroy, solid background color, preset projection, MSAA/AA toggle, grid on/off, and a basic trihedron. Users building parametric CAD tools from Lisp cannot control visual quality, lighting, per-object materials, camera behavior, backgrounds, dimensions, or the color system — yet these are the controls that differentiate a usable engineering tool from a wireframe toy.

CL-OCCT aims to be a serious parametric CAD library. To deliver on that, the viewer must expose the full OCCT visual API in a Lisp-idiomatic way. Every visual element that OCCT's C++ API can control must be accessible from the REPL at runtime, with both convenience functions for common operations and first-class Lisp objects for deep customization.

## What Changes

This change introduces **12 new capability areas**, each implemented as an independent spec. Every spec follows the same three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each spec includes unit tests and README updates.

**New capabilities** (see below). No breaking changes to existing APIs.

### Design principle: two-tier API

Every visual element gets both:

1. **Convenience functions** — simple keyword-driven calls for REPL use, e.g. `(set-camera view :eye '(10 10 10) :target '(0 0 0))`, `(ais-set-material obj :gold)`, `(set-grid-color view :dark-grey)`
2. **First-class objects** — Lisp objects wrapping OCCT handles so power users can access the full tree, e.g. `(light-ambient :color :warm-white :intensity 0.4)`, access to `prs3d-drawer` sub-aspects via slot accessors

## Capabilities

### New Capabilities

- `viewer-camera`: Full camera control — eye/target/up vectors, perspective/orthographic toggle, field-of-view, Z-clipping planes, FitAll for individual shapes
- `viewer-lighting`: Complete lighting system — 4 light types (ambient, directional, positional, spot), per-light color/intensity/position/direction, headlight mode, default lights management, shadow casting toggle
- `viewer-background`: Background environment — two-color gradient, image file background, cube-map environment
- `viewer-grid`: Grid customization — color, uniform and non-uniform size, offset from origin (extends existing grid on/off)
- `viewer-trihedron`: Extended trihedron control — per-axis colors (SetColors), text label color (SetTextColor), datum display modes including label visibility, draw-names toggle (extends existing trihedron)
- `viewer-object-props`: Per-object display properties — transparency slider, 50+ material presets, custom material (ambient/diffuse/specular/shininess/emissive), line width, shaded+edges mode, selection mode (shape/face/edge/vertex), tessellation quality
- `viewer-drawer`: First-class Prs3d_Drawer object — expose the full aspect tree as CLOS objects: ShadingAspect → Graphic3d_AspectFillArea3d, LineAspect → Graphic3d_AspectLine3d, PointAspect → Graphic3d_AspectMarker3d, TextAspect → Graphic3d_AspectText3d, plus boundary/iso/wire sub-aspects
- `viewer-dimensions`: Dimension measurement primitives — AIS_LengthDimension, AIS_AngleDimension, AIS_DiameterDimension with full styling (extension lines, arrows, text)
- `viewer-colors`: Color system — all ~260 named color constants (Quantity_NOC_*) as Lisp keywords, HLS color model, hex string parsing (#RRGGBB), color difference (DeltaE)
- `viewer-text-labels`: Text label enhancements — rotation angle, horizontal/vertical alignment, display type (ordinary/subtitle/dekale), subtitle background color, character spacing (extends existing text labels)
- `viewer-rendering`: Rendering quality controls — computed (ray-traced) mode, back-face model, frustum culling, transparent shading sorting
- `viewer-defaults`: Viewer-level defaults — custom default Prs3d_Drawer, default background color/gradient, default projection, default view size, default layer configuration

### Modified Capabilities

- `styling`: Extended with new convenience functions for camera, grid, and per-object controls that overlap with existing styling spec. The existing styling spec's requirements remain unchanged; new requirements are added in the new capability specs.
- `aids`: Extended trihedron requirements moved to `viewer-trihedron`. Existing aids spec remains stable.
- `viewer`: No requirement changes, but the viewer CLOS class gains new accessor methods and slots.

## Impact

- **wrap/occt_wrap.h + .cpp**: Each spec adds 5-25 new `extern "C"` bridge functions. The trihedron, lighting, and drawer specs are the largest (20+ functions each).
- **src/ffi/bindings.lisp**: Each spec adds corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files created per area:
  - `src/core/viewer-camera.lisp`
  - `src/core/viewer-lighting.lisp`
  - `src/core/viewer-background.lisp`
  - `src/core/viewer-grid.lisp`
  - `src/core/viewer-trihedron.lisp` (extends existing functions)
  - `src/core/viewer-object-props.lisp`
  - `src/core/viewer-drawer.lisp`
  - `src/core/viewer-dimensions.lisp`
  - `src/core/viewer-colors.lisp`
  - `src/core/viewer-text-labels.lisp`
  - `src/core/viewer-rendering.lisp`
  - `src/core/viewer-defaults.lisp`
- **src/core/viewer.lisp**: Extended with new generic methods and accessors on existing classes
- **src/package.lisp**: ~200+ new exported symbols across both packages
- **t/smoke-tests.lisp**: New test sections per spec, ~20-40 tests each
- **README.md**: Updated with viewer capabilities documentation
- **Dependencies**: No new external dependencies; all OCCT headers already included in wrap

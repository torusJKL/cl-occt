## Why

cl-occt currently binds only three AIS interactive object types: `AIS_Shape`, `AIS_Trihedron`, and `AIS_TextLabel`. This limits the viewer to basic shape display without support for rich interactive widgets (manipulators, view cubes, color scales), non-geometric objects (planes, axes, circles), point clouds, textured meshes, light sources, or connected/copied interactive objects that OCCT provides out of the box.

Adding bindings for these 13 AIS classes unlocks advanced visualization capabilities needed for CAD-like applications: direct manipulation, orientation cues, measurement overlays, large point cloud rendering, material preview, and hierarchical object sharing.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp` for each of the 13 AIS classes
- Add CFFI `%`-prefixed bindings in `src/ffi/bindings.lisp`
- Add CLOS wrapper classes and constructors/properties in `src/core/viewer.lisp` (or new `src/core/viewer-ais-types.lisp`)
- Update `src/package.lisp` to export new public symbols
- Add unit tests for each new AIS type
- Update `docs/api-reference.md` with documentation for all new functions

## Capabilities

### New Capabilities
- `ais-colored-shape`: Bindings for `AIS_ColoredShape` — an interactive shape with per-subshape color assignment
- `ais-manipulator`: Bindings for `AIS_Manipulator` — interactive translation/rotation/scale gizmo
- `ais-connected-interactive`: Bindings for `AIS_ConnectedInteractive` — shared/copied interactive object referencing another's geometry
- `ais-point-cloud`: Bindings for `AIS_PointCloud` — efficient display of point cloud data
- `ais-construction-geometry`: Bindings for `AIS_Plane`, `AIS_Axis`, `AIS_Line`, `AIS_Circle` — infinite and finite construction geometry overlays
- `ais-textured-shape`: Bindings for `AIS_TexturedShape` — shape with image texture mapping
- `ais-view-cube`: Bindings for `AIS_ViewCube` — 3D orientation cube widget
- `ais-triangulation`: Bindings for `AIS_Triangulation` — colored mesh display
- `ais-color-scale`: Bindings for `AIS_ColorScale` — color legend bar widget
- `ais-light-source`: Bindings for `AIS_LightSource` — interactive light representation
- `ais-multiple-connected`: Bindings for `AIS_MultipleConnectedInteractive` — compound of connected interactive objects
- `api-reference-docs`: Update `docs/api-reference.md` with all new AIS function signatures

### Modified Capabilities

None.

## Impact

- **C wrapper**: ~300–500 new lines in `occt_wrap.h` and `occt_wrap.cpp`
- **FFI bindings**: ~50–80 new `defcfun` forms in `src/ffi/bindings.lisp`
- **Core Lisp**: New `src/core/viewer-ais-types.lisp` file for CLOS wrappers, plus exports in `src/package.lisp`
- **Tests**: ~13 new test files or sections in `t/` for each AIS type
- **Docs**: Updated `docs/api-reference.md` with AIS section additions
- **Dependencies**: No new OCCT libraries required — all classes are part of the OCCT `TKViz` toolkit already linked

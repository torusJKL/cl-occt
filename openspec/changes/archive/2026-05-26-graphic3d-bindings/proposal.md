## Why

cl-occt currently lacks bindings for fundamental OCCT Graphic3d classes that control low-level rendering appearance, clipping, shading, primitive grouping, and structure management. These are needed for advanced viewer features like per-object clip planes, custom shaders, aspect-level styling, and structured scene graph manipulation.

## What Changes

### New Capabilities

- **graphic3d-clip-plane**: Bind `Graphic3d_ClipPlane` — define and configure clipping planes with equation, plane object, capping, and on/off state.
- **graphic3d-shader-program**: Bind `Graphic3d_ShaderProgram` — load, compile, and attach custom GLSL vertex/fragment shader programs.
- **graphic3d-aspects**: Bind `Graphic3d_AspectFillArea3d`, `Graphic3d_AspectLine3d`, `Graphic3d_AspectMarker3d`, `Graphic3d_AspectText3d` — create and configure visual aspect attributes (color, width, style, font, material) for fill areas, lines, markers, and text.
- **graphic3d-structure**: Bind `Graphic3d_Structure` — create, manage, and manipulate scene graph structures (visibility, transforms, hierarchy, display, removal).
- **graphic3d-group**: Bind `Graphic3d_Group` — create primitive groups within a structure and add graphic primitives (polylines, triangles, text, etc.).
- **graphic3d-rendering-params**: Bind `Graphic3d_RenderingParams` — configure rendering parameters (method, ray-tracing, shadows, reflections, antialiasing, gamma correction, etc.).

### Modified Capabilities

- **api-reference**: The docs/api-reference.md will be updated with new API function tables for all the above capabilities.

## Capabilities

### New Capabilities
- `graphic3d-clip-plane`: Graphic3d_ClipPlane bindings — creation, equation/plane configuration, capping, enable/disable
- `graphic3d-shader-program`: Graphic3d_ShaderProgram bindings — create from source, header management, attach/detach shaders
- `graphic3d-aspects`: Graphic3d_AspectFillArea3d, AspectLine3d, AspectMarker3d, AspectText3d bindings — visual appearance attributes
- `graphic3d-structure`: Graphic3d_Structure bindings — scene graph node management, display, transforms, hierarchy
- `graphic3d-group`: Graphic3d_Group bindings — primitive grouping within a structure, add graphic elements
- `graphic3d-rendering-params`: Graphic3d_RenderingParams bindings — rendering method, ray-tracing settings, gamma, etc.

### Modified Capabilities
- `docs-publishing`: Update api-reference.md with new API function tables for all new Graphic3d bindings

## Impact

- `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp`: New `extern "C"` wrapper functions for Graphic3d classes
- `src/ffi/bindings.lisp`: New CFFI `defcfun` declarations for the wrapper functions
- `src/core/`: New CLOS wrapper modules for each Graphic3d capability with `tg:finalize` GC
- `src/package.lisp`: New exports for public API symbols
- `docs/api-reference.md`: Updated with documentation for all new functions
- `cl-occt.asd`: New source files added to the system definition

## Why

cl-occt has basic viewer support (AIS, camera, lights, grid, background) but lacks the ability to load and apply image textures, configure texture parameters, and use modern PBR/BSDF materials. This capability gap prevents rendering realistic scenes with surface detail (albedo, roughness, metalness, normal maps) and environment textures.

## What Changes

- **C wrapper functions** in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp` for:
  - `Image_AlienPixMap` — load/save image pixel maps from file formats (PNG, JPEG, BMP, TGA, etc.)
  - `Graphic3d_Texture2D` — create a 2D texture from an image file for surface mapping
  - `Graphic3d_Texture2Dplane` — planar texture mapping with UV repeat/origin/rotation control
  - `Graphic3d_TextureParams` — configure texture filtering (nearest/linear/trilinear), wrap mode (clamp/repeat/mirror), and anisotropy
  - `Graphic3d_PBRMaterial` — set PBR material properties (albedo, metalness, roughness, emissive, transparency, normal/ORM texture slots)
  - `Graphic3d_BSDF` — set BSDF material properties (ambient, diffuse, specular, transmission, reflection, refraction index, absorption)
- **CFFI `%`-prefixed bindings** in `src/ffi/bindings.lisp`
- **Core CLOS wrappers** in `src/core/` with `tg:finalize` GC management
- **Public API exports** from `src/package.lisp` (`cl-occt` package)
- **Updated `docs/api-reference.md`** with new function reference tables

## Capabilities

### New Capabilities
- `image-pixmap`: Load image files into OCCT pixel maps for texture source material
- `texture-2d`: Attach 2D image textures to shapes via `AIS_TexturedShape` and `Graphic3d_Texture2D`
- `texture-params`: Control texture filtering, wrapping, and anisotropy per texture
- `texture-plane`: Map textures onto planar surfaces with UV repeat, origin, and rotation
- `pbr-material`: Assign PBR material properties (albedo, metalness, roughness, emissive, normal/ORM maps)
- `bsdf-material`: Assign BSDF material properties (diffuse, specular, transmission, reflection, IOR, absorption)

### Modified Capabilities
*(none — all capabilities are new)*

## Impact

- `wrap/occt_wrap.h` — new extern "C" function declarations
- `wrap/occt_wrap.cpp` — new function implementations, new OCCT includes (`Image_AlienPixMap.hxx`, `Graphic3d_Texture2D.hxx`, `Graphic3d_Texture2Dplane.hxx`, `Graphic3d_TextureParams.hxx`, `Graphic3d_PBRMaterial.hxx`, `Graphic3d_BSDF.hxx`, `Graphic3d_TextureRoot.hxx`)
- `src/ffi/bindings.lisp` — new `%`-prefixed CFFI defcfun forms
- `src/core/` — new files `texture.lisp` and `materials.lisp` (or add to existing `viewer-object-props.lisp`)
- `src/package.lisp` — new exports in both `cl-occt.impl` and `cl-occt` packages
- `docs/api-reference.md` — new sections for texture, PBR, BSDF
- Build: `just wrap` must recompile `lib/libocctwrap.so`

## 1. C Wrapper — Image (Image_AlienPixMap)

- [x] 1.1 Add `#include <Image_AlienPixMap.hxx>` to `wrap/occt_wrap.cpp`
- [x] 1.2 Implement `image_from_file` — create occ::handle<Image_AlienPixMap>, call Load(filename), return occt_image
- [x] 1.3 Implement `free_image` — delete the handle
- [x] 1.4 Implement `image_save` — call Save(filename) on the pixmap, return 1/0
- [x] 1.5 Implement `image_width` and `image_height` — return Width()/Height() pixel counts
- [x] 1.6 Declare all image functions in `wrap/occt_wrap.h` with `typedef void* occt_image`

## 2. C Wrapper — Texture 2D & Texture Params

- [x] 2.1 Add `#include <Graphic3d_Texture2D.hxx>`, `<Graphic3d_TextureParams.hxx>` to `wrap/occt_wrap.cpp`
- [x] 2.2 Implement `texture_2d_from_file` — create occ::handle<Graphic3d_Texture2D> from filename, return occt_texture
- [x] 2.3 Implement `texture_2d_from_image` — create occ::handle<Graphic3d_Texture2D> from occt_image (Image_PixMap)
- [x] 2.4 Implement `free_texture` — delete the handle
- [x] 2.5 Implement `texture_params_create` and `free_texture_params`
- [x] 2.6 Implement `texture_params_set_filter`, `_set_repeat`, `_set_aniso`
- [x] 2.7 Implement `texture_get_params` — return texture's internal params handle (no SetParams in OCCT 8.0)
- [x] 2.8 Declare all texture/params functions in `wrap/occt_wrap.h` with `typedef void* occt_texture` and `typedef void* occt_tex_params`

## 3. C Wrapper — Texture 2D Plane

- [x] 3.1 Add `#include <Graphic3d_Texture2Dplane.hxx>` to `wrap/occt_wrap.cpp` (removed — header moved to top of file)
- [x] 3.2 Implement `texture_2dplane_from_file` — create occ::handle<Graphic3d_Texture2Dplane> from filename
- [x] 3.3 Implement `texture_2dplane_set_repeat` — stub (no SetUVRepeat in OCCT 8.0)
- [x] 3.4 Implement `texture_2dplane_set_origin` — call SetTranslateS/SetTranslateT
- [x] 3.5 Implement `texture_2dplane_set_scale` — call SetScaleS/SetScaleT
- [x] 3.6 Implement `texture_2dplane_set_rotation` — call SetRotation(float) (angle in degrees)
- [x] 3.7 Declare all plane functions in `wrap/occt_wrap.h`

## 4. C Wrapper — PBR Material

- [x] 4.1 Add `#include <Graphic3d_PBRMaterial.hxx>` to `wrap/occt_wrap.cpp`
- [x] 4.2 Implement `pbr_material_create` — heap-allocate Graphic3d_PBRMaterial, return occt_pbr_material
- [x] 4.3 Implement `free_pbr_material` — delete the heap allocation
- [x] 4.4 Implement `pbr_material_set_albedo` — set Color with Quantity_Color(r,g,b, sRGB)
- [x] 4.5 Implement `pbr_material_set_metallic` — set Metallic(float)
- [x] 4.6 Implement `pbr_material_set_roughness` — set Roughness(float)
- [x] 4.7 Implement `pbr_material_set_emissive` — set Emission(NCollection_Vec3)
- [x] 4.8 Implement `pbr_material_set_refraction_index` — set IOR(float)
- [x] 4.9 Implement `pbr_material_set_transparency` — set Alpha(1.0 - v)
- [x] 4.10 Texture setters: Not available on Graphic3d_PBRMaterial in OCCT 8.0 — omitted
- [x] 4.11 `ais_context_set_pbr_material`: No SetMaterial(Graphic3d_PBRMaterial) on AIS in OCCT 8.0 — omitted
- [x] 4.12 Declare all PBR functions in `wrap/occt_wrap.h` with `typedef void* occt_pbr_material`

## 5. C Wrapper — BSDF

- [x] 5.1 Add `#include <Graphic3d_BSDF.hxx>` to `wrap/occt_wrap.cpp`
- [x] 5.2 Implement `bsdf_create` — heap-allocate Graphic3d_BSDF, return occt_bsdf
- [x] 5.3 Implement `free_bsdf` — delete the heap allocation
- [x] 5.4 Implement `bsdf_set_ambient`, `_set_diffuse`, `_set_specular` — set Kd/Ks fields (NCollection_Vec3/Vec4)
- [x] 5.5 Implement `bsdf_set_transmission`, `_set_reflection` — set Kt/Kc fields
- [x] 5.6 Implement `bsdf_set_refraction_index` — set FresnelBase to dielectric Fresnel
- [x] 5.7 Implement `bsdf_set_absorption` — set Absorption(NCollection_Vec4)
- [x] 5.8 `ais_context_set_bsdf_material`: No SetMaterial(Graphic3d_BSDF) on AIS in OCCT 8.0 — omitted
- [x] 5.9 Declare all BSDF functions in `wrap/occt_wrap.h` with `typedef void* occt_bsdf`

## 6. CFFI Bindings

- [x] 6.1 Add `%image-from-file`, `%free-image`, `%image-save`, `%image-width`, `%image-height` to `src/ffi/bindings.lisp`
- [x] 6.2 Add `%texture-2d-from-file`, `%texture-2d-from-image`, `%free-texture`, `%texture-get-params` to `src/ffi/bindings.lisp`
- [x] 6.3 Add `%texture-2dplane-from-file`, `%texture-2dplane-set-repeat`, `%texture-2dplane-set-origin`, `%texture-2dplane-set-scale`, `%texture-2dplane-set-rotation` to `src/ffi/bindings.lisp`
- [x] 6.4 Add `%make-texture-params`, `%free-texture-params`, `%texture-params-set-filter`, `%texture-params-set-repeat`, `%texture-params-set-aniso` to `src/ffi/bindings.lisp`
- [x] 6.5 Add `%make-pbr-material`, `%free-pbr-material`, `%pbr-material-set-albedo`, `%pbr-material-set-metallic`, `%pbr-material-set-roughness`, `%pbr-material-set-emissive`, `%pbr-material-set-refraction-index`, `%pbr-material-set-transparency` to `src/ffi/bindings.lisp`
- [x] 6.6 PBR apply: removed (OCCT 8.0 doesn't support SetMaterial(Graphic3d_PBRMaterial) on AIS)
- [x] 6.7 Add `%make-bsdf`, `%free-bsdf`, `%bsdf-set-ambient`, `%bsdf-set-diffuse`, `%bsdf-set-specular`, `%bsdf-set-transmission`, `%bsdf-set-reflection`, `%bsdf-set-refraction-index`, `%bsdf-set-absorption` to `src/ffi/bindings.lisp`
- [x] 6.8 BSDF apply: removed (OCCT 8.0 doesn't support SetMaterial(Graphic3d_BSDF) on AIS)

## 7. CLOS Core Wrappers — Texture Layer

- [x] 7.1 Create `src/core/texture.lisp` with `image` CLOS class (handle slot, tg:finalize)
- [x] 7.2 Implement `image-from-file`, `image-save`, `image-width`, `image-height` public API functions
- [x] 7.3 Create `texture-2d` CLOS class with handle slot
- [x] 7.4 Implement `texture-2d-from-file`, `texture-2d-from-image`, `texture-2d-p` public API
- [x] 7.5 Create `texture-2dplane` CLOS class inheriting from `texture-2d`
- [x] 7.6 Implement `texture-2dplane-from-file`, `texture-2dplane-p`, `set-texture-plane-repeat`, `set-texture-plane-origin`, `set-texture-plane-scale`, `set-texture-plane-rotation`
- [x] 7.7 Create `texture-params` CLOS class with handle slot
- [x] 7.8 Implement `make-texture-params`, `texture-params-p`, `set-texture-params-filter`, `set-texture-params-repeat`, `set-texture-params-aniso`, `texture-params` (reader)
- [x] 7.9 Implement `texture-params` reader on `texture-2d` for accessing texture's internal params

## 8. CLOS Core Wrappers — Material Layer

- [x] 8.1 Create `src/core/materials.lisp` with `pbr-material` CLOS class
- [x] 8.2 Implement `make-pbr-material`, `pbr-material-p`, and setter functions (albedo, metallic, roughness, emissive, ior, transparency)
- [x] 8.3 PBR apply: omitted (OCCT 8.0 doesn't support SetMaterial(Graphic3d_PBRMaterial) on AIS)
- [x] 8.4 Create `bsdf` CLOS class
- [x] 8.5 Implement `make-bsdf`, `bsdf-p`, and setter functions (ambient, diffuse, specular, transmission, reflection, refraction-index, absorption)
- [x] 8.6 BSDF apply: omitted (OCCT 8.0 doesn't support SetMaterial(Graphic3d_BSDF) on AIS)

## 9. Package Exports

- [x] 9.1 Export all %-prefixed CFFI bindings from `cl-occt.impl`
- [x] 9.2 Export all public API functions from `cl-occt`

## 10. Build & Verify

- [x] 10.1 Run `just wrap` to rebuild `lib/libocctwrap.so` — compiles clean
- [x] 10.2 Start REPL with `just start` and verify system loads without errors
- [x] 10.3 Run `just test-core` — 465 pass, 0 fail, no regressions

## 11. Documentation

- [x] 11.1 Add Image, Texture 2D, Texture Plane, Texture Params, PBR Material, BSDF Material sections to `docs/api-reference.md` with function tables and examples

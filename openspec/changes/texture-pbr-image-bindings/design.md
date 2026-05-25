## Context

cl-occt currently has basic material support via `Graphic3d_MaterialAspect` (legacy material preset system) and `AIS_TexturedShape` (file-path-based texture). There is no way to:

- Load images as reusable pixel maps (`Image_AlienPixMap`)
- Create `Graphic3d_Texture2D` objects from loaded images or files
- Configure texture filtering, wrap modes, or anisotropy (`Graphic3d_TextureParams`)
- Use planar texture mapping with UV repeat/origin/rotation (`Graphic3d_Texture2Dplane`)
- Set modern PBR material properties (`Graphic3d_PBRMaterial`)
- Set BSDF material properties (`Graphic3d_BSDF`)

The three-tier architecture (C wrapper → CFFI → CLOS) is well-established in the codebase. All new bindings will follow this same pattern.

## Goals / Non-Goals

**Goals:**
- Expose Image_AlienPixMap for loading/saving image pixel maps from disk
- Expose Graphic3d_Texture2D for 2D textures from files or pixel maps
- Expose Graphic3d_Texture2Dplane for planar texture mapping
- Expose Graphic3d_TextureParams for texture filter/wrap/anisotropy control
- Expose Graphic3d_PBRMaterial as a value type settable on AIS objects
- Expose Graphic3d_BSDF as a value type settable on AIS objects
- Provide CLOS wrappers with tg:finalize GC for all handle types
- Update api-reference.md with new function tables

**Non-Goals:**
- Image manipulation (resize, crop, format conversion) — only load/save/query
- Procedural texture generation
- Cube-map textures (already have Graphic3d_CubeMapSeparate wrapper)
- Ray-tracing-specific or advanced rendering features beyond PBR/BSDF material assignment
- Texture editing or GPU-side manipulation

## Decisions

### 1. Value types vs handle types for PBRMaterial and BSDF

`Graphic3d_PBRMaterial` and `Graphic3d_BSDF` are C++ value types (stack-allocated structs with no `Handle()`), unlike `Graphic3d_Texture2D` which is a `Handle()` managed object.

**Decision:** Wrap PBRMaterial and BSDF as C heap-allocated pointers in the C layer. The C functions will allocate, mutate fields, and free. The final `apply` call copies the value onto the AIS object. The CLOS wrapper gains `tg:finalize` for automatic cleanup.

**Rationale:** Matching the pattern used by existing material wrappers (e.g., `make_material` allocates, `ais_set_custom_material` copies onto the AIS object then the caller frees the source). The value-type semantics mean calling `pbr-material-apply` / `bsdf-apply` copies the data — the CLOS wrapper can be freed immediately after, or kept for reuse.

### 2. Texture param handling

`Graphic3d_TextureParams` is a `Handle()` object attached to a `Graphic3d_Texture2D`.

**Decision:** Expose as a separate CLOS class `texture-params` that wraps `Handle(Graphic3d_TextureParams)`. Provide a setter `(setf texture-params)` on texture objects. The texture owns its params — freeing the texture frees the params.

**Rationale:** Params can be shared across textures (same handle). Keeping a separate class allows independent creation and configuration.

### 3. Image loading vs texture loading

`Image_AlienPixMap` loads any OCCT-supported image format (PNG, JPEG, BMP, TGA, etc.) into a pixel buffer. `Graphic3d_Texture2D` can be constructed from a filename or from an `Image_PixMap`.

**Decision:** Provide both paths:
- `image-from-file` → creates an `Image_AlienPixMap` for inspection/saving
- `texture-2d-from-file` → creates `Graphic3d_Texture2D` directly from filename (internal image loading)
- `texture-2d-from-image` → creates `Graphic3d_Texture2D` from an already-loaded `image` object

**Rationale:** The direct-from-file path is the common case (just load and map), but exposing Image_AlienPixMap enables image dimension queries, saving processed images (e.g., render-to-texture), and batch texture loading.

### 4. File layout in src/core/

**Decision:** Add two new files:
- `src/core/texture.lisp` — image, texture-2d, texture-2dplane, texture-params classes and functions
- `src/core/materials.lisp` — pbr-material, bsdf-material classes and functions

**Rationale:** Grouping by concern — all texture/image types in one file, all material types in another. Avoids bloat in existing `viewer-object-props.lisp`.

### 5. `AIS_TexturedShape` existing wrapper

The existing `ais_create_textured_shape` loads a texture internally. We will NOT modify it. The new texture bindings allow constructing textures separately and applying them via `ais-object` methods.

## C API Surface

### Image (Image_AlienPixMap)

```c
typedef void* occt_image;
occt_image image_from_file(const char* filename);
void       free_image(occt_image img);
int        image_save(occt_image img, const char* filename);
int        image_width(occt_image img);
int        image_height(occt_image img);
```

### Texture 2D & Texture 2D Plane

```c
typedef void* occt_texture;
occt_texture texture_2d_from_file(const char* filename);
occt_texture texture_2d_from_image(occt_image img);
void         free_texture(occt_texture tex);
void         texture_set_params(occt_texture tex, void* params);

occt_texture texture_2dplane_from_file(const char* filename);
void         texture_2dplane_set_repeat(void* tex, int uRepeat, int vRepeat);
void         texture_2dplane_set_origin(void* tex, double u, double v);
void         texture_2dplane_set_scale(void* tex, double u, double v);
void         texture_2dplane_set_rotation(void* tex, double angle_deg);
```

### Texture Params

```c
typedef void* occt_tex_params;
occt_tex_params texture_params_create(void);
void            free_texture_params(occt_tex_params params);
void            texture_params_set_filter(void* params, int filter);
void            texture_params_set_wrap_s(void* params, int mode);
void            texture_params_set_wrap_t(void* params, int mode);
void            texture_params_set_aniso(void* params, int level);
```

Where filter: 0=NEAREST, 1=BILINEAR, 2=TRILINEAR. Wrap modes: 0=CLAMP, 1=REPEAT, 2=MIRROR.

### PBR Material

```c
typedef void* occt_pbr_material;
occt_pbr_material pbr_material_create(void);
void              free_pbr_material(occt_pbr_material mat);
void              pbr_material_set_albedo(void* mat, double r, double g, double b);
void              pbr_material_set_metallic(void* mat, double v);
void              pbr_material_set_roughness(void* mat, double v);
void              pbr_material_set_emissive(void* mat, double r, double g, double b, double intensity);
void              pbr_material_set_refraction_index(void* mat, double v);
void              pbr_material_set_transparency(void* mat, double v);
void              pbr_material_set_normal_tex(void* mat, void* tex);
void              pbr_material_set_base_color_tex(void* mat, void* tex);
void              pbr_material_set_orm_tex(void* mat, void* tex);
void              pbr_material_set_metallic_roughness_tex(void* mat, void* tex);
void              pbr_material_set_occlusion_tex(void* mat, void* tex);
void              pbr_material_set_emissive_tex(void* mat, void* tex);
void              ais_context_set_pbr_material(void* ctx, void* obj, void* mat);
```

### BSDF

```c
typedef void* occt_bsdf;
occt_bsdf bsdf_create(void);
void      free_bsdf(occt_bsdf bsdf);
void      bsdf_set_ambient(void* bsdf, double r, double g, double b);
void      bsdf_set_diffuse(void* bsdf, double r, double g, double b);
void      bsdf_set_specular(void* bsdf, double r, double g, double b);
void      bsdf_set_transmission(void* bsdf, double r, double g, double b);
void      bsdf_set_reflection(void* bsdf, double r, double g, double b);
void      bsdf_set_refraction_index(void* bsdf, double v);
void      bsdf_set_absorption(void* bsdf, double r, double g, double b, double coeff);
void      ais_context_set_bsdf_material(void* ctx, void* obj, void* bsdf);
```

## CLOS Class Hierarchy

```
image           → wraps Handle(Image_AlienPixMap), tg:finalized-class
texture-2d      → wraps Handle(Graphic3d_Texture2D), tg:finalized-class
texture-2dplane → wraps Handle(Graphic3d_Texture2Dplane) (subclass of texture-2d), tg:finalized-class
texture-params  → wraps Handle(Graphic3d_TextureParams), tg:finalized-class
pbr-material    → wraps occt_pbr_material* (heap-allocated value), tg:finalized-class
bsdf-material   → wraps occt_bsdf* (heap-allocated value), tg:finalized-class
```

`texture-2dplane` inherits from `texture-2d` — CFFI functions for textures work on both; plane-specific setters require a plane object (dynamic type check at C level or Lisp level).

## Risks / Trade-offs

- **Risk: PBRMaterial/BSDF are value types in OCCT** → Mitigation: heap-allocate in C wrapper, copy on apply. The CLOS wrapper can be freed after apply if no reuse needed.
- **Risk: OCCT 8.0 PBRMaterial API differs from 7.x** → Mitigation: target OCCT 8.0 (project's base). Verify field names compile-clean.
- **Risk: Texture params shared mutable state** → Mitigation: document that textures own their params; avoid sharing a params object across textures unless intentional.
- **Trade-off: Not wrapping every field of PBRMaterial (e.g., clear coat, sheen)** → These are less common; users can request additions. Core fields (albedo, metalness, roughness, emissive, normal/basecolor/orm textures, IOR) cover >95% of use cases.

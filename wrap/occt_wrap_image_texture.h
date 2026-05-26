#ifndef OCCT_WRAP_IMAGE_TEXTURE_H
#define OCCT_WRAP_IMAGE_TEXTURE_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Image / AlienPixMap ---

occt_image image_from_file(const char* filename);
void       free_image(occt_image img);
int        image_save(occt_image img, const char* filename);
int        image_width(occt_image img);
int        image_height(occt_image img);

// --- Texture 2D / Texture Params ---

occt_texture  texture_2d_from_file(const char* filename);
occt_texture  texture_2d_from_image(occt_image img);
void          free_texture(occt_texture tex);
occt_tex_params texture_get_params(occt_texture tex);

occt_tex_params texture_params_create(void);
void            free_texture_params(occt_tex_params params);
void            texture_params_set_filter(void* params, int filter);
void            texture_params_set_repeat(void* params, int on);
void            texture_params_set_aniso(void* params, int level);

// --- Texture 2D Plane ---

occt_texture texture_2dplane_from_file(const char* filename);
void         texture_2dplane_set_repeat(void* tex, int uRepeat, int vRepeat);
void         texture_2dplane_set_origin(void* tex, double u, double v);
void         texture_2dplane_set_scale(void* tex, double u, double v);
void         texture_2dplane_set_rotation(void* tex, double angle_deg);

// --- PBR Material ---

occt_pbr_material pbr_material_create(void);
void              free_pbr_material(occt_pbr_material mat);
void              pbr_material_set_albedo(void* mat, double r, double g, double b);
void              pbr_material_set_metallic(void* mat, double v);
void              pbr_material_set_roughness(void* mat, double v);
void              pbr_material_set_emissive(void* mat, double r, double g, double b);
void              pbr_material_set_refraction_index(void* mat, double v);
void              pbr_material_set_transparency(void* mat, double v);
void              pbr_material_set_emissive(void* mat, double r, double g, double b);

// --- BSDF ---

occt_bsdf bsdf_create(void);
void      free_bsdf(occt_bsdf bsdf);
void      bsdf_set_ambient(void* bsdf, double r, double g, double b);
void      bsdf_set_diffuse(void* bsdf, double r, double g, double b);
void      bsdf_set_specular(void* bsdf, double r, double g, double b);
void      bsdf_set_transmission(void* bsdf, double r, double g, double b);
void      bsdf_set_reflection(void* bsdf, double r, double g, double b);
void      bsdf_set_refraction_index(void* bsdf, double v);
void      bsdf_set_absorption(void* bsdf, double r, double g, double b, double coeff);

#ifdef __cplusplus
}
#endif

#endif

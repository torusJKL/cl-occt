#ifndef OCCT_WRAP_TYPES_H
#define OCCT_WRAP_TYPES_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* occt_shape;
typedef void* occt_shape_ptr;
typedef void* occt_geom2d;
typedef void* occt_brep_font;

typedef void* xde_doc;

typedef void* occt_curve;

typedef void* occt_surface;

typedef void* occt_image;

typedef void* occt_texture;
typedef void* occt_tex_params;

typedef void* occt_pbr_material;

typedef void* occt_bsdf;

typedef void* occt_ais_animation;

void free_shape(occt_shape shape);

int get_error_code(void);
const char* get_error_message(void);

#ifdef __cplusplus
}
#endif

#endif

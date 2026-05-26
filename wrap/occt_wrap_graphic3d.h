#ifndef OCCT_WRAP_GRAPHIC3D_H
#define OCCT_WRAP_GRAPHIC3D_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Graphic3d_ClipPlane ---

void* graphic3d_clip_plane_new(double a, double b, double c, double d);
void  graphic3d_clip_plane_free(void* p);
void  graphic3d_clip_plane_set_equation(void* p, double a, double b, double c, double d);
void  graphic3d_clip_plane_get_equation(void* p, double* a, double* b, double* c, double* d);
void  graphic3d_clip_plane_set_on(void* p, int on);
int   graphic3d_clip_plane_is_on(void* p);
void  graphic3d_clip_plane_set_capping(void* p, int on);
void  graphic3d_clip_plane_set_cap_color(void* p, double r, double g, double b);

// --- Graphic3d_ShaderProgram ---

void* graphic3d_shader_program_new(void);
void  graphic3d_shader_program_free(void* p);
void  graphic3d_shader_program_set_vertex_source(void* p, const char* src);
void  graphic3d_shader_program_set_fragment_source(void* p, const char* src);
void  graphic3d_shader_program_set_header(void* p, const char* hdr);

// --- Graphic3d_AspectFillArea3d ---

void* graphic3d_aspect_fill_area_new(int interior, double r, double g, double b,
                                      double er, double eg, double eb,
                                      int edge_line_type, double edge_width);
void  graphic3d_aspect_fill_area_free(void* a);
void  graphic3d_aspect_fill_area_set_interior_color(void* a, double r, double g, double b);
void  graphic3d_aspect_fill_area_get_interior_color(void* a, double* r, double* g, double* b);
void  graphic3d_aspect_fill_area_set_edge_color(void* a, double r, double g, double b);
void  graphic3d_aspect_fill_area_get_edge_color(void* a, double* r, double* g, double* b);
int   graphic3d_aspect_fill_area_get_interior_style(void* a);

// --- Graphic3d_AspectLine3d ---

void* graphic3d_aspect_line_new(double r, double g, double b, int line_type, double width);
void  graphic3d_aspect_line_free(void* a);
void  graphic3d_aspect_line_set_color(void* a, double r, double g, double b);
void  graphic3d_aspect_line_get_color(void* a, double* r, double* g, double* b);
int   graphic3d_aspect_line_get_type(void* a);
double graphic3d_aspect_line_get_width(void* a);

// --- Graphic3d_AspectMarker3d ---

void* graphic3d_aspect_marker_new(int marker_type, double r, double g, double b, double scale);
void  graphic3d_aspect_marker_free(void* a);
void  graphic3d_aspect_marker_set_color(void* a, double r, double g, double b);
void  graphic3d_aspect_marker_get_color(void* a, double* r, double* g, double* b);
int   graphic3d_aspect_marker_get_type(void* a);
double graphic3d_aspect_marker_get_scale(void* a);

// --- Graphic3d_AspectText3d ---

void* graphic3d_aspect_text_new(double r, double g, double b, const char* font, int style);
void  graphic3d_aspect_text_free(void* a);
void  graphic3d_aspect_text_set_color(void* a, double r, double g, double b);
void  graphic3d_aspect_text_get_color(void* a, double* r, double* g, double* b);
const char* graphic3d_aspect_text_get_font(void* a);
int   graphic3d_aspect_text_get_style(void* a);

// --- Graphic3d_Structure ---

void* graphic3d_structure_new(void* driver_ptr);
void  graphic3d_structure_free(void* s);
void  graphic3d_structure_set_visible(void* s, int visible);
void  graphic3d_structure_set_transform(void* s, double* mat16);
void  graphic3d_structure_remove_transform(void* s);
void  graphic3d_structure_add_child(void* parent, void* child);
void  graphic3d_structure_remove_child(void* parent, void* child);
void  graphic3d_structure_display(void* s);
void  graphic3d_structure_erase(void* s);

// --- Graphic3d_Group ---

void* graphic3d_group_new(void* struct_ptr);
void  graphic3d_group_free(void* g);
void  graphic3d_group_set_visible(void* g, int visible);
void  graphic3d_group_add_triangles(void* g, float* verts, const float* norms, int count);
void  graphic3d_group_add_lines(void* g, float* verts, int count);
void  graphic3d_group_add_points(void* g, float* verts, int count);
void  graphic3d_group_add_text(void* g, const char* text, double x, double y, double z);
void  graphic3d_group_set_aspect(void* g, void* aspect);
void  graphic3d_group_set_line_aspect(void* g, void* aspect);

// --- Graphic3d_RenderingParams ---

void* graphic3d_view_rendering_params(void* view_ptr);
void  graphic3d_rendering_params_set_method(void* p, int method);
int   graphic3d_rendering_params_get_method(void* p);
void  graphic3d_rendering_params_set_raytracing_depth(void* p, int depth);
int   graphic3d_rendering_params_get_raytracing_depth(void* p);
void  graphic3d_rendering_params_set_shadows(void* p, int on);
int   graphic3d_rendering_params_get_shadows(void* p);
void  graphic3d_rendering_params_set_reflections(void* p, int on);
int   graphic3d_rendering_params_get_reflections(void* p);
void  graphic3d_rendering_params_set_antialiasing(void* p, int on);
int   graphic3d_rendering_params_get_antialiasing(void* p);

#ifdef __cplusplus
}
#endif

#endif

#ifndef OCCT_WRAP_AIS_TYPES_H
#define OCCT_WRAP_AIS_TYPES_H

#ifdef __cplusplus
extern "C" {
#endif

void* ais_create_trihedron(double ox, double oy, double oz,
                           double dx, double dy, double dz,
                           double ux, double uy, double uz);
void  ais_trihedron_set_datum_mode(void* obj, int mode);
void  ais_trihedron_set_draw_arrows(void* obj, int on);
void  ais_trihedron_set_size(void* obj, double size);
void  ais_trihedron_set_transform_pers(void* obj, int corner, int xOff, int yOff);
int   ais_trihedron_set_datum_part_color(void* obj, int part, double r, double g, double b);
void  ais_trihedron_set_text_color(void* obj, double r, double g, double b);
void  ais_trihedron_set_wireframe_color(void* obj, double r, double g, double b);

// --- AIS Interactive Types ---

void* ais_create_colored_shape(occt_shape shape);
int   ais_colored_shape_set_color(void* obj, occt_shape sub, double r, double g, double b);

void* ais_create_manipulator(void);
void  ais_manipulator_attach(void* obj, void* ais_obj);
void  ais_manipulator_set_position(void* obj, double x, double y, double z);
void  ais_manipulator_set_size(void* obj, double size);
void  ais_manipulator_set_active_axes(void* obj, int translate, int rotate, int scale);

void* ais_create_connected(void* src);
void* ais_create_multiple_connected(void);
void  ais_multiple_connected_connect(void* obj, void* src);

void* ais_create_point_cloud(double* verts, int count);
void  ais_point_cloud_set_colors(void* obj, double* colors, int count);
void  ais_point_cloud_set_size(void* obj, double size);

void* ais_create_triangulation(double* verts, int vcount, int* tris, int tcount, double* colors);

void* ais_create_plane(double ox, double oy, double oz, double nx, double ny, double nz, double size);
void* ais_create_axis(double ox, double oy, double oz, double dx, double dy, double dz);
void* ais_create_line(double x1, double y1, double z1, double x2, double y2, double z2);
void* ais_create_circle(double cx, double cy, double cz, double nx, double ny, double nz, double radius);

void* ais_create_textured_shape(occt_shape shape, const char* filename);
void  ais_textured_shape_set_repeat(void* obj, double u, double v);
void  ais_textured_shape_set_origin(void* obj, double u, double v);

void* ais_create_view_cube(void);
void  ais_view_cube_set_size(void* obj, double size);
void  ais_view_cube_set_box_color(void* obj, double r, double g, double b);
void  ais_view_cube_set_corner(void* obj, int corner);

void* ais_create_color_scale(void);
void  ais_color_scale_set_range(void* obj, double min, double max);
void  ais_color_scale_set_size(void* obj, double w, double h);
void  ais_color_scale_set_title(void* obj, const char* title);
void  ais_color_scale_set_intervals(void* obj, int n);

void* ais_create_light_source(void* light);

// --- Custom Material ---

void* make_material(double ar, double ag, double ab, double dr, double dg, double db,
                     double sr, double sg, double sb, double shininess, double transparency);
void  ais_set_custom_material(void* ctx, void* obj, void* mat);

// --- Per-Object Properties ---

void ais_set_transparency(void* ctx, void* obj, double v);
int  ais_set_material_by_name(void* ctx, void* obj, const char* name);
int  ais_material_preset_count(void);
const char* ais_material_preset_name(int index);
void ais_set_line_width(void* ctx, void* obj, double w);
void ais_set_edges_display(void* obj, int on);
void ais_set_edge_color(void* obj, double r, double g, double b);
void ais_set_selection_mode(void* ctx, void* obj, int mode);
void ais_deactivate_selection(void* ctx, void* obj);
void ais_set_tessellation(void* obj, double deflection, double deviation);

// --- Drawer (Prs3d) ---

void* ais_object_attributes(void* obj);
void ais_object_set_point_color(void* obj, double r, double g, double b);
void ais_object_set_point_type(void* obj, int type);
void ais_object_set_point_scale(void* obj, double scale);
void ais_object_set_text_color(void* obj, double r, double g, double b);
void ais_object_set_text_font(void* obj, const char* font);
void ais_object_set_text_height(void* obj, double h);
void ais_object_set_iso_display(void* obj, int uOn, int vOn);
void ais_object_set_wire_color(void* obj, double r, double g, double b);
void* drawer_shading_aspect(void* drawer);
void* drawer_line_aspect(void* drawer);
void  line_aspect_set_color(void* aspect, double r, double g, double b);
void  line_aspect_set_width(void* aspect, double w);
void  line_aspect_set_type(void* aspect, int type);
void  shading_aspect_set_color(void* aspect, double r, double g, double b);
void  shading_aspect_set_material(void* aspect, double ar, double ag, double ab, double dr, double dg, double db, double sr, double sg, double sb, double shininess, double transparency);
void ais_object_set_line_color(void* obj, double r, double g, double b);
void ais_object_set_line_width(void* obj, double w);
void ais_object_set_line_type(void* obj, int type);
void ais_object_set_shading_color(void* obj, double r, double g, double b);
void ais_object_set_face_boundary_draw(void* obj, int on);
void ais_object_set_free_boundary_draw(void* obj, int on);

#ifdef __cplusplus
}
#endif

#endif

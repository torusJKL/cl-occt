#ifndef OCCT_WRAP_H
#define OCCT_WRAP_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* occt_shape;
typedef void* occt_shape_ptr;
typedef void* occt_geom2d;
typedef void* occt_brep_font;

occt_shape make_box(double dx, double dy, double dz);
occt_shape make_cylinder(double radius, double height);
occt_shape make_sphere(double radius);
occt_shape make_cone(double r1, double r2, double height);
occt_shape make_torus(double major_radius, double minor_radius);
occt_shape make_prism(occt_shape shape, double dx, double dy, double dz);
occt_shape make_revol(occt_shape shape, double ax, double ay, double az, double angle_deg);

occt_shape boolean_cut(occt_shape a, occt_shape b);
occt_shape boolean_fuse(occt_shape a, occt_shape b);
occt_shape boolean_common(occt_shape a, occt_shape b);
occt_shape boolean_section(occt_shape a, occt_shape b);

occt_shape translate(occt_shape shape, double dx, double dy, double dz);
occt_shape rotate(occt_shape shape, double ax, double ay, double az, double angle_deg);

int write_step(occt_shape shape, const char* filename);
occt_shape read_step(const char* filename);

int write_stl(occt_shape shape, const char* filename, double deflection);
occt_shape read_stl(const char* filename);

void free_shape(occt_shape shape);

occt_geom2d make_pnt2d(double x, double y);
occt_geom2d make_vec2d(double x, double y);
occt_geom2d make_dir2d(double x, double y);
void free_geom2d(occt_geom2d g);

occt_geom2d make_line_2d(double x, double y, double dx, double dy);
occt_geom2d make_circle_2d(double x, double y, double radius);

occt_shape make_edge_line_2d(double x1, double y1, double x2, double y2);
occt_shape make_edge_line_3d(double x1, double y1, double z1, double x2, double y2, double z2);
occt_shape make_edge_circle_2d(double x, double y, double radius);
occt_shape make_edge_arc_2d(double x1, double y1, double x2, double y2, double x3, double y3);

occt_shape make_compound(occt_shape* shapes, int count);
occt_shape add_to_compound(occt_shape compound_shape, occt_shape shape);
int compound_is_empty(occt_shape shape);
int shape_is_compound(occt_shape shape);

occt_shape make_wire(occt_shape* edges, int count);
occt_shape make_face(occt_shape wire);
occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz);

int get_error_code(void);
const char* get_error_message(void);

// --- XDE Document Lifecycle ---
typedef void* xde_doc;

xde_doc xde_new_doc(void);
void   xde_free_doc(xde_doc doc);
xde_doc xde_read_step(const char* filename);
int    xde_write_step(xde_doc doc, const char* filename);

// --- Label Navigation ---
int  xde_get_root_count(xde_doc doc);
void xde_get_root_path(xde_doc doc, int index, char* buf, int buf_size);
int  xde_get_child_count(xde_doc doc, const char* path);
void xde_get_child_path(xde_doc doc, const char* parent_path, int index, char* buf, int buf_size);

// --- Attribute Read ---
occt_shape xde_get_shape_at(xde_doc doc, const char* path);
void       xde_get_name_at(xde_doc doc, const char* path, char* buf, int buf_size);
int        xde_get_color_at(xde_doc doc, const char* path, int* type, double* r, double* g, double* b, double* a);
int        xde_get_location_at(xde_doc doc, const char* path, double* matrix);

// --- Attribute Write (composite — creates label, sets all properties, returns child path) ---
void xde_add_part(xde_doc doc, const char* parent_path, occt_shape shape,
                  const char* name, int color_type, double r, double g, double b, double a,
                  const double* matrix, char* buf, int buf_size);

// --- Visualization (Graphic Driver, Viewer, View, Window) ---
void* create_graphic_driver(void);
void  free_graphic_driver(void* driver);
void* v3d_create_viewer(void* driver);
void  v3d_free_viewer(void* viewer);
void* v3d_create_view(void* viewer);
void  v3d_free_view(void* view);
void  v3d_fit_all(void* view);
void  v3d_view_must_be_resized(void* view);
void* create_neutral_window(void* native_handle);
  void  free_neutral_window(void* window);

// --- AIS Visualization (Display Objects) ---
void* ais_create_context(void* viewer);
void  ais_free_context(void*);
void* ais_create_shape(void* shape);
void  ais_free_shape(void*);
void  ais_context_display(void* ctx, void* obj, int update);
void  ais_context_erase(void* ctx, void* obj, int update);
void  ais_context_remove(void* ctx, void* obj, int update);
void  ais_context_remove_all(void* ctx, int update);
int   ais_context_is_displayed(void* ctx, void* obj);

// --- Visualization — Styling, Camera, MSAA, Grid ---
void v3d_view_set_bg_color(void* view, double r, double g, double b);
void ais_context_set_color(void* ctx, void* obj, double r, double g, double b);
void ais_context_unset_color(void* ctx, void* obj);
void ais_context_set_display_mode(void* ctx, void* obj, int mode);
void v3d_view_set_proj(void* view, int orientation);
void v3d_view_set_eye(void* view, double x, double y, double z);
double v3d_view_get_eye_x(void* view);
double v3d_view_get_eye_y(void* view);
double v3d_view_get_eye_z(void* view);
void v3d_view_set_target(void* view, double x, double y, double z);
double v3d_view_get_target_x(void* view);
double v3d_view_get_target_y(void* view);
double v3d_view_get_target_z(void* view);
void v3d_view_set_up(void* view, double x, double y, double z);
double v3d_view_get_up_x(void* view);
double v3d_view_get_up_y(void* view);
double v3d_view_get_up_z(void* view);
void v3d_view_set_projection_type(void* view, int is_perspective);
int  v3d_view_get_projection_type(void* view);
void v3d_view_set_fov(void* view, double fov_rad);
double v3d_view_get_fov(void* view);
void v3d_view_set_clip_planes(void* view, double near, double far);
void v3d_view_fit_all_shape(void* view, void* shape);
void v3d_view_pan(void* view, double dx, double dy);
void v3d_view_zoom(void* view, double factor);
void v3d_view_rotate(void* view, double ax, double ay, double az);
void v3d_view_reset(void* view);
void v3d_view_set_msaa(void* view, int samples);
int  v3d_view_get_msaa(void* view);
void v3d_view_set_antialiasing(void* view, int on);
int  v3d_view_get_antialiasing(void* view);
void v3d_viewer_activate_grid(void* viewer, int gridType, int drawMode);
void v3d_viewer_deactivate_grid(void* viewer);
void v3d_view_invalidate(void* view);

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

// --- Lighting ---
void* make_light_ambient(double r, double g, double b, double intensity);
void* make_light_directional(double r, double g, double b, double intensity, double dx, double dy, double dz);
void* make_light_positional(double r, double g, double b, double intensity, double x, double y, double z);
void* make_light_spot(double r, double g, double b, double intensity, double x, double y, double z, double dx, double dy, double dz, double angle, double concentration);
void  light_free(void* light);
void  v3d_viewer_add_light(void* viewer, void* light);
void  v3d_viewer_remove_light(void* viewer, void* light);
void  v3d_viewer_light_on(void* viewer, void* light);
void  v3d_viewer_light_off(void* viewer, void* light);
int   light_is_on(void* light);
void  light_set_color(void* light, double r, double g, double b);
void  light_set_intensity(void* light, double v);
void  light_set_direction(void* light, double dx, double dy, double dz);
void  light_set_position(void* light, double x, double y, double z);
void  light_set_angle(void* light, double angle_deg);
void  light_set_concentration(void* light, double v);
void  light_set_headlight(void* light, int on);
void  light_set_shadows(void* light, int on);
void  v3d_viewer_default_lights(void* viewer);

// --- Grid Extensions ---
int  v3d_viewer_grid_active(void* viewer);
void v3d_view_set_grid_echo(void* view, int on);
void v3d_viewer_set_rectangular_grid_values(void* viewer, double xOrigin, double yOrigin, double xStep, double yStep, double rotationAngle);
void v3d_view_grid_display(void* view, double r, double g, double b, double sizeX, double sizeY);

// --- Background ---
void v3d_view_set_bg_gradient(void* view, double r1, double g1, double b1, double r2, double g2, double b2, int style);
void v3d_view_set_bg_image(void* view, const char* path);
void v3d_view_set_bg_cubemap(void* view, void* cubemap);
void v3d_view_reset_background(void* view);
void* make_cubemap_separate(const char** paths, int count);
void  free_cubemap(void* cubemap);

// --- Rendering ---
void v3d_view_set_transparent_shading(void* view, int on);
void v3d_view_get_camera_handle(void* view, void** out_camera);
void v3d_view_set_camera(void* view, void* camera);

void v3d_view_set_transparency_method(void* view, int method);

void v3d_viewer_set_default_bg_gradient(void* viewer, double r1, double g1, double b1, double r2, double g2, double b2, int style);

void* ais_context_default_drawer(void* ctx);
void v3d_view_set_computed_mode(void* view, int on);
int  v3d_view_computed_mode(void* view);
void v3d_view_set_back_face_model(void* view, int mode);
void v3d_view_set_frustum_culling(void* view, int on);
void v3d_view_set_transparent_shading(void* view, int on);
void v3d_view_redraw(void* view);
void v3d_view_set_immediate_update(void* view, int on);

// --- Text Label Enhancements ---
void ais_text_label_set_angle(void* label, double rad);
void ais_text_label_set_hjustification(void* label, int align);
void ais_text_label_set_vjustification(void* label, int align);
void ais_text_label_set_color_sub_title(void* label, double r, double g, double b);
void ais_text_label_set_display_type(void* label, int type);

// --- Viewer Defaults ---
void v3d_viewer_set_default_lights(void* viewer, int on);
void v3d_viewer_set_default_bg_color(void* viewer, double r, double g, double b);
void v3d_viewer_set_default_view_proj(void* viewer, int orientation);
void v3d_viewer_set_default_view_size(void* viewer, double size);
void v3d_viewer_set_default_view_type(void* viewer, int is_perspective);

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

// --- Dimensions ---
void* prsdim_make_length_2p(double x1, double y1, double z1, double x2, double y2, double z2);
void* prsdim_make_angle_3p(double vx, double vy, double vz, double p1x, double p1y, double p1z, double p2x, double p2y, double p2z);
void* prsdim_make_diameter(void* shape);
void* prsdim_make_radius(void* shape);
void  prsdim_set_text_position(void* dim, double x, double y, double z);
void  prsdim_set_display_units(void* dim, const char* units);
void  prsdim_set_flyout(void* dim, double v);
void  prsdim_set_measured_edge(void* dim, void* shape, double px, double py, double pz, double nx, double ny, double nz);
void  prsdim_set_arrow_length(void* dim, double v);
void  prsdim_set_extension_size(void* dim, double v);
void  prsdim_set_custom_value(void* dim, const char* value);
void  prsdim_set_angle_edges(void* dim, void* edge1, void* edge2);

// --- Font & Text ---
occt_brep_font make_brep_font_from_file(const char* font_path, double size, int face_id);
occt_brep_font make_brep_font_from_name(const char* font_name, int font_aspect, double size);
void free_brep_font(occt_brep_font font);
occt_shape make_text_shape(occt_brep_font font, const char* text, int h_align, int v_align);
occt_shape make_text_shape_on_plane(occt_brep_font font, const char* text, int h_align, int v_align,
                                     double px, double py, double pz,
                                     double zx, double zy, double zz);
occt_shape make_text_shape_on_plane_full(occt_brep_font font, const char* text, int h_align, int v_align,
                                          double px, double py, double pz,
                                          double zx, double zy, double zz,
                                          double xx, double xy, double xz);
void text_bounding_box(occt_brep_font font, const char* text,
                       int h_align, int v_align,
                       double* out_width, double* out_height);
const char* enumerate_fonts(void);
const char* query_font_info(const char* font_name);
void* ais_text_label_create(const char* text);
void  ais_text_label_free(void* label);
void  ais_text_label_set_text(void* label, const char* text);
void  ais_text_label_set_position(void* label, double x, double y, double z);
void  ais_text_label_set_color(void* label, double r, double g, double b);
void  ais_text_label_set_font(void* label, const char* font_name, double height);
void  ais_text_label_set_height(void* label, double height);
occt_shape font_render_glyph(occt_brep_font font, unsigned int codepoint);
double font_ascender(occt_brep_font font);
double font_descender(occt_brep_font font);
double font_line_spacing(occt_brep_font font);
double font_advance_x(occt_brep_font font, unsigned int c1, unsigned int c2);
double font_advance_y(occt_brep_font font, unsigned int c1, unsigned int c2);
void font_set_width_scaling(occt_brep_font font, double scale);
void font_set_composite_curve_mode(occt_brep_font font, int on);

#ifdef __cplusplus
}
#endif

#endif

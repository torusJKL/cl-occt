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

int write_stl(occt_shape shape, const char* filename, double deflection, double angle, int relative);
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

// --- IGES I/O ---

int write_iges(occt_shape shape, const char* filename);
occt_shape read_iges(const char* filename);

// --- XDE Document Lifecycle ---
typedef void* xde_doc;

xde_doc xde_new_doc(void);
void   xde_free_doc(xde_doc doc);
xde_doc xde_read_step(const char* filename);
int    xde_write_step(xde_doc doc, const char* filename);

// --- IGES Assembly (XDE) I/O ---

xde_doc xde_read_iges(const char* filename);
int    xde_write_iges(xde_doc doc, const char* filename);

// --- OBJ Mesh I/O ---

int write_obj(occt_shape shape, const char* filename,
              int coordinate_system, int name_format, int per_vertex_colors);
occt_shape read_obj(const char* filename, int coordinate_system);

// --- VRML Export ---

int write_vrml(occt_shape shape, const char* filename, double deflection);

// --- glTF I/O ---

int write_gltf(occt_shape shape, const char* filename,
               int coordinate_system, int per_vertex_colors);
occt_shape read_gltf(const char* filename, int coordinate_system);

// --- PLY Export ---

int write_ply(occt_shape shape, const char* filename,
              int coordinate_system, int per_vertex_colors);

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

// --- Selection (AIS_InteractiveContext) ---

int    ais_context_nb_selected(void* ctx);
void   ais_context_init_selected(void* ctx);
int    ais_context_more_selected(void* ctx);
void   ais_context_next_selected(void* ctx);
void*  ais_context_selected_interactive(void* ctx);
void*  ais_context_selected_shape(void* ctx);
int    ais_context_has_selected_shape(void* ctx);

void   ais_context_set_selected(void* ctx, void* obj, int update);
void   ais_context_add_or_remove_selected(void* ctx, void* obj, int update);
void   ais_context_clear_selected(void* ctx, int update);
int    ais_context_is_selected(void* ctx, void* obj);

int    ais_context_move_to(void* ctx, void* view, int x, int y);
int    ais_context_select_detected(void* ctx, int scheme);
int    ais_context_select_point(void* ctx, void* view, int x, int y, int scheme);

void   ais_context_hilight_selected(void* ctx, int update);
void   ais_context_unhilight_selected(void* ctx, int update);

void   ais_context_fit_selected(void* ctx, void* view, double margin);
void*  ais_context_detected_interactive(void* ctx);
int    ais_context_has_detected(void* ctx);
void   ais_context_clear_detected(void* ctx);
void   ais_context_set_selection_sensitivity(void* ctx, void* obj, int mode, int sensitivity);
void   ais_context_set_pixel_tolerance(void* ctx, int pixels);
void   ais_context_set_automatic_hilight(void* ctx, int on);
void   ais_context_set_to_hilight_selected(void* ctx, int on);

// --- Selection Filters (StdSelect) ---

void*  make_edge_filter(void);
void*  make_face_filter(void);
void*  make_shape_type_filter(int shape_type);
void   filter_set_edge_type(void* filter, int edge_type);
void   filter_set_face_type(void* filter, int face_type);
void   ais_context_add_filter(void* ctx, void* filter);
void   ais_context_remove_filter(void* ctx, void* filter);
void   free_filter(void* filter);

// --- Entity Owners (SelectMgr / StdSelect) ---

void*  ais_context_selected_owner(void* ctx);
int    owner_priority(void* owner);
void*  brep_owner_shape(void* owner);
int    owner_has_shape(void* owner);
int    owner_location(void* owner, double* matrix);
void   free_owner(void* owner);

// --- 3D Curves ---

typedef void* occt_curve;

occt_curve make_line_3d(double ox, double oy, double oz, double dx, double dy, double dz);
occt_curve make_circle_3d(double ox, double oy, double oz, double radius);
occt_curve make_ellipse_3d(double ox, double oy, double oz, double major_r, double minor_r);
occt_curve make_hyperbola(double ox, double oy, double oz, double major_r, double minor_r);
occt_curve make_parabola(double ox, double oy, double oz, double focal);
occt_curve make_bezier_curve(double* points, int num_points);
occt_curve make_bspline_curve(double* poles, int num_poles, double* knots, int* mults, int num_knots, int degree);
void      free_curve(occt_curve curve);
int       curve_type(occt_curve curve);
occt_curve make_gc_line(double x1, double y1, double z1, double x2, double y2, double z2);
occt_curve make_gc_arc_of_circle(double x1, double y1, double z1,
                                  double x2, double y2, double z2,
                                  double x3, double y3, double z3);
occt_curve convert_curve_to_bspline(occt_curve curve);
int       curve_bounding_box(occt_curve curve,
                             double* xmin, double* ymin, double* zmin,
                             double* xmax, double* ymax, double* zmax);

// --- 3D Surfaces ---

typedef void* occt_surface;

occt_surface make_plane(double ox, double oy, double oz, double nx, double ny, double nz);
occt_surface make_cylindrical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius);
occt_surface make_conical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius, double semi_angle);
occt_surface make_spherical_surface(double ox, double oy, double oz, double radius);
occt_surface make_toroidal_surface(double ox, double oy, double oz, double major_r, double minor_r);
occt_surface make_bezier_surface(double* poles, int num_u, int num_v);
occt_surface make_bspline_surface(double* poles, int num_u_poles, int num_v_poles,
                                   double* uknots, int* umults, int num_uknots,
                                   double* vknots, int* vmults, int num_vknots,
                                   int udeg, int vdeg);
void        free_surface(occt_surface surface);
int         surface_type(occt_surface surface);
occt_surface convert_surface_to_bspline(occt_surface surface);
int         surface_bounding_box(occt_surface surface,
                                 double* xmin, double* ymin, double* zmin,
                                 double* xmax, double* ymax, double* zmax);

// --- Geometric Algorithms ---

int project_point_on_curve(occt_curve curve,
                           double px, double py, double pz,
                           double* out_x, double* out_y, double* out_z,
                           double* out_dist, double* out_param);
int project_point_on_surface(occt_surface surface,
                             double px, double py, double pz,
                             double* out_x, double* out_y, double* out_z,
                             double* out_u, double* out_v, double* out_dist);
int intersect_curves(occt_curve c1, occt_curve c2,
                     double* out_points, int max_points);
int intersect_curve_surface(occt_curve curve, occt_surface surface,
                            double* out_points, int max_points);
int intersect_surfaces(occt_surface s1, occt_surface s2,
                       occt_curve* out_curves, int max_curves);
int extrema_curve_curve(occt_curve c1, occt_curve c2,
                        double* out_dist,
                        double* out_p1x, double* out_p1y, double* out_p1z,
                        double* out_p2x, double* out_p2y, double* out_p2z);
int extrema_curve_surface(occt_curve curve, occt_surface surface,
                          double* out_dist,
                          double* out_px, double* out_py, double* out_pz,
                          double* out_u, double* out_v);
int intersect_curves_2d(occt_geom2d c1, occt_geom2d c2,
                        double* out_points, int max_points);
int project_point_on_curve_2d(occt_geom2d curve,
                              double px, double py,
                              double* out_x, double* out_y,
                              double* out_dist, double* out_param);
occt_curve points_to_bspline(double* points, int num_points, int degree);
occt_curve interpolate_points(double* points, int num_points,
                              double* init_tangent, double* final_tangent);

// --- Helix ---

occt_curve make_helix_curve(double radius, double pitch, double height,
                            int left_handed, double angle);
occt_shape make_helix_edge(double radius, double pitch, double height,
                           int left_handed, double angle,
                           occt_surface on_surface);

// --- Mass Properties (BRepGProp) ---

double shape_volume(occt_shape shape);
double shape_area(occt_shape shape);
int    shape_center_of_mass(occt_shape shape, double* out_x, double* out_y, double* out_z);
int    shape_inertia(occt_shape shape, double* out_inertia, int inertia_size,
                     double* out_principal_moments, int pm_size,
                     double* out_principal_axes, int pa_size);

// --- Shape Analysis Queries ---

double shape_distance(occt_shape shape1, occt_shape shape2);
int    shape_distance_extrema(occt_shape shape1, occt_shape shape2,
                              double* out_dist,
                              double* out_p1x, double* out_p1y, double* out_p1z,
                              double* out_p2x, double* out_p2y, double* out_p2z);
int    classify_point_in_solid(occt_shape shape, double px, double py, double pz,
                               int* out_state, occt_shape* out_face);
int    shape_is_valid(occt_shape shape);
const char* shape_analysis_report(occt_shape shape);
int    intersect_curve_shape(occt_curve curve, occt_shape shape,
                             double* out_points, double* out_params,
                             occt_shape* out_faces, int max_results);

// --- Topology Navigation ---

int    map_subshapes(occt_shape shape, int shape_type, int stop_at_type,
                     occt_shape* out_shapes, int max_shapes);
int    count_subshapes(occt_shape shape, int shape_type, int stop_at_type);
const char* dump_shape(occt_shape shape);
int    shape_triangle_count(occt_shape shape);
int    wire_order_check(occt_shape wire, occt_shape face);
occt_curve edge_to_curve(occt_shape edge);
occt_surface face_to_surface(occt_shape face);
occt_shape make_vertex(double x, double y, double z);
occt_shape make_polygon(double* points, int num_points, int closed);

// --- Fillet / Chamfer / Blend ---

occt_shape fillet_edge_constant(occt_shape shape, occt_shape edge, double radius);
occt_shape fillet_edges_constant(occt_shape shape, occt_shape* edges, int num_edges, double radius);
occt_shape fillet_edge_variable(occt_shape shape, occt_shape edge, double* params_and_radii, int num_pairs);
occt_shape fillet_wire_corner(occt_shape wire, double radius);
occt_shape fillet_wire_all_corners(occt_shape wire, double radius);

occt_shape chamfer_edge_equal(occt_shape shape, occt_shape edge, double distance);
occt_shape chamfer_edges_equal(occt_shape shape, occt_shape* edges, int num_edges, double distance);
occt_shape chamfer_edge_asym(occt_shape shape, occt_shape edge, double distance1, double distance2);
occt_shape chamfer_edge_on_face(occt_shape shape, occt_shape edge, double distance, occt_shape face);

occt_shape blend_faces_constant(occt_shape face1, occt_shape face2, double radius);
occt_shape blend_make_constant(occt_shape face1, occt_shape face2, double radius);

// --- Sweep / Pipe ---

occt_shape sweep_pipe(occt_shape profile, occt_shape spine);
occt_shape sweep_pipe_fixed(occt_shape profile, occt_shape spine);
occt_shape sweep_pipe_shell(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_sliding(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_fixed(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_aux(occt_shape profile, occt_shape main_spine, occt_shape aux_spine);

// --- Loft ---

occt_shape loft_sections(occt_shape* wires, int count, int solid);
occt_shape loft_sections_ruled(occt_shape* wires, int count, int solid, int ruled);
occt_shape loft_sections_smooth(occt_shape* wires, int count, int solid, int smooth);
occt_shape loft_sections_tangency(occt_shape* wires, int count, int solid, occt_shape init_face, occt_shape final_face);

// --- Face Filling ---

occt_shape fill_face(occt_shape wire);
occt_shape fill_face_constrained(occt_shape wire, occt_shape* support_faces, int* continuities, int count);
occt_shape fill_n_sided_face(occt_shape* edges, int count, int continuity);

// --- Shell / Thicken ---
occt_shape shell_shape(occt_shape shape, occt_shape* faces, int num_faces, double thickness);

// --- Offset ---
occt_shape offset_shape_3d(occt_shape shape, double offset, int join);
occt_shape offset_wire_2d(occt_shape wire, double offset);

// --- Draft ---
occt_shape draft_face(occt_shape shape, occt_shape face, double angle,
                      double dx, double dy, double dz,
                      double px, double py, double pz,
                      double nx, double ny, double nz);
occt_shape make_evolved(occt_shape profile, occt_shape spine, double offset, int join);

// --- Mechanical Features (BRepFeat) ---

occt_shape make_cylindrical_hole(occt_shape shape, occt_shape face,
                                 double radius, double depth, int through);
occt_shape make_prism_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double height, double dx, double dy, double dz, int operation);
occt_shape make_revol_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double ax, double ay, double az, double angle, int operation);
occt_shape make_pipe_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                             occt_shape path, int operation);

// --- Local Operations (LocOpe) ---

occt_shape local_extrude(occt_shape face, double height, double dx, double dy, double dz);
occt_shape make_groove(occt_shape shape, occt_shape face,
                        double ax, double ay, double az, double angle);
occt_shape make_rib(occt_shape shape, occt_shape profile, double thickness,
                    double dx, double dy, double dz);

// --- Shape Fix ---

occt_shape fix_shape(occt_shape shape);
occt_shape fix_wire(occt_shape wire, occt_shape face, double tolerance);
occt_shape fix_solid(occt_shape shape);
occt_shape fix_edge(occt_shape edge);
occt_shape fix_face(occt_shape face);
occt_shape shape_analysis_free_edges(occt_shape shape);
int shape_analysis_check_intersections(occt_shape shape);
int shape_analysis_wire_contains(occt_shape wire, double x, double y);
const char* shape_analysis_contents(occt_shape shape);

// --- Shape Rebuild ---

occt_shape substitute_single(occt_shape shape, occt_shape old_sub, occt_shape new_sub);
occt_shape substitute_batch(occt_shape shape, occt_shape* old_shapes, occt_shape* new_shapes, int count);
occt_shape shape_to_nurbs(occt_shape shape);
occt_shape shape_reduce_degree(occt_shape shape, int max_degree);
occt_shape shape_to_rational_bspline(occt_shape shape);
occt_shape shape_split_u(occt_shape shape, int num_splits);
occt_shape shape_upgrade_continuity(occt_shape shape, int continuity);

// --- Shape Process Pipeline ---

occt_shape apply_shape_process(occt_shape shape, const char* operator_name);
occt_shape apply_operator_sequence(occt_shape shape, const char** operators, int count);
occt_shape apply_healing_pipeline(occt_shape shape, const char* pipeline_name, const char* resource);
occt_shape heal_shape_default(occt_shape shape);

// --- Sewing ---

occt_shape sew_shapes(occt_shape* shapes, int num_shapes, double tolerance, int allow_non_manifold);

// --- Defeaturing ---

occt_shape defeature_shape(occt_shape shape, occt_shape* faces, int num_faces);

// --- Shape Check & Builder ---

const char* check_shape_validity(occt_shape shape);
occt_shape boolean_builder(occt_shape shape1, occt_shape shape2, int operation);

// --- Image / AlienPixMap ---

typedef void* occt_image;

occt_image image_from_file(const char* filename);
void       free_image(occt_image img);
int        image_save(occt_image img, const char* filename);
int        image_width(occt_image img);
int        image_height(occt_image img);

// --- Texture 2D / Texture Params ---

typedef void* occt_texture;
typedef void* occt_tex_params;

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

typedef void* occt_pbr_material;

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

// --- HLR ---

occt_shape hlr_project(occt_shape shape,
                        double proj_dx, double proj_dy, double proj_dz,
                        double px, double py, double pz);

// --- Shape Conversion ---

occt_shape convert_to_revolution(occt_shape shape);
occt_shape convert_swept_to_elementary(occt_shape shape);

// --- Mesh Operations (BRepMesh_IncrementalMesh, Poly_Triangulation, Poly_Connect) ---

occt_shape mesh_shape(occt_shape shape, double deflection, double angle, int relative);

int mesh_get_vertices(occt_shape shape, double* out_verts, int max_count);
int mesh_get_triangles(occt_shape shape, int* out_tris, int max_count);
int mesh_get_normals(occt_shape shape, double* out_normals, int max_count);
int mesh_get_triangle_count(occt_shape shape);

int mesh_triangle_adjacent(occt_shape shape, int tri_index, int edge_index);
int mesh_triangle_elements(occt_shape shape, int tri_index, int* out_n1, int* out_n2, int* out_n3);

// --- RWMesh Utility Enums ---

int rwmesh_coordinate_system_zup(void);
int rwmesh_coordinate_system_yup(void);
int rwmesh_name_format_auto(void);
int rwmesh_name_format_short(void);
int rwmesh_name_format_full(void);

// --- MeshVS ---

void* meshvs_create_mesh(void);
void  meshvs_free_mesh(void* mesh);
int   meshvs_set_data(void* mesh, double* verts, int vcount, int* tris, int tcount, double* colors);
void  meshvs_display(void* ctx, void* mesh);

// --- XCAF Document Tools ---

int xcaf_new_doc(xde_doc* out_doc);
void xcaf_free_doc(xde_doc doc);
int xcaf_save_shape_to_doc(xde_doc doc, occt_shape shape);
// LayerTool
int xcaf_set_layer(xde_doc doc, occt_shape shape, const char* layer);
int xcaf_unset_one_layer(xde_doc doc, occt_shape shape, const char* layer);
int xcaf_unset_all_layers(xde_doc doc, occt_shape shape);
int xcaf_get_layer_count(xde_doc doc, occt_shape shape);
void xcaf_get_layer_name(xde_doc doc, occt_shape shape, int index, char* buf, int buf_size);
// MaterialTool
int xcaf_has_material(xde_doc doc, occt_shape shape);
// ViewTool
int xcaf_add_view(xde_doc doc);
int xcaf_get_view_count(xde_doc doc);
// VisMaterialTool
int xcaf_get_visual_material_count(xde_doc doc);
int xcaf_get_visual_material(xde_doc doc, occt_shape shape,
                              double* out_r, double* out_g, double* out_b, double* out_a);
// ClippingPlaneTool
int xcaf_get_clipping_plane_count(xde_doc doc);
// Editor
int xcaf_expand_assembly(xde_doc doc);

// --- AIS Animation ---

typedef void* occt_ais_animation;

occt_ais_animation ais_animation_create(const char* name);
void               ais_animation_free(occt_ais_animation anim);
void               ais_animation_start(occt_ais_animation anim);
void               ais_animation_stop(occt_ais_animation anim);
int                ais_animation_is_playing(occt_ais_animation anim);
void               ais_animation_set_duration(occt_ais_animation anim, double seconds);
double             ais_animation_duration(occt_ais_animation anim);
void               ais_animation_set_progress(occt_ais_animation anim, double progress);
double             ais_animation_progress(occt_ais_animation anim);
void               ais_animation_set_start_pause(occt_ais_animation anim, double seconds);
void               ais_animation_add(occt_ais_animation parent, occt_ais_animation child);
void               ais_animation_remove(occt_ais_animation parent, occt_ais_animation child);
void*              ais_animation_object_create(const char* name, void* ctx, void* ais_obj,
                                                double tx, double ty, double tz,
                                                double rx, double ry, double rz, double angle_deg);
void*              ais_animation_object_get_object(occt_ais_animation anim);
void*              ais_animation_camera_create(const char* name, void* view,
                                                double sex, double sey, double sez,
                                                double stx, double sty, double stz,
                                                double sux, double suy, double suz,
                                                double eex, double eey, double eez,
                                                double etx, double ety, double etz,
                                                double eux, double euy, double euz);
void*              ais_animation_axis_rotation_create(const char* name, void* ctx, void* ais_obj,
                                                       double ox, double oy, double oz,
                                                       double dx, double dy, double dz,
                                                       double angle_start_deg,
                                                       double angle_end_deg);

#ifdef __cplusplus
}
#endif

#endif

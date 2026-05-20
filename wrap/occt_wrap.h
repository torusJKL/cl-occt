#ifndef OCCT_WRAP_H
#define OCCT_WRAP_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* occt_shape;
typedef void* occt_shape_ptr;
typedef void* occt_geom2d;

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
void v3d_view_set_msaa(void* view, int samples);
int  v3d_view_get_msaa(void* view);
void v3d_view_set_antialiasing(void* view, int on);
int  v3d_view_get_antialiasing(void* view);
void v3d_viewer_activate_grid(void* viewer, int gridType, int drawMode);
void v3d_viewer_deactivate_grid(void* viewer);
void v3d_view_invalidate(void* view);

#ifdef __cplusplus
}
#endif

#endif

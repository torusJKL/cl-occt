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

#ifdef __cplusplus
}
#endif

#endif

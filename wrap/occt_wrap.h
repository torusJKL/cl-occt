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

occt_shape make_wire(occt_shape* edges, int count);
occt_shape make_face(occt_shape wire);
occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz);

int get_error_code(void);
const char* get_error_message(void);

#ifdef __cplusplus
}
#endif

#endif

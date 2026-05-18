#ifndef OCCT_WRAP_H
#define OCCT_WRAP_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* occt_shape;
typedef void* occt_shape_ptr;

occt_shape make_box(double dx, double dy, double dz);
occt_shape make_cylinder(double radius, double height);
occt_shape make_sphere(double radius);
occt_shape make_cone(double r1, double r2, double height);

occt_shape boolean_cut(occt_shape a, occt_shape b);
occt_shape boolean_fuse(occt_shape a, occt_shape b);
occt_shape boolean_common(occt_shape a, occt_shape b);

occt_shape translate(occt_shape shape, double dx, double dy, double dz);
occt_shape rotate(occt_shape shape, double ax, double ay, double az, double angle_deg);

int write_step(occt_shape shape, const char* filename);
occt_shape read_step(const char* filename);

void free_shape(occt_shape shape);

int get_error_code(void);
const char* get_error_message(void);

#ifdef __cplusplus
}
#endif

#endif

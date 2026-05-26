#ifndef OCCT_WRAP_PROPS_H
#define OCCT_WRAP_PROPS_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int face_area(occt_shape face, double* out_area);
int edge_length(occt_shape edge, double* out_length);
int face_normal_at_center(occt_shape face, double* out_nx, double* out_ny, double* out_nz);
int face_surface_type(occt_shape face);
int edge_curve_type(occt_shape edge);
int subshape_bounding_box(occt_shape shape, double* out_xmin, double* out_ymin, double* out_zmin,
                           double* out_xmax, double* out_ymax, double* out_zmax);
int face_center(occt_shape face, double* out_x, double* out_y, double* out_z);
int shape_extent_along(occt_shape shape, double dx, double dy, double dz,
                        double* out_min, double* out_max);

#ifdef __cplusplus
}
#endif

#endif

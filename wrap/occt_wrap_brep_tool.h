#ifndef OCCT_WRAP_BREP_TOOL_H
#define OCCT_WRAP_BREP_TOOL_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int vertex_point(occt_shape vertex, double* out_x, double* out_y, double* out_z);
occt_curve edge_get_curve(occt_shape edge, double* out_first, double* out_last);
occt_surface face_get_surface(occt_shape face, double* out_umin, double* out_umax, double* out_vmin, double* out_vmax);
int shape_tolerance(occt_shape shape, double* out_tol);
int face_natural_restriction(occt_shape face);
occt_shape shape_reversed(occt_shape shape);

#ifdef __cplusplus
}
#endif

#endif

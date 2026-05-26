#ifndef OCCT_WRAP_EXTREMA_H
#define OCCT_WRAP_EXTREMA_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int shape_proximity(occt_shape shape1, occt_shape shape2, double tolerance,
                    double* out_value,
                    occt_shape* out_subshapes1, occt_shape* out_subshapes2, int max_results);

int shape_overlap_p(occt_shape shape1, occt_shape shape2, double tolerance);

int shape_overlap_detail(occt_shape shape1, occt_shape shape2, double tolerance,
                         occt_shape* out_subshapes1, occt_shape* out_subshapes2, int max_results);

int shape_self_intersect(occt_shape shape, double tolerance,
                         occt_shape* out_faces, int max_results);

int face_distance(occt_shape face1, occt_shape face2,
                  double* out_min, double* out_max);

#ifdef __cplusplus
}
#endif

#endif

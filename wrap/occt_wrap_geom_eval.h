#ifndef OCCT_WRAP_GEOM_EVAL_H
#define OCCT_WRAP_GEOM_EVAL_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int curve_value(occt_curve curve, double t, double* out_x, double* out_y, double* out_z);
int surface_value(occt_surface surface, double u, double v, double* out_x, double* out_y, double* out_z);

#ifdef __cplusplus
}
#endif

#endif

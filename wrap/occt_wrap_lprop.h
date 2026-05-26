#ifndef OCCT_WRAP_LPROP_H
#define OCCT_WRAP_LPROP_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int curve_tangent_at(occt_curve curve, double param,
                     double* out_tx, double* out_ty, double* out_tz);

int curve_curvature_at(occt_curve curve, double param, double* out_k);

int surface_normal_at(occt_surface surface, double u, double v,
                      double* out_nx, double* out_ny, double* out_nz);

int surface_curvature_at(occt_surface surface, double u, double v,
                         double* out_min_k, double* out_max_k);

#ifdef __cplusplus
}
#endif

#endif

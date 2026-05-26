#ifndef OCCT_WRAP_FAIRCURVE_H
#define OCCT_WRAP_FAIRCURVE_H

#ifdef __cplusplus
extern "C" {
#endif

occt_curve fair_curve_batten(double* points, int num_points,
                              int free_end, int free_slide,
                              double* init_tangent, double* final_tangent);
occt_curve fair_curve_minvar(double* points, int num_points,
                              int free_end, int free_slide,
                              double* init_slope, double* final_slope);

#ifdef __cplusplus
}
#endif

#endif

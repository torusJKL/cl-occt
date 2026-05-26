#ifndef OCCT_WRAP_GCPNTS_H
#define OCCT_WRAP_GCPNTS_H

#ifdef __cplusplus
extern "C" {
#endif

int uniform_abscissa_points(occt_curve curve, double first, double last,
                            int num_points, double* out_coords);

int uniform_deflection_points(occt_curve curve, double first, double last,
                              double deflection, double* out_coords);

#ifdef __cplusplus
}
#endif

#endif

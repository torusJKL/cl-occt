#ifndef OCCT_WRAP_TRANSFER_PARAMS_H
#define OCCT_WRAP_TRANSFER_PARAMS_H

#ifdef __cplusplus
extern "C" {
#endif

int transfer_params(occt_shape source_edge, occt_curve target_curve, double param, double* out_param);

#ifdef __cplusplus
}
#endif

#endif

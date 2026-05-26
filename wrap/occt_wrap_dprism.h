#ifndef OCCT_WRAP_DPRISM_H
#define OCCT_WRAP_DPRISM_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape make_drafted_prism(occt_shape shape, occt_shape face, occt_shape profile,
                              double height, double angle, int operation);

#ifdef __cplusplus
}
#endif

#endif

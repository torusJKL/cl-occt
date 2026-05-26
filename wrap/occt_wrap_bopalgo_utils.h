#ifndef OCCT_WRAP_BOPALGO_UTILS_H
#define OCCT_WRAP_BOPALGO_UTILS_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

char* argument_analyzer(occt_shape* shapes, int num_shapes);
occt_shape make_connected_shapes(occt_shape* shapes, int num_shapes);
occt_shape make_shape_periodic(occt_shape shape, double dx, double dy, double dz);

#ifdef __cplusplus
}
#endif

#endif

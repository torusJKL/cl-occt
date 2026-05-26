#ifndef OCCT_WRAP_BOOLEANS_H
#define OCCT_WRAP_BOOLEANS_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape boolean_cut(occt_shape a, occt_shape b);
occt_shape boolean_fuse(occt_shape a, occt_shape b);
occt_shape boolean_common(occt_shape a, occt_shape b);
occt_shape boolean_section(occt_shape a, occt_shape b);

#ifdef __cplusplus
}
#endif

#endif

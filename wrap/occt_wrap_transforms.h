#ifndef OCCT_WRAP_TRANSFORMS_H
#define OCCT_WRAP_TRANSFORMS_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape translate(occt_shape shape, double dx, double dy, double dz);
occt_shape rotate(occt_shape shape, double ax, double ay, double az, double angle_deg);

#ifdef __cplusplus
}
#endif

#endif

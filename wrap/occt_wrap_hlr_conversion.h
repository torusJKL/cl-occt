#ifndef OCCT_WRAP_HLR_CONVERSION_H
#define OCCT_WRAP_HLR_CONVERSION_H

#ifdef __cplusplus
extern "C" {
#endif

// --- HLR ---

occt_shape hlr_project(occt_shape shape,
                        double proj_dx, double proj_dy, double proj_dz,
                        double px, double py, double pz);

// --- Shape Conversion ---

occt_shape convert_to_revolution(occt_shape shape);
occt_shape convert_swept_to_elementary(occt_shape shape);

#ifdef __cplusplus
}
#endif

#endif

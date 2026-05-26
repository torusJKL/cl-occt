#ifndef OCCT_WRAP_GEOM_PLATE_H
#define OCCT_WRAP_GEOM_PLATE_H

#ifdef __cplusplus
extern "C" {
#endif

occt_surface fill_surface_from_curves(occt_curve* curves, int num_curves,
                                       int continuity,
                                       occt_shape* support_faces, int num_support_faces);

#ifdef __cplusplus
}
#endif

#endif

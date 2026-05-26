#ifndef OCCT_WRAP_LOCATION_H
#define OCCT_WRAP_LOCATION_H

#ifdef __cplusplus
extern "C" {
#endif

occt_location location_from_translation(double dx, double dy, double dz);
occt_location location_multiply(occt_location loc1, occt_location loc2);
occt_location location_inverted(occt_location loc);
void location_free(occt_location loc);
occt_location shape_get_location(occt_shape shape);
occt_shape shape_moved(occt_shape shape, occt_location loc);

#ifdef __cplusplus
}
#endif

#endif

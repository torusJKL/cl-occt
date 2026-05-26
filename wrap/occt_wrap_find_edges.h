#ifndef OCCT_WRAP_FIND_EDGES_H
#define OCCT_WRAP_FIND_EDGES_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape* find_edges_by_type(occt_shape shape, int curve_type, int* out_count);
occt_shape* find_edges_by_radius(occt_shape shape, double radius, int* out_count);

#ifdef __cplusplus
}
#endif

#endif

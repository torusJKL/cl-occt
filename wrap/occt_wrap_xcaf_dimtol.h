#ifndef OCCT_WRAP_XCAF_DIMTOL_H
#define OCCT_WRAP_XCAF_DIMTOL_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

// --- Dimension creation ---
int xcaf_add_linear_dimension(xde_doc doc, occt_shape shape,
                               double* point_coords, int num_points,
                               double value);

int xcaf_add_angular_dimension(xde_doc doc, occt_shape shape,
                                occt_shape* edges, int num_edges,
                                double value);

int xcaf_add_diameter_dimension(xde_doc doc, occt_shape shape,
                                 occt_shape subshape, double value);

// --- Tolerance (DimTol) ---
int xcaf_add_tolerance(xde_doc doc, occt_shape shape,
                        int type_code, double value,
                        int modifier_flags);

// --- Datum ---
int xcaf_add_datum(xde_doc doc, occt_shape shape,
                    const char* label_str);

// --- Geometric Tolerance ---
int xcaf_add_geometric_tolerance(xde_doc doc, occt_shape shape,
                                  int type_code, double value,
                                  const char** datum_labels, int num_datums);

// --- Query: dimensions ---
// Returns flat double array [count, type1, val1, nbPts1, p1x,p1y,p1z, ..., type2,...]
double* xcaf_get_dimensions(xde_doc doc, occt_shape shape, int* out_count);

// --- Query: tolerances ---
// Returns flat double array [count, type1, val1, type2, val2, ...]
double* xcaf_get_tolerances(xde_doc doc, occt_shape shape, int* out_count);

// --- Query: datums ---
// Returns array of string pointers. Caller must free with xcaf_free_string_array()
char** xcaf_get_datums(xde_doc doc, occt_shape shape, int* out_count);

// --- Memory management helpers ---
void xcaf_free_double_array(double* arr);
void xcaf_free_string_array(char** arr, int count);

#ifdef __cplusplus
}
#endif

#endif

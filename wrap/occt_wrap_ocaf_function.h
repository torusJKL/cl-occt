#ifndef OCCT_WRAP_OCAF_FUNCTION_H
#define OCCT_WRAP_OCAF_FUNCTION_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

// --- Parametric Functions ---

int ocaf_add_function(ocaf_label label, const char* driver_guid);
int ocaf_set_function_input(ocaf_label func_label, ocaf_label input_label);
int ocaf_set_function_output(ocaf_label func_label, ocaf_label output_label);
int ocaf_recompute_doc(xde_doc doc);
int ocaf_recompute_function(ocaf_label func_label);

#ifdef __cplusplus
}
#endif

#endif

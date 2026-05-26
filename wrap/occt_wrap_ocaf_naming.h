#ifndef OCCT_WRAP_OCAF_NAMING_H
#define OCCT_WRAP_OCAF_NAMING_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

// --- Topological Naming ---

void ocaf_name_shape(ocaf_label label, occt_shape shape, int evolution);
occt_shape ocaf_get_named_shape(ocaf_label label, int evolution);
int ocaf_named_shape_is_deleted(ocaf_label label);

#ifdef __cplusplus
}
#endif

#endif

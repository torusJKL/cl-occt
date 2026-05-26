#include "occt_wrap_internal.h"
#include "occt_wrap_types.h"

void free_shape(occt_shape shape) {
    if (shape) {
        delete to_shape(shape);
    }
}

int get_error_code(void) {
    return g_error_code;
}

const char* get_error_message(void) {
    return g_error_message;
}

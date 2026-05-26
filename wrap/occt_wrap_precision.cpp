#include "occt_wrap_internal.h"
#include "occt_wrap_precision.h"
#include <Precision.hxx>

double precision_confusion(void) {
    return Precision::Confusion();
}

double precision_angular(void) {
    return Precision::Angular();
}

double precision_intersection(void) {
    return Precision::Intersection();
}

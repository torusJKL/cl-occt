#include "occt_wrap_internal.h"
#include "occt_wrap_shape_tolerance.h"
#include <ShapeFix_ShapeTolerance.hxx>

int set_shape_tolerance(occt_shape shape, double tolerance, int shape_type) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return 0; }
    if (tolerance < 0) { set_error("negative tolerance", 2); return 0; }
    try {
        ShapeFix_ShapeTolerance st;
        TopAbs_ShapeEnum stype = topabs_from_int(shape_type);
        st.SetTolerance(*to_shape(shape), tolerance, stype);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

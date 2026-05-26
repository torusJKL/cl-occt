#include "occt_wrap_internal.h"
#include "occt_wrap_small_faces.h"
#include <ShapeFix_FixSmallFace.hxx>

occt_shape fix_small_faces(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return nullptr; }
    try {
        ShapeFix_FixSmallFace fixer;
        fixer.Init(*to_shape(shape));
        fixer.SetPrecision(Precision::Confusion());
        fixer.Perform();
        TopoDS_Shape result = fixer.Shape();
        if (result.IsNull()) { set_error("FixSmallFace produced null", 2); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

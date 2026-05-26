#include "occt_wrap_internal.h"
#include "occt_wrap_dprism.h"
#include <BRepFeat_MakeDPrism.hxx>

occt_shape make_drafted_prism(occt_shape shape, occt_shape face, occt_shape profile,
                              double height, double angle, int operation) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return nullptr; }
    if (!face) { set_error("null face", 2); return nullptr; }
    if (!profile) { set_error("null profile", 2); return nullptr; }
    if (height < Precision::Confusion()) { set_error("non-positive height", 2); return nullptr; }
    try {
        int fuse = (operation != 0) ? 1 : 0;
        double ang = angle * M_PI / 180.0;
        BRepFeat_MakeDPrism feat(*to_shape(shape),
                                  TopoDS::Face(*to_shape(face)),
                                  TopoDS::Face(*to_shape(profile)),
                                  ang, fuse, false);
        feat.Perform(height);
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakeDPrism produced null shape", 2); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

#include "occt_wrap_internal.h"
#include "occt_wrap_transforms.h"


occt_shape translate(occt_shape shape, double dx, double dy, double dz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        gp_Trsf trsf;
        trsf.SetTranslation(gp_Vec(dx, dy, dz));
        BRepBuilderAPI_Transform xform(*to_shape(shape), trsf);
        return from_shape(xform.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape rotate(occt_shape shape, double ax, double ay, double az, double angle_deg) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        gp_Trsf trsf;
        trsf.SetRotation(gp_Ax1(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az)), angle_deg * M_PI / 180.0);
        BRepBuilderAPI_Transform xform(*to_shape(shape), trsf);
        return from_shape(xform.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

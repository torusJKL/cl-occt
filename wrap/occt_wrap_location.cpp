#include "occt_wrap_internal.h"
#include "occt_wrap_location.h"

occt_location location_from_translation(double dx, double dy, double dz) {
    clear_error();
    try {
        gp_Trsf trsf;
        trsf.SetTranslation(gp_Vec(dx, dy, dz));
        return new TopLoc_Location(trsf);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_location location_multiply(occt_location loc1, occt_location loc2) {
    clear_error();
    if (!loc1 || !loc2) { set_error("null location", 2); return nullptr; }
    try {
        const TopLoc_Location& a = *static_cast<TopLoc_Location*>(loc1);
        const TopLoc_Location& b = *static_cast<TopLoc_Location*>(loc2);
        return new TopLoc_Location(a.Multiplied(b));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_location location_inverted(occt_location loc) {
    clear_error();
    if (!loc) { set_error("null location", 2); return nullptr; }
    try {
        const TopLoc_Location& a = *static_cast<TopLoc_Location*>(loc);
        return new TopLoc_Location(a.Inverted());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void location_free(occt_location loc) {
    if (loc) {
        delete static_cast<TopLoc_Location*>(loc);
    }
}

occt_location shape_get_location(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return nullptr; }
    try {
        const TopLoc_Location& loc = to_shape(shape)->Location();
        return new TopLoc_Location(loc);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_moved(occt_shape shape, occt_location loc) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return nullptr; }
    if (!loc) { set_error("null location", 2); return nullptr; }
    try {
        const TopLoc_Location& tloc = *static_cast<TopLoc_Location*>(loc);
        TopoDS_Shape moved = to_shape(shape)->Moved(tloc);
        if (moved.IsNull()) { set_error("Moved produced null shape", 2); return nullptr; }
        return from_shape(moved);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

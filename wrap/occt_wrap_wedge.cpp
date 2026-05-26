#include "occt_wrap_internal.h"
#include "occt_wrap_wedge.h"
#include <BRepPrimAPI_MakeWedge.hxx>

occt_shape make_wedge_full(double dx, double dy, double dz, double ltx) {
    clear_error();
    if (dx < Precision::Confusion() || dy < Precision::Confusion() || dz < Precision::Confusion()) {
        set_error("non-positive wedge dimension", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeWedge maker(dx, dy, dz, ltx);
        const TopoDS_Shape& shape = maker.Shape();
        if (shape.IsNull()) { set_error("MakeWedge produced null shape", 2); return nullptr; }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_wedge_corner(double dx, double dy, double dz,
                             double xmin, double zmin,
                             double xmax, double zmax) {
    clear_error();
    if (dx < Precision::Confusion() || dy < Precision::Confusion() || dz < Precision::Confusion()) {
        set_error("non-positive wedge dimension", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeWedge maker(dx, dy, dz, xmin, zmin, xmax, zmax);
        const TopoDS_Shape& shape = maker.Shape();
        if (shape.IsNull()) { set_error("MakeWedge produced null shape", 2); return nullptr; }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

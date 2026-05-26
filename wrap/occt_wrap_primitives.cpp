#include "occt_wrap_internal.h"
#include "occt_wrap_primitives.h"


occt_shape make_box(double dx, double dy, double dz) {
    clear_error();
    if (dx < Precision::Confusion() || dy < Precision::Confusion() || dz < Precision::Confusion()) {
        set_error("non-positive dimension", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeBox maker(dx, dy, dz);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_cylinder(double radius, double height) {
    clear_error();
    if (radius < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive radius or height", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeCylinder maker(radius, height);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_sphere(double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeSphere maker(radius);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_cone(double r1, double r2, double height) {
    clear_error();
    if (height < Precision::Confusion()) {
        set_error("non-positive height", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeCone maker(r1, r2, height);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_torus(double major_radius, double minor_radius) {
    clear_error();
    if (major_radius < Precision::Confusion() || minor_radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeTorus maker(major_radius, minor_radius);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_prism(occt_shape shape, double dx, double dy, double dz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    double mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (mag < Precision::Confusion()) {
        set_error("zero extrusion vector", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakePrism maker(*to_shape(shape), gp_Vec(dx, dy, dz));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_revol(occt_shape shape, double ax, double ay, double az, double angle_deg) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    double angle = angle_deg * M_PI / 180.0;
    if (fabs(angle) < Precision::Confusion()) {
        set_error("zero revolution angle", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeRevol maker(*to_shape(shape), gp_Ax1(gp_Pnt(0,0,0), gp_Dir(ax, ay, az)), angle);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

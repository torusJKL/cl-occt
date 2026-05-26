#include "occt_wrap_internal.h"
#include "occt_wrap_geom2d.h"

occt_geom2d make_pnt2d(double x, double y) {
    clear_error();
    try {
        return alloc_geom2d(KIND_PNT2D, new gp_Pnt2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_vec2d(double x, double y) {
    clear_error();
    try {
        return alloc_geom2d(KIND_VEC2D, new gp_Vec2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_dir2d(double x, double y) {
    clear_error();
    double mag = sqrt(x*x + y*y);
    if (mag < Precision::Confusion()) {
        set_error("zero direction vector", 2);
        return nullptr;
    }
    try {
        return alloc_geom2d(KIND_DIR2D, new gp_Dir2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_geom2d(occt_geom2d g) {
    if (!g) return;
    Geom2dObj* obj = static_cast<Geom2dObj*>(g);
    switch (obj->kind) {
        case KIND_PNT2D:  delete static_cast<gp_Pnt2d*>(obj->obj); break;
        case KIND_VEC2D:  delete static_cast<gp_Vec2d*>(obj->obj); break;
        case KIND_DIR2D:  delete static_cast<gp_Dir2d*>(obj->obj); break;
        case KIND_LINE2D: delete static_cast<Handle(Geom2d_Line)*>(obj->obj); break;
        case KIND_CIRCLE2D: delete static_cast<Handle(Geom2d_Circle)*>(obj->obj); break;
    }
    delete obj;
}

occt_geom2d make_line_2d(double x, double y, double dx, double dy) {
    clear_error();
    double mag = sqrt(dx*dx + dy*dy);
    if (mag < Precision::Confusion()) {
        set_error("zero direction vector", 2);
        return nullptr;
    }
    try {
        gp_Pnt2d origin(x, y);
        gp_Dir2d dir(dx, dy);
        Handle(Geom2d_Line)* h = new Handle(Geom2d_Line)(new Geom2d_Line(origin, dir));
        return alloc_geom2d(KIND_LINE2D, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_circle_2d(double x, double y, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        gp_Pnt2d center(x, y);
        gp_Dir2d xDir(1.0, 0.0);
        gp_Ax2d axis(center, xDir);
        Handle(Geom2d_Circle)* h = new Handle(Geom2d_Circle)(new Geom2d_Circle(axis, radius));
        return alloc_geom2d(KIND_CIRCLE2D, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}


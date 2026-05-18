#include "occt_wrap.h"
#include <BRepPrimAPI_MakeBox.hxx>
#include <BRepPrimAPI_MakeCylinder.hxx>
#include <BRepPrimAPI_MakeSphere.hxx>
#include <BRepPrimAPI_MakeCone.hxx>
#include <BRepPrimAPI_MakeTorus.hxx>
#include <BRepPrimAPI_MakePrism.hxx>
#include <BRepPrimAPI_MakeRevol.hxx>
#include <BRepAlgoAPI_Cut.hxx>
#include <BRepAlgoAPI_Fuse.hxx>
#include <BRepAlgoAPI_Common.hxx>
#include <BRepBuilderAPI_Transform.hxx>
#include <BRepBuilderAPI_MakeEdge.hxx>
#include <BRepBuilderAPI_MakeWire.hxx>
#include <BRepBuilderAPI_MakeFace.hxx>
#include <gp_Trsf.hxx>
#include <gp_Pnt2d.hxx>
#include <gp_Vec2d.hxx>
#include <gp_Dir2d.hxx>
#include <gp_Ax2d.hxx>
#include <gp_XY.hxx>
#include <gp_Pln.hxx>
#include <gp_Ax2.hxx>
#include <gp_Circ.hxx>
#include <Geom2d_Line.hxx>
#include <Geom2d_Circle.hxx>
#include <GC_MakeArcOfCircle.hxx>
#include <GC_MakeSegment.hxx>
#include <STEPControl_Writer.hxx>
#include <STEPControl_Reader.hxx>
#include <IFSelect_ReturnStatus.hxx>
#include <Standard_Failure.hxx>
#include <Standard_ErrorHandler.hxx>
#include <TopoDS_Shape.hxx>
#include <TopoDS_Wire.hxx>
#include <TopoDS.hxx>
#include <TopExp_Explorer.hxx>
#include <TopAbs_ShapeEnum.hxx>
#include <Precision.hxx>
#include <iostream>
#include <cstring>
#include <cmath>

static thread_local int g_error_code = 0;
static thread_local char g_error_message[512];

static void set_error(const char* msg, int code = 1) {
    g_error_code = code;
    strncpy(g_error_message, msg, sizeof(g_error_message) - 1);
    g_error_message[sizeof(g_error_message) - 1] = '\0';
}

static void clear_error() {
    g_error_code = 0;
    g_error_message[0] = '\0';
}

static TopoDS_Shape* to_shape(occt_shape s) {
    return static_cast<TopoDS_Shape*>(s);
}

static occt_shape from_shape(const TopoDS_Shape& s) {
    return new TopoDS_Shape(s);
}

static bool is_empty_shape(const TopoDS_Shape& s) {
    if (s.IsNull()) return true;
    TopExp_Explorer exp(s, TopAbs_FACE);
    return !exp.More();
}

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

occt_shape boolean_cut(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Cut maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean cut not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean cut produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape boolean_fuse(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Fuse maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean fuse not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean fuse produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape boolean_common(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Common maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean common not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean common produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

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

int write_step(occt_shape shape, const char* filename) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        STEPControl_Writer writer;
        IFSelect_ReturnStatus stat = writer.Transfer(*to_shape(shape), STEPControl_AsIs);
        if (stat != IFSelect_RetDone) {
            set_error("STEP transfer failed");
            return 0;
        }
        stat = writer.Write(filename);
        if (stat != IFSelect_RetDone) {
            set_error("STEP write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape read_step(const char* filename) {
    clear_error();
    try {
        STEPControl_Reader reader;
        IFSelect_ReturnStatus stat = reader.ReadFile(filename);
        if (stat != IFSelect_RetDone) {
            set_error("STEP read failed");
            return nullptr;
        }
        reader.TransferRoots();
        TopoDS_Shape shape = reader.OneShape();
        if (shape.IsNull()) {
            set_error("STEP file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- 2D Geometry types ---

enum Geom2dKind {
    KIND_PNT2D = 0,
    KIND_VEC2D = 1,
    KIND_DIR2D = 2,
    KIND_LINE2D = 3,
    KIND_CIRCLE2D = 4,
};

struct Geom2dObj {
    Geom2dKind kind;
    void* obj;
};

static Geom2dObj* alloc_geom2d(Geom2dKind kind, void* obj) {
    Geom2dObj* g = new Geom2dObj;
    g->kind = kind;
    g->obj = obj;
    return g;
}

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

// --- 2D Curves ---

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

// --- Edge construction ---

occt_shape make_edge_line_2d(double x1, double y1, double x2, double y2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, 0), gp_Pnt(x2, y2, 0));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_line_3d(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_circle_2d(double x, double y, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        gp_Circ circle(gp_Ax2(gp_Pnt(x, y, 0), gp_Dir(0, 0, 1)), radius);
        BRepBuilderAPI_MakeEdge maker(circle);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_arc_2d(double x1, double y1, double x2, double y2, double x3, double y3) {
    clear_error();
    try {
        gp_Pnt p1(x1, y1, 0), p2(x2, y2, 0), p3(x3, y3, 0);
        GC_MakeArcOfCircle arcMaker(p1, p2, p3);
        if (!arcMaker.IsDone()) {
            set_error("arc of circle construction failed");
            return nullptr;
        }
        Handle(Geom_Curve) arc = arcMaker.Value();
        BRepBuilderAPI_MakeEdge maker(arc);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Wire and Face construction ---

occt_shape make_wire(occt_shape* edges, int count) {
    clear_error();
    if (count < 1) {
        set_error("wire requires at least one edge", 2);
        return nullptr;
    }
    try {
        BRepBuilderAPI_MakeWire maker;
        for (int i = 0; i < count; i++) {
            if (!edges[i]) {
                set_error("null edge in wire construction", 2);
                return nullptr;
            }
            maker.Add(TopoDS::Edge(*to_shape(edges[i])));
        }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face(occt_shape wire) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        gp_Pln plane(gp_Pnt(ox, oy, oz), gp_Dir(nx, ny, nz));
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(plane, w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

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

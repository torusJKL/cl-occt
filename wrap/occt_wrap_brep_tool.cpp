#include "occt_wrap_internal.h"
#include "occt_wrap_brep_tool.h"
#include <BRep_Tool.hxx>
#include <BRepAdaptor_Curve.hxx>
#include <BRepAdaptor_Surface.hxx>
#include <TopExp.hxx>
#include <gp_Pnt.hxx>
#include <TopoDS.hxx>
#include <TopoDS_Edge.hxx>
#include <TopoDS_Face.hxx>
#include <TopoDS_Vertex.hxx>
#include <Geom_Curve.hxx>
#include <Geom_Surface.hxx>
#include <Geom_Line.hxx>
#include <Geom_Circle.hxx>
#include <Geom_Ellipse.hxx>
#include <Geom_Parabola.hxx>
#include <Geom_Hyperbola.hxx>
#include <Geom_BezierCurve.hxx>
#include <Geom_BSplineCurve.hxx>
#include <Geom_Plane.hxx>
#include <Geom_CylindricalSurface.hxx>
#include <Geom_ConicalSurface.hxx>
#include <Geom_SphericalSurface.hxx>
#include <Geom_ToroidalSurface.hxx>
#include <Geom_BezierSurface.hxx>
#include <Geom_BSplineSurface.hxx>

int vertex_point(occt_shape vertex, double* out_x, double* out_y, double* out_z) {
    clear_error();
    if (!vertex) { set_error("null vertex argument", 2); return 0; }
    try {
        TopoDS_Vertex v = TopoDS::Vertex(*to_shape(vertex));
        gp_Pnt p = BRep_Tool::Pnt(v);
        *out_x = p.X();
        *out_y = p.Y();
        *out_z = p.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_curve edge_get_curve(occt_shape edge, double* out_first, double* out_last) {
    clear_error();
    if (!edge) { set_error("null edge argument", 2); return nullptr; }
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        Handle(Geom_Curve) curve = BRep_Tool::Curve(e, *out_first, *out_last);
        if (curve.IsNull()) { set_error("edge has no curve"); return nullptr; }
        GeomCurveKind kind;
        if (curve->DynamicType() == STANDARD_TYPE(Geom_Line))
            kind = CURVE_LINE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Circle))
            kind = CURVE_CIRCLE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Ellipse))
            kind = CURVE_ELLIPSE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Parabola))
            kind = CURVE_PARABOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Hyperbola))
            kind = CURVE_HYPERBOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BezierCurve))
            kind = CURVE_BEZIER;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BSplineCurve))
            kind = CURVE_BSPLINE;
        else
            kind = CURVE_BSPLINE;
        Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
        return alloc_curve(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_surface face_get_surface(occt_shape face, double* out_umin, double* out_umax, double* out_vmin, double* out_vmax) {
    clear_error();
    if (!face) { set_error("null face argument", 2); return nullptr; }
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface adaptor(f);
        *out_umin = adaptor.FirstUParameter();
        *out_umax = adaptor.LastUParameter();
        *out_vmin = adaptor.FirstVParameter();
        *out_vmax = adaptor.LastVParameter();
        Handle(Geom_Surface) surface = BRep_Tool::Surface(f);
        if (surface.IsNull()) { set_error("face has no surface"); return nullptr; }
        GeomSurfaceKind kind;
        if (surface->DynamicType() == STANDARD_TYPE(Geom_Plane))
            kind = SURFACE_PLANE;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_CylindricalSurface))
            kind = SURFACE_CYLINDRICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ConicalSurface))
            kind = SURFACE_CONICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_SphericalSurface))
            kind = SURFACE_SPHERICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ToroidalSurface))
            kind = SURFACE_TOROIDAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BezierSurface))
            kind = SURFACE_BEZIER;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BSplineSurface))
            kind = SURFACE_BSPLINE;
        else
            kind = SURFACE_BSPLINE;
        Handle(Geom_Surface)* h = new Handle(Geom_Surface)(surface);
        return alloc_surface(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

static double get_tolerance(const TopoDS_Shape& shape) {
    switch (shape.ShapeType()) {
        case TopAbs_EDGE: return BRep_Tool::Tolerance(TopoDS::Edge(shape));
        case TopAbs_FACE: return BRep_Tool::Tolerance(TopoDS::Face(shape));
        case TopAbs_VERTEX: return BRep_Tool::Tolerance(TopoDS::Vertex(shape));
        default: return 0.0;
    }
}

int shape_tolerance(occt_shape shape, double* out_tol) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        *out_tol = get_tolerance(*to_shape(shape));
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_natural_restriction(occt_shape face) {
    clear_error();
    if (!face) { set_error("null face argument", 2); return 0; }
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        return BRep_Tool::NaturalRestriction(f) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape shape_reversed(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Shape reversed = to_shape(shape)->Reversed();
        return from_shape(reversed);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

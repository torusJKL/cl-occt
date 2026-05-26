#include "occt_wrap_internal.h"
#include "occt_wrap_find_edges.h"
#include <TopTools_MapOfShape.hxx>

occt_shape* find_edges_by_type(occt_shape shape, int curve_type, int* out_count) {
    clear_error();
    if (!shape) { set_error("null shape", 2); if (out_count) *out_count = 0; return nullptr; }
    if (!out_count) { set_error("null out_count", 2); return nullptr; }
    *out_count = 0;
    try {
        GeomAbs_CurveType targetType = (GeomAbs_CurveType)curve_type;
        TopTools_MapOfShape edgeMap;
        TopExp_Explorer exp(*to_shape(shape), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            double f, l;
            Handle(Geom_Curve) c = BRep_Tool::Curve(TopoDS::Edge(exp.Current()), f, l);
            if (!c.IsNull()) {
                GeomAdaptor_Curve adaptor(c);
                if (adaptor.GetType() == targetType) {
                    edgeMap.Add(exp.Current());
                }
            }
        }
        int count = static_cast<int>(edgeMap.Extent());
        if (count == 0) return nullptr;
        occt_shape* result = new occt_shape[count];
        int i = 0;
        for (TopTools_MapOfShape::Iterator it(edgeMap); it.More(); it.Next(), i++) {
            result[i] = from_shape(it.Value());
        }
        *out_count = count;
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return nullptr;
    }
}

occt_shape* find_edges_by_radius(occt_shape shape, double radius, int* out_count) {
    clear_error();
    if (!shape) { set_error("null shape", 2); if (out_count) *out_count = 0; return nullptr; }
    if (!out_count) { set_error("null out_count", 2); return nullptr; }
    *out_count = 0;
    try {
        TopTools_MapOfShape edgeMap;
        double eps = Precision::Confusion();
        TopExp_Explorer exp(*to_shape(shape), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            double f, l;
            Handle(Geom_Curve) c = BRep_Tool::Curve(TopoDS::Edge(exp.Current()), f, l);
            if (!c.IsNull()) {
                GeomAdaptor_Curve adaptor(c);
                if (adaptor.GetType() == GeomAbs_Circle) {
                    Handle(Geom_Circle) circle = Handle(Geom_Circle)::DownCast(c);
                    if (!circle.IsNull()) {
                        double r = circle->Radius();
                        if (fabs(r - radius) < eps) {
                            edgeMap.Add(exp.Current());
                        }
                    }
                }
            }
        }
        int count = static_cast<int>(edgeMap.Extent());
        if (count == 0) return nullptr;
        occt_shape* result = new occt_shape[count];
        int i = 0;
        for (TopTools_MapOfShape::Iterator it(edgeMap); it.More(); it.Next(), i++) {
            result[i] = from_shape(it.Value());
        }
        *out_count = count;
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return nullptr;
    }
}

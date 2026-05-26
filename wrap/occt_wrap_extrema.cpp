#include "occt_wrap_internal.h"
#include "occt_wrap_extrema.h"
#include <BRepExtrema_ShapeProximity.hxx>
#include <BRepExtrema_SelfIntersection.hxx>
#include <BRepExtrema_DistShapeShape.hxx>
#include <NCollection_DataMap.hxx>
#include <BRepMesh_IncrementalMesh.hxx>

typedef NCollection_DataMap<int, TColStd_PackedMapOfInteger>::Iterator MapIterator;

static void ensure_mesh(const TopoDS_Shape& shape) {
    BRepMesh_IncrementalMesh mesh(shape, 0.5);
}

int shape_proximity(occt_shape shape1, occt_shape shape2, double tolerance,
                    double* out_value,
                    occt_shape* out_subshapes1, occt_shape* out_subshapes2, int max_results) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return 0; }
    try {
        ensure_mesh(*to_shape(shape1));
        ensure_mesh(*to_shape(shape2));
        BRepExtrema_ShapeProximity prox(*to_shape(shape1), *to_shape(shape2), tolerance);
        prox.Perform();
        if (!prox.IsDone()) { set_error("proximity computation failed"); return 0; }
        if (out_value) *out_value = prox.Proximity();
        const auto& map1 = prox.OverlapSubShapes1();
        const auto& map2 = prox.OverlapSubShapes2();
        int count1 = 0, count2 = 0;
        for (MapIterator it(map1); it.More() && count1 < max_results; it.Next(), ++count1) {
            if (out_subshapes1) out_subshapes1[count1] = new TopoDS_Shape(prox.GetSubShape1(it.Key()));
        }
        for (MapIterator it(map2); it.More() && count2 < max_results; it.Next(), ++count2) {
            if (out_subshapes2) out_subshapes2[count2] = new TopoDS_Shape(prox.GetSubShape2(it.Key()));
        }
        return (count1 < count2) ? count2 : count1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_overlap_p(occt_shape shape1, occt_shape shape2, double tolerance) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return 0; }
    try {
        ensure_mesh(*to_shape(shape1));
        ensure_mesh(*to_shape(shape2));
        BRepExtrema_ShapeProximity prox(*to_shape(shape1), *to_shape(shape2), tolerance);
        prox.Perform();
        if (!prox.IsDone()) return 0;
        return prox.OverlapSubShapes1().IsEmpty() ? 0 : 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_overlap_detail(occt_shape shape1, occt_shape shape2, double tolerance,
                         occt_shape* out_subshapes1, occt_shape* out_subshapes2, int max_results) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return 0; }
    try {
        ensure_mesh(*to_shape(shape1));
        ensure_mesh(*to_shape(shape2));
        BRepExtrema_ShapeProximity prox(*to_shape(shape1), *to_shape(shape2), tolerance);
        prox.Perform();
        if (!prox.IsDone()) return 0;
        const auto& map1 = prox.OverlapSubShapes1();
        const auto& map2 = prox.OverlapSubShapes2();
        int count1 = 0, count2 = 0;
        for (MapIterator it(map1); it.More() && count1 < max_results; it.Next(), ++count1) {
            if (out_subshapes1) out_subshapes1[count1] = new TopoDS_Shape(prox.GetSubShape1(it.Key()));
        }
        for (MapIterator it(map2); it.More() && count2 < max_results; it.Next(), ++count2) {
            if (out_subshapes2) out_subshapes2[count2] = new TopoDS_Shape(prox.GetSubShape2(it.Key()));
        }
        return (count1 < count2) ? count2 : count1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_self_intersect(occt_shape shape, double tolerance,
                         occt_shape* out_faces, int max_results) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        ensure_mesh(*to_shape(shape));
        BRepExtrema_SelfIntersection si(*to_shape(shape), tolerance);
        si.Perform();
        if (!si.IsDone()) return 0;
        const auto& overlap = si.OverlapElements();
        int count = 0;
        for (MapIterator it(overlap); it.More() && count < max_results; it.Next(), ++count) {
            if (out_faces) out_faces[count] = new TopoDS_Shape(si.GetSubShape(it.Key()));
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_distance(occt_shape face1, occt_shape face2,
                  double* out_min, double* out_max) {
    clear_error();
    if (!face1 || !face2 || !out_min || !out_max) { set_error("null argument", 2); return 0; }
    try {
        BRepExtrema_DistShapeShape extrema(*to_shape(face1), *to_shape(face2));
        if (!extrema.IsDone()) { set_error("distance computation failed"); return 0; }
        *out_min = extrema.Value();
        int n = extrema.NbSolution();
        double maxDist = *out_min;
        for (int i = 1; i <= n; i++) {
            double d = extrema.Value();
            if (d > maxDist) maxDist = d;
        }
        *out_max = maxDist;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

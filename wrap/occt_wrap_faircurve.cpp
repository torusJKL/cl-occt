#include "occt_wrap_internal.h"
#include "occt_wrap_faircurve.h"
#include <GeomAPI_PointsToBSpline.hxx>
#include <Geom_BSplineCurve.hxx>
#include <GeomConvert.hxx>

occt_curve fair_curve_batten(double* points, int num_points,
                              int free_end, int free_slide,
                              double* init_tangent, double* final_tangent) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        int deg = 3;
        NCollection_Array1<gp_Pnt> pts(1, num_points);
        for (int i = 0; i < num_points; i++)
            pts.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        GeomAPI_PointsToBSpline fitter(pts, deg, 3, GeomAbs_C2, 1.0e-3);
        Handle(Geom_BSplineCurve) curve = fitter.Curve();
        if (curve.IsNull()) { set_error("fair curve interpolation failed"); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(curve);
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve fair_curve_minvar(double* points, int num_points,
                              int free_end, int free_slide,
                              double* init_slope, double* final_slope) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        int deg = 3;
        NCollection_Array1<gp_Pnt> pts(1, num_points);
        for (int i = 0; i < num_points; i++)
            pts.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        GeomAPI_PointsToBSpline fitter(pts, deg, 3, GeomAbs_C2, 1.0e-3);
        Handle(Geom_BSplineCurve) curve = fitter.Curve();
        if (curve.IsNull()) { set_error("minvar curve interpolation failed"); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(curve);
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

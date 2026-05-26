#include "occt_wrap_internal.h"
#include "occt_wrap_gcpnts.h"
#include <GCPnts_UniformAbscissa.hxx>
#include <GCPnts_UniformDeflection.hxx>

int uniform_abscissa_points(occt_curve curve, double first, double last,
                            int num_points, double* out_coords) {
    clear_error();
    if (!curve) { set_error("null curve", 2); return 0; }
    if (num_points < 2) { set_error("num_points must be >= 2", 2); return 0; }
    if (!out_coords) { set_error("null output array", 2); return 0; }
    try {
        Handle(Geom_Curve) hCurve = *curve_handle(curve);
        if (hCurve.IsNull()) { set_error("null curve handle", 2); return 0; }
        GeomAdaptor_Curve adaptor(hCurve);
        GCPnts_UniformAbscissa algo(adaptor, num_points, first, last);
        if (!algo.IsDone()) { set_error("UniformAbscissa failed", 2); return 0; }
        int count = algo.NbPoints();
        for (int i = 1; i <= count; i++) {
            double param = algo.Parameter(i);
            gp_Pnt p = adaptor.Value(param);
            int idx = (i - 1) * 3;
            out_coords[idx] = p.X();
            out_coords[idx + 1] = p.Y();
            out_coords[idx + 2] = p.Z();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int uniform_deflection_points(occt_curve curve, double first, double last,
                              double deflection, double* out_coords) {
    clear_error();
    if (!curve) { set_error("null curve", 2); return 0; }
    if (deflection <= 0) { set_error("deflection must be positive", 2); return 0; }
    if (!out_coords) { set_error("null output array", 2); return 0; }
    try {
        Handle(Geom_Curve) hCurve = *curve_handle(curve);
        if (hCurve.IsNull()) { set_error("null curve handle", 2); return 0; }
        GeomAdaptor_Curve adaptor(hCurve);
        GCPnts_UniformDeflection algo(adaptor, deflection, first, last);
        if (!algo.IsDone()) { set_error("UniformDeflection failed", 2); return 0; }
        int count = algo.NbPoints();
        for (int i = 1; i <= count; i++) {
            double param = algo.Parameter(i);
            gp_Pnt p = adaptor.Value(param);
            int idx = (i - 1) * 3;
            out_coords[idx] = p.X();
            out_coords[idx + 1] = p.Y();
            out_coords[idx + 2] = p.Z();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

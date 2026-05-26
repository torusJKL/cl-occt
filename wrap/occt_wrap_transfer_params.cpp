#include "occt_wrap_internal.h"
#include "occt_wrap_transfer_params.h"
#include <ShapeAnalysis_TransferParameters.hxx>
#include <GeomAPI_ProjectPointOnCurve.hxx>

int transfer_params(occt_shape source_edge, occt_curve target_curve, double param, double* out_param) {
    clear_error();
    if (!source_edge) { set_error("null source edge", 2); return 0; }
    if (!target_curve) { set_error("null target curve", 2); return 0; }
    if (!out_param) { set_error("null output param", 2); return 0; }
    try {
        TopoDS_Edge edge = TopoDS::Edge(*to_shape(source_edge));
        Handle(Geom_Curve) hCurve = *curve_handle(target_curve);
        if (hCurve.IsNull()) { set_error("null curve handle", 2); return 0; }
        double f, l;
        Handle(Geom_Curve) edgeCurve = BRep_Tool::Curve(edge, f, l);
        if (edgeCurve.IsNull()) { set_error("edge has no 3D curve", 2); return 0; }
        double ratio = 1.0;
        if (edgeCurve != hCurve) {
            gp_Pnt p;
            edgeCurve->D0(param, p);
            GeomAdaptor_Curve targetAdaptor(hCurve);
            GeomAPI_ProjectPointOnCurve proj(p, targetAdaptor.Curve());
            if (proj.NbPoints() > 0) {
                ratio = proj.LowerDistanceParameter();
            }
        } else {
            ratio = param;
        }
        *out_param = ratio;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

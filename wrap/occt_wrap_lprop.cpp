#include "occt_wrap_internal.h"
#include "occt_wrap_lprop.h"
#include <GeomLProp_CLProps.hxx>
#include <GeomLProp_SLProps.hxx>

int curve_tangent_at(occt_curve curve, double param,
                     double* out_tx, double* out_ty, double* out_tz) {
    clear_error();
    if (!curve || !out_tx || !out_ty || !out_tz) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Curve) c = *curve_handle(curve);
        GeomLProp_CLProps props(c, 1, Precision::Confusion());
        props.SetParameter(param);
        if (!props.IsTangentDefined()) { set_error("tangent not defined at this parameter"); return 0; }
        gp_Dir tanDir;
        props.Tangent(tanDir);
        *out_tx = tanDir.X();
        *out_ty = tanDir.Y();
        *out_tz = tanDir.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int curve_curvature_at(occt_curve curve, double param, double* out_k) {
    clear_error();
    if (!curve || !out_k) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Curve) c = *curve_handle(curve);
        GeomLProp_CLProps props(c, 2, Precision::Confusion());
        props.SetParameter(param);
        *out_k = props.Curvature();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int surface_normal_at(occt_surface surface, double u, double v,
                      double* out_nx, double* out_ny, double* out_nz) {
    clear_error();
    if (!surface || !out_nx || !out_ny || !out_nz) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Surface) s = *surface_handle(surface);
        GeomLProp_SLProps props(s, 1, Precision::Confusion());
        props.SetParameters(u, v);
        if (!props.IsNormalDefined()) { set_error("normal not defined at this UV"); return 0; }
        const gp_Dir& norm = props.Normal();
        *out_nx = norm.X();
        *out_ny = norm.Y();
        *out_nz = norm.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int surface_curvature_at(occt_surface surface, double u, double v,
                         double* out_min_k, double* out_max_k) {
    clear_error();
    if (!surface || !out_min_k || !out_max_k) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Surface) s = *surface_handle(surface);
        GeomLProp_SLProps props(s, 2, Precision::Confusion());
        props.SetParameters(u, v);
        *out_min_k = props.MinCurvature();
        *out_max_k = props.MaxCurvature();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

#include "occt_wrap_internal.h"
#include "occt_wrap_geom_eval.h"
#include <Geom_Curve.hxx>
#include <Geom_Surface.hxx>
#include <gp_Pnt.hxx>

int curve_value(occt_curve curve, double t, double* out_x, double* out_y, double* out_z) {
    clear_error();
    if (!curve) { set_error("null curve argument", 2); return 0; }
    try {
        Handle(Geom_Curve) h = *curve_handle(curve);
        if (h.IsNull()) { set_error("curve handle is null"); return 0; }
        gp_Pnt p = h->Value(t);
        *out_x = p.X();
        *out_y = p.Y();
        *out_z = p.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int surface_value(occt_surface surface, double u, double v, double* out_x, double* out_y, double* out_z) {
    clear_error();
    if (!surface) { set_error("null surface argument", 2); return 0; }
    try {
        Handle(Geom_Surface) h = *surface_handle(surface);
        if (h.IsNull()) { set_error("surface handle is null"); return 0; }
        gp_Pnt p = h->Value(u, v);
        *out_x = p.X();
        *out_y = p.Y();
        *out_z = p.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

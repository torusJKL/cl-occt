#include "occt_wrap_internal.h"
#include "occt_wrap_geomplate.h"
#include <GeomPlate_BuildPlateSurface.hxx>
#include <GeomPlate_CurveConstraint.hxx>
#include <GeomPlate_MakeApprox.hxx>
#include <GeomAdaptor_Curve.hxx>

occt_surface fill_surface_from_curves(occt_curve* curves, int num_curves,
                                       int continuity,
                                       occt_shape* support_faces, int num_support_faces) {
    clear_error();
    if (!curves || num_curves < 3) { set_error("need at least 3 curves", 2); return nullptr; }
    try {
        (void)support_faces;
        (void)num_support_faces;
        GeomPlate_BuildPlateSurface builder(3, 15, 3, 0.00001, 0.0001, 0.01, 0.1);
        for (int i = 0; i < num_curves; i++) {
            if (!curves[i]) { set_error("null curve in array", 2); return nullptr; }
            Handle(Geom_Curve) gc = *curve_handle(curves[i]);
            Handle(GeomAdaptor_Curve) adaptor = new GeomAdaptor_Curve(gc);
            Handle(GeomPlate_CurveConstraint) constraint =
                new GeomPlate_CurveConstraint(adaptor, continuity, 25, 0.001, 0.01, 0.1);
            builder.Add(constraint);
        }
        builder.Perform();
        if (!builder.IsDone()) { set_error("GeomPlate surface building failed"); return nullptr; }
        Handle(GeomPlate_Surface) plateSurf = builder.Surface();
        if (plateSurf.IsNull()) { set_error("null plate surface result"); return nullptr; }
        GeomPlate_MakeApprox approx(plateSurf, 0.001, 100, 8, 0.001, 0, GeomAbs_C1, 1.1);
        Handle(Geom_BSplineSurface) bsplSurf = approx.Surface();
        if (bsplSurf.IsNull()) { set_error("null approximated surface"); return nullptr; }
        Handle(Geom_BSplineSurface)* h = new Handle(Geom_BSplineSurface)(bsplSurf);
        return alloc_surface(SURFACE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

#include "occt_wrap_internal.h"
#include "occt_wrap_helix.h"

occt_curve make_helix_curve(double radius, double pitch, double height,
                            int left_handed, double angle) {
    clear_error();
    if (radius < Precision::Confusion() || pitch < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive parameter", 2); return nullptr;
    }
    try {
        double totalAngle = (height / pitch) * 2.0 * M_PI;
        double taperAngle = angle * M_PI / 180.0;
        HelixGeom_BuilderHelix builder;
        builder.SetPosition(gp_Ax2(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1)));
        builder.SetCurveParameters(0.0, totalAngle, pitch, radius, taperAngle, left_handed != 0);
        builder.SetApproxParameters(GeomAbs_C1, 8, 100);
        builder.SetTolerance(Precision::Confusion());
        builder.Perform();
        if (builder.ErrorStatus() != 0) { set_error("helix curve construction failed"); return nullptr; }
        const auto& curves = builder.Curves();
        if (curves.Size() < 1) { set_error("helix produced no curves"); return nullptr; }
        Handle(Geom_Curve) curve = curves.First();
        if (curve.IsNull()) { set_error("helix curve is null"); return nullptr; }
        Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
        return alloc_curve(CURVE_HELIX, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_shape make_helix_edge(double radius, double pitch, double height,
                           int left_handed, double angle,
                           occt_surface on_surface) {
    clear_error();
    if (radius < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive parameter", 2); return nullptr;
    }
    if (fabs(pitch) < Precision::Confusion()) {
        set_error("pitch too small", 2); return nullptr;
    }
    (void)on_surface; // surface constraint for future use
    try {
        gp_Ax3 axis(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1));
        double effectivePitch = left_handed ? -fabs(pitch) : fabs(pitch);
        NCollection_Array1<double> pitches(1, 1);
        pitches(1) = effectivePitch;
        NCollection_Array1<double> nbTurns(1, 1);
        nbTurns(1) = height / fabs(pitch);

        HelixBRep_BuilderHelix builder;
        builder.SetParameters(axis, 2.0 * radius, nbTurns, pitches);
        builder.Perform();
        if (builder.ErrorStatus() != 0) { set_error("helix edge construction failed"); return nullptr; }
        const TopoDS_Shape& shape = builder.Shape();
        if (shape.IsNull()) { set_error("helix edge is null"); return nullptr; }
        return from_shape(shape);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}


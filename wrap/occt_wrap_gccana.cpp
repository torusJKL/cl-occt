#include "occt_wrap_internal.h"
#include "occt_wrap_gccana.h"
#include <GccAna_Circ2d2TanRad.hxx>
#include <GccAna_Lin2d2Tan.hxx>
#include <GccEnt_QualifiedLin.hxx>
#include <GccEnt.hxx>
#include <gp_Lin2d.hxx>
#include <gp_Circ2d.hxx>
#include <gp_Pnt2d.hxx>
#include <gp_Dir2d.hxx>

int gccana_circle_tangent_two_lines(
    double x1, double y1, double dx1, double dy1,
    double x2, double y2, double dx2, double dy2,
    double radius,
    double* out_circles, int max_circles, int* out_count) {
    clear_error();
    if (!out_circles || !out_count) { set_error("null output", 2); return 0; }
    if (radius <= 0) { set_error("radius must be positive", 2); return 0; }
    try {
        gp_Lin2d line1(gp_Pnt2d(x1, y1), gp_Dir2d(dx1, dy1));
        gp_Lin2d line2(gp_Pnt2d(x2, y2), gp_Dir2d(dx2, dy2));
        GccAna_Circ2d2TanRad solver(
            GccEnt::Unqualified(line1),
            GccEnt::Unqualified(line2),
            radius, Precision::Confusion());
        if (!solver.IsDone()) { *out_count = 0; return 1; }
        int n = solver.NbSolutions();
        if (n > max_circles) n = max_circles;
        for (int i = 0; i < n; i++) {
            gp_Circ2d c = solver.ThisSolution(i + 1);
            int idx = i * 3;
            out_circles[idx]     = c.Location().X();
            out_circles[idx + 1] = c.Location().Y();
            out_circles[idx + 2] = c.Radius();
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int gccana_line_through_two_points(
    double x1, double y1,
    double x2, double y2,
    double* out_params) {
    clear_error();
    if (!out_params) { set_error("null output", 2); return 0; }
    try {
        double ex = x2 - x1;
        double ey = y2 - y1;
        double len = std::sqrt(ex * ex + ey * ey);
        if (len < Precision::Confusion()) { set_error("coincident points", 2); return 0; }
        out_params[0] = x1;
        out_params[1] = y1;
        out_params[2] = ex / len;
        out_params[3] = ey / len;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

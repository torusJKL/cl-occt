#include "occt_wrap_internal.h"
#include "occt_wrap_math_inttools.h"

namespace {
    class MathObjAdapter : public math_MultipleVarFunctionWithGradient {
    public:
        MathObjAdapter(int n, double (*fn)(int, const double*))
            : myFn(fn), myN(n) {}
        bool Value(const math_Vector& X, double& F) override {
            double* x = new double[myN];
            for (int i = 0; i < myN; i++) x[i] = X(i + 1);
            F = myFn(myN, x);
            delete[] x;
            return true;
        }
        bool Gradient(const math_Vector& X, math_Vector& G) override {
            for (int i = 0; i < myN; i++) {
                double xi = X(i + 1);
                double h = (std::abs(xi) > 1.0e-8) ? 1.0e-8 * std::abs(xi) : 1.0e-8;
                double* xp = new double[myN];
                double* xm = new double[myN];
                for (int j = 0; j < myN; j++) { xp[j] = X(j + 1); xm[j] = X(j + 1); }
                xp[i] = xi + h; xm[i] = xi - h;
                G(i + 1) = (myFn(myN, xp) - myFn(myN, xm)) / (2.0 * h);
                delete[] xp; delete[] xm;
            }
            return true;
        }
        bool Values(const math_Vector& X, double& F, math_Vector& G) override {
            Value(X, F);
            Gradient(X, G);
            return true;
        }
        int NbVariables() const override { return myN; }
    private:
        double (*myFn)(int, const double*);
        int myN;
    };
}

int math_bfgs_minimize(double (*fn)(int, const double*), int n_vars,
                       double* initial, double tolerance, int max_iter,
                       double* out_minimizer, double* out_min_value,
                       int* out_iterations) {
    clear_error();
    if (!fn || n_vars <= 0 || !initial) return 0;
    try {
        math_Vector X(1, n_vars);
        for (int i = 0; i < n_vars; i++) X(i + 1) = initial[i];
        MathObjAdapter adapter(n_vars, fn);
        math_BFGS bfgs(n_vars, tolerance, max_iter);
        bfgs.Perform(adapter, X);
        if (!bfgs.IsDone()) return 0;
        const math_Vector& sol = bfgs.Location();
        for (int i = 0; i < n_vars; i++) out_minimizer[i] = sol(i + 1);
        if (out_min_value) *out_min_value = bfgs.Minimum();
        if (out_iterations) *out_iterations = bfgs.NbIterations();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int math_frpr_minimize(double (*fn)(int, const double*), int n_vars,
                       double* initial, double tolerance, int max_iter,
                       double* out_minimizer, double* out_min_value,
                       int* out_iterations) {
    clear_error();
    if (!fn || n_vars <= 0 || !initial) return 0;
    try {
        math_Vector X(1, n_vars);
        for (int i = 0; i < n_vars; i++) X(i + 1) = initial[i];
        MathObjAdapter adapter(n_vars, fn);
        math_FRPR frpr(adapter, tolerance, max_iter);
        frpr.Perform(adapter, X);
        if (!frpr.IsDone()) return 0;
        const math_Vector& sol = frpr.Location();
        for (int i = 0; i < n_vars; i++) out_minimizer[i] = sol(i + 1);
        if (out_min_value) *out_min_value = frpr.Minimum();
        if (out_iterations) *out_iterations = frpr.NbIterations();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int math_pso_minimize(double (*fn)(int, const double*), int n_vars,
                      double* lower, double* upper,
                      double* initial, int n_particles, int max_iter,
                      double tolerance,
                      double* out_minimizer, double* out_min_value,
                      int* out_iterations) {
    clear_error();
    if (!fn || n_vars <= 0 || !lower || !upper) return 0;
    try {
        math_Vector low(1, n_vars), upp(1, n_vars);
        for (int i = 0; i < n_vars; i++) { low(i + 1) = lower[i]; upp(i + 1) = upper[i]; }
        MathObjAdapter adapter(n_vars, fn);
        math_Vector steps(1, n_vars);
        for (int i = 0; i < n_vars; i++) steps(i + 1) = (upper[i] - lower[i]) * 0.1;
        math_PSO pso(&adapter, low, upp, steps, n_particles, max_iter);
        double min_val = 0.0;
        math_Vector result(1, n_vars);
        pso.Perform(steps, min_val, result, max_iter);
        for (int i = 0; i < n_vars; i++) out_minimizer[i] = result(i + 1);
        if (out_min_value) *out_min_value = min_val;
        if (out_iterations) *out_iterations = 0;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int math_globoptmin_minimize(double (*fn)(int, const double*), int n_vars,
                             double* lower, double* upper,
                             double tolerance, int max_iter,
                             double* out_minimizer, double* out_min_value,
                             int* out_iterations) {
    clear_error();
    if (!fn || n_vars <= 0 || !lower || !upper) return 0;
    try {
        math_Vector low(1, n_vars), upp(1, n_vars);
        for (int i = 0; i < n_vars; i++) { low(i + 1) = lower[i]; upp(i + 1) = upper[i]; }
        MathObjAdapter adapter(n_vars, fn);
        math_GlobOptMin gom(&adapter, low, upp, tolerance, tolerance);
        gom.Perform();
        if (gom.NbExtrema() == 0) return 0;
        math_Vector sol(1, n_vars);
        gom.Points(1, sol);
        for (int i = 0; i < n_vars; i++) out_minimizer[i] = sol(i + 1);
        // Compute function value at solution
        double min_val = 0.0;
        adapter.Value(sol, min_val);
        if (out_min_value) *out_min_value = min_val;
        if (out_iterations) *out_iterations = 0;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}


int inttools_edge_edge(void* edge1, void* edge2,
                       double* out_points, int max_points,
                       int* out_count) {
    clear_error();
    if (!edge1 || !edge2 || !out_points || !out_count) return 0;
    try {
        const TopoDS_Edge& e1 = *static_cast<const TopoDS_Edge*>(edge1);
        const TopoDS_Edge& e2 = *static_cast<const TopoDS_Edge*>(edge2);
        IntTools_EdgeEdge ee;
        ee.SetEdge1(e1);
        ee.SetEdge2(e2);
        ee.Perform();
        if (!ee.IsDone()) return 0;
        const NCollection_Sequence<IntTools_CommonPrt>& parts = ee.CommonParts();
        int n = 0;
        for (int i = 1; i <= parts.Length() && n < max_points; i++) {
            const IntTools_CommonPrt& cp = parts.Value(i);
            if (cp.Type() == TopAbs_VERTEX) {
                eval_edge_point(e1, cp.VertexParameter1(), out_points, n);
                n++;
            } else {
                gp_Pnt p1, p2;
                cp.BoundingPoints(p1, p2);
                if (n < max_points) {
                    out_points[n * 3] = p1.X();
                    out_points[n * 3 + 1] = p1.Y();
                    out_points[n * 3 + 2] = p1.Z();
                    n++;
                }
            }
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int inttools_edge_face(void* edge, void* face,
                       double* out_points, int max_points,
                       int* out_count) {
    clear_error();
    if (!edge || !face || !out_points || !out_count) return 0;
    try {
        const TopoDS_Edge& e = *static_cast<const TopoDS_Edge*>(edge);
        const TopoDS_Face& f = *static_cast<const TopoDS_Face*>(face);
        IntTools_EdgeFace ef;
        ef.SetEdge(e);
        ef.SetFace(f);
        ef.SetFuzzyValue(Precision::Confusion());
        ef.Perform();
        if (!ef.IsDone()) {
            // EdgeFace may fail for certain configurations. Return gracefully.
            *out_count = 0;
            return 1;
        }
        const NCollection_Sequence<IntTools_CommonPrt>& parts = ef.CommonParts();
        int n = 0;
        for (int i = 1; i <= parts.Length() && n < max_points; i++) {
            const IntTools_CommonPrt& cp = parts.Value(i);
            if (cp.Type() == TopAbs_VERTEX) {
                eval_edge_point(e, cp.VertexParameter1(), out_points, n);
                n++;
            } else {
                gp_Pnt p1, p2;
                cp.BoundingPoints(p1, p2);
                if (n < max_points) {
                    out_points[n * 3] = p1.X();
                    out_points[n * 3 + 1] = p1.Y();
                    out_points[n * 3 + 2] = p1.Z();
                    n++;
                }
            }
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int inttools_face_face(void* face1, void* face2,
                       double* out_points, int max_points,
                       int* out_point_count,
                       void** out_curves, int max_curves,
                       int* out_curve_count) {
    clear_error();
    if (!face1 || !face2) return 0;
    try {
        const TopoDS_Face& f1 = *static_cast<const TopoDS_Face*>(face1);
        const TopoDS_Face& f2 = *static_cast<const TopoDS_Face*>(face2);
        IntTools_FaceFace ff;
        ff.Perform(f1, f2, false);
        if (!ff.IsDone()) return 0;

        // Return intersection curves
        const NCollection_Sequence<IntTools_Curve>& curves = ff.Lines();
        int nc = curves.Length();
        if (out_curves && out_curve_count) {
            if (nc > max_curves) nc = max_curves;
            for (int i = 0; i < nc; i++) {
                const Handle(Geom_Curve)& c3d = curves.Value(i + 1).Curve();
                if (!c3d.IsNull()) {
                    out_curves[i] = new Handle(Geom_Curve)(c3d);
                } else {
                    out_curves[i] = nullptr;
                }
            }
            *out_curve_count = nc;
        }

        // Return intersection points
        const NCollection_Sequence<IntTools_PntOn2Faces>& pts = ff.Points();
        int np = pts.Length();
        if (out_points && out_point_count) {
            if (np > max_points) np = max_points;
            for (int i = 0; i < np; i++) {
                const IntTools_PntOnFace& pf = pts.Value(i + 1).P1();
                gp_Pnt p = pf.Pnt();
                out_points[i * 3] = p.X();
                out_points[i * 3 + 1] = p.Y();
                out_points[i * 3 + 2] = p.Z();
            }
            *out_point_count = np;
        }

        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

void inttools_free_curve(void* curve) {
    if (!curve) return;
    delete static_cast<Handle(Geom_Curve)*>(curve);
}


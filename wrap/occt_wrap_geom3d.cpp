#include "occt_wrap_internal.h"
#include "occt_wrap_geom3d.h"



occt_curve make_line_3d(double ox, double oy, double oz, double dx, double dy, double dz) {
    clear_error();
    double mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (mag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        Handle(Geom_Line)* h = new Handle(Geom_Line)(new Geom_Line(get_pnt(ox, oy, oz), get_dir(dx, dy, dz)));
        return alloc_curve(CURVE_LINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_circle_3d(double ox, double oy, double oz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Circle)* h = new Handle(Geom_Circle)(new Geom_Circle(ax, radius));
        return alloc_curve(CURVE_CIRCLE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_ellipse_3d(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Ellipse)* h = new Handle(Geom_Ellipse)(new Geom_Ellipse(ax, major_r, minor_r));
        return alloc_curve(CURVE_ELLIPSE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_hyperbola(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Hyperbola)* h = new Handle(Geom_Hyperbola)(new Geom_Hyperbola(ax, major_r, minor_r));
        return alloc_curve(CURVE_HYPERBOLA, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_parabola(double ox, double oy, double oz, double focal) {
    clear_error();
    if (focal < Precision::Confusion()) { set_error("non-positive focal length", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Parabola)* h = new Handle(Geom_Parabola)(new Geom_Parabola(ax, focal));
        return alloc_curve(CURVE_PARABOLA, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_bezier_curve(double* points, int num_points) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        NCollection_Array1<gp_Pnt> arr(1, num_points);
        for (int i = 0; i < num_points; i++)
            arr.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        Handle(Geom_BezierCurve)* h = new Handle(Geom_BezierCurve)(new Geom_BezierCurve(arr));
        return alloc_curve(CURVE_BEZIER, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_bspline_curve(double* poles, int num_poles, double* knots, int* mults, int num_knots, int degree) {
    clear_error();
    if (!poles || num_poles < 2 || !knots || !mults || num_knots < 2 || degree < 1) { set_error("invalid bspline parameters", 2); return nullptr; }
    try {
        NCollection_Array1<gp_Pnt> poleArr(1, num_poles);
        for (int i = 0; i < num_poles; i++)
            poleArr.SetValue(i + 1, gp_Pnt(poles[i * 3], poles[i * 3 + 1], poles[i * 3 + 2]));
        NCollection_Array1<double> knotArr(1, num_knots);
        NCollection_Array1<int> multArr(1, num_knots);
        for (int i = 0; i < num_knots; i++) {
            knotArr.SetValue(i + 1, knots[i]);
            multArr.SetValue(i + 1, mults[i]);
        }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(new Geom_BSplineCurve(poleArr, knotArr, multArr, degree));
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void free_curve(occt_curve c) {
    if (!c) return;
    OccctCurve* oc = static_cast<OccctCurve*>(c);
    switch (oc->kind) {
        case CURVE_LINE:        delete static_cast<Handle(Geom_Line)*>(oc->handle); break;
        case CURVE_CIRCLE:      delete static_cast<Handle(Geom_Circle)*>(oc->handle); break;
        case CURVE_ELLIPSE:     delete static_cast<Handle(Geom_Ellipse)*>(oc->handle); break;
        case CURVE_HYPERBOLA:   delete static_cast<Handle(Geom_Hyperbola)*>(oc->handle); break;
        case CURVE_PARABOLA:    delete static_cast<Handle(Geom_Parabola)*>(oc->handle); break;
        case CURVE_BEZIER:      delete static_cast<Handle(Geom_BezierCurve)*>(oc->handle); break;
        case CURVE_BSPLINE:     delete static_cast<Handle(Geom_BSplineCurve)*>(oc->handle); break;
        case CURVE_GC_LINE:
        case CURVE_GC_ARC_CIRCLE: delete static_cast<Handle(Geom_TrimmedCurve)*>(oc->handle); break;
        case CURVE_HELIX:       delete static_cast<Handle(Geom_Curve)*>(oc->handle); break;
    }
    delete oc;
}

int curve_type(occt_curve c) {
    if (!c) return -1;
    return static_cast<OccctCurve*>(c)->kind;
}

occt_curve make_gc_line(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        GC_MakeSegment maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2));
        if (!maker.IsDone()) { set_error("GC_MakeSegment failed"); return nullptr; }
        Handle(Geom_TrimmedCurve)* h = new Handle(Geom_TrimmedCurve)(maker.Value());
        return alloc_curve(CURVE_GC_LINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_gc_arc_of_circle(double x1, double y1, double z1,
                                  double x2, double y2, double z2,
                                  double x3, double y3, double z3) {
    clear_error();
    try {
        GC_MakeArcOfCircle maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2), gp_Pnt(x3, y3, z3));
        if (!maker.IsDone()) { set_error("GC_MakeArcOfCircle failed"); return nullptr; }
        Handle(Geom_TrimmedCurve)* h = new Handle(Geom_TrimmedCurve)(maker.Value());
        return alloc_curve(CURVE_GC_ARC_CIRCLE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve convert_curve_to_bspline(occt_curve c) {
    clear_error();
    if (!c) { set_error("null curve", 2); return nullptr; }
    try {
        Handle(Geom_Curve) gc = *curve_handle(c);
        Handle(Geom_BSplineCurve) bs = GeomConvert::CurveToBSplineCurve(gc);
        if (bs.IsNull()) { set_error("curve conversion failed"); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(bs);
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

int curve_bounding_box(occt_curve c,
                       double* xmin, double* ymin, double* zmin,
                       double* xmax, double* ymax, double* zmax) {
    clear_error();
    if (!c || !xmin || !ymin || !zmin || !xmax || !ymax || !zmax) { set_error("null argument", 2); return 0; }
    try {
        Bnd_Box box;
        GeomAdaptor_Curve adaptor(*curve_handle(c));
        BndLib_Add3dCurve::Add(adaptor, Precision::Confusion(), box);
        if (box.IsVoid()) return 0;
        box.Get(*xmin, *ymin, *zmin, *xmax, *ymax, *zmax);
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

// --- 3D Surface types ---





occt_surface make_plane(double ox, double oy, double oz, double nx, double ny, double nz) {
    clear_error();
    double nmag = sqrt(nx*nx + ny*ny + nz*nz);
    if (nmag < Precision::Confusion()) { set_error("zero normal vector", 2); return nullptr; }
    try {
        Handle(Geom_Plane)* h = new Handle(Geom_Plane)(new Geom_Plane(get_pnt(ox, oy, oz), get_dir(nx, ny, nz)));
        return alloc_surface(SURFACE_PLANE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_cylindrical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    double dmag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dmag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), get_dir(dx, dy, dz));
        Handle(Geom_CylindricalSurface)* h = new Handle(Geom_CylindricalSurface)(new Geom_CylindricalSurface(ax3, radius));
        return alloc_surface(SURFACE_CYLINDRICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_conical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius, double semi_angle) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    double dmag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dmag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), get_dir(dx, dy, dz));
        Handle(Geom_ConicalSurface)* h = new Handle(Geom_ConicalSurface)(new Geom_ConicalSurface(ax3, semi_angle * M_PI / 180.0, radius));
        return alloc_surface(SURFACE_CONICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_spherical_surface(double ox, double oy, double oz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_SphericalSurface)* h = new Handle(Geom_SphericalSurface)(new Geom_SphericalSurface(ax3, radius));
        return alloc_surface(SURFACE_SPHERICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_toroidal_surface(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_ToroidalSurface)* h = new Handle(Geom_ToroidalSurface)(new Geom_ToroidalSurface(ax3, major_r, minor_r));
        return alloc_surface(SURFACE_TOROIDAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_bezier_surface(double* poles, int num_u, int num_v) {
    clear_error();
    if (!poles || num_u < 2 || num_v < 2) { set_error("need at least 2x2 poles", 2); return nullptr; }
    try {
        NCollection_Array2<gp_Pnt> arr(1, num_u, 1, num_v);
        for (int u = 0; u < num_u; u++)
            for (int v = 0; v < num_v; v++) {
                int idx = (u * num_v + v) * 3;
                arr.SetValue(u + 1, v + 1, gp_Pnt(poles[idx], poles[idx + 1], poles[idx + 2]));
            }
        Handle(Geom_BezierSurface)* h = new Handle(Geom_BezierSurface)(new Geom_BezierSurface(arr));
        return alloc_surface(SURFACE_BEZIER, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_bspline_surface(double* poles, int num_u_poles, int num_v_poles,
                                   double* uknots, int* umults, int num_uknots,
                                   double* vknots, int* vmults, int num_vknots,
                                   int udeg, int vdeg) {
    clear_error();
    if (!poles || num_u_poles < 2 || num_v_poles < 2) { set_error("need at least 2x2 poles", 2); return nullptr; }
    if (!uknots || !umults || num_uknots < 2 || !vknots || !vmults || num_vknots < 2) { set_error("invalid knot data", 2); return nullptr; }
    if (udeg < 1 || vdeg < 1) { set_error("degree must be >= 1", 2); return nullptr; }
    try {
        NCollection_Array2<gp_Pnt> poleArr(1, num_u_poles, 1, num_v_poles);
        for (int u = 0; u < num_u_poles; u++)
            for (int v = 0; v < num_v_poles; v++) {
                int idx = (u * num_v_poles + v) * 3;
                poleArr.SetValue(u + 1, v + 1, gp_Pnt(poles[idx], poles[idx + 1], poles[idx + 2]));
            }
        NCollection_Array1<double> uKnotArr(1, num_uknots);
        NCollection_Array1<int> uMultArr(1, num_uknots);
        for (int i = 0; i < num_uknots; i++) { uKnotArr.SetValue(i + 1, uknots[i]); uMultArr.SetValue(i + 1, umults[i]); }
        NCollection_Array1<double> vKnotArr(1, num_vknots);
        NCollection_Array1<int> vMultArr(1, num_vknots);
        for (int i = 0; i < num_vknots; i++) { vKnotArr.SetValue(i + 1, vknots[i]); vMultArr.SetValue(i + 1, vmults[i]); }
        Handle(Geom_BSplineSurface)* h = new Handle(Geom_BSplineSurface)(new Geom_BSplineSurface(poleArr, uKnotArr, vKnotArr, uMultArr, vMultArr, udeg, vdeg));
        return alloc_surface(SURFACE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void free_surface(occt_surface s) {
    if (!s) return;
    OccctSurface* os = static_cast<OccctSurface*>(s);
    switch (os->kind) {
        case SURFACE_PLANE:        delete static_cast<Handle(Geom_Plane)*>(os->handle); break;
        case SURFACE_CYLINDRICAL:  delete static_cast<Handle(Geom_CylindricalSurface)*>(os->handle); break;
        case SURFACE_CONICAL:      delete static_cast<Handle(Geom_ConicalSurface)*>(os->handle); break;
        case SURFACE_SPHERICAL:    delete static_cast<Handle(Geom_SphericalSurface)*>(os->handle); break;
        case SURFACE_TOROIDAL:     delete static_cast<Handle(Geom_ToroidalSurface)*>(os->handle); break;
        case SURFACE_BEZIER:       delete static_cast<Handle(Geom_BezierSurface)*>(os->handle); break;
        case SURFACE_BSPLINE:      delete static_cast<Handle(Geom_BSplineSurface)*>(os->handle); break;
    }
    delete os;
}

int surface_type(occt_surface s) {
    if (!s) return -1;
    return static_cast<OccctSurface*>(s)->kind;
}

occt_surface convert_surface_to_bspline(occt_surface s) {
    clear_error();
    if (!s) { set_error("null surface", 2); return nullptr; }
    try {
        Handle(Geom_Surface) gs = *surface_handle(s);
        Handle(Geom_BSplineSurface) bs = GeomConvert::SurfaceToBSplineSurface(gs);
        if (bs.IsNull()) { set_error("surface conversion failed"); return nullptr; }
        Handle(Geom_BSplineSurface)* h = new Handle(Geom_BSplineSurface)(bs);
        return alloc_surface(SURFACE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

int surface_bounding_box(occt_surface s,
                         double* xmin, double* ymin, double* zmin,
                         double* xmax, double* ymax, double* zmax) {
    clear_error();
    if (!s || !xmin || !ymin || !zmin || !xmax || !ymax || !zmax) { set_error("null argument", 2); return 0; }
    try {
        GeomBndLib_Surface bnd(*surface_handle(s));
        Bnd_Box box = bnd.Box(Precision::Confusion());
        if (box.IsVoid()) return 0;
        box.Get(*xmin, *ymin, *zmin, *xmax, *ymax, *zmax);
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

// --- Geometric Algorithms ---

int project_point_on_curve(occt_curve c,
                           double px, double py, double pz,
                           double* out_x, double* out_y, double* out_z,
                           double* out_dist, double* out_param) {
    clear_error();
    if (!c || !out_x || !out_y || !out_z || !out_dist || !out_param) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ProjectPointOnCurve proj(gp_Pnt(px, py, pz), *curve_handle(c));
        if (!proj.NbPoints()) return 0;
        gp_Pnt p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y(); *out_z = p.Z();
        *out_dist = proj.LowerDistance();
        *out_param = proj.LowerDistanceParameter();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int project_point_on_surface(occt_surface s,
                             double px, double py, double pz,
                             double* out_x, double* out_y, double* out_z,
                             double* out_u, double* out_v, double* out_dist) {
    clear_error();
    if (!s || !out_x || !out_y || !out_z || !out_u || !out_v || !out_dist) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ProjectPointOnSurf proj(gp_Pnt(px, py, pz), *surface_handle(s));
        if (!proj.NbPoints()) return 0;
        gp_Pnt p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y(); *out_z = p.Z();
        proj.LowerDistanceParameters(*out_u, *out_v);
        *out_dist = proj.LowerDistance();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_curves(occt_curve c1, occt_curve c2,
                     double* out_points, int max_points) {
    clear_error();
    if (!c1 || !c2 || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        BRepBuilderAPI_MakeEdge edgeMaker1(*curve_handle(c1));
        BRepBuilderAPI_MakeEdge edgeMaker2(*curve_handle(c2));
        if (!edgeMaker1.IsDone() || !edgeMaker2.IsDone()) { set_error("failed to create edges", 2); return 0; }
        const TopoDS_Edge& e1 = edgeMaker1.Edge();
        const TopoDS_Edge& e2 = edgeMaker2.Edge();
        BRepExtrema_ExtCC extrema(e1, e2);
        if (!extrema.IsDone()) return 0;
        if (extrema.IsParallel()) return 0;
        int n = extrema.NbExt();
        int count = 0;
        for (int i = 1; i <= n && (count < max_points || max_points == 0); i++) {
            gp_Pnt p1 = extrema.PointOnE1(i);
            gp_Pnt p2 = extrema.PointOnE2(i);
            double dist = p1.Distance(p2);
            if (dist < Precision::Confusion()) {
                if (out_points && count < max_points) {
                    out_points[count * 3] = p1.X();
                    out_points[count * 3 + 1] = p1.Y();
                    out_points[count * 3 + 2] = p1.Z();
                }
                count++;
            }
        }
        return count;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_curve_surface(occt_curve c, occt_surface s,
                            double* out_points, int max_points) {
    clear_error();
    if (!c || !s || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_IntCS intersector(*curve_handle(c), *surface_handle(s));
        if (!intersector.NbPoints()) return 0;
        int n = intersector.NbPoints();
        if (out_points && max_points > 0) {
            int count = (n < max_points) ? n : max_points;
            for (int i = 0; i < count; i++) {
                gp_Pnt p = intersector.Point(i + 1);
                out_points[i * 3] = p.X();
                out_points[i * 3 + 1] = p.Y();
                out_points[i * 3 + 2] = p.Z();
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_surfaces(occt_surface s1, occt_surface s2,
                       occt_curve* out_curves, int max_curves) {
    clear_error();
    if (!s1 || !s2 || (!out_curves && max_curves > 0)) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_IntSS intersector(*surface_handle(s1), *surface_handle(s2), Precision::Confusion());
        if (!intersector.NbLines()) return 0;
        int n = intersector.NbLines();
        if (out_curves && max_curves > 0) {
            int count = (n < max_curves) ? n : max_curves;
            for (int i = 0; i < count; i++) {
                Handle(Geom_Curve) curve = intersector.Line(i + 1);
                Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
                out_curves[i] = alloc_curve(CURVE_BSPLINE, h);
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int extrema_curve_curve(occt_curve c1, occt_curve c2,
                        double* out_dist,
                        double* out_p1x, double* out_p1y, double* out_p1z,
                        double* out_p2x, double* out_p2y, double* out_p2z) {
    clear_error();
    if (!c1 || !c2 || !out_dist || !out_p1x || !out_p1y || !out_p1z || !out_p2x || !out_p2y || !out_p2z) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ExtremaCurveCurve extrema(*curve_handle(c1), *curve_handle(c2));
        if (!extrema.NbExtrema()) return 0;
        gp_Pnt p1, p2;
        extrema.NearestPoints(p1, p2);
        *out_p1x = p1.X(); *out_p1y = p1.Y(); *out_p1z = p1.Z();
        *out_p2x = p2.X(); *out_p2y = p2.Y(); *out_p2z = p2.Z();
        *out_dist = extrema.LowerDistance();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int extrema_curve_surface(occt_curve c, occt_surface s,
                          double* out_dist,
                          double* out_px, double* out_py, double* out_pz,
                          double* out_u, double* out_v) {
    clear_error();
    if (!c || !s || !out_dist || !out_px || !out_py || !out_pz || !out_u || !out_v) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ExtremaCurveSurface extrema(*curve_handle(c), *surface_handle(s));
        int n = extrema.NbExtrema();
        if (!n) return 0;
        double bestDist = DBL_MAX;
        gp_Pnt bestP;
        double bestU = 0, bestV = 0;
        for (int i = 1; i <= n; i++) {
            gp_Pnt p1, p2;
            double w, u, v;
            extrema.Points(i, p1, p2);
            extrema.Parameters(i, w, u, v);
            double d = p1.Distance(p2);
            if (d < bestDist) {
                bestDist = d;
                bestP = (p1.X() != 0 || p1.Y() != 0 || p1.Z() != 0) ? p1 : p2;
                bestU = u;
                bestV = v;
            }
        }
        *out_dist = bestDist;
        *out_px = bestP.X(); *out_py = bestP.Y(); *out_pz = bestP.Z();
        *out_u = bestU;
        *out_v = bestV;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}


int intersect_curves_2d(occt_geom2d c1, occt_geom2d c2,
                        double* out_points, int max_points) {
    clear_error();
    if (!c1 || !c2 || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom2d_Curve) hc1 = get_geom2d_curve(c1);
        Handle(Geom2d_Curve) hc2 = get_geom2d_curve(c2);
        if (hc1.IsNull() || hc2.IsNull()) { set_error("both arguments must be 2D curves", 2); return 0; }
        Geom2dAPI_InterCurveCurve intersector(hc1, hc2);
        if (!intersector.NbPoints()) return 0;
        int n = intersector.NbPoints();
        if (out_points && max_points > 0) {
            int count = (n < max_points) ? n : max_points;
            for (int i = 0; i < count; i++) {
                gp_Pnt2d p = intersector.Point(i + 1);
                out_points[i * 2] = p.X();
                out_points[i * 2 + 1] = p.Y();
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int project_point_on_curve_2d(occt_geom2d curve,
                              double px, double py,
                              double* out_x, double* out_y,
                              double* out_dist, double* out_param) {
    clear_error();
    if (!curve || !out_x || !out_y || !out_dist || !out_param) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom2d_Curve) hc = get_geom2d_curve(curve);
        if (hc.IsNull()) { set_error("must be a 2D curve", 2); return 0; }
        Geom2dAPI_ProjectPointOnCurve proj(gp_Pnt2d(px, py), hc);
        if (!proj.NbPoints()) return 0;
        gp_Pnt2d p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y();
        *out_dist = proj.LowerDistance();
        *out_param = proj.LowerDistanceParameter();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

occt_curve points_to_bspline(double* points, int num_points, int degree) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        NCollection_Array1<gp_Pnt> arr(1, num_points);
        for (int i = 0; i < num_points; i++)
            arr.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        int deg = (degree > 0) ? degree : 3;
        GeomAPI_PointsToBSpline fitter(arr, deg);
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(fitter.Curve());
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve interpolate_points(double* points, int num_points,
                              double* init_tangent, double* final_tangent) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        occ::handle<NCollection_HArray1<gp_Pnt>> harr = new NCollection_HArray1<gp_Pnt>(1, num_points);
        for (int i = 0; i < num_points; i++)
            harr->SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        GeomAPI_Interpolate interpolator(harr, false, Precision::Confusion());
        gp_Vec initV(0, 0, 0), finalV(0, 0, 0);
        bool hasInit = init_tangent != nullptr;
        bool hasFinal = final_tangent != nullptr;
        if (hasInit) initV = gp_Vec(init_tangent[0], init_tangent[1], init_tangent[2]);
        if (hasFinal) finalV = gp_Vec(final_tangent[0], final_tangent[1], final_tangent[2]);
        if (hasInit || hasFinal)
            interpolator.Load(initV, finalV, true);
        interpolator.Perform();
        if (!interpolator.IsDone()) { set_error("interpolation failed", 2); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(interpolator.Curve());
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

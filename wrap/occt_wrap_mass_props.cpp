#include "occt_wrap_internal.h"
#include "occt_wrap_mass_props.h"

double shape_volume(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        return props.Mass();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double shape_area(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::SurfaceProperties(*to_shape(shape), props);
        return props.Mass();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_center_of_mass(occt_shape shape, double* out_x, double* out_y, double* out_z) {
    clear_error();
    if (!shape || !out_x || !out_y || !out_z) { set_error("null argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        gp_Pnt cm = props.CentreOfMass();
        *out_x = cm.X(); *out_y = cm.Y(); *out_z = cm.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_inertia(occt_shape shape, double* out_inertia, int inertia_size,
                  double* out_principal_moments, int pm_size,
                  double* out_principal_axes, int pa_size) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        gp_Mat inertia = props.MatrixOfInertia();
        // Inertia matrix: Ixx, Iyy, Izz, Ixy, Ixz, Iyz (6 components)
        if (out_inertia && inertia_size >= 6) {
            out_inertia[0] = inertia(1,1); out_inertia[1] = inertia(2,2); out_inertia[2] = inertia(3,3);
            out_inertia[3] = inertia(1,2); out_inertia[4] = inertia(1,3); out_inertia[5] = inertia(2,3);
        }
        // Principal moments and axes via GProp_PrincipalProps
        if ((out_principal_moments && pm_size >= 3) || (out_principal_axes && pa_size >= 9)) {
            GProp_PrincipalProps pp = props.PrincipalProperties();
            if (out_principal_moments && pm_size >= 3) {
                double Ixx, Iyy, Izz;
                pp.Moments(Ixx, Iyy, Izz);
                out_principal_moments[0] = Ixx;
                out_principal_moments[1] = Iyy;
                out_principal_moments[2] = Izz;
            }
            if (out_principal_axes && pa_size >= 9) {
                gp_Vec v1 = pp.FirstAxisOfInertia();
                gp_Vec v2 = pp.SecondAxisOfInertia();
                gp_Vec v3 = pp.ThirdAxisOfInertia();
                out_principal_axes[0] = v1.X(); out_principal_axes[1] = v1.Y(); out_principal_axes[2] = v1.Z();
                out_principal_axes[3] = v2.X(); out_principal_axes[4] = v2.Y(); out_principal_axes[5] = v2.Z();
                out_principal_axes[6] = v3.X(); out_principal_axes[7] = v3.Y(); out_principal_axes[8] = v3.Z();
            }
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double shape_distance(occt_shape shape1, occt_shape shape2) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return -1; }
    try {
        BRepExtrema_DistShapeShape extrema(*to_shape(shape1), *to_shape(shape2));
        if (!extrema.IsDone()) { set_error("distance computation failed"); return -1; }
        return extrema.Value();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}

int shape_distance_extrema(occt_shape shape1, occt_shape shape2,
                           double* out_dist,
                           double* out_p1x, double* out_p1y, double* out_p1z,
                           double* out_p2x, double* out_p2y, double* out_p2z) {
    clear_error();
    if (!shape1 || !shape2 || !out_dist || !out_p1x || !out_p1y || !out_p1z || !out_p2x || !out_p2y || !out_p2z) {
        set_error("null argument", 2); return 0;
    }
    try {
        BRepExtrema_DistShapeShape extrema(*to_shape(shape1), *to_shape(shape2));
        if (!extrema.IsDone()) { set_error("distance computation failed"); return 0; }
        *out_dist = extrema.Value();
        if (extrema.NbSolution() >= 1) {
            gp_Pnt p1 = extrema.PointOnShape1(1);
            gp_Pnt p2 = extrema.PointOnShape2(1);
            *out_p1x = p1.X(); *out_p1y = p1.Y(); *out_p1z = p1.Z();
            *out_p2x = p2.X(); *out_p2y = p2.Y(); *out_p2z = p2.Z();
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int classify_point_in_solid(occt_shape shape, double px, double py, double pz,
                            int* out_state, occt_shape* out_face) {
    clear_error();
    if (!shape || !out_state) { set_error("null argument", 2); return 0; }
    try {
        BRepClass3d_SolidClassifier classifier(*to_shape(shape), gp_Pnt(px, py, pz), Precision::Confusion());
        TopAbs_State state = classifier.State();
        // State mapping: 0=IN, 1=OUT, 2=ON, 3=UNKNOWN
        switch (state) {
            case TopAbs_IN:      *out_state = 0; break;
            case TopAbs_OUT:     *out_state = 1; break;
            case TopAbs_ON:      *out_state = 2; break;
            default:             *out_state = 3; break;
        }
        if (out_face && state == TopAbs_ON) {
            TopoDS_Face face = classifier.Face();
            if (!face.IsNull()) {
                *out_face = new TopoDS_Shape(face);
            } else {
                *out_face = nullptr;
            }
        } else if (out_face) {
            *out_face = nullptr;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_is_valid(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepCheck_Analyzer analyzer(*to_shape(shape));
        return analyzer.IsValid() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

const char* shape_analysis_report(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        static std::string result;
        result.clear();
        BRepCheck_Analyzer analyzer(*to_shape(shape));
        if (analyzer.IsValid()) {
            result = "Shape is valid.";
        } else {
            result = "Shape has issues.";
        }
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int intersect_curve_shape(occt_curve curve, occt_shape shape,
                          double* out_points, double* out_params,
                          occt_shape* out_faces, int max_results) {
    clear_error();
    if (!curve || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Curve) gc = *curve_handle(curve);
        BRepIntCurveSurface_Inter intersector;
        intersector.Init(*to_shape(shape), gc, Precision::Confusion());
        int count = 0;
        while (intersector.More() && (max_results <= 0 || count < max_results)) {
            if (out_points && count < max_results) {
                gp_Pnt p = intersector.Pnt();
                out_points[count * 3]     = p.X();
                out_points[count * 3 + 1] = p.Y();
                out_points[count * 3 + 2] = p.Z();
            }
            if (out_params && count < max_results) {
                out_params[count * 2]     = intersector.U();
                out_params[count * 2 + 1] = intersector.V();
            }
            if (out_faces && count < max_results) {
                TopoDS_Face face = intersector.Face();
                if (!face.IsNull()) {
                    out_faces[count] = new TopoDS_Shape(face);
                } else {
                    out_faces[count] = nullptr;
                }
            }
            count++;
            intersector.Next();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int map_subshapes(occt_shape shape, int shape_type, int stop_at_type,
                  occt_shape* out_shapes, int max_shapes) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopAbs_ShapeEnum type = topabs_from_int(shape_type);
        TopAbs_ShapeEnum stop = topabs_from_int(stop_at_type);
        TopExp_Explorer exp(*to_shape(shape), type, stop);
        int count = 0;
        while (exp.More() && (max_shapes <= 0 || count < max_shapes)) {
            if (out_shapes && count < max_shapes) {
                out_shapes[count] = new TopoDS_Shape(exp.Current());
            }
            count++;
            exp.Next();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int count_subshapes(occt_shape shape, int shape_type, int stop_at_type) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopAbs_ShapeEnum type = topabs_from_int(shape_type);
        TopAbs_ShapeEnum stop = topabs_from_int(stop_at_type);
        TopExp_Explorer exp(*to_shape(shape), type, stop);
        int count = 0;
        while (exp.More()) { count++; exp.Next(); }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

const char* dump_shape(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        static std::string result;
        result.clear();
        std::ostringstream oss;
        BRepTools::Dump(*to_shape(shape), oss);
        result = oss.str();
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int shape_triangle_count(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepMesh_IncrementalMesh mesh(*to_shape(shape), 0.1);
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int total = 0;
        while (exp.More()) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                total += tri->NbTriangles();
            }
            exp.Next();
        }
        return total;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int wire_order_check(occt_shape wire, occt_shape face) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return 0; }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        if (face) {
            TopoDS_Face f = TopoDS::Face(*to_shape(face));
            // Check wire validity relative to face using BRepCheck
            BRepCheck_Analyzer analyzer(w);
            BRepCheck_Analyzer faceAnalyzer(f);
            return (analyzer.IsValid() && faceAnalyzer.IsValid()) ? 1 : 0;
        }
        // Without face, just check basic wire structure
        BRepCheck_Analyzer analyzer(w);
        return analyzer.IsValid() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_curve edge_to_curve(occt_shape edge) {
    clear_error();
    if (!edge) { set_error("null edge argument", 2); return nullptr; }
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        BRepAdaptor_Curve adaptor(e);
        Handle(Geom_Curve) curve = adaptor.Curve().Curve();
        if (curve.IsNull()) { set_error("edge has no curve"); return nullptr; }
        // Classify the curve type
        GeomCurveKind kind;
        if (curve->DynamicType() == STANDARD_TYPE(Geom_Line))
            kind = CURVE_LINE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Circle))
            kind = CURVE_CIRCLE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Ellipse))
            kind = CURVE_ELLIPSE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Parabola))
            kind = CURVE_PARABOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Hyperbola))
            kind = CURVE_HYPERBOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BezierCurve))
            kind = CURVE_BEZIER;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BSplineCurve))
            kind = CURVE_BSPLINE;
        else
            kind = CURVE_BSPLINE;
        Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
        return alloc_curve(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_surface face_to_surface(occt_shape face) {
    clear_error();
    if (!face) { set_error("null face argument", 2); return nullptr; }
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface adaptor(f);
        Handle(Geom_Surface) surface = adaptor.AdaptorSurfaceOriginal().Surface();
        if (surface.IsNull()) { set_error("face has no surface"); return nullptr; }
        GeomSurfaceKind kind;
        if (surface->DynamicType() == STANDARD_TYPE(Geom_Plane))
            kind = SURFACE_PLANE;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_CylindricalSurface))
            kind = SURFACE_CYLINDRICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ConicalSurface))
            kind = SURFACE_CONICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_SphericalSurface))
            kind = SURFACE_SPHERICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ToroidalSurface))
            kind = SURFACE_TOROIDAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BezierSurface))
            kind = SURFACE_BEZIER;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BSplineSurface))
            kind = SURFACE_BSPLINE;
        else
            kind = SURFACE_BSPLINE;
        Handle(Geom_Surface)* h = new Handle(Geom_Surface)(surface);
        return alloc_surface(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_vertex(double x, double y, double z) {
    clear_error();
    try {
        BRepBuilderAPI_MakeVertex maker(gp_Pnt(x, y, z));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_polygon(double* points, int num_points, int closed) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        BRepBuilderAPI_MakePolygon maker;
        for (int i = 0; i < num_points; i++) {
            maker.Add(gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        }
        if (closed) maker.Close();
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}


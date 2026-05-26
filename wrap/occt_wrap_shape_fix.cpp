#include "occt_wrap_internal.h"
#include "occt_wrap_shape_fix.h"
static thread_local char g_contents_buffer[512];

occt_shape fix_shape(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        ShapeFix_Shape fixer(*to_shape(shape));
        fixer.SetPrecision(Precision::Confusion());
        fixer.SetMaxTolerance(Precision::Confusion() * 100);
        fixer.Perform();
        TopoDS_Shape result = fixer.Shape();
        if (!result.IsNull()) return from_shape(result);
        set_error("ShapeFix_Shape produced null result");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fix_wire(occt_shape wire, occt_shape face, double tolerance) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        TopoDS_Face f;
        if (face) f = TopoDS::Face(*to_shape(face));
        ShapeFix_Wire fixer;
        fixer.Load(w);
        if (!f.IsNull()) fixer.SetFace(f);
        fixer.SetMaxTolerance(tolerance > 0 ? tolerance : Precision::Confusion());
        if (fixer.Perform()) {
            return from_shape(fixer.Wire());
        }
        set_error("ShapeFix_Wire::Perform failed");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fix_solid(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Solid solid = TopoDS::Solid(*to_shape(shape));
        ShapeFix_Solid fixer(solid);
        fixer.SetPrecision(Precision::Confusion());
        fixer.SetMaxTolerance(Precision::Confusion() * 100);
        fixer.Perform();
        TopoDS_Shape result = fixer.Solid();
        if (!result.IsNull()) return from_shape(result);
        set_error("ShapeFix_Solid produced null result");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fix_edge(occt_shape edge) {
    clear_error();
    if (!edge) { set_error("null edge argument", 2); return nullptr; }
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        ShapeFix_Edge fixer;
        fixer.FixAddCurve3d(e);
        fixer.FixVertexTolerance(e);
        return from_shape(e);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fix_face(occt_shape face) {
    clear_error();
    if (!face) { set_error("null face argument", 2); return nullptr; }
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        ShapeFix_Face fixer(f);
        fixer.SetPrecision(Precision::Confusion());
        fixer.SetMaxTolerance(Precision::Confusion() * 100);
        fixer.Perform();
        TopoDS_Face result = fixer.Face();
        if (!result.IsNull()) return from_shape(result);
        set_error("ShapeFix_Face produced null result");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_analysis_free_edges(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Compound compOfFaces;
        BRep_Builder builder;
        builder.MakeCompound(compOfFaces);
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        for (; exp.More(); exp.Next()) {
            builder.Add(compOfFaces, exp.Current());
        }
        ShapeAnalysis_FreeBounds freeBounds(compOfFaces, Precision::Confusion(), false, true);
        const TopoDS_Compound& closed = freeBounds.GetClosedWires();
        const TopoDS_Compound& open = freeBounds.GetOpenWires();
        TopoDS_Compound result;
        builder.MakeCompound(result);
        TopExp_Explorer cExp(closed, TopAbs_EDGE);
        for (; cExp.More(); cExp.Next())
            builder.Add(result, cExp.Current());
        TopExp_Explorer oExp(open, TopAbs_EDGE);
        for (; oExp.More(); oExp.Next())
            builder.Add(result, oExp.Current());
        if (is_empty_shape(result)) return nullptr;
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int shape_analysis_check_intersections(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        NCollection_List<TopoDS_Shape> faces;
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        for (; exp.More(); exp.Next())
            faces.Append(exp.Current());

        int count = 0;
        NCollection_List<TopoDS_Shape>::Iterator it1(faces);
        for (; it1.More(); it1.Next()) {
            NCollection_List<TopoDS_Shape>::Iterator it2(faces);
            for (; it2.More(); it2.Next()) {
                if (it1.Value().IsSame(it2.Value())) continue;
                BRepAlgoAPI_Section section(it1.Value(), it2.Value());
                section.Build();
                if (!section.IsDone()) continue;
                TopExp_Explorer edgeExp(section.Shape(), TopAbs_EDGE);
                if (edgeExp.More()) count++;
            }
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_analysis_wire_contains(occt_shape wire, double x, double y) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return 0; }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        gp_Pln plane(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1));
        BRepBuilderAPI_MakeFace faceMaker(plane, w);
        if (!faceMaker.IsDone()) return 0;
        TopoDS_Face face = faceMaker.Face();
        gp_Pnt p3d(x, y, 0);
        BRepClass_FaceClassifier classifier;
        classifier.Perform(face, p3d, Precision::Confusion());
        return (classifier.State() == TopAbs_IN) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

const char* shape_analysis_contents(occt_shape shape) {
    clear_error();
    g_contents_buffer[0] = '\0';
    if (!shape) { set_error("null shape argument", 2); return g_contents_buffer; }
    try {
        const TopoDS_Shape& s = *to_shape(shape);
        int nSolids = 0, nShells = 0, nFaces = 0, nWires = 0, nEdges = 0, nVerts = 0;
        TopExp_Explorer exp;
        exp.Init(s, TopAbs_SOLID); for (; exp.More(); exp.Next()) nSolids++;
        exp.Init(s, TopAbs_SHELL); for (; exp.More(); exp.Next()) nShells++;
        exp.Init(s, TopAbs_FACE);  for (; exp.More(); exp.Next()) nFaces++;
        exp.Init(s, TopAbs_WIRE);  for (; exp.More(); exp.Next()) nWires++;
        exp.Init(s, TopAbs_EDGE);  for (; exp.More(); exp.Next()) nEdges++;
        exp.Init(s, TopAbs_VERTEX); for (; exp.More(); exp.Next()) nVerts++;
        snprintf(g_contents_buffer, sizeof(g_contents_buffer),
                 "{\"solids\":%d,\"shells\":%d,\"faces\":%d,\"wires\":%d,\"edges\":%d,\"vertices\":%d}",
                 nSolids, nShells, nFaces, nWires, nEdges, nVerts);
        return g_contents_buffer;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return g_contents_buffer;
    }
}

occt_shape substitute_single(occt_shape shape, occt_shape old_sub, occt_shape new_sub) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!old_sub) { set_error("null old sub-shape argument", 2); return nullptr; }
    if (!new_sub) { set_error("null new sub-shape argument", 2); return nullptr; }
    try {
        Handle(ShapeBuild_ReShape) builder = new ShapeBuild_ReShape();
        builder->Replace(*to_shape(old_sub), *to_shape(new_sub));
        TopoDS_Shape result = builder->Apply(*to_shape(shape));
        if (result.IsNull()) { set_error("ReShape produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape substitute_batch(occt_shape shape, occt_shape* old_shapes, occt_shape* new_shapes, int count) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!old_shapes || !new_shapes || count < 1) { set_error("invalid batch arguments", 2); return nullptr; }
    try {
        Handle(ShapeBuild_ReShape) builder = new ShapeBuild_ReShape();
        for (int i = 0; i < count; i++) {
            if (old_shapes[i] && new_shapes[i])
                builder->Replace(*to_shape(old_shapes[i]), *to_shape(new_shapes[i]));
        }
        TopoDS_Shape result = builder->Apply(*to_shape(shape));
        if (result.IsNull()) { set_error("ReShape batch produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_to_nurbs(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Shape result = ShapeCustom::ConvertToBSpline(*to_shape(shape), true, true, true, false);
        if (!result.IsNull()) return from_shape(result);
        set_error("ConvertToBSpline failed");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_reduce_degree(occt_shape shape, int max_degree) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (max_degree < 1) { set_error("max_degree must be >= 1", 2); return nullptr; }
    try {
        Handle(ShapeCustom_BSplineRestriction) modifier =
            new ShapeCustom_BSplineRestriction(true, true, true,
                                                Precision::Confusion(), Precision::Confusion(),
                                                GeomAbs_C1, GeomAbs_C1,
                                                max_degree, 100, true, false);
        BRepTools_Modifier bmod(*to_shape(shape));
        bmod.Perform(modifier);
        if (bmod.IsDone()) {
            TopoDS_Shape result = bmod.ModifiedShape(*to_shape(shape));
            if (!result.IsNull()) return from_shape(result);
        }
        set_error("ReduceDegree failed");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_to_rational_bspline(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        Handle(ShapeCustom_BSplineRestriction) modifier =
            new ShapeCustom_BSplineRestriction(true, true, true,
                                                Precision::Confusion(), Precision::Confusion(),
                                                GeomAbs_C1, GeomAbs_C1,
                                                25, 200, false, true);
        BRepTools_Modifier bmod(*to_shape(shape));
        bmod.Perform(modifier);
        if (bmod.IsDone()) {
            TopoDS_Shape result = bmod.ModifiedShape(*to_shape(shape));
            if (!result.IsNull()) return from_shape(result);
        }
        set_error("ConvertToRationalBSpline failed");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_split_u(occt_shape shape, int num_splits) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    (void)num_splits;
    try {
        ShapeUpgrade_ShapeDivideContinuity splitter(*to_shape(shape));
        splitter.SetTolerance(Precision::Confusion());
        splitter.SetBoundaryCriterion(GeomAbs_C0);
        splitter.SetPCurveCriterion(GeomAbs_C0);
        splitter.SetSurfaceCriterion(GeomAbs_C0);
        splitter.Perform();
        TopoDS_Shape result = splitter.Result();
        if (result.IsNull()) { set_error("Split produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shape_upgrade_continuity(occt_shape shape, int continuity) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (continuity < 0 || continuity > 3) { set_error("continuity must be 0-3 (C0-C3)", 2); return nullptr; }
    try {
        static const GeomAbs_Shape contMap[] = { GeomAbs_C0, GeomAbs_C1, GeomAbs_C2, GeomAbs_C3 };
        ShapeUpgrade_ShapeDivideContinuity upgrader(*to_shape(shape));
        upgrader.SetTolerance(Precision::Confusion());
        upgrader.SetBoundaryCriterion(contMap[continuity]);
        upgrader.SetSurfaceCriterion(contMap[continuity]);
        upgrader.Perform();
        TopoDS_Shape result = upgrader.Result();
        if (result.IsNull()) { set_error("Continuity upgrade produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

static bool dispatch_operator(TopoDS_Shape& shape, const char* name) {
    std::string op(name);
    if (op == "FixShape") {
        ShapeFix_Shape fixer(shape);
        fixer.SetPrecision(Precision::Confusion());
        fixer.SetMaxTolerance(Precision::Confusion() * 100);
        if (fixer.Perform()) { shape = fixer.Shape(); return true; }
        return false;
    }
    if (op == "FixSolid") {
        TopExp_Explorer exp(shape, TopAbs_SOLID);
        Handle(ShapeBuild_ReShape) reshape = new ShapeBuild_ReShape();
        bool any = false;
        for (; exp.More(); exp.Next()) {
            TopoDS_Solid solid = TopoDS::Solid(exp.Current());
            ShapeFix_Solid fixer(solid);
            fixer.SetPrecision(Precision::Confusion());
            fixer.SetMaxTolerance(Precision::Confusion() * 100);
            fixer.Perform();
            TopoDS_Shape result = fixer.Solid();
            if (!result.IsNull()) {
                reshape->Replace(solid, result);
                any = true;
            }
        }
        if (any) { shape = reshape->Apply(shape); return true; }
        return false;
    }
    if (op == "FixWire") {
        TopExp_Explorer exp(shape, TopAbs_WIRE);
        Handle(ShapeBuild_ReShape) reshape = new ShapeBuild_ReShape();
        bool any = false;
        for (; exp.More(); exp.Next()) {
            TopoDS_Wire w = TopoDS::Wire(exp.Current());
            ShapeFix_Wire fixer;
            fixer.Load(w);
            fixer.SetMaxTolerance(Precision::Confusion());
            if (fixer.Perform()) {
                reshape->Replace(w, fixer.Wire());
                any = true;
            }
        }
        if (any) { shape = reshape->Apply(shape); return true; }
        return false;
    }
    if (op == "FixEdge") {
        TopExp_Explorer exp(shape, TopAbs_EDGE);
        Handle(ShapeBuild_ReShape) reshape = new ShapeBuild_ReShape();
        bool any = false;
        for (; exp.More(); exp.Next()) {
            TopoDS_Edge e = TopoDS::Edge(exp.Current());
            ShapeFix_Edge fixer;
            fixer.FixAddCurve3d(e);
            any = true;
        }
        if (any) { shape = reshape->Apply(shape); return true; }
        return false;
    }
    if (op == "FixFace") {
        TopExp_Explorer exp(shape, TopAbs_FACE);
        Handle(ShapeBuild_ReShape) reshape = new ShapeBuild_ReShape();
        bool any = false;
        for (; exp.More(); exp.Next()) {
            TopoDS_Face f = TopoDS::Face(exp.Current());
            ShapeFix_Face fixer(f);
            fixer.SetPrecision(Precision::Confusion());
            fixer.SetMaxTolerance(Precision::Confusion() * 100);
            fixer.Perform();
            TopoDS_Face result = fixer.Face();
            if (!result.IsNull()) {
                reshape->Replace(f, result);
                any = true;
            }
        }
        if (any) { shape = reshape->Apply(shape); return true; }
        return false;
    }
    if (op == "SameParameter") {
        BRepTools::Clean(shape);
        BRepTools::Update(shape);
        return true;
    }
    if (op == "SplitContinuity") {
        ShapeUpgrade_ShapeDivideContinuity splitter(shape);
        splitter.SetTolerance(Precision::Confusion());
        splitter.SetBoundaryCriterion(GeomAbs_C1);
        splitter.Perform();
        shape = splitter.Result();
        return !shape.IsNull();
    }
    return false;
}

occt_shape apply_shape_process(occt_shape shape, const char* operator_name) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!operator_name) { set_error("null operator_name", 2); return nullptr; }
    try {
        TopoDS_Shape current = *to_shape(shape);
        if (dispatch_operator(current, operator_name) && !current.IsNull())
            return from_shape(current);
        set_error("ShapeProcess operator failed");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape apply_operator_sequence(occt_shape shape, const char** operators, int count) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!operators || count < 1) { set_error("invalid operator sequence", 2); return nullptr; }
    try {
        TopoDS_Shape current = *to_shape(shape);
        for (int i = 0; i < count; i++) {
            if (!operators[i]) continue;
            if (!dispatch_operator(current, operators[i])) {
                set_error("ShapeProcess operator failed");
                return nullptr;
            }
        }
        if (current.IsNull()) { set_error("operator sequence produced null result"); return nullptr; }
        return from_shape(current);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape apply_healing_pipeline(occt_shape shape, const char* pipeline_name, const char* resource) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!pipeline_name || !resource) { set_error("null pipeline or resource name", 2); return nullptr; }
    try {
        ShapeProcessAPI_ApplySequence applier(resource, pipeline_name);
        TopoDS_Shape result = applier.PrepareShape(*to_shape(shape));
        if (!result.IsNull()) return from_shape(result);
        set_error("healing pipeline produced null result");
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape heal_shape_default(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Shape current = *to_shape(shape);

        // Apply FixShape
        if (!dispatch_operator(current, "FixShape")) {
            // Non-fatal, continue with original
        }

        // Apply SameParameter
        dispatch_operator(current, "SameParameter");

        // Apply FixSolid
        dispatch_operator(current, "FixSolid");

        if (current.IsNull()) { set_error("default healing produced null result"); return nullptr; }
        return from_shape(current);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sew_shapes(occt_shape* shapes, int num_shapes, double tolerance, int allow_non_manifold) {
    clear_error();
    if (!shapes || num_shapes < 1) { set_error("no shapes provided", 2); return nullptr; }
    try {
        BRepBuilderAPI_Sewing sewer(tolerance, true, true, true, allow_non_manifold ? true : false);
        for (int i = 0; i < num_shapes; i++) {
            if (shapes[i]) {
                sewer.Add(*to_shape(shapes[i]));
            }
        }
        sewer.Perform();
        const TopoDS_Shape& result = sewer.SewedShape();
        if (result.IsNull()) { set_error("sewing produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape defeature_shape(occt_shape shape, occt_shape* faces, int num_faces) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!faces || num_faces < 1) { set_error("no faces provided", 2); return nullptr; }
    try {
        BRepAlgoAPI_Defeaturing defeaturer;
        defeaturer.SetShape(*to_shape(shape));
        NCollection_List<TopoDS_Shape> facesToRemove;
        for (int i = 0; i < num_faces; i++) {
            if (faces[i]) {
                facesToRemove.Append(*to_shape(faces[i]));
            }
        }
        defeaturer.AddFacesToRemove(facesToRemove);
        defeaturer.Build();
        if (!defeaturer.IsDone()) { set_error("defeaturing failed"); return nullptr; }
        return from_shape(defeaturer.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

const char* check_shape_validity(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Check checker(*to_shape(shape));
        if (!checker.IsValid()) {
            const NCollection_List<BOPAlgo_CheckResult>& results = checker.Result();
            std::ostringstream oss;
            for (NCollection_List<BOPAlgo_CheckResult>::Iterator it(results); it.More(); it.Next()) {
                const BOPAlgo_CheckResult& cr = it.Value();
                if (!cr.GetFaultyShapes1().IsEmpty()) {
                    oss << "faulty shapes in object; ";
                }
            }
            std::string msg = oss.str();
            if (!msg.empty()) {
                // Trim trailing "; "
                msg = msg.substr(0, msg.length() - 2);
                char* buf = new char[msg.length() + 1];
                std::strcpy(buf, msg.c_str());
                return buf;
            }
            return "shape is not valid";
        }
        return nullptr; // no errors
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape boolean_builder(occt_shape shape1, occt_shape shape2, int operation) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Shape result;
        switch (operation) {
            case 0: {
                BRepAlgoAPI_Fuse maker(*to_shape(shape1), *to_shape(shape2));
                if (!maker.IsDone()) { set_error("boolean builder fuse failed"); return nullptr; }
                result = maker.Shape();
                break;
            }
            case 1: {
                BRepAlgoAPI_Cut maker(*to_shape(shape1), *to_shape(shape2));
                if (!maker.IsDone()) { set_error("boolean builder cut failed"); return nullptr; }
                result = maker.Shape();
                break;
            }
            case 2: {
                BRepAlgoAPI_Common maker(*to_shape(shape1), *to_shape(shape2));
                if (!maker.IsDone()) { set_error("boolean builder common failed"); return nullptr; }
                result = maker.Shape();
                break;
            }
            case 3: {
                BRepAlgoAPI_Section maker(*to_shape(shape1), *to_shape(shape2));
                maker.Build();
                if (!maker.IsDone()) { set_error("boolean builder section failed"); return nullptr; }
                result = maker.Shape();
                break;
            }
            default:
                set_error("unknown boolean operation");
                return nullptr;
        }
        if (result.IsNull()) { set_error("boolean builder produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int shape_bounding_box(occt_shape shape,
                       double* xmin, double* ymin, double* zmin,
                       double* xmax, double* ymax, double* zmax) {
    clear_error();
    if (!shape || !xmin || !ymin || !zmin || !xmax || !ymax || !zmax) return 0;
    try {
        const TopoDS_Shape& s = *static_cast<const TopoDS_Shape*>(shape);
        if (s.IsNull()) return 0;
        Bnd_Box box;
        BRepBndLib::Add(s, box);
        if (box.IsVoid()) return 0;
        box.Get(*xmin, *ymin, *zmin, *xmax, *ymax, *zmax);
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

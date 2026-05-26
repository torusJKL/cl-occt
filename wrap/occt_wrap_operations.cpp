#include "occt_wrap_internal.h"
#include "occt_wrap_operations.h"
#include "occt_wrap_features.h"

static gp_Ax1 face_to_axis(const TopoDS_Face& face) {
    BRepAdaptor_Surface adaptor(face);
    double u1, u2, v1, v2;
    adaptor.AdaptorSurfaceOriginal().Bounds(u1, u2, v1, v2);
    double u = (u1 + u2) / 2.0;
    double v = (v1 + v2) / 2.0;
    gp_Pnt pt = adaptor.Value(u, v);
    gp_Dir normal = adaptor.Plane().Axis().Direction();
    if (face.Orientation() == TopAbs_REVERSED) {
        normal.Reverse();
    }
    return gp_Ax1(pt, normal);
}

occt_shape fillet_edge_constant(occt_shape shape, occt_shape edge, double radius) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        maker.Add(radius, TopoDS::Edge(*to_shape(edge)));
        maker.Build();
        if (!maker.IsDone()) { set_error("fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_edges_constant(occt_shape shape, occt_shape* edges, int num_edges, double radius) {
    clear_error();
    if (!shape || !edges || num_edges < 1) { set_error("invalid arguments", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        for (int i = 0; i < num_edges; i++) {
            if (!edges[i]) { set_error("null edge in array", 2); return nullptr; }
            maker.Add(radius, TopoDS::Edge(*to_shape(edges[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_edge_variable(occt_shape shape, occt_shape edge, double* params_and_radii, int num_pairs) {
    clear_error();
    if (!shape || !edge || !params_and_radii || num_pairs < 1) {
        set_error("invalid arguments", 2); return nullptr;
    }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        const TopoDS_Edge& edgeRef = TopoDS::Edge(*to_shape(edge));
        // Build array of (parameter, radius) pairs for OCCT
        NCollection_Array1<gp_Pnt2d> uAndR(0, num_pairs - 1);
        for (int i = 0; i < num_pairs; i++) {
            uAndR[i].SetX(params_and_radii[i * 2]);
            uAndR[i].SetY(params_and_radii[i * 2 + 1]);
        }
        maker.Add(uAndR, edgeRef);
        maker.Build();
        if (!maker.IsDone()) { set_error("variable fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_wire_corner(occt_shape wire, double radius) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        // Build a planar face from the wire, then fillet its vertices
        BRepBuilderAPI_MakeFace faceMaker(TopoDS::Wire(*to_shape(wire)));
        if (!faceMaker.IsDone()) { set_error("cannot make face from wire", 2); return nullptr; }
        TopoDS_Face face = faceMaker.Face();

        BRepFilletAPI_MakeFillet2d maker(face);
        // Find first vertex and fillet it
        TopExp_Explorer exp(face, TopAbs_VERTEX);
        if (!exp.More()) { set_error("no vertices in wire", 2); return nullptr; }
        maker.AddFillet(TopoDS::Vertex(exp.Current()), radius);
        if (!maker.IsDone()) { set_error("2D fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_wire_all_corners(occt_shape wire, double radius) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepBuilderAPI_MakeFace faceMaker(TopoDS::Wire(*to_shape(wire)));
        if (!faceMaker.IsDone()) { set_error("cannot make face from wire", 2); return nullptr; }
        TopoDS_Face face = faceMaker.Face();

        BRepFilletAPI_MakeFillet2d maker(face);
        // Fillet every vertex
        TopExp_Explorer exp(face, TopAbs_VERTEX);
        int vertexCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.AddFillet(TopoDS::Vertex(exp.Current()), radius);
            vertexCount++;
        }
        if (vertexCount == 0) { set_error("no vertices in wire", 2); return nullptr; }
        if (!maker.IsDone()) { set_error("2D fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_equal(occt_shape shape, occt_shape edge, double distance) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        maker.Add(distance, TopoDS::Edge(*to_shape(edge)));
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edges_equal(occt_shape shape, occt_shape* edges, int num_edges, double distance) {
    clear_error();
    if (!shape || !edges || num_edges < 1) { set_error("invalid arguments", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        for (int i = 0; i < num_edges; i++) {
            if (!edges[i]) { set_error("null edge in array", 2); return nullptr; }
            maker.Add(distance, TopoDS::Edge(*to_shape(edges[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_asym(occt_shape shape, occt_shape edge, double distance1, double distance2) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance1 <= 0 || distance2 <= 0) { set_error("distances must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        // For asymmetric chamfer, use Add with two distances and a null face
        TopoDS_Face nullFace;
        maker.Add(distance1, distance2, TopoDS::Edge(*to_shape(edge)), nullFace);
        maker.Build();
        if (!maker.IsDone()) { set_error("asymmetric chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_on_face(occt_shape shape, occt_shape edge, double distance, occt_shape face) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        TopoDS_Face faceRef;
        if (face) {
            faceRef = TopoDS::Face(*to_shape(face));
        }
        // Use asymmetric Add with second distance = first (equal), specifying the face
        maker.Add(distance, distance, TopoDS::Edge(*to_shape(edge)), faceRef);
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape blend_faces_constant(occt_shape face1, occt_shape face2, double radius) {
    clear_error();
    if (!face1 || !face2) { set_error("null face argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        // Build a shell from the two faces and fillet the shared edge
        TopoDS_Shell shell;
        BRep_Builder builder;
        builder.MakeShell(shell);
        builder.Add(shell, TopoDS::Face(*to_shape(face1)));
        builder.Add(shell, TopoDS::Face(*to_shape(face2)));

        BRepFilletAPI_MakeFillet maker(shell);
        TopExp_Explorer exp(shell, TopAbs_EDGE);
        int edgeCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.Add(radius, TopoDS::Edge(exp.Current()));
            edgeCount++;
        }
        if (edgeCount == 0) { set_error("no edges between faces", 2); return nullptr; }

        maker.Build();
        if (!maker.IsDone()) { set_error("blend not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape blend_make_constant(occt_shape face1, occt_shape face2, double radius) {
    clear_error();
    if (!face1 || !face2) { set_error("null face argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        TopoDS_Shell shell;
        BRep_Builder builder;
        builder.MakeShell(shell);
        builder.Add(shell, TopoDS::Face(*to_shape(face1)));
        builder.Add(shell, TopoDS::Face(*to_shape(face2)));

        BRepFilletAPI_MakeFillet maker(shell);
        TopExp_Explorer exp(shell, TopAbs_EDGE);
        int edgeCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.Add(radius, TopoDS::Edge(exp.Current()));
            edgeCount++;
        }
        if (edgeCount == 0) { set_error("no edges between faces", 2); return nullptr; }

        maker.Build();
        if (!maker.IsDone()) { set_error("blend not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe(occt_shape profile, occt_shape spine) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipe maker(TopoDS::Wire(*to_shape(spine)), *to_shape(profile));
        if (!maker.IsDone()) { set_error("MakePipe failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_fixed(occt_shape profile, occt_shape spine) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipe maker(TopoDS::Wire(*to_shape(spine)), *to_shape(profile));
        if (!maker.IsDone()) { set_error("MakePipe failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_sliding(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        maker.SetMode(true);
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell sliding failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_fixed(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        maker.SetMode(false);
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell fixed failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_aux(occt_shape profile, occt_shape main_spine, occt_shape aux_spine) {
    clear_error();
    if (!profile || !main_spine || !aux_spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(main_spine)));
        maker.SetMode(TopoDS::Wire(*to_shape(aux_spine)));
        maker.Add(*to_shape(profile), 0.0, true);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell aux spine failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections(occt_shape* wires, int count, int solid) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, false);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_ruled(occt_shape* wires, int count, int solid, int ruled) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, ruled == 0);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections ruled failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_smooth(occt_shape* wires, int count, int solid, int smooth) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, smooth != 0);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections smooth failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_tangency(occt_shape* wires, int count, int solid,
                                   occt_shape init_face, occt_shape final_face) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    (void)init_face;
    (void)final_face;
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, false);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections tangency failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fill_face(occt_shape wire) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        TopExp_Explorer exp(*to_shape(wire), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            filler.Add(TopoDS::Edge(exp.Current()), GeomAbs_C0, false);
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fill_face_constrained(occt_shape wire, occt_shape* support_faces, int* continuities, int count) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        TopExp_Explorer exp(*to_shape(wire), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            filler.Add(TopoDS::Edge(exp.Current()), GeomAbs_C0, false);
        }
        for (int i = 0; i < count; i++) {
            if (support_faces[i]) {
                GeomAbs_Shape cont = GeomAbs_C0;
                if (continuities[i] == 1) cont = GeomAbs_C1;
                else if (continuities[i] == 2) cont = GeomAbs_C2;
                else if (continuities[i] == 3) cont = GeomAbs_C3;
                filler.Add(TopoDS::Face(*to_shape(support_faces[i])), cont);
            }
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling constrained failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fill_n_sided_face(occt_shape* edges, int count, int continuity) {
    clear_error();
    if (!edges || count < 3) { set_error("need at least 3 edges", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        GeomAbs_Shape cont = GeomAbs_C0;
        if (continuity == 1) cont = GeomAbs_C1;
        else if (continuity == 2) cont = GeomAbs_C2;
        else if (continuity == 3) cont = GeomAbs_C3;
        for (int i = 0; i < count; i++) {
            if (!edges[i]) { set_error("null edge in fill", 2); return nullptr; }
            filler.Add(TopoDS::Edge(*to_shape(edges[i])), cont);
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling N-sided failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape shell_shape(occt_shape shape, occt_shape* faces, int num_faces, double thickness) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        NCollection_List<TopoDS_Shape> facesToRemove;
        for (int i = 0; i < num_faces; i++) {
            if (faces[i]) {
                facesToRemove.Append(*to_shape(faces[i]));
            }
        }
        BRepOffsetAPI_MakeThickSolid maker;
        maker.MakeThickSolidByJoin(*to_shape(shape), facesToRemove, thickness,
                                   Precision::Confusion(), BRepOffset_Skin);
        if (!maker.IsDone()) { set_error("MakeThickSolid failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape offset_shape_3d(occt_shape shape, double offset, int join) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        GeomAbs_JoinType joinType = GeomAbs_Arc;
        if (join == 1) joinType = GeomAbs_Tangent;
        else if (join == 2) joinType = GeomAbs_Intersection;
        BRepOffsetAPI_MakeOffsetShape maker;
        maker.PerformByJoin(*to_shape(shape), offset, Precision::Confusion(),
                            BRepOffset_Skin, false, false, joinType);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakeOffsetShape failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape offset_wire_2d(occt_shape wire, double offset) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakeOffset maker(TopoDS::Wire(*to_shape(wire)), GeomAbs_Arc);
        maker.Perform(offset);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakeOffset failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape draft_face(occt_shape shape, occt_shape face, double angle,
                      double dx, double dy, double dz,
                      double px, double py, double pz,
                      double nx, double ny, double nz) {
    clear_error();
    if (!shape || !face) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_DraftAngle maker(*to_shape(shape));
        maker.Add(TopoDS::Face(*to_shape(face)), gp_Dir(dx, dy, dz),
                  angle, gp_Pln(gp_Pnt(px, py, pz), gp_Dir(nx, ny, nz)));
        maker.Build();
        if (!maker.IsDone()) { set_error("DraftAngle failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_evolved(occt_shape profile, occt_shape spine, double /*offset*/, int join) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    TopoDS_Shape* spineShape = to_shape(spine);
    TopoDS_Shape* profShape  = to_shape(profile);
    if (spineShape->IsNull() || profShape->IsNull()) {
        set_error("null shape argument", 2);
        return nullptr;
    }
    if (spineShape->ShapeType() != TopAbs_WIRE && spineShape->ShapeType() != TopAbs_FACE) {
        set_error("spine must be a wire or face", 2);
        return nullptr;
    }
    try {
        GeomAbs_JoinType joinType = GeomAbs_Arc;
        if (join == 1) joinType = GeomAbs_Tangent;
        else if (join == 2) joinType = GeomAbs_Intersection;
        BRepOffsetAPI_MakeEvolved maker(*spineShape,
                                         TopoDS::Wire(*profShape),
                                         joinType, true, false, false,
                                         0.0000001, false, false);
        if (!maker.IsDone()) { set_error("MakeEvolved failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_cylindrical_hole(occt_shape shape, occt_shape face,
                                 double radius, double depth, int through) {
    clear_error();
    if (!shape || !face) { set_error("null shape or face", 2); return nullptr; }
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        TopoDS_Face faceShape = TopoDS::Face(*to_shape(face));
        gp_Ax1 axis = face_to_axis(faceShape);
        BRepFeat_MakeCylindricalHole feat;
        feat.Init(*to_shape(shape), axis);
        if (through) {
            feat.PerformThruNext(radius, true);
        } else {
            feat.PerformBlind(radius, depth, true);
        }
        feat.Build();
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakeCylindricalHole produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_prism_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double height, double dx, double dy, double dz, int operation) {
    clear_error();
    if (!shape || !base_face || !profile) { set_error("null argument", 2); return nullptr; }
    double dir_mag = sqrt(dx*dx + dy*dy + dz*dz);
    try {
        gp_Dir dir(0, 0, 1);
        if (dir_mag >= Precision::Confusion()) {
            dir = gp_Dir(dx, dy, dz);
        }
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakePrism feat(*to_shape(shape), profShape,
                                 TopoDS::Face(*to_shape(base_face)),
                                 dir, fuse, false);
        feat.Perform(height);
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakePrism produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_revol_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double ax, double ay, double az, double angle, int operation) {
    clear_error();
    if (!shape || !base_face || !profile) { set_error("null argument", 2); return nullptr; }
    double axis_mag = sqrt(ax*ax + ay*ay + az*az);
    if (axis_mag < Precision::Confusion()) { set_error("zero axis direction", 2); return nullptr; }
    double ang = angle * M_PI / 180.0;
    if (fabs(ang) < Precision::Confusion()) { set_error("zero revolution angle", 2); return nullptr; }
    try {
        gp_Ax1 axis(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az));
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakeRevol feat(*to_shape(shape), profShape,
                                 TopoDS::Face(*to_shape(base_face)),
                                 axis, fuse, false);
        feat.Perform(ang);
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakeRevol produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_pipe_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                             occt_shape path, int operation) {
    clear_error();
    if (!shape || !base_face || !profile || !path) { set_error("null argument", 2); return nullptr; }
    try {
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakePipe feat(*to_shape(shape), profShape,
                                TopoDS::Face(*to_shape(base_face)),
                                TopoDS::Wire(*to_shape(path)),
                                fuse, false);
        feat.Perform();
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakePipe produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape local_extrude(occt_shape face, double height, double dx, double dy, double dz) {
    clear_error();
    if (!face) { set_error("null face", 2); return nullptr; }
    if (height < Precision::Confusion()) { set_error("non-positive height", 2); return nullptr; }
    try {
        LocOpe_DPrism prism(TopoDS::Face(*to_shape(face)), height, 0.0);
        if (!prism.IsDone()) { set_error("LocOpe_DPrism not done"); return nullptr; }
        TopoDS_Shape result = prism.Shape();
        if (result.IsNull()) { set_error("LocOpe_DPrism produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_groove(occt_shape shape, occt_shape face,
                        double ax, double ay, double az, double angle) {
    clear_error();
    if (!shape || !face) { set_error("null argument", 2); return nullptr; }
    double axis_mag = sqrt(ax*ax + ay*ay + az*az);
    if (axis_mag < Precision::Confusion()) { set_error("zero axis direction", 2); return nullptr; }
    if (angle < Precision::Confusion()) { set_error("non-positive angle", 2); return nullptr; }
    try {
        gp_Ax1 axis(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az));
        double ang = angle * M_PI / 180.0;
        LocOpe_Revol rev;
        rev.Perform(*to_shape(face), axis, ang);
        TopoDS_Shape revShape = rev.Shape();
        if (revShape.IsNull()) { set_error("LocOpe_Revol produced null shape"); return nullptr; }
        BRepAlgoAPI_Cut cut(*to_shape(shape), revShape);
        if (!cut.IsDone()) { set_error("Groove boolean cut not done"); return nullptr; }
        TopoDS_Shape cutResult = cut.Shape();
        if (cutResult.IsNull() || is_empty_shape(cutResult)) { set_error("Groove produced empty result"); return nullptr; }
        return from_shape(cutResult);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_rib(occt_shape shape, occt_shape profile_face, double thickness,
                    double dx, double dy, double dz) {
    clear_error();
    if (!shape || !profile_face) { set_error("null argument", 2); return nullptr; }
    if (thickness < Precision::Confusion()) { set_error("non-positive thickness", 2); return nullptr; }
    try {
        gp_Vec dir(dx, dy, dz);
        dir.Multiply(thickness);
        TopoDS_Shape profShape = *to_shape(profile_face);
        BRepPrimAPI_MakePrism prism(TopoDS::Face(profShape), dir);
        if (!prism.IsDone()) { set_error("rib prism not done"); return nullptr; }
        TopoDS_Shape ribShape = prism.Shape();
        if (ribShape.IsNull()) { set_error("rib prism produced null"); return nullptr; }
        BRepAlgoAPI_Fuse fuse(*to_shape(shape), ribShape);
        if (!fuse.IsDone()) { set_error("rib fuse not done"); return nullptr; }
        TopoDS_Shape result = fuse.Shape();
        if (result.IsNull() || is_empty_shape(result)) { set_error("rib produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}


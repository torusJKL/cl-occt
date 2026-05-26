#include "occt_wrap_internal.h"
#include "occt_wrap_topology.h"
#include <TopExp.hxx>
#include <TopTools_IndexedMapOfShape.hxx>
#include <BRepTools_WireExplorer.hxx>

occt_shape make_edge_line_2d(double x1, double y1, double x2, double y2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, 0), gp_Pnt(x2, y2, 0));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_line_3d(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_circle_2d(double x, double y, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        gp_Circ circle(gp_Ax2(gp_Pnt(x, y, 0), gp_Dir(0, 0, 1)), radius);
        BRepBuilderAPI_MakeEdge maker(circle);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_arc_2d(double x1, double y1, double x2, double y2, double x3, double y3) {
    clear_error();
    try {
        gp_Pnt p1(x1, y1, 0), p2(x2, y2, 0), p3(x3, y3, 0);
        GC_MakeArcOfCircle arcMaker(p1, p2, p3);
        if (!arcMaker.IsDone()) {
            set_error("arc of circle construction failed");
            return nullptr;
        }
        Handle(Geom_TrimmedCurve) arc = arcMaker.Value();
        BRepBuilderAPI_MakeEdge maker(arc);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_wire(occt_shape* edges, int count) {
    clear_error();
    if (count < 1) {
        set_error("wire requires at least one edge", 2);
        return nullptr;
    }
    try {
        BRepBuilderAPI_MakeWire maker;
        for (int i = 0; i < count; i++) {
            if (!edges[i]) {
                set_error("null edge in wire construction", 2);
                return nullptr;
            }
            maker.Add(TopoDS::Edge(*to_shape(edges[i])));
        }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face(occt_shape wire) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        gp_Pln plane(gp_Pnt(ox, oy, oz), gp_Dir(nx, ny, nz));
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(plane, w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_compound(occt_shape* shapes, int count) {
    clear_error();
    try {
        TopoDS_Compound compound;
        BRep_Builder builder;
        builder.MakeCompound(compound);
        for (int i = 0; i < count; i++) {
            if (shapes[i]) {
                builder.Add(compound, *to_shape(shapes[i]));
            }
        }
        return from_shape(compound);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape add_to_compound(occt_shape compound_shape, occt_shape shape) {
    clear_error();
    if (!compound_shape) { set_error("null compound argument", 2); return nullptr; }
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Compound compound;
        BRep_Builder builder;
        builder.MakeCompound(compound);
        // Copy existing sub-shapes into new compound
        TopExp_Explorer exp(*to_shape(compound_shape), TopAbs_SHAPE);
        for (; exp.More(); exp.Next()) {
            builder.Add(compound, exp.Current());
        }
        builder.Add(compound, *to_shape(shape));
        return from_shape(compound);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int compound_is_empty(occt_shape shape) {
    clear_error();
    if (!shape) return 1;
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_SHAPE);
        return exp.More() ? 0 : 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 1;
    }
}

int shape_is_compound(occt_shape shape) {
    clear_error();
    if (!shape) return 0;
    try {
        return to_shape(shape)->ShapeType() == TopAbs_COMPOUND ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void free_shape_array(occt_shape* arr) {
    delete[] arr;
}

int face_edges(occt_shape face, occt_shape** out_edges, int* out_count) {
    clear_error();
    *out_edges = nullptr;
    *out_count = 0;
    if (!face) return 0;
    try {
        TopTools_IndexedMapOfShape edgeMap;
        TopExp_Explorer exp(*to_shape(face), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            edgeMap.Add(exp.Current());
        }
        int n = edgeMap.Extent();
        *out_edges = new occt_shape[n];
        for (int i = 1; i <= n; i++) {
            (*out_edges)[i - 1] = from_shape(edgeMap(i));
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int edge_vertices(occt_shape edge, occt_shape* out_start, occt_shape* out_end) {
    clear_error();
    *out_start = nullptr;
    *out_end = nullptr;
    if (!edge) return 0;
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        TopoDS_Vertex v1, v2;
        TopExp::Vertices(e, v1, v2);
        *out_start = from_shape(v1);
        *out_end = from_shape(v2);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

static bool vertex_matches(const TopoDS_Vertex& v, const TopoDS_Shape& target) {
    if (v.IsNull()) return false;
    return v.IsEqual(target);
}

int vertex_edges(occt_shape vertex, occt_shape parent, occt_shape** out_edges, int* out_count) {
    clear_error();
    *out_edges = nullptr;
    *out_count = 0;
    if (!vertex || !parent) return 0;
    try {
        TopTools_IndexedMapOfShape resultMap;
        TopExp_Explorer exp(*to_shape(parent), TopAbs_EDGE);
        TopoDS_Vertex v_target = TopoDS::Vertex(*to_shape(vertex));
        for (; exp.More(); exp.Next()) {
            TopoDS_Edge e = TopoDS::Edge(exp.Current());
            TopoDS_Vertex v1, v2;
            TopExp::Vertices(e, v1, v2);
            if (vertex_matches(v1, v_target) || vertex_matches(v2, v_target)) {
                resultMap.Add(e);
            }
        }
        int n = resultMap.Extent();
        *out_edges = new occt_shape[n];
        for (int i = 1; i <= n; i++) {
            (*out_edges)[i - 1] = from_shape(resultMap(i));
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int edge_faces(occt_shape edge, occt_shape parent, occt_shape** out_faces, int* out_count) {
    clear_error();
    *out_faces = nullptr;
    *out_count = 0;
    if (!edge || !parent) return 0;
    try {
        TopTools_IndexedMapOfShape resultMap;
        TopExp_Explorer exp(*to_shape(parent), TopAbs_FACE);
        TopoDS_Edge e_target = TopoDS::Edge(*to_shape(edge));
        for (; exp.More(); exp.Next()) {
            TopoDS_Face f = TopoDS::Face(exp.Current());
            TopExp_Explorer fexp(f, TopAbs_EDGE);
            for (; fexp.More(); fexp.Next()) {
                if (fexp.Current().IsEqual(e_target)) {
                    resultMap.Add(f);
                    break;
                }
            }
        }
        int n = resultMap.Extent();
        *out_faces = new occt_shape[n];
        for (int i = 1; i <= n; i++) {
            (*out_faces)[i - 1] = from_shape(resultMap(i));
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_wires(occt_shape face, occt_shape** out_wires, int* out_count) {
    clear_error();
    *out_wires = nullptr;
    *out_count = 0;
    if (!face) return 0;
    try {
        TopTools_IndexedMapOfShape wireMap;
        TopExp_Explorer exp(*to_shape(face), TopAbs_WIRE);
        for (; exp.More(); exp.Next()) {
            wireMap.Add(exp.Current());
        }
        int n = wireMap.Extent();
        *out_wires = new occt_shape[n];
        for (int i = 1; i <= n; i++) {
            (*out_wires)[i - 1] = from_shape(wireMap(i));
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int wire_edges(occt_shape wire, occt_shape** out_edges, int* out_count) {
    clear_error();
    *out_edges = nullptr;
    *out_count = 0;
    if (!wire) return 0;
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepTools_WireExplorer wexp(w);
        TopTools_IndexedMapOfShape edgeMap;
        for (; wexp.More(); wexp.Next()) {
            edgeMap.Add(wexp.Current());
        }
        int n = edgeMap.Extent();
        *out_edges = new occt_shape[n];
        for (int i = 1; i <= n; i++) {
            (*out_edges)[i - 1] = from_shape(edgeMap(i));
        }
        *out_count = n;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_type_int(occt_shape shape) {
    clear_error();
    if (!shape) return -1;
    try {
        return (int)to_shape(shape)->ShapeType();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}

int shape_orientation_int(occt_shape shape) {
    clear_error();
    if (!shape) return -1;
    try {
        return (int)to_shape(shape)->Orientation();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}


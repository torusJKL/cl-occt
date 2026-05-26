#include "occt_wrap_internal.h"
#include "occt_wrap_mesh.h"

occt_shape mesh_shape(occt_shape shape, double deflection, double angle, int relative) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepMesh_IncrementalMesh mesh(*to_shape(shape), deflection, relative != 0, angle, true);
        mesh.Perform();
        return shape;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int mesh_get_vertices(occt_shape shape, double* out_verts, int max_count) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int idx = 0;
        while (exp.More() && (idx + 2) < max_count) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                int nbNodes = tri->NbNodes();
                for (int ni = 1; ni <= nbNodes && (idx + 2) < max_count; ni++) {
                    gp_Pnt p = tri->Node(ni).Transformed(loc.Transformation());
                    out_verts[idx++] = p.X();
                    out_verts[idx++] = p.Y();
                    out_verts[idx++] = p.Z();
                }
            }
            exp.Next();
        }
        return idx;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int mesh_get_triangles(occt_shape shape, int* out_tris, int max_count) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int idx = 0;
        int vert_offset = 0;
        while (exp.More()) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                int nbtri = tri->NbTriangles();
                for (int ti = 1; ti <= nbtri && (idx + 2) < max_count; ti++) {
                    int n1, n2, n3;
                    tri->Triangle(ti).Get(n1, n2, n3);
                    out_tris[idx++] = n1 - 1 + vert_offset;
                    out_tris[idx++] = n2 - 1 + vert_offset;
                    out_tris[idx++] = n3 - 1 + vert_offset;
                }
                vert_offset += tri->NbNodes();
            }
            exp.Next();
        }
        return idx;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int mesh_get_normals(occt_shape shape, double* out_normals, int max_count) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int idx = 0;
        while (exp.More() && idx < max_count) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                int nbNodes = tri->NbNodes();
                for (int ni = 1; ni <= nbNodes && (idx + 2) < max_count; ni++) {
                    gp_Dir d = tri->Normal(ni);
                    out_normals[idx++] = d.X();
                    out_normals[idx++] = d.Y();
                    out_normals[idx++] = d.Z();
                }
            }
            exp.Next();
        }
        return idx;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int mesh_get_triangle_count(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
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

int mesh_triangle_adjacent(occt_shape shape, int tri_index, int edge_index) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return -2; }
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int tri_offset = 0;
        while (exp.More()) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                int nbtri = tri->NbTriangles();
                int local_idx = tri_index - tri_offset;
                if (local_idx >= 0 && local_idx < nbtri) {
                    Poly_Connect conn(tri);
                    int adj[3];
                    conn.Triangles(local_idx + 1, adj[0], adj[1], adj[2]);
                    if (edge_index >= 0 && edge_index < 3) {
                        return adj[edge_index] - 1;
                    }
                    return -2;
                }
                tri_offset += nbtri;
            }
            exp.Next();
        }
        return -1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -2;
    }
}

int mesh_triangle_elements(occt_shape shape, int tri_index, int* out_n1, int* out_n2, int* out_n3) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int tri_offset = 0;
        int vert_offset = 0;
        while (exp.More()) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                int nbtri = tri->NbTriangles();
                int local_idx = tri_index - tri_offset;
                if (local_idx >= 0 && local_idx < nbtri) {
                    int n1, n2, n3;
                    tri->Triangle(local_idx + 1).Get(n1, n2, n3);
                    *out_n1 = n1 - 1 + vert_offset;
                    *out_n2 = n2 - 1 + vert_offset;
                    *out_n3 = n3 - 1 + vert_offset;
                    return 1;
                }
                tri_offset += nbtri;
                vert_offset += tri->NbNodes();
            }
            exp.Next();
        }
        return 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void* meshvs_create_mesh(void) {
    clear_error();
    try {
        Handle(MeshVS_Mesh) mesh = new MeshVS_Mesh();
        mesh->SetDisplayMode(1);
        mesh->SetHilightMode(1);
        mesh->SetAutoHilight(true);
        mesh->SetColor(Quantity_Color(0.8, 0.8, 0.8, Quantity_TOC_RGB));
        return (void*)new Handle(MeshVS_Mesh)(mesh);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void meshvs_free_mesh(void* mesh_ptr) {
    if (!mesh_ptr) return;
    try {
        Handle(MeshVS_Mesh)* mesh = (Handle(MeshVS_Mesh)*)mesh_ptr;
        delete mesh;
    } catch (...) {}
}

int meshvs_set_data(void* mesh_ptr, double* verts, int vcount, int* tris, int tcount, double* colors) {
    clear_error();
    if (!mesh_ptr || !verts || !tris) { set_error("null argument", 2); return 0; }
    try {
        Handle(MeshVS_Mesh)* mesh = (Handle(MeshVS_Mesh)*)mesh_ptr;
        Handle(MeshVS_DataSourceWrapper) src = new MeshVS_DataSourceWrapper(verts, vcount, tris, tcount, colors);
        (*mesh)->SetDataSource(src);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void meshvs_display(void* ctx_ptr, void* mesh_ptr) {
    if (!ctx_ptr || !mesh_ptr) return;
    try {
        AIS_InteractiveContext* ctx = (AIS_InteractiveContext*)ctx_ptr;
        Handle(MeshVS_Mesh)* mesh = (Handle(MeshVS_Mesh)*)mesh_ptr;
        ctx->Display(*mesh, true);
    } catch (...) {}
}


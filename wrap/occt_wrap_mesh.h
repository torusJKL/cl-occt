#ifndef OCCT_WRAP_MESH_H
#define OCCT_WRAP_MESH_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Mesh Operations (BRepMesh_IncrementalMesh, Poly_Triangulation, Poly_Connect) ---

occt_shape mesh_shape(occt_shape shape, double deflection, double angle, int relative);

int mesh_get_vertices(occt_shape shape, double* out_verts, int max_count);
int mesh_get_triangles(occt_shape shape, int* out_tris, int max_count);
int mesh_get_normals(occt_shape shape, double* out_normals, int max_count);
int mesh_get_triangle_count(occt_shape shape);

int mesh_triangle_adjacent(occt_shape shape, int tri_index, int edge_index);
int mesh_triangle_elements(occt_shape shape, int tri_index, int* out_n1, int* out_n2, int* out_n3);

// --- MeshVS ---

void* meshvs_create_mesh(void);
void  meshvs_free_mesh(void* mesh);
int   meshvs_set_data(void* mesh, double* verts, int vcount, int* tris, int tcount, double* colors);
void  meshvs_display(void* ctx, void* mesh);

#ifdef __cplusplus
}
#endif

#endif

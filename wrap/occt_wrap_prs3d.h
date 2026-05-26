#ifndef OCCT_WRAP_PRS3D_H
#define OCCT_WRAP_PRS3D_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Prs3d_Tool* (Parametric Triangulation Generators) ---

void* prs3d_tool_cylinder(double radius, double height, int n_slices, int n_stacks);
void* prs3d_tool_sphere(double radius, int n_slices, int n_stacks);
void* prs3d_tool_torus(double major_radius, double minor_radius, int n_slices, int n_stacks);
void* prs3d_tool_disk(double inner_radius, double outer_radius, int n_slices, int n_stacks);
void  prs3d_triangulation_free(void* handle);
int   prs3d_triangulation_vertex_count(void* handle);
int   prs3d_triangulation_triangle_count(void* handle);
int   prs3d_triangulation_has_normals(void* handle);
void  prs3d_triangulation_get_vertices(void* handle, double* out, int max_count);
void  prs3d_triangulation_get_normals(void* handle, double* out, int max_count);
void  prs3d_triangulation_get_triangles(void* handle, int* out, int max_count);

// --- Prs3d_Arrow, Prs3d_Text, Prs3d_BndBox ---

void* prs3d_arrow(double sx, double sy, double sz,
                  double ex, double ey, double ez,
                  double shaft_radius, double cone_length,
                  double cone_radius, int n_facets);
void* prs3d_bndbox(double xmin, double ymin, double zmin,
                   double xmax, double ymax, double zmax);
int   prs3d_segments_vertex_count(void* handle);
int   prs3d_segments_edge_count(void* handle);
void  prs3d_segments_free(void* handle);
void  prs3d_segments_get_vertices(void* handle, double* out, int max_count);
void  prs3d_segments_get_edges(void* handle, int* out, int max_count);
int   shape_bounding_box(occt_shape shape,
                         double* xmin, double* ymin, double* zmin,
                         double* xmax, double* ymax, double* zmax);

#ifdef __cplusplus
}
#endif

#endif

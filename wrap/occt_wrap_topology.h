#ifndef OCCT_WRAP_TOPOLOGY_H
#define OCCT_WRAP_TOPOLOGY_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape make_edge_line_2d(double x1, double y1, double x2, double y2);
occt_shape make_edge_line_3d(double x1, double y1, double z1, double x2, double y2, double z2);
occt_shape make_edge_circle_2d(double x, double y, double radius);
occt_shape make_edge_arc_2d(double x1, double y1, double x2, double y2, double x3, double y3);

occt_shape make_compound(occt_shape* shapes, int count);
occt_shape add_to_compound(occt_shape compound_shape, occt_shape shape);
int compound_is_empty(occt_shape shape);
int shape_is_compound(occt_shape shape);

occt_shape make_wire(occt_shape* edges, int count);
occt_shape make_face(occt_shape wire);
occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz);

void free_shape_array(occt_shape* arr);

int face_edges(occt_shape face, occt_shape** out_edges, int* out_count);
int edge_vertices(occt_shape edge, occt_shape* out_start, occt_shape* out_end);
int vertex_edges(occt_shape vertex, occt_shape parent, occt_shape** out_edges, int* out_count);
int edge_faces(occt_shape edge, occt_shape parent, occt_shape** out_faces, int* out_count);
int face_wires(occt_shape face, occt_shape** out_wires, int* out_count);
int wire_edges(occt_shape wire, occt_shape** out_edges, int* out_count);
int shape_type_int(occt_shape shape);
int shape_orientation_int(occt_shape shape);

#ifdef __cplusplus
}
#endif

#endif

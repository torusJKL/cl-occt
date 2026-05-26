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

#ifdef __cplusplus
}
#endif

#endif

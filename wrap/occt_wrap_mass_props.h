#ifndef OCCT_WRAP_MASS_PROPS_H
#define OCCT_WRAP_MASS_PROPS_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Mass Properties (BRepGProp) ---

double shape_volume(occt_shape shape);
double shape_area(occt_shape shape);
int    shape_center_of_mass(occt_shape shape, double* out_x, double* out_y, double* out_z);
int    shape_inertia(occt_shape shape, double* out_inertia, int inertia_size,
                     double* out_principal_moments, int pm_size,
                     double* out_principal_axes, int pa_size);

// --- Shape Analysis Queries ---

double shape_distance(occt_shape shape1, occt_shape shape2);
int    shape_distance_extrema(occt_shape shape1, occt_shape shape2,
                              double* out_dist,
                              double* out_p1x, double* out_p1y, double* out_p1z,
                              double* out_p2x, double* out_p2y, double* out_p2z);
int    classify_point_in_solid(occt_shape shape, double px, double py, double pz,
                               int* out_state, occt_shape* out_face);
int    shape_is_valid(occt_shape shape);
const char* shape_analysis_report(occt_shape shape);
int    intersect_curve_shape(occt_curve curve, occt_shape shape,
                             double* out_points, double* out_params,
                             occt_shape* out_faces, int max_results);

// --- Topology Navigation ---

int    map_subshapes(occt_shape shape, int shape_type, int stop_at_type,
                     occt_shape* out_shapes, int max_shapes);
int    count_subshapes(occt_shape shape, int shape_type, int stop_at_type);
const char* dump_shape(occt_shape shape);
int    shape_triangle_count(occt_shape shape);
int    wire_order_check(occt_shape wire, occt_shape face);
occt_curve edge_to_curve(occt_shape edge);
occt_surface face_to_surface(occt_shape face);
occt_shape make_vertex(double x, double y, double z);
occt_shape make_polygon(double* points, int num_points, int closed);

#ifdef __cplusplus
}
#endif

#endif

#ifndef OCCT_WRAP_GEOM3D_H
#define OCCT_WRAP_GEOM3D_H

#ifdef __cplusplus
extern "C" {
#endif

// --- 3D Curves ---

occt_curve make_line_3d(double ox, double oy, double oz, double dx, double dy, double dz);
occt_curve make_circle_3d(double ox, double oy, double oz, double radius);
occt_curve make_ellipse_3d(double ox, double oy, double oz, double major_r, double minor_r);
occt_curve make_hyperbola(double ox, double oy, double oz, double major_r, double minor_r);
occt_curve make_parabola(double ox, double oy, double oz, double focal);
occt_curve make_bezier_curve(double* points, int num_points);
occt_curve make_bspline_curve(double* poles, int num_poles, double* knots, int* mults, int num_knots, int degree);
void      free_curve(occt_curve curve);
int       curve_type(occt_curve curve);
occt_curve make_gc_line(double x1, double y1, double z1, double x2, double y2, double z2);
occt_curve make_gc_arc_of_circle(double x1, double y1, double z1,
                                  double x2, double y2, double z2,
                                  double x3, double y3, double z3);
occt_curve convert_curve_to_bspline(occt_curve curve);
int       curve_bounding_box(occt_curve curve,
                             double* xmin, double* ymin, double* zmin,
                             double* xmax, double* ymax, double* zmax);

// --- 3D Surfaces ---

occt_surface make_plane(double ox, double oy, double oz, double nx, double ny, double nz);
occt_surface make_cylindrical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius);
occt_surface make_conical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius, double semi_angle);
occt_surface make_spherical_surface(double ox, double oy, double oz, double radius);
occt_surface make_toroidal_surface(double ox, double oy, double oz, double major_r, double minor_r);
occt_surface make_bezier_surface(double* poles, int num_u, int num_v);
occt_surface make_bspline_surface(double* poles, int num_u_poles, int num_v_poles,
                                   double* uknots, int* umults, int num_uknots,
                                   double* vknots, int* vmults, int num_vknots,
                                   int udeg, int vdeg);
void        free_surface(occt_surface surface);
int         surface_type(occt_surface surface);
occt_surface convert_surface_to_bspline(occt_surface surface);
int         surface_bounding_box(occt_surface surface,
                                 double* xmin, double* ymin, double* zmin,
                                 double* xmax, double* ymax, double* zmax);

// --- Geometric Algorithms ---

int project_point_on_curve(occt_curve curve,
                           double px, double py, double pz,
                           double* out_x, double* out_y, double* out_z,
                           double* out_dist, double* out_param);
int project_point_on_surface(occt_surface surface,
                             double px, double py, double pz,
                             double* out_x, double* out_y, double* out_z,
                             double* out_u, double* out_v, double* out_dist);
int intersect_curves(occt_curve c1, occt_curve c2,
                     double* out_points, int max_points);
int intersect_curve_surface(occt_curve curve, occt_surface surface,
                            double* out_points, int max_points);
int intersect_surfaces(occt_surface s1, occt_surface s2,
                       occt_curve* out_curves, int max_curves);
int extrema_curve_curve(occt_curve c1, occt_curve c2,
                        double* out_dist,
                        double* out_p1x, double* out_p1y, double* out_p1z,
                        double* out_p2x, double* out_p2y, double* out_p2z);
int extrema_curve_surface(occt_curve curve, occt_surface surface,
                          double* out_dist,
                          double* out_px, double* out_py, double* out_pz,
                          double* out_u, double* out_v);
int intersect_curves_2d(occt_geom2d c1, occt_geom2d c2,
                        double* out_points, int max_points);
int project_point_on_curve_2d(occt_geom2d curve,
                              double px, double py,
                              double* out_x, double* out_y,
                              double* out_dist, double* out_param);
occt_curve points_to_bspline(double* points, int num_points, int degree);
occt_curve interpolate_points(double* points, int num_points,
                              double* init_tangent, double* final_tangent);

#ifdef __cplusplus
}
#endif

#endif

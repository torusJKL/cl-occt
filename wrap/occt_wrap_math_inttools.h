#ifndef OCCT_WRAP_MATH_INTTOOLS_H
#define OCCT_WRAP_MATH_INTTOOLS_H

#ifdef __cplusplus
extern "C" {
#endif

// --- math_BFGS, math_FRPR, math_PSO, math_GlobOptMin ---

int math_bfgs_minimize(double (*fn)(int, const double*), int n_vars,
                       double* initial, double tolerance, int max_iter,
                       double* out_minimizer, double* out_min_value,
                       int* out_iterations);
int math_frpr_minimize(double (*fn)(int, const double*), int n_vars,
                       double* initial, double tolerance, int max_iter,
                       double* out_minimizer, double* out_min_value,
                       int* out_iterations);
int math_pso_minimize(double (*fn)(int, const double*), int n_vars,
                      double* lower, double* upper,
                      double* initial, int n_particles, int max_iter,
                      double tolerance,
                      double* out_minimizer, double* out_min_value,
                      int* out_iterations);
int math_globoptmin_minimize(double (*fn)(int, const double*), int n_vars,
                             double* lower, double* upper,
                             double tolerance, int max_iter,
                             double* out_minimizer, double* out_min_value,
                             int* out_iterations);

// --- IntTools_EdgeEdge, IntTools_EdgeFace, IntTools_FaceFace ---

int  inttools_edge_edge(void* edge1, void* edge2,
                        double* out_points, int max_points,
                        int* out_count);
int  inttools_edge_face(void* edge, void* face,
                        double* out_points, int max_points,
                        int* out_count);
int  inttools_face_face(void* face1, void* face2,
                        double* out_points, int max_points,
                        int* out_point_count,
                        void** out_curves, int max_curves,
                        int* out_curve_count);
void inttools_free_curve(void* curve);

#ifdef __cplusplus
}
#endif

#endif

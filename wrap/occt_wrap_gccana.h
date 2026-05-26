#ifndef OCCT_WRAP_GCCANA_H
#define OCCT_WRAP_GCCANA_H

#ifdef __cplusplus
extern "C" {
#endif

int gccana_circle_tangent_two_lines(
    double x1, double y1, double dx1, double dy1,
    double x2, double y2, double dx2, double dy2,
    double radius,
    double* out_circles, int max_circles, int* out_count);

int gccana_line_through_two_points(
    double x1, double y1,
    double x2, double y2,
    double* out_params);

#ifdef __cplusplus
}
#endif

#endif

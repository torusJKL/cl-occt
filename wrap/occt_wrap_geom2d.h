#ifndef OCCT_WRAP_GEOM2D_H
#define OCCT_WRAP_GEOM2D_H

#ifdef __cplusplus
extern "C" {
#endif

occt_geom2d make_pnt2d(double x, double y);
occt_geom2d make_vec2d(double x, double y);
occt_geom2d make_dir2d(double x, double y);
void free_geom2d(occt_geom2d g);

occt_geom2d make_line_2d(double x, double y, double dx, double dy);
occt_geom2d make_circle_2d(double x, double y, double radius);

#ifdef __cplusplus
}
#endif

#endif

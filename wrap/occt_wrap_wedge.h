#ifndef OCCT_WRAP_WEDGE_H
#define OCCT_WRAP_WEDGE_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape make_wedge_full(double dx, double dy, double dz, double ltx);
occt_shape make_wedge_corner(double dx, double dy, double dz,
                             double xmin, double zmin,
                             double xmax, double zmax);

#ifdef __cplusplus
}
#endif

#endif

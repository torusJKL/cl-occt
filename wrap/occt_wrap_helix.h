#ifndef OCCT_WRAP_HELIX_H
#define OCCT_WRAP_HELIX_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Helix ---

occt_curve make_helix_curve(double radius, double pitch, double height,
                            int left_handed, double angle);
occt_shape make_helix_edge(double radius, double pitch, double height,
                           int left_handed, double angle,
                           occt_surface on_surface);

#ifdef __cplusplus
}
#endif

#endif

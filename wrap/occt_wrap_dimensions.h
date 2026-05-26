#ifndef OCCT_WRAP_DIMENSIONS_H
#define OCCT_WRAP_DIMENSIONS_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Dimensions ---

void* prsdim_make_length_2p(double x1, double y1, double z1, double x2, double y2, double z2);
void* prsdim_make_angle_3p(double vx, double vy, double vz, double p1x, double p1y, double p1z, double p2x, double p2y, double p2z);
void* prsdim_make_diameter(void* shape);
void* prsdim_make_radius(void* shape);
void  prsdim_set_text_position(void* dim, double x, double y, double z);
void  prsdim_set_display_units(void* dim, const char* units);
void  prsdim_set_flyout(void* dim, double v);
void  prsdim_set_measured_edge(void* dim, void* shape, double px, double py, double pz, double nx, double ny, double nz);
void  prsdim_set_arrow_length(void* dim, double v);
void  prsdim_set_extension_size(void* dim, double v);
void  prsdim_set_custom_value(void* dim, const char* value);
void  prsdim_set_angle_edges(void* dim, void* edge1, void* edge2);

#ifdef __cplusplus
}
#endif

#endif

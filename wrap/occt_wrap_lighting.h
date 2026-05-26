#ifndef OCCT_WRAP_LIGHTING_H
#define OCCT_WRAP_LIGHTING_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Lighting ---

void* make_light_ambient(double r, double g, double b, double intensity);
void* make_light_directional(double r, double g, double b, double intensity, double dx, double dy, double dz);
void* make_light_positional(double r, double g, double b, double intensity, double x, double y, double z);
void* make_light_spot(double r, double g, double b, double intensity, double x, double y, double z, double dx, double dy, double dz, double angle, double concentration);
void  light_free(void* light);
void  v3d_viewer_add_light(void* viewer, void* light);
void  v3d_viewer_remove_light(void* viewer, void* light);
void  v3d_viewer_light_on(void* viewer, void* light);
void  v3d_viewer_light_off(void* viewer, void* light);
int   light_is_on(void* light);
void  light_set_color(void* light, double r, double g, double b);
void  light_set_intensity(void* light, double v);
void  light_set_direction(void* light, double dx, double dy, double dz);
void  light_set_position(void* light, double x, double y, double z);
void  light_set_angle(void* light, double angle_deg);
void  light_set_concentration(void* light, double v);
void  light_set_headlight(void* light, int on);
void  light_set_shadows(void* light, int on);
void  v3d_viewer_default_lights(void* viewer);

#ifdef __cplusplus
}
#endif

#endif

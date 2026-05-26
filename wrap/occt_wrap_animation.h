#ifndef OCCT_WRAP_ANIMATION_H
#define OCCT_WRAP_ANIMATION_H

#ifdef __cplusplus
extern "C" {
#endif

// --- AIS Animation ---

occt_ais_animation ais_animation_create(const char* name);
void               ais_animation_free(occt_ais_animation anim);
void               ais_animation_start(occt_ais_animation anim);
void               ais_animation_stop(occt_ais_animation anim);
int                ais_animation_is_playing(occt_ais_animation anim);
void               ais_animation_set_duration(occt_ais_animation anim, double seconds);
double             ais_animation_duration(occt_ais_animation anim);
void               ais_animation_set_progress(occt_ais_animation anim, double progress);
double             ais_animation_progress(occt_ais_animation anim);
void               ais_animation_set_start_pause(occt_ais_animation anim, double seconds);
void               ais_animation_add(occt_ais_animation parent, occt_ais_animation child);
void               ais_animation_remove(occt_ais_animation parent, occt_ais_animation child);
void*              ais_animation_object_create(const char* name, void* ctx, void* ais_obj,
                                                double tx, double ty, double tz,
                                                double rx, double ry, double rz, double angle_deg);
void*              ais_animation_object_get_object(occt_ais_animation anim);
void*              ais_animation_camera_create(const char* name, void* view,
                                                double sex, double sey, double sez,
                                                double stx, double sty, double stz,
                                                double sux, double suy, double suz,
                                                double eex, double eey, double eez,
                                                double etx, double ety, double etz,
                                                double eux, double euy, double euz);
void*              ais_animation_axis_rotation_create(const char* name, void* ctx, void* ais_obj,
                                                       double ox, double oy, double oz,
                                                       double dx, double dy, double dz,
                                                       double angle_start_deg,
                                                       double angle_end_deg);

#ifdef __cplusplus
}
#endif

#endif

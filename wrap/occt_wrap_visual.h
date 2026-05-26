#ifndef OCCT_WRAP_VISUAL_H
#define OCCT_WRAP_VISUAL_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Visualization (Graphic Driver, Viewer, View, Window) ---

void* create_graphic_driver(void);
void  free_graphic_driver(void* driver);
void* v3d_create_viewer(void* driver);
void  v3d_free_viewer(void* viewer);
void* v3d_create_view(void* viewer);
void  v3d_free_view(void* view);
void  v3d_fit_all(void* view);
void  v3d_view_must_be_resized(void* view);
void* create_neutral_window(void* native_handle);
  void  free_neutral_window(void* window);

// --- AIS Visualization (Display Objects) ---

void* ais_create_context(void* viewer);
void  ais_free_context(void*);
void* ais_create_shape(void* shape);
void  ais_free_shape(void*);
void  ais_context_display(void* ctx, void* obj, int update);
void  ais_context_erase(void* ctx, void* obj, int update);
void  ais_context_remove(void* ctx, void* obj, int update);
void  ais_context_remove_all(void* ctx, int update);
int   ais_context_is_displayed(void* ctx, void* obj);

// --- Visualization -- Styling, Camera, MSAA, Grid ---

void v3d_view_set_bg_color(void* view, double r, double g, double b);
void ais_context_set_color(void* ctx, void* obj, double r, double g, double b);
void ais_context_unset_color(void* ctx, void* obj);
void ais_context_set_display_mode(void* ctx, void* obj, int mode);
void v3d_view_set_proj(void* view, int orientation);
void v3d_view_set_eye(void* view, double x, double y, double z);
double v3d_view_get_eye_x(void* view);
double v3d_view_get_eye_y(void* view);
double v3d_view_get_eye_z(void* view);
void v3d_view_set_target(void* view, double x, double y, double z);
double v3d_view_get_target_x(void* view);
double v3d_view_get_target_y(void* view);
double v3d_view_get_target_z(void* view);
void v3d_view_set_up(void* view, double x, double y, double z);
double v3d_view_get_up_x(void* view);
double v3d_view_get_up_y(void* view);
double v3d_view_get_up_z(void* view);
void v3d_view_set_projection_type(void* view, int is_perspective);
int  v3d_view_get_projection_type(void* view);
void v3d_view_set_fov(void* view, double fov_rad);
double v3d_view_get_fov(void* view);
void v3d_view_set_clip_planes(void* view, double near, double far);
void v3d_view_fit_all_shape(void* view, void* shape);
void v3d_view_pan(void* view, double dx, double dy);
void v3d_view_zoom(void* view, double factor);
void v3d_view_rotate(void* view, double ax, double ay, double az);
void v3d_view_reset(void* view);
void v3d_view_set_msaa(void* view, int samples);
int  v3d_view_get_msaa(void* view);
void v3d_view_set_antialiasing(void* view, int on);
int  v3d_view_get_antialiasing(void* view);
void v3d_viewer_activate_grid(void* viewer, int gridType, int drawMode);
void v3d_viewer_deactivate_grid(void* viewer);
void v3d_view_invalidate(void* view);

// --- Grid Extensions ---

int  v3d_viewer_grid_active(void* viewer);
void v3d_view_set_grid_echo(void* view, int on);
void v3d_viewer_set_rectangular_grid_values(void* viewer, double xOrigin, double yOrigin, double xStep, double yStep, double rotationAngle);
void v3d_view_grid_display(void* view, double r, double g, double b, double sizeX, double sizeY);

// --- Background ---

void v3d_view_set_bg_gradient(void* view, double r1, double g1, double b1, double r2, double g2, double b2, int style);
void v3d_view_set_bg_image(void* view, const char* path);
void v3d_view_set_bg_cubemap(void* view, void* cubemap);
void v3d_view_reset_background(void* view);
void* make_cubemap_separate(const char** paths, int count);
void  free_cubemap(void* cubemap);

// --- Rendering ---

void v3d_view_get_camera_handle(void* view, void** out_camera);
void v3d_view_set_camera(void* view, void* camera);

void v3d_view_set_transparency_method(void* view, int method);

void v3d_viewer_set_default_bg_gradient(void* viewer, double r1, double g1, double b1, double r2, double g2, double b2, int style);

void* ais_context_default_drawer(void* ctx);
void v3d_view_set_computed_mode(void* view, int on);
int  v3d_view_computed_mode(void* view);
void v3d_view_set_back_face_model(void* view, int mode);
void v3d_view_set_frustum_culling(void* view, int on);
void v3d_view_redraw(void* view);
void v3d_view_set_immediate_update(void* view, int on);

// --- Viewer Defaults ---

void v3d_viewer_set_default_lights(void* viewer, int on);
void v3d_viewer_set_default_bg_color(void* viewer, double r, double g, double b);
void v3d_viewer_set_default_view_proj(void* viewer, int orientation);
void v3d_viewer_set_default_view_size(void* viewer, double size);
void v3d_viewer_set_default_view_type(void* viewer, int is_perspective);

#ifdef __cplusplus
}
#endif

#endif

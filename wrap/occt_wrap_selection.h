#ifndef OCCT_WRAP_SELECTION_H
#define OCCT_WRAP_SELECTION_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Selection (AIS_InteractiveContext) ---

int    ais_context_nb_selected(void* ctx);
void   ais_context_init_selected(void* ctx);
int    ais_context_more_selected(void* ctx);
void   ais_context_next_selected(void* ctx);
void*  ais_context_selected_interactive(void* ctx);
void*  ais_context_selected_shape(void* ctx);
int    ais_context_has_selected_shape(void* ctx);

void   ais_context_set_selected(void* ctx, void* obj, int update);
void   ais_context_add_or_remove_selected(void* ctx, void* obj, int update);
void   ais_context_clear_selected(void* ctx, int update);
int    ais_context_is_selected(void* ctx, void* obj);

int    ais_context_move_to(void* ctx, void* view, int x, int y);
int    ais_context_select_detected(void* ctx, int scheme);
int    ais_context_select_point(void* ctx, void* view, int x, int y, int scheme);

void   ais_context_hilight_selected(void* ctx, int update);
void   ais_context_unhilight_selected(void* ctx, int update);

void   ais_context_fit_selected(void* ctx, void* view, double margin);
void*  ais_context_detected_interactive(void* ctx);
int    ais_context_has_detected(void* ctx);
void   ais_context_clear_detected(void* ctx);
void   ais_context_set_selection_sensitivity(void* ctx, void* obj, int mode, int sensitivity);
void   ais_context_set_pixel_tolerance(void* ctx, int pixels);
void   ais_context_set_automatic_hilight(void* ctx, int on);
void   ais_context_set_to_hilight_selected(void* ctx, int on);

// --- Selection Filters (StdSelect) ---

void*  make_edge_filter(void);
void*  make_face_filter(void);
void*  make_shape_type_filter(int shape_type);
void   filter_set_edge_type(void* filter, int edge_type);
void   filter_set_face_type(void* filter, int face_type);
void   ais_context_add_filter(void* ctx, void* filter);
void   ais_context_remove_filter(void* ctx, void* filter);
void   free_filter(void* filter);

// --- Entity Owners (SelectMgr / StdSelect) ---

void*  ais_context_selected_owner(void* ctx);
int    owner_priority(void* owner);
void*  brep_owner_shape(void* owner);
int    owner_has_shape(void* owner);
int    owner_location(void* owner, double* matrix);
void   free_owner(void* owner);

#ifdef __cplusplus
}
#endif

#endif

#ifndef OCCT_WRAP_XCAF_H
#define OCCT_WRAP_XCAF_H

#ifdef __cplusplus
extern "C" {
#endif

// --- XCAF Document Tools ---

int xcaf_new_doc(xde_doc* out_doc);
void xcaf_free_doc(xde_doc doc);
int xcaf_save_shape_to_doc(xde_doc doc, occt_shape shape);
// LayerTool
int xcaf_set_layer(xde_doc doc, occt_shape shape, const char* layer);
int xcaf_unset_one_layer(xde_doc doc, occt_shape shape, const char* layer);
int xcaf_unset_all_layers(xde_doc doc, occt_shape shape);
int xcaf_get_layer_count(xde_doc doc, occt_shape shape);
void xcaf_get_layer_name(xde_doc doc, occt_shape shape, int index, char* buf, int buf_size);
// MaterialTool
int xcaf_has_material(xde_doc doc, occt_shape shape);
// ViewTool
int xcaf_add_view(xde_doc doc);
int xcaf_get_view_count(xde_doc doc);
// VisMaterialTool
int xcaf_get_visual_material_count(xde_doc doc);
int xcaf_get_visual_material(xde_doc doc, occt_shape shape,
                              double* out_r, double* out_g, double* out_b, double* out_a);
// ClippingPlaneTool
int xcaf_get_clipping_plane_count(xde_doc doc);
// Editor
int xcaf_expand_assembly(xde_doc doc);

#ifdef __cplusplus
}
#endif

#endif

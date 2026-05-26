#ifndef OCCT_WRAP_TEXT_H
#define OCCT_WRAP_TEXT_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Font & Text ---

occt_brep_font make_brep_font_from_file(const char* font_path, double size, int face_id);
occt_brep_font make_brep_font_from_name(const char* font_name, int font_aspect, double size);
void free_brep_font(occt_brep_font font);
occt_shape make_text_shape(occt_brep_font font, const char* text, int h_align, int v_align);
occt_shape make_text_shape_on_plane(occt_brep_font font, const char* text, int h_align, int v_align,
                                     double px, double py, double pz,
                                     double zx, double zy, double zz);
occt_shape make_text_shape_on_plane_full(occt_brep_font font, const char* text, int h_align, int v_align,
                                          double px, double py, double pz,
                                          double zx, double zy, double zz,
                                          double xx, double xy, double xz);
void text_bounding_box(occt_brep_font font, const char* text,
                       int h_align, int v_align,
                       double* out_width, double* out_height);
const char* enumerate_fonts(void);
const char* query_font_info(const char* font_name);
void* ais_text_label_create(const char* text);
void  ais_text_label_free(void* label);
void  ais_text_label_set_text(void* label, const char* text);
void  ais_text_label_set_position(void* label, double x, double y, double z);
void  ais_text_label_set_color(void* label, double r, double g, double b);
void  ais_text_label_set_font(void* label, const char* font_name, double height);
void  ais_text_label_set_height(void* label, double height);
occt_shape font_render_glyph(occt_brep_font font, unsigned int codepoint);
double font_ascender(occt_brep_font font);
double font_descender(occt_brep_font font);
double font_line_spacing(occt_brep_font font);
double font_advance_x(occt_brep_font font, unsigned int c1, unsigned int c2);
double font_advance_y(occt_brep_font font, unsigned int c1, unsigned int c2);
void font_set_width_scaling(occt_brep_font font, double scale);
void font_set_composite_curve_mode(occt_brep_font font, int on);

// --- Text Label Enhancements ---

void ais_text_label_set_angle(void* label, double rad);
void ais_text_label_set_hjustification(void* label, int align);
void ais_text_label_set_vjustification(void* label, int align);
void ais_text_label_set_color_sub_title(void* label, double r, double g, double b);
void ais_text_label_set_display_type(void* label, int type);

#ifdef __cplusplus
}
#endif

#endif

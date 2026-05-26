#ifndef OCCT_WRAP_XDE_H
#define OCCT_WRAP_XDE_H

#ifdef __cplusplus
extern "C" {
#endif

// --- XDE Document Lifecycle ---

xde_doc xde_new_doc(void);
void   xde_free_doc(xde_doc doc);
xde_doc xde_read_step(const char* filename);
int    xde_write_step(xde_doc doc, const char* filename);

// --- Label Navigation ---

int  xde_get_root_count(xde_doc doc);
void xde_get_root_path(xde_doc doc, int index, char* buf, int buf_size);
int  xde_get_child_count(xde_doc doc, const char* path);
void xde_get_child_path(xde_doc doc, const char* parent_path, int index, char* buf, int buf_size);

// --- Attribute Read ---

occt_shape xde_get_shape_at(xde_doc doc, const char* path);
void       xde_get_name_at(xde_doc doc, const char* path, char* buf, int buf_size);
int        xde_get_color_at(xde_doc doc, const char* path, int* type, double* r, double* g, double* b, double* a);
int        xde_get_location_at(xde_doc doc, const char* path, double* matrix);

// --- Attribute Write (composite -- creates label, sets all properties, returns child path) ---

void xde_add_part(xde_doc doc, const char* parent_path, occt_shape shape,
                  const char* name, int color_type, double r, double g, double b, double a,
                  const double* matrix, char* buf, int buf_size);

#ifdef __cplusplus
}
#endif

#endif

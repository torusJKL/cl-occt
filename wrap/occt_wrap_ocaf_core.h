#ifndef OCCT_WRAP_OCAF_CORE_H
#define OCCT_WRAP_OCAF_CORE_H

#include "occt_wrap_types.h"

#ifdef __cplusplus
extern "C" {
#endif

// --- Document Lifecycle ---

xde_doc ocaf_new_doc(void);
void ocaf_free_doc(xde_doc doc);

// --- Label Tree Navigation ---

ocaf_label ocaf_root_label(xde_doc doc);
ocaf_label ocaf_find_label(xde_doc doc, const int* tags, int count, int create);
int ocaf_label_tag(ocaf_label label);
int ocaf_label_depth(ocaf_label label);
ocaf_label* ocaf_label_children(ocaf_label label, int* out_count);

// --- Transactions ---

void ocaf_begin_transaction(xde_doc doc, const char* name);
void ocaf_commit_transaction(xde_doc doc);
void ocaf_undo_transaction(xde_doc doc);

// --- Attributes — Integer ---

void ocaf_set_integer(ocaf_label label, int value);
int ocaf_get_integer(ocaf_label label);
int ocaf_has_integer(ocaf_label label);

// --- Attributes — Real ---

void ocaf_set_real(ocaf_label label, double value);
double ocaf_get_real(ocaf_label label);
int ocaf_has_real(ocaf_label label);

// --- Attributes — String ---

void ocaf_set_string(ocaf_label label, const char* value);
const char* ocaf_get_string(ocaf_label label);
int ocaf_has_string(ocaf_label label);

// --- Attributes — Name ---

void ocaf_set_name(ocaf_label label, const char* name);
const char* ocaf_get_name(ocaf_label label);

// --- Resource Management ---

void ocaf_free_label(ocaf_label label);
void ocaf_free_label_array(ocaf_label* labels, int count);
void ocaf_free_string(const char* str);

#ifdef __cplusplus
}
#endif

#endif

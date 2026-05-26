#include "occt_wrap_internal.h"
#include "occt_wrap_ocaf_core.h"

#include <TDF_Data.hxx>
#include <TDF_Label.hxx>
#include <TDF_Tool.hxx>
#include <TDocStd_Document.hxx>
#include <TDataStd_Integer.hxx>
#include <TDataStd_Real.hxx>
#include <TDataStd_AsciiString.hxx>
#include <TDataStd_Name.hxx>

// --- Document Lifecycle ---

xde_doc ocaf_new_doc(void) {
    clear_error();
    try {
        Handle(TDocStd_Document)* h = new Handle(TDocStd_Document);
        *h = new TDocStd_Document("MDTV-XCAF");
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ocaf_free_doc(xde_doc doc) {
    if (doc) {
        delete static_cast<Handle(TDocStd_Document)*>(doc);
    }
}

// --- Label Tree Navigation ---

ocaf_label ocaf_root_label(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null doc", 2); return nullptr; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TDF_Label* label = new TDF_Label(hDoc->Main());
        return label;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

ocaf_label ocaf_find_label(xde_doc doc, const int* tags, int count, int create) {
    clear_error();
    if (!doc || !tags) { set_error("null argument", 2); return nullptr; }
    if (count < 1) { set_error("tag count must be >= 1", 2); return nullptr; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TDF_Label label = hDoc->Main();
        for (int i = 0; i < count; i++) {
            label = label.FindChild(tags[i], create != 0);
            if (label.IsNull()) {
                return nullptr;
            }
        }
        TDF_Label* result = new TDF_Label(label);
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ocaf_label_tag(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        return l->Tag();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_label_depth(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        return l->Depth();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

ocaf_label* ocaf_label_children(ocaf_label label, int* out_count) {
    clear_error();
    if (!label || !out_count) { set_error("null argument", 2); return nullptr; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        int count = 0;
        {
            TDF_ChildIterator it(*l, false);
            for (; it.More(); it.Next()) {
                count++;
            }
        }
        ocaf_label* arr = new ocaf_label[count];
        int idx = 0;
        {
            TDF_ChildIterator it(*l, false);
            for (; it.More(); it.Next()) {
                arr[idx] = new TDF_Label(it.Value());
                idx++;
            }
        }
        *out_count = count;
        return arr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return nullptr;
    }
}

// --- Transactions ---

void ocaf_begin_transaction(xde_doc doc, const char* name) {
    clear_error();
    if (!doc) { set_error("null doc", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        hDoc->NewCommand();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ocaf_commit_transaction(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null doc", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        hDoc->CommitCommand();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ocaf_undo_transaction(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null doc", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        hDoc->Undo();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Attributes --- Integer ---

void ocaf_set_integer(ocaf_label label, int value) {
    clear_error();
    if (!label) { set_error("null label", 2); return; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        TDataStd_Integer::Set(*l, value);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ocaf_get_integer(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_Integer) attr;
        if (l->FindAttribute(TDataStd_Integer::GetID(), attr)) {
            return attr->Get();
        }
        return 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_has_integer(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_Integer) attr;
        return l->FindAttribute(TDataStd_Integer::GetID(), attr) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Attributes --- Real ---

void ocaf_set_real(ocaf_label label, double value) {
    clear_error();
    if (!label) { set_error("null label", 2); return; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        TDataStd_Real::Set(*l, value);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

double ocaf_get_real(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0.0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_Real) attr;
        if (l->FindAttribute(TDataStd_Real::GetID(), attr)) {
            return attr->Get();
        }
        return 0.0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0.0;
    }
}

int ocaf_has_real(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_Real) attr;
        return l->FindAttribute(TDataStd_Real::GetID(), attr) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Attributes --- String ---

void ocaf_set_string(ocaf_label label, const char* value) {
    clear_error();
    if (!label) { set_error("null label", 2); return; }
    if (!value) { set_error("null value", 2); return; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        TDataStd_AsciiString::Set(*l, TCollection_AsciiString(value));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

const char* ocaf_get_string(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return nullptr; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_AsciiString) attr;
        if (l->FindAttribute(TDataStd_AsciiString::GetID(), attr)) {
            TCollection_AsciiString s = attr->Get();
            char* buf = new char[s.Length() + 1];
            strcpy(buf, s.ToCString());
            return buf;
        }
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ocaf_has_string(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_AsciiString) attr;
        return l->FindAttribute(TDataStd_AsciiString::GetID(), attr) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Attributes --- Name ---

void ocaf_set_name(ocaf_label label, const char* name) {
    clear_error();
    if (!label) { set_error("null label", 2); return; }
    if (!name) { set_error("null name", 2); return; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        TDataStd_Name::Set(*l, TCollection_ExtendedString(name));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

const char* ocaf_get_name(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return nullptr; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TDataStd_Name) attr;
        if (l->FindAttribute(TDataStd_Name::GetID(), attr)) {
            TCollection_ExtendedString ext = attr->Get();
            char* buf = new char[ext.LengthOfCString() + 1];
            strcpy(buf, TCollection_AsciiString(ext).ToCString());
            return buf;
        }
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Resource Management ---

void ocaf_free_label(ocaf_label label) {
    if (label) {
        delete static_cast<TDF_Label*>(label);
    }
}

void ocaf_free_label_array(ocaf_label* labels, int count) {
    if (labels) {
        for (int i = 0; i < count; i++) {
            if (labels[i]) {
                delete static_cast<TDF_Label*>(labels[i]);
            }
        }
        delete[] labels;
    }
}

void ocaf_free_string(const char* str) {
    if (str) {
        delete[] str;
    }
}

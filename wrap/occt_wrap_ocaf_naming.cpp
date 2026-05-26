#include "occt_wrap_internal.h"
#include "occt_wrap_ocaf_naming.h"

#include <TNaming_Builder.hxx>
#include <TNaming_NamedShape.hxx>
#include <TNaming_Evolution.hxx>

// --- Topological Naming ---

void ocaf_name_shape(ocaf_label label, occt_shape shape, int evolution) {
    clear_error();
    if (!label || !shape) { set_error("null argument", 2); return; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        TNaming_Builder builder(*l);
        if (evolution == 3) {
            // DELETED
            builder.Delete(*to_shape(shape));
        } else {
            builder.Generated(*to_shape(shape));
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_shape ocaf_get_named_shape(ocaf_label label, int evolution) {
    clear_error();
    if (!label) { set_error("null label", 2); return nullptr; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TNaming_NamedShape) ns;
        if (!l->FindAttribute(TNaming_NamedShape::GetID(), ns)) {
            return nullptr;
        }
        if (ns.IsNull()) {
            return nullptr;
        }
        TopoDS_Shape result = ns->Get();
        if (result.IsNull()) {
            return nullptr;
        }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ocaf_named_shape_is_deleted(ocaf_label label) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Handle(TNaming_NamedShape) ns;
        if (!l->FindAttribute(TNaming_NamedShape::GetID(), ns)) {
            return 0;
        }
        if (ns.IsNull()) {
            return 0;
        }
        return (ns->Evolution() == TNaming_DELETE) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

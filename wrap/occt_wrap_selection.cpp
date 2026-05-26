#include "occt_wrap_internal.h"
#include "occt_wrap_selection.h"

int ais_context_nb_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->NbSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_init_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->InitSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_context_more_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->MoreSelected() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_next_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->NextSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_context_selected_interactive(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(AIS_InteractiveObject)* h = new Handle(AIS_InteractiveObject);
        *h = (*ctx)->SelectedInteractive();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_context_selected_shape(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return new TopoDS_Shape((*ctx)->SelectedShape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ais_context_has_selected_shape(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->HasSelectedShape() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_set_selected(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetSelected(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_add_or_remove_selected(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->AddOrRemoveSelected(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_clear_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->ClearSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_context_is_selected(void* ctx_ptr, void* obj_ptr) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        return (*ctx)->IsSelected(*obj) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_move_to(void* ctx_ptr, void* view_ptr, int x, int y) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return static_cast<int>((*ctx)->MoveTo(x, y, *view, true));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_select_detected(void* ctx_ptr, int scheme) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return static_cast<int>((*ctx)->SelectDetected(static_cast<AIS_SelectionScheme>(scheme)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_select_point(void* ctx_ptr, void* view_ptr, int x, int y, int scheme) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        NCollection_Vec2<int> pnt(x, y);
        return static_cast<int>((*ctx)->SelectPoint(pnt, *view, static_cast<AIS_SelectionScheme>(scheme)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_hilight_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->HilightSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_unhilight_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->UnhilightSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_fit_selected(void* ctx_ptr, void* view_ptr, double margin) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*ctx)->FitSelected(*view, margin, true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_context_detected_interactive(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(AIS_InteractiveObject)* h = new Handle(AIS_InteractiveObject);
        *h = (*ctx)->DetectedInteractive();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ais_context_has_detected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->HasDetected() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_clear_detected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->ClearDetected(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_selection_sensitivity(void* ctx_ptr, void* obj_ptr, int mode, int sensitivity) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetSelectionSensitivity(*obj, mode, sensitivity);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_pixel_tolerance(void* ctx_ptr, int pixels) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetPixelTolerance(pixels);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_automatic_hilight(void* ctx_ptr, int on) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetAutomaticHilight(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_to_hilight_selected(void* ctx_ptr, int on) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetToHilightSelected(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* make_edge_filter(void) {
    clear_error();
    try {
        Handle(SelectMgr_Filter)* h = new Handle(SelectMgr_Filter);
        *h = new StdSelect_EdgeFilter(StdSelect_AnyEdge);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* make_face_filter(void) {
    clear_error();
    try {
        Handle(SelectMgr_Filter)* h = new Handle(SelectMgr_Filter);
        *h = new StdSelect_FaceFilter(StdSelect_AnyFace);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* make_shape_type_filter(int shape_type) {
    clear_error();
    try {
        Handle(SelectMgr_Filter)* h = new Handle(SelectMgr_Filter);
        *h = new StdSelect_ShapeTypeFilter(static_cast<TopAbs_ShapeEnum>(shape_type));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void filter_set_edge_type(void* filter_ptr, int edge_type) {
    clear_error();
    if (!filter_ptr) { set_error("null filter", 2); return; }
    try {
        auto* filter = static_cast<Handle(SelectMgr_Filter)*>(filter_ptr);
        Handle(StdSelect_EdgeFilter) ef = Handle(StdSelect_EdgeFilter)::DownCast(*filter);
        if (ef.IsNull()) { set_error("not an EdgeFilter", 2); return; }
        ef->SetType(static_cast<StdSelect_TypeOfEdge>(edge_type));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void filter_set_face_type(void* filter_ptr, int face_type) {
    clear_error();
    if (!filter_ptr) { set_error("null filter", 2); return; }
    try {
        auto* filter = static_cast<Handle(SelectMgr_Filter)*>(filter_ptr);
        Handle(StdSelect_FaceFilter) ff = Handle(StdSelect_FaceFilter)::DownCast(*filter);
        if (ff.IsNull()) { set_error("not a FaceFilter", 2); return; }
        ff->SetType(static_cast<StdSelect_TypeOfFace>(face_type));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_add_filter(void* ctx_ptr, void* filter_ptr) {
    clear_error();
    if (!ctx_ptr || !filter_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* filter = static_cast<Handle(SelectMgr_Filter)*>(filter_ptr);
        (*ctx)->AddFilter(*filter);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_remove_filter(void* ctx_ptr, void* filter_ptr) {
    clear_error();
    if (!ctx_ptr || !filter_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* filter = static_cast<Handle(SelectMgr_Filter)*>(filter_ptr);
        (*ctx)->RemoveFilter(*filter);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void free_filter(void* filter_ptr) {
    clear_error();
    if (!filter_ptr) { return; }
    delete static_cast<Handle(SelectMgr_Filter)*>(filter_ptr);
}

void* ais_context_selected_owner(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(SelectMgr_EntityOwner)* h = new Handle(SelectMgr_EntityOwner);
        *h = (*ctx)->SelectedOwner();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int owner_priority(void* owner_ptr) {
    clear_error();
    if (!owner_ptr) { set_error("null owner", 2); return 0; }
    try {
        auto* owner = static_cast<Handle(SelectMgr_EntityOwner)*>(owner_ptr);
        return (*owner)->Priority();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void* brep_owner_shape(void* owner_ptr) {
    clear_error();
    if (!owner_ptr) { set_error("null owner", 2); return nullptr; }
    try {
        auto* owner = static_cast<Handle(SelectMgr_EntityOwner)*>(owner_ptr);
        Handle(StdSelect_BRepOwner) brep = Handle(StdSelect_BRepOwner)::DownCast(*owner);
        if (brep.IsNull()) { return nullptr; }
        const TopoDS_Shape& s = brep->Shape();
        if (s.IsNull()) { return nullptr; }
        return new TopoDS_Shape(s);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int owner_has_shape(void* owner_ptr) {
    clear_error();
    if (!owner_ptr) { set_error("null owner", 2); return 0; }
    try {
        auto* owner = static_cast<Handle(SelectMgr_EntityOwner)*>(owner_ptr);
        Handle(StdSelect_BRepOwner) brep = Handle(StdSelect_BRepOwner)::DownCast(*owner);
        if (brep.IsNull()) { return 0; }
        return brep->HasShape() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int owner_location(void* owner_ptr, double* matrix) {
    clear_error();
    if (!owner_ptr || !matrix) { set_error("null argument", 2); return 0; }
    try {
        auto* owner = static_cast<Handle(SelectMgr_EntityOwner)*>(owner_ptr);
        Handle(StdSelect_BRepOwner) brep = Handle(StdSelect_BRepOwner)::DownCast(*owner);
        if (brep.IsNull()) { return 0; }
        TopLoc_Location tl = brep->Location();
        if (tl.IsIdentity()) { return 0; }
        gp_Trsf loc = tl.Transformation();
        gp_Mat rot = loc.VectorialPart();
        gp_XYZ trans = loc.TranslationPart();
        matrix[0]  = rot(1,1); matrix[1]  = rot(1,2); matrix[2]  = rot(1,3); matrix[3]  = 0;
        matrix[4]  = rot(2,1); matrix[5]  = rot(2,2); matrix[6]  = rot(2,3); matrix[7]  = 0;
        matrix[8]  = rot(3,1); matrix[9]  = rot(3,2); matrix[10] = rot(3,3); matrix[11] = 0;
        matrix[12] = trans.X(); matrix[13] = trans.Y(); matrix[14] = trans.Z(); matrix[15] = 1;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void free_owner(void* owner_ptr) {
    clear_error();
    if (!owner_ptr) { return; }
    delete static_cast<Handle(SelectMgr_EntityOwner)*>(owner_ptr);
}


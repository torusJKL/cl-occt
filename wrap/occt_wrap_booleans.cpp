#include "occt_wrap_internal.h"
#include "occt_wrap_booleans.h"


occt_shape boolean_cut(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Cut maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean cut not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean cut produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape boolean_fuse(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Fuse maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean fuse not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean fuse produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape boolean_common(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Common maker(*to_shape(a), *to_shape(b));
        if (!maker.IsDone()) { set_error("Boolean common not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (is_empty_shape(result)) { set_error("Boolean common produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}


occt_shape boolean_section(occt_shape a, occt_shape b) {
    clear_error();
    if (!a || !b) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepAlgoAPI_Section maker(*to_shape(a), *to_shape(b));
        maker.Build();
        if (!maker.IsDone()) { set_error("Boolean section not done"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (result.IsNull() || is_empty_edge_shape(result)) { set_error("Boolean section produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

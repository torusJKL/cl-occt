#include "occt_wrap_internal.h"
#include "occt_wrap_shape_copy.h"
#include <BRepBuilderAPI_Copy.hxx>

occt_shape shape_copy(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        BRepBuilderAPI_Copy copier(*to_shape(shape));
        TopoDS_Shape result = copier.Shape();
        if (result.IsNull()) { set_error("shape copy produced null result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

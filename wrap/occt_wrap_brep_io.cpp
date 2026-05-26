#include "occt_wrap_internal.h"
#include "occt_wrap_brep_io.h"
#include <TopTools_FormatVersion.hxx>

int brep_write_shape(occt_shape shape, const char* filename) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return 0; }
    if (!filename || filename[0] == '\0') { set_error("invalid filename", 2); return 0; }
    try {
        bool ok = BRepTools::Write(*to_shape(shape), filename, false, false,
                                   TopTools_FormatVersion_CURRENT);
        if (!ok) { set_error("BRepTools::Write failed", 2); return 0; }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape brep_read_shape(const char* filename) {
    clear_error();
    if (!filename || filename[0] == '\0') { set_error("invalid filename", 2); return nullptr; }
    try {
        TopoDS_Shape shape;
        BRep_Builder builder;
        bool ok = BRepTools::Read(shape, filename, builder);
        if (!ok || shape.IsNull()) {
            set_error("BRepTools::Read failed", 2);
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

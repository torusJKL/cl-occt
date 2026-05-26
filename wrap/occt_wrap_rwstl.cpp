#include "occt_wrap_internal.h"
#include "occt_wrap_rwstl.h"
#include <RWStl.hxx>
#include <OSD_Path.hxx>

occt_triangulation rwstl_read_file(const char* filename) {
    clear_error();
    if (!filename || filename[0] == '\0') { set_error("invalid filename", 2); return nullptr; }
    try {
        Handle(Poly_Triangulation) tri = RWStl::ReadFile(filename);
        if (tri.IsNull()) { set_error("RWStl::ReadFile returned null", 2); return nullptr; }
        return new Handle(Poly_Triangulation)(tri);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int rwstl_write_file(occt_triangulation tri, const char* filename) {
    clear_error();
    if (!tri) { set_error("null triangulation", 2); return 0; }
    if (!filename || filename[0] == '\0') { set_error("invalid filename", 2); return 0; }
    try {
        Handle(Poly_Triangulation)* hTri = static_cast<Handle(Poly_Triangulation)*>(tri);
        OSD_Path path{TCollection_AsciiString{filename}};
        bool ok = RWStl::WriteBinary(*hTri, path);
        if (!ok) { set_error("RWStl::WriteBinary failed", 2); return 0; }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void rwstl_free_triangulation(occt_triangulation tri) {
    if (tri) {
        delete static_cast<Handle(Poly_Triangulation)*>(tri);
    }
}

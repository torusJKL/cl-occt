#include "occt_wrap_internal.h"
#include "occt_wrap_normal_project.h"
#include <BRepAlgo_NormalProjection.hxx>

occt_shape normal_project(occt_shape shape_to_project, occt_shape face) {
    clear_error();
    if (!shape_to_project) { set_error("null shape to project", 2); return nullptr; }
    if (!face) { set_error("null face", 2); return nullptr; }
    try {
        TopoDS_Face targetFace = TopoDS::Face(*to_shape(face));
        BRepAlgo_NormalProjection proj(targetFace);
        proj.Add(*to_shape(shape_to_project));
        proj.Build();
        if (!proj.IsDone()) { set_error("NormalProjection failed", 2); return nullptr; }
        TopoDS_Shape result = proj.Projection();
        if (result.IsNull()) { set_error("NormalProjection produced null", 2); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

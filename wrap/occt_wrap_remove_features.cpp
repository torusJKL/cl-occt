#include "occt_wrap_internal.h"
#include "occt_wrap_remove_features.h"
#include <BOPAlgo_RemoveFeatures.hxx>

occt_shape remove_features(occt_shape shape, occt_shape* faces, int num_faces) {
    clear_error();
    if (!shape) { set_error("null shape", 2); return nullptr; }
    if (!faces || num_faces < 1) { set_error("no faces provided", 2); return nullptr; }
    try {
        BOPAlgo_RemoveFeatures remover;
        remover.SetShape(*to_shape(shape));
        NCollection_List<TopoDS_Shape> facesToRemove;
        for (int i = 0; i < num_faces; i++) {
            if (faces[i]) {
                facesToRemove.Append(*to_shape(faces[i]));
            }
        }
        remover.AddFacesToRemove(facesToRemove);
        remover.Perform();
        if (remover.HasErrors()) { set_error("RemoveFeatures failed", 2); return nullptr; }
        TopoDS_Shape result = remover.Shape();
        if (result.IsNull()) { set_error("RemoveFeatures produced null shape", 2); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

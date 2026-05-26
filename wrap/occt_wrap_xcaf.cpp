#include "occt_wrap_internal.h"
#include "occt_wrap_xcaf.h"

int xcaf_new_doc(xde_doc* out_doc) {
    clear_error();
    if (!out_doc) { set_error("null output pointer", 2); return 0; }
    try {
        Handle(TDocStd_Document)* h = new Handle(TDocStd_Document);
        *h = new TDocStd_Document("MDTV-XCAF");
        // Initialize XCAF document structure
        XCAFDoc_DocumentTool::Set((*h)->Main());
        *out_doc = h;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void xcaf_free_doc(xde_doc doc) {
    if (doc) {
        delete static_cast<Handle(TDocStd_Document)*>(doc);
    }
}

int xcaf_save_shape_to_doc(xde_doc doc, occt_shape shape) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        TDF_Label label = st->AddShape(*to_shape(shape), true);
        return !label.IsNull() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_set_layer(xde_doc doc, occt_shape shape, const char* layer) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_LayerTool) tool = XCAFDoc_DocumentTool::LayerTool(hDoc->Main());
        TDF_Label label = xcaf_find_shape_label(hDoc, *to_shape(shape));
        if (label.IsNull()) { set_error("shape not found in document"); return 0; }
        tool->SetLayer(label, TCollection_ExtendedString(layer));
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_unset_one_layer(xde_doc doc, occt_shape shape, const char* layer) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_LayerTool) tool = XCAFDoc_DocumentTool::LayerTool(hDoc->Main());
        TDF_Label label = xcaf_find_shape_label(hDoc, *to_shape(shape));
        if (label.IsNull()) { set_error("shape not found in document"); return 0; }
        return tool->UnSetOneLayer(label, TCollection_ExtendedString(layer)) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_unset_all_layers(xde_doc doc, occt_shape shape) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_LayerTool) tool = XCAFDoc_DocumentTool::LayerTool(hDoc->Main());
        TDF_Label label = xcaf_find_shape_label(hDoc, *to_shape(shape));
        if (label.IsNull()) { set_error("shape not found in document"); return 0; }
        tool->UnSetLayers(label);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_get_layer_count(xde_doc doc, occt_shape shape) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_LayerTool) tool = XCAFDoc_DocumentTool::LayerTool(hDoc->Main());
        auto layers = tool->GetLayers(*to_shape(shape));
        return layers.IsNull() ? 0 : layers->Size();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void xcaf_get_layer_name(xde_doc doc, occt_shape shape, int index, char* buf, int buf_size) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); buf[0] = '\0'; return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_LayerTool) tool = XCAFDoc_DocumentTool::LayerTool(hDoc->Main());
        auto layers = tool->GetLayers(*to_shape(shape));
        if (layers.IsNull() || index < 1 || index > layers->Size()) { buf[0] = '\0'; return; }
        TCollection_ExtendedString name = layers->Value(index);
        TCollection_AsciiString ascii(name);
        const char* str = ascii.ToCString();
        strncpy(buf, str, buf_size - 1);
        buf[buf_size - 1] = '\0';
    } catch (Standard_Failure& e) {
        set_error(e.what());
        buf[0] = '\0';
    }
}

int xcaf_has_material(xde_doc doc, occt_shape shape) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TDF_Label label = xcaf_find_shape_label(hDoc, *to_shape(shape));
        if (label.IsNull()) return 0;
        double density = XCAFDoc_MaterialTool::GetDensityForShape(label);
        return density > 0 ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_view(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ViewTool) tool = XCAFDoc_DocumentTool::ViewTool(hDoc->Main());
        TDF_Label viewLabel = tool->AddView();
        return !viewLabel.IsNull() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_get_view_count(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ViewTool) tool = XCAFDoc_DocumentTool::ViewTool(hDoc->Main());
        NCollection_Sequence<TDF_Label> views;
        tool->GetViewLabels(views);
        return views.Length();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_get_visual_material_count(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_VisMaterialTool) tool = XCAFDoc_DocumentTool::VisMaterialTool(hDoc->Main());
        NCollection_Sequence<TDF_Label> mats;
        tool->GetMaterials(mats);
        return mats.Length();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_get_visual_material(xde_doc doc, occt_shape shape,
                              double* out_r, double* out_g, double* out_b, double* out_a) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_VisMaterialTool) tool = XCAFDoc_DocumentTool::VisMaterialTool(hDoc->Main());
        TDF_Label label = xcaf_find_shape_label(hDoc, *to_shape(shape));
        if (label.IsNull()) return 0;
        occ::handle<XCAFDoc_VisMaterial> mat = tool->GetShapeMaterial(label);
        if (!mat.IsNull()) {
            Quantity_ColorRGBA baseColor = mat->BaseColor();
            if (out_r) *out_r = baseColor.GetRGB().Red();
            if (out_g) *out_g = baseColor.GetRGB().Green();
            if (out_b) *out_b = baseColor.GetRGB().Blue();
            if (out_a) *out_a = baseColor.Alpha();
            return 1;
        }
        // Also try with shape directly
        mat = tool->GetShapeMaterial(*to_shape(shape));
        if (!mat.IsNull()) {
            Quantity_ColorRGBA baseColor = mat->BaseColor();
            if (out_r) *out_r = baseColor.GetRGB().Red();
            if (out_g) *out_g = baseColor.GetRGB().Green();
            if (out_b) *out_b = baseColor.GetRGB().Blue();
            if (out_a) *out_a = baseColor.Alpha();
            return 1;
        }
        return 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_get_clipping_plane_count(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ClippingPlaneTool) tool = XCAFDoc_DocumentTool::ClippingPlaneTool(hDoc->Main());
        NCollection_Sequence<TDF_Label> planes;
        tool->GetClippingPlanes(planes);
        return planes.Length();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_expand_assembly(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        return XCAFDoc_Editor::Expand(hDoc->Main()) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}


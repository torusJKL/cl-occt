#include "occt_wrap_internal.h"
#include "occt_wrap_xde.h"

xde_doc xde_new_doc(void) {
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

void xde_free_doc(xde_doc doc) {
    if (doc) {
        delete static_cast<Handle(TDocStd_Document)*>(doc);
    }
}

xde_doc xde_read_step(const char* filename) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        Handle(TDocStd_Document)* h = new Handle(TDocStd_Document);
        *h = new TDocStd_Document("MDTV-XCAF");
        STEPCAFControl_Reader reader;
        IFSelect_ReturnStatus rs = reader.ReadFile(filename);
        if (rs != IFSelect_RetDone) {
            set_error("STEP read failed");
            delete h;
            return nullptr;
        }
        if (!reader.Transfer(*h)) {
            set_error("STEP transfer to XDE failed");
            delete h;
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int xde_write_step(xde_doc doc, const char* filename) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        STEPCAFControl_Writer writer;
        if (!writer.Transfer(hDoc)) {
            set_error("STEP transfer failed");
            return 0;
        }
        IFSelect_ReturnStatus rs = writer.Write(filename);
        if (rs != IFSelect_RetDone) {
            set_error("STEP write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xde_get_root_count(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        LabelSeq labels;
        st->GetShapes(labels);
        return labels.Size();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void xde_get_root_path(xde_doc doc, int index, char* buf, int buf_size) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        LabelSeq labels;
        st->GetShapes(labels);
        if (index < 1 || index > labels.Size()) {
            buf[0] = '\0';
            return;
        }
        TDF_Label label = labels.Value(index);
        std::string path;
        TDF_Label cur = label;
        while (!cur.IsNull() && cur != hDoc->Main()) {
            if (!path.empty()) path = ":" + path;
            path = std::to_string(cur.Tag()) + path;
            cur = cur.Father();
        }
        snprintf(buf, buf_size, "%s", path.c_str());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        buf[0] = '\0';
    }
}

int xde_get_child_count(xde_doc doc, const char* path) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        TDF_Label label = resolve_label(hDoc, path);
        if (label.IsNull()) return 0;
        LabelSeq children;
        st->GetComponents(label, children);
        return children.Size();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void xde_get_child_path(xde_doc doc, const char* parent_path, int index, char* buf, int buf_size) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        TDF_Label parent = resolve_label(hDoc, parent_path);
        if (parent.IsNull()) { buf[0] = '\0'; return; }
        LabelSeq children;
        st->GetComponents(parent, children);
        if (index < 1 || index > children.Size()) { buf[0] = '\0'; return; }
        TDF_Label child = children.Value(index);
        std::string child_path;
        TDF_Label cur = child;
        while (!cur.IsNull() && cur != hDoc->Main()) {
            if (!child_path.empty()) child_path = ":" + child_path;
            child_path = std::to_string(cur.Tag()) + child_path;
            cur = cur.Father();
        }
        snprintf(buf, buf_size, "%s", child_path.c_str());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        buf[0] = '\0';
    }
}

occt_shape xde_get_shape_at(xde_doc doc, const char* path) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return nullptr; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        TDF_Label label = resolve_label(hDoc, path);
        if (label.IsNull()) { set_error("label not found"); return nullptr; }
        TopoDS_Shape shape;
        if (st->GetShape(label, shape)) {
            return from_shape(shape);
        }
        return nullptr;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void xde_get_name_at(xde_doc doc, const char* path, char* buf, int buf_size) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); buf[0] = '\0'; return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TDF_Label label = resolve_label(hDoc, path);
        if (label.IsNull()) { buf[0] = '\0'; return; }
        Handle(TDataStd_Name) nameAttr;
        if (label.FindAttribute(TDataStd_Name::GetID(), nameAttr)) {
            TCollection_ExtendedString estr = nameAttr->Get();
            snprintf(buf, buf_size, "%s", TCollection_AsciiString(estr).ToCString());
        } else {
            buf[0] = '\0';
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
        buf[0] = '\0';
    }
}

int xde_get_color_at(xde_doc doc, const char* path, int* type, double* r, double* g, double* b, double* a) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ColorTool) ct = XCAFDoc_DocumentTool::ColorTool(hDoc->Main());
        TDF_Label label = resolve_label(hDoc, path);
        if (label.IsNull()) return 0;
        Quantity_ColorRGBA color;
        XCAFDoc_ColorType colorType;
        // Try generic, then surface
        if (ct->GetColor(label, XCAFDoc_ColorGen, color)) {
            colorType = XCAFDoc_ColorGen;
        } else if (ct->GetColor(label, XCAFDoc_ColorSurf, color)) {
            colorType = XCAFDoc_ColorSurf;
        } else if (ct->GetColor(label, XCAFDoc_ColorCurv, color)) {
            colorType = XCAFDoc_ColorCurv;
        } else {
            return 0;
        }
        *type = (int)colorType;
        *r = color.GetRGB().Red();
        *g = color.GetRGB().Green();
        *b = color.GetRGB().Blue();
        *a = color.Alpha();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xde_get_location_at(xde_doc doc, const char* path, double* matrix) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TDF_Label label = resolve_label(hDoc, path);
        if (label.IsNull()) return 0;
        TopLoc_Location tl = XCAFDoc_ShapeTool::GetLocation(label);
        if (!tl.IsIdentity()) {
            gp_Trsf loc = tl.Transformation();
            gp_Mat rot = loc.VectorialPart();
            gp_XYZ trans = loc.TranslationPart();
            matrix[0]  = rot(1,1); matrix[1]  = rot(1,2); matrix[2]  = rot(1,3); matrix[3]  = 0;
            matrix[4]  = rot(2,1); matrix[5]  = rot(2,2); matrix[6]  = rot(2,3); matrix[7]  = 0;
            matrix[8]  = rot(3,1); matrix[9]  = rot(3,2); matrix[10] = rot(3,3); matrix[11] = 0;
            matrix[12] = trans.X(); matrix[13] = trans.Y(); matrix[14] = trans.Z(); matrix[15] = 1;
            return 1;
        }
        return 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void xde_add_part(xde_doc doc, const char* parent_path, occt_shape shape,
                  const char* name, int color_type, double r, double g, double b, double a,
                  const double* matrix, char* buf, int buf_size) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return; }
    if (!shape) { set_error("null shape argument", 2); return; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_ShapeTool) st = XCAFDoc_DocumentTool::ShapeTool(hDoc->Main());
        Handle(XCAFDoc_ColorTool) ct = XCAFDoc_DocumentTool::ColorTool(hDoc->Main());
        TDF_Label parent = resolve_label(hDoc, parent_path);
        TDF_Label child;
        // Attach to parent, or top-level if parent is root
        if (parent.IsNull() || parent == hDoc->Main()) {
            child = st->AddShape(*to_shape(shape), true);
        } else {
            int tag = 1;
            while (!parent.FindChild(tag, false).IsNull()) tag++;
            child = parent.FindChild(tag, true);
            st->SetShape(child, *to_shape(shape));
        }
        // Set name
        if (name && *name) {
            TDataStd_Name::Set(child, TCollection_ExtendedString(name));
        }
        // Set color
        if (color_type >= 0) {
            Quantity_ColorRGBA qcolor(Quantity_Color(r, g, b, Quantity_TOC_RGB), a);
            ct->SetColor(child, qcolor, (XCAFDoc_ColorType)color_type);
        }
        // Set location
        if (matrix) {
            gp_Trsf trsf;
            trsf.SetValues(matrix[0], matrix[1], matrix[2], matrix[3],
                           matrix[4], matrix[5], matrix[6], matrix[7],
                           matrix[8], matrix[9], matrix[10], matrix[11]);
            TopLoc_Location tl(trsf);
            TDF_Label locLabel;
            st->SetLocation(child, tl, locLabel);
        }
        // Build child path
        std::string child_path;
        TDF_Label cur = child;
        while (!cur.IsNull() && cur != hDoc->Main()) {
            if (!child_path.empty()) child_path = ":" + child_path;
            child_path = std::to_string(cur.Tag()) + child_path;
            cur = cur.Father();
        }
        snprintf(buf, buf_size, "%s", child_path.c_str());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        buf[0] = '\0';
    }
}

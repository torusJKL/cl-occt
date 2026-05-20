#include "occt_wrap.h"
#include <BRepPrimAPI_MakeBox.hxx>
#include <BRepPrimAPI_MakeCylinder.hxx>
#include <BRepPrimAPI_MakeSphere.hxx>
#include <BRepPrimAPI_MakeCone.hxx>
#include <BRepPrimAPI_MakeTorus.hxx>
#include <BRepPrimAPI_MakePrism.hxx>
#include <BRepPrimAPI_MakeRevol.hxx>
#include <BRepAlgoAPI_Cut.hxx>
#include <BRepAlgoAPI_Fuse.hxx>
#include <BRepAlgoAPI_Common.hxx>
#include <BRepAlgoAPI_Section.hxx>
#include <BRepBuilderAPI_Transform.hxx>
#include <BRepBuilderAPI_MakeEdge.hxx>
#include <BRepBuilderAPI_MakeWire.hxx>
#include <BRepBuilderAPI_MakeFace.hxx>
#include <gp_Trsf.hxx>
#include <gp_Pnt2d.hxx>
#include <gp_Vec2d.hxx>
#include <gp_Dir2d.hxx>
#include <gp_Ax2d.hxx>
#include <gp_XY.hxx>
#include <gp_Pln.hxx>
#include <gp_Ax2.hxx>
#include <gp_Circ.hxx>
#include <Geom2d_Line.hxx>
#include <Geom2d_Circle.hxx>
#include <GC_MakeArcOfCircle.hxx>
#include <GC_MakeSegment.hxx>
#include <STEPControl_Writer.hxx>
#include <STEPControl_Reader.hxx>
#include <BRepMesh_IncrementalMesh.hxx>
#include <StlAPI_Writer.hxx>
#include <StlAPI_Reader.hxx>
#include <STEPCAFControl_Writer.hxx>
#include <STEPCAFControl_Reader.hxx>
#include <TDocStd_Document.hxx>
#include <XCAFDoc_ShapeTool.hxx>
#include <XCAFDoc_ColorTool.hxx>
#include <XCAFDoc_DocumentTool.hxx>
#include <TDataStd_Name.hxx>
#include <TDataXtd_Shape.hxx>
#include <NCollection_Sequence.hxx>
#include <TopLoc_Location.hxx>
#include <Quantity_Color.hxx>
#include <Quantity_ColorRGBA.hxx>
#include <IFSelect_ReturnStatus.hxx>
#include <Standard_Failure.hxx>
#include <Standard_ErrorHandler.hxx>
#include <TopoDS_Shape.hxx>
#include <TopoDS_Wire.hxx>
#include <TopoDS_Compound.hxx>
#include <TopoDS.hxx>
#include <BRep_Builder.hxx>
#include <TopExp_Explorer.hxx>
#include <TopAbs_ShapeEnum.hxx>
#include <Precision.hxx>
#include <OpenGl_GraphicDriver.hxx>
#include <Aspect_DisplayConnection.hxx>
#include <Aspect_NeutralWindow.hxx>
#include <V3d_Viewer.hxx>
#include <V3d_View.hxx>
#include <AIS_InteractiveContext.hxx>
#include <AIS_Shape.hxx>
#include <AIS_InteractiveObject.hxx>
#include <Aspect_GridType.hxx>
#include <Aspect_GridDrawMode.hxx>
#include <V3d_TypeOfOrientation.hxx>
#include <iostream>
#include <cstring>
#include <cmath>
#include <string>
#include <sstream>
#include <cstdio>

static thread_local int g_error_code = 0;
static thread_local char g_error_message[512];

static void set_error(const char* msg, int code = 1) {
    g_error_code = code;
    strncpy(g_error_message, msg, sizeof(g_error_message) - 1);
    g_error_message[sizeof(g_error_message) - 1] = '\0';
}

static void clear_error() {
    g_error_code = 0;
    g_error_message[0] = '\0';
}

static TopoDS_Shape* to_shape(occt_shape s) {
    return static_cast<TopoDS_Shape*>(s);
}

static occt_shape from_shape(const TopoDS_Shape& s) {
    return new TopoDS_Shape(s);
}

static bool is_empty_shape(const TopoDS_Shape& s) {
    if (s.IsNull()) return true;
    TopExp_Explorer exp(s, TopAbs_FACE);
    return !exp.More();
}

occt_shape make_box(double dx, double dy, double dz) {
    clear_error();
    if (dx < Precision::Confusion() || dy < Precision::Confusion() || dz < Precision::Confusion()) {
        set_error("non-positive dimension", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeBox maker(dx, dy, dz);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_cylinder(double radius, double height) {
    clear_error();
    if (radius < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive radius or height", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeCylinder maker(radius, height);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_sphere(double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeSphere maker(radius);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_cone(double r1, double r2, double height) {
    clear_error();
    if (height < Precision::Confusion()) {
        set_error("non-positive height", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeCone maker(r1, r2, height);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_torus(double major_radius, double minor_radius) {
    clear_error();
    if (major_radius < Precision::Confusion() || minor_radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeTorus maker(major_radius, minor_radius);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_prism(occt_shape shape, double dx, double dy, double dz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    double mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (mag < Precision::Confusion()) {
        set_error("zero extrusion vector", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakePrism maker(*to_shape(shape), gp_Vec(dx, dy, dz));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_revol(occt_shape shape, double ax, double ay, double az, double angle_deg) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    double angle = angle_deg * M_PI / 180.0;
    if (fabs(angle) < Precision::Confusion()) {
        set_error("zero revolution angle", 2);
        return nullptr;
    }
    try {
        BRepPrimAPI_MakeRevol maker(*to_shape(shape), gp_Ax1(gp_Pnt(0,0,0), gp_Dir(ax, ay, az)), angle);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

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

static bool is_empty_edge_shape(const TopoDS_Shape& shape) {
    TopExp_Explorer exp(shape, TopAbs_EDGE);
    return !exp.More();
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

occt_shape translate(occt_shape shape, double dx, double dy, double dz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        gp_Trsf trsf;
        trsf.SetTranslation(gp_Vec(dx, dy, dz));
        BRepBuilderAPI_Transform xform(*to_shape(shape), trsf);
        return from_shape(xform.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape rotate(occt_shape shape, double ax, double ay, double az, double angle_deg) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        gp_Trsf trsf;
        trsf.SetRotation(gp_Ax1(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az)), angle_deg * M_PI / 180.0);
        BRepBuilderAPI_Transform xform(*to_shape(shape), trsf);
        return from_shape(xform.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int write_step(occt_shape shape, const char* filename) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        STEPControl_Writer writer;
        IFSelect_ReturnStatus stat = writer.Transfer(*to_shape(shape), STEPControl_AsIs);
        if (stat != IFSelect_RetDone) {
            set_error("STEP transfer failed");
            return 0;
        }
        stat = writer.Write(filename);
        if (stat != IFSelect_RetDone) {
            set_error("STEP write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape read_step(const char* filename) {
    clear_error();
    try {
        STEPControl_Reader reader;
        IFSelect_ReturnStatus stat = reader.ReadFile(filename);
        if (stat != IFSelect_RetDone) {
            set_error("STEP read failed");
            return nullptr;
        }
        reader.TransferRoots();
        TopoDS_Shape shape = reader.OneShape();
        if (shape.IsNull()) {
            set_error("STEP file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int write_stl(occt_shape shape, const char* filename, double deflection) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepMesh_IncrementalMesh mesh(*to_shape(shape), deflection);
        StlAPI_Writer writer;
        writer.ASCIIMode() = false;
        if (!writer.Write(*to_shape(shape), filename)) {
            set_error("STL write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- XDE Document Lifecycle ---

static TDF_Label resolve_label(const Handle(TDocStd_Document)& doc, const char* path) {
    TDF_Label label = doc->Main();
    if (!path || *path == '\0') return label;
    std::string s(path);
    std::stringstream ss(s);
    std::string token;
    while (std::getline(ss, token, ':')) {
        if (token.empty()) continue;
        int tag = std::stoi(token);
        label = label.FindChild(tag, false);
        if (label.IsNull()) break;
    }
    return label;
}

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

occt_shape read_stl(const char* filename) {
    clear_error();
    try {
        StlAPI_Reader reader;
        TopoDS_Shape shape;
        if (!reader.Read(shape, filename)) {
            set_error("STL read failed");
            return nullptr;
        }
        if (shape.IsNull()) {
            set_error("STL file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Label Navigation ---

typedef NCollection_Sequence<TDF_Label> LabelSeq;

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

// --- Attribute Read ---

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

// --- Attribute Write ---

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

// --- 2D Geometry types ---

enum Geom2dKind {
    KIND_PNT2D = 0,
    KIND_VEC2D = 1,
    KIND_DIR2D = 2,
    KIND_LINE2D = 3,
    KIND_CIRCLE2D = 4,
};

struct Geom2dObj {
    Geom2dKind kind;
    void* obj;
};

static Geom2dObj* alloc_geom2d(Geom2dKind kind, void* obj) {
    Geom2dObj* g = new Geom2dObj;
    g->kind = kind;
    g->obj = obj;
    return g;
}

occt_geom2d make_pnt2d(double x, double y) {
    clear_error();
    try {
        return alloc_geom2d(KIND_PNT2D, new gp_Pnt2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_vec2d(double x, double y) {
    clear_error();
    try {
        return alloc_geom2d(KIND_VEC2D, new gp_Vec2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_dir2d(double x, double y) {
    clear_error();
    double mag = sqrt(x*x + y*y);
    if (mag < Precision::Confusion()) {
        set_error("zero direction vector", 2);
        return nullptr;
    }
    try {
        return alloc_geom2d(KIND_DIR2D, new gp_Dir2d(x, y));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_geom2d(occt_geom2d g) {
    if (!g) return;
    Geom2dObj* obj = static_cast<Geom2dObj*>(g);
    switch (obj->kind) {
        case KIND_PNT2D:  delete static_cast<gp_Pnt2d*>(obj->obj); break;
        case KIND_VEC2D:  delete static_cast<gp_Vec2d*>(obj->obj); break;
        case KIND_DIR2D:  delete static_cast<gp_Dir2d*>(obj->obj); break;
        case KIND_LINE2D: delete static_cast<Handle(Geom2d_Line)*>(obj->obj); break;
        case KIND_CIRCLE2D: delete static_cast<Handle(Geom2d_Circle)*>(obj->obj); break;
    }
    delete obj;
}

// --- 2D Curves ---

occt_geom2d make_line_2d(double x, double y, double dx, double dy) {
    clear_error();
    double mag = sqrt(dx*dx + dy*dy);
    if (mag < Precision::Confusion()) {
        set_error("zero direction vector", 2);
        return nullptr;
    }
    try {
        gp_Pnt2d origin(x, y);
        gp_Dir2d dir(dx, dy);
        Handle(Geom2d_Line)* h = new Handle(Geom2d_Line)(new Geom2d_Line(origin, dir));
        return alloc_geom2d(KIND_LINE2D, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_geom2d make_circle_2d(double x, double y, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        gp_Pnt2d center(x, y);
        gp_Dir2d xDir(1.0, 0.0);
        gp_Ax2d axis(center, xDir);
        Handle(Geom2d_Circle)* h = new Handle(Geom2d_Circle)(new Geom2d_Circle(axis, radius));
        return alloc_geom2d(KIND_CIRCLE2D, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Edge construction ---

occt_shape make_edge_line_2d(double x1, double y1, double x2, double y2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, 0), gp_Pnt(x2, y2, 0));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_line_3d(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        BRepBuilderAPI_MakeEdge maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_circle_2d(double x, double y, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) {
        set_error("non-positive radius", 2);
        return nullptr;
    }
    try {
        gp_Circ circle(gp_Ax2(gp_Pnt(x, y, 0), gp_Dir(0, 0, 1)), radius);
        BRepBuilderAPI_MakeEdge maker(circle);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_edge_arc_2d(double x1, double y1, double x2, double y2, double x3, double y3) {
    clear_error();
    try {
        gp_Pnt p1(x1, y1, 0), p2(x2, y2, 0), p3(x3, y3, 0);
        GC_MakeArcOfCircle arcMaker(p1, p2, p3);
        if (!arcMaker.IsDone()) {
            set_error("arc of circle construction failed");
            return nullptr;
        }
        Handle(Geom_TrimmedCurve) arc = arcMaker.Value();
        BRepBuilderAPI_MakeEdge maker(arc);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Wire and Face construction ---

occt_shape make_wire(occt_shape* edges, int count) {
    clear_error();
    if (count < 1) {
        set_error("wire requires at least one edge", 2);
        return nullptr;
    }
    try {
        BRepBuilderAPI_MakeWire maker;
        for (int i = 0; i < count; i++) {
            if (!edges[i]) {
                set_error("null edge in wire construction", 2);
                return nullptr;
            }
            maker.Add(TopoDS::Edge(*to_shape(edges[i])));
        }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face(occt_shape wire) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_face_on_plane(occt_shape wire, double ox, double oy, double oz, double nx, double ny, double nz) {
    clear_error();
    if (!wire) {
        set_error("null wire argument", 2);
        return nullptr;
    }
    try {
        gp_Pln plane(gp_Pnt(ox, oy, oz), gp_Dir(nx, ny, nz));
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        BRepBuilderAPI_MakeFace maker(plane, w);
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Compound ---

occt_shape make_compound(occt_shape* shapes, int count) {
    clear_error();
    try {
        TopoDS_Compound compound;
        BRep_Builder builder;
        builder.MakeCompound(compound);
        for (int i = 0; i < count; i++) {
            if (shapes[i]) {
                builder.Add(compound, *to_shape(shapes[i]));
            }
        }
        return from_shape(compound);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape add_to_compound(occt_shape compound_shape, occt_shape shape) {
    clear_error();
    if (!compound_shape) { set_error("null compound argument", 2); return nullptr; }
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        TopoDS_Compound compound;
        BRep_Builder builder;
        builder.MakeCompound(compound);
        // Copy existing sub-shapes into new compound
        TopExp_Explorer exp(*to_shape(compound_shape), TopAbs_SHAPE);
        for (; exp.More(); exp.Next()) {
            builder.Add(compound, exp.Current());
        }
        builder.Add(compound, *to_shape(shape));
        return from_shape(compound);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int compound_is_empty(occt_shape shape) {
    clear_error();
    if (!shape) return 1;
    try {
        TopExp_Explorer exp(*to_shape(shape), TopAbs_SHAPE);
        return exp.More() ? 0 : 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 1;
    }
}

int shape_is_compound(occt_shape shape) {
    clear_error();
    if (!shape) return 0;
    try {
        return to_shape(shape)->ShapeType() == TopAbs_COMPOUND ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Visualization ---

void* create_graphic_driver(void) {
    clear_error();
    try {
        Handle(OpenGl_GraphicDriver)* h = new Handle(OpenGl_GraphicDriver);
        Handle(Aspect_DisplayConnection) display = new Aspect_DisplayConnection();
        *h = new OpenGl_GraphicDriver(display);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_graphic_driver(void* driver) {
    if (driver) {
        delete static_cast<Handle(OpenGl_GraphicDriver)*>(driver);
    }
}

void* v3d_create_viewer(void* driver_ptr) {
    clear_error();
    if (!driver_ptr) { set_error("null driver argument", 2); return nullptr; }
    try {
        auto* driver = static_cast<Handle(OpenGl_GraphicDriver)*>(driver_ptr);
        Handle(V3d_Viewer)* h = new Handle(V3d_Viewer);
        *h = new V3d_Viewer(*driver);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void v3d_free_viewer(void* viewer) {
    if (viewer) {
        delete static_cast<Handle(V3d_Viewer)*>(viewer);
    }
}

void* v3d_create_view(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return nullptr; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        Handle(V3d_View)* h = new Handle(V3d_View);
        *h = (*viewer)->CreateView();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void v3d_free_view(void* view) {
    if (view) {
        delete static_cast<Handle(V3d_View)*>(view);
    }
}

void v3d_fit_all(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->FitAll();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_must_be_resized(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->MustBeResized();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* create_neutral_window(void* native_handle) {
    clear_error();
    try {
        Handle(Aspect_NeutralWindow)* h = new Handle(Aspect_NeutralWindow)(new Aspect_NeutralWindow());
        if (native_handle) {
            (*h)->SetNativeHandle(reinterpret_cast<Aspect_Drawable>(native_handle));
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_neutral_window(void* window) {
    if (window) {
        delete static_cast<Handle(Aspect_NeutralWindow)*>(window);
    }
}

// --- AIS Visualization (Display Objects) ---

void* ais_create_context(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return nullptr; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        Handle(AIS_InteractiveContext)* h = new Handle(AIS_InteractiveContext);
        *h = new AIS_InteractiveContext(*viewer);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_free_context(void* ctx) {
    if (ctx) {
        delete static_cast<Handle(AIS_InteractiveContext)*>(ctx);
    }
}

void* ais_create_shape(void* shape_ptr) {
    clear_error();
    if (!shape_ptr) { set_error("null shape argument", 2); return nullptr; }
    try {
        auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
        Handle(AIS_Shape)* h = new Handle(AIS_Shape)(new AIS_Shape(*shape));
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_free_shape(void* obj) {
    if (obj) {
        delete static_cast<Handle(AIS_InteractiveObject)*>(obj);
    }
}

void ais_context_display(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->Display(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_erase(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->Erase(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_remove(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->Remove(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_remove_all(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->RemoveAll(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_context_is_displayed(void* ctx_ptr, void* obj_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return 0; }
    if (!obj_ptr) { set_error("null object argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        return (*ctx)->IsDisplayed(*obj) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Visualization — Styling, Camera, MSAA, Grid ---

void v3d_view_set_bg_color(void* view_ptr, double r, double g, double b) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetBackgroundColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_color(void* ctx_ptr, void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetColor(*obj, Quantity_Color(r, g, b, Quantity_TOC_RGB), false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_unset_color(void* ctx_ptr, void* obj_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->UnsetColor(*obj, false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_display_mode(void* ctx_ptr, void* obj_ptr, int mode) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return; }
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetDisplayMode(*obj, mode, false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_proj(void* view_ptr, int orientation) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetProj(static_cast<V3d_TypeOfOrientation>(orientation));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_msaa(void* view_ptr, int samples) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->ChangeRenderingParams().NbMsaaSamples = samples;
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int v3d_view_get_msaa(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->ChangeRenderingParams().NbMsaaSamples;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void v3d_view_set_antialiasing(void* view_ptr, int on) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->ChangeRenderingParams().IsAntialiasingEnabled = (on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int v3d_view_get_antialiasing(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->ChangeRenderingParams().IsAntialiasingEnabled ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void v3d_viewer_activate_grid(void* viewer_ptr, int gridType, int drawMode) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->ActivateGrid(static_cast<Aspect_GridType>(gridType),
                                static_cast<Aspect_GridDrawMode>(drawMode));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_deactivate_grid(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->DeactivateGrid();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_invalidate(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Invalidate();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void free_shape(occt_shape shape) {
    if (shape) {
        delete to_shape(shape);
    }
}

int get_error_code(void) {
    return g_error_code;
}

const char* get_error_message(void) {
    return g_error_message;
}

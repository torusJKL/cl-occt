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
#include <V3d_TypeOfView.hxx>
#include <Graphic3d_Camera.hxx>
#include <Graphic3d_TextureEnv.hxx>
#include <BRepBndLib.hxx>
#include <AIS_Trihedron.hxx>
#include <Geom_Axis2Placement.hxx>
#include <gp_Pnt.hxx>
#include <gp_Dir.hxx>
#include <Graphic3d_TransformPers.hxx>
#include <Prs3d_DatumMode.hxx>
#include <Prs3d_Drawer.hxx>
#include <Prs3d_DatumParts.hxx>
#include <Prs3d_TextAspect.hxx>
#include <Prs3d_LineAspect.hxx>
#include <Prs3d_ShadingAspect.hxx>
#include <Aspect_TypeOfTriedronPosition.hxx>
#include <Font_FontAspect.hxx>
#include <Font_StrictLevel.hxx>
#include <Font_FTFont.hxx>
#include <Font_FontMgr.hxx>
#include <Graphic3d_HorizontalTextAlignment.hxx>
#include <Graphic3d_VerticalTextAlignment.hxx>
#include <NCollection_String.hxx>
#include <StdPrs_BRepFont.hxx>
#include <StdPrs_BRepTextBuilder.hxx>
#include <TCollection_AsciiString.hxx>
#include <AIS_TextLabel.hxx>
#include <V3d_AmbientLight.hxx>
#include <V3d_DirectionalLight.hxx>
#include <V3d_PositionalLight.hxx>
#include <V3d_SpotLight.hxx>
#include <V3d_Light.hxx>
#include <Prs3d_PointAspect.hxx>
#include <Prs3d_TextAspect.hxx>
#include <Font_TextFormatter.hxx>
#include <gp_Ax3.hxx>
#include <gp_Pnt.hxx>
#include <gp_Dir.hxx>
#include <iostream>
#include <cstring>
#include <cmath>
#include <string>
#include <sstream>
#include <cstdio>
#include <unistd.h>

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
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
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

occt_shape read_stl(const char* filename) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
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

// --- Trihedron ---

void* ais_create_trihedron(double ox, double oy, double oz,
                           double dx, double dy, double dz,
                           double ux, double uy, double uz) {
    clear_error();
    double nmag = sqrt(dx*dx + dy*dy + dz*dz);
    double xmag = sqrt(ux*ux + uy*uy + uz*uz);
    if (nmag < Precision::Confusion() || xmag < Precision::Confusion()) {
        set_error("zero direction vector in trihedron construction", 2);
        return nullptr;
    }
    try {
        gp_Pnt origin(ox, oy, oz);
        gp_Dir normal(dx, dy, dz);
        gp_Dir xDir(ux, uy, uz);
        Handle(Geom_Axis2Placement) axis = new Geom_Axis2Placement(origin, normal, xDir);
        Handle(AIS_Trihedron)* h = new Handle(AIS_Trihedron)(new AIS_Trihedron(axis));
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_trihedron_set_datum_mode(void* obj_ptr, int mode) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        (**obj).SetDatumDisplayMode(static_cast<Prs3d_DatumMode>(mode));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_trihedron_set_draw_arrows(void* obj_ptr, int on) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        (**obj).SetDrawArrows(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_trihedron_set_size(void* obj_ptr, double size) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        (**obj).SetSize(size);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// Prs3d_DatumPart indices: 0=XAxis, 1=YAxis, 2=ZAxis
int ais_trihedron_set_datum_part_color(void* obj_ptr, int part, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return 0; }
    if (part < 0 || part > 2) { set_error("invalid datum part (0=X, 1=Y, 2=Z)", 2); return 0; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        static const Prs3d_DatumParts parts[] = {
            Prs3d_DatumParts_XAxis,
            Prs3d_DatumParts_YAxis,
            Prs3d_DatumParts_ZAxis
        };
        (**obj).SetDatumPartColor(parts[part], Quantity_Color(r, g, b, Quantity_TOC_RGB));
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_trihedron_set_text_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        (**obj).Attributes()->TextAspect()->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// draw-names is not available in OCCT 8.0 AIS_Trihedron API.
// Labels are always shown as part of the datum presentation.

void ais_trihedron_set_transform_pers(void* obj_ptr, int corner, int xOff, int yOff) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        Handle(Graphic3d_TransformPers) pers =
            new Graphic3d_TransformPers(Graphic3d_TMF_TriedronPers,
                                         static_cast<Aspect_TypeOfTriedronPosition>(corner),
                                         NCollection_Vec2<int>(xOff, yOff));
        (**obj).SetTransformPersistence(pers);
    } catch (Standard_Failure& e) {
        set_error(e.what());
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

void v3d_view_set_eye(void* view_ptr, double x, double y, double z) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetEye(gp_Pnt(x, y, z));
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_target(void* view_ptr, double x, double y, double z) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetCenter(gp_Pnt(x, y, z));
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_up(void* view_ptr, double x, double y, double z) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetUp(gp_Dir(x, y, z));
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_projection_type(void* view_ptr, int is_perspective) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetProjectionType(
            is_perspective ? Graphic3d_Camera::Projection_Perspective
                           : Graphic3d_Camera::Projection_Orthographic);
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int v3d_view_get_projection_type(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->ProjectionType() == Graphic3d_Camera::Projection_Perspective ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void v3d_view_set_fov(void* view_ptr, double fov_rad) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetFOVy(fov_rad);
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_clip_planes(void* view_ptr, double near, double far) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    if (far <= near) { set_error("far must be greater than near", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Camera()->SetZRange(near, far);
        (*view)->Update();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_fit_all_shape(void* view_ptr, void* shape_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    if (!shape_ptr) { set_error("null shape argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
        Bnd_Box box;
        BRepBndLib::Add(*shape, box);
        (*view)->FitAll(box);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_pan(void* view_ptr, double dx, double dy) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Pan(dx, dy, 0.0, 0.0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_zoom(void* view_ptr, double factor) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetScale(factor);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_rotate(void* view_ptr, double ax, double ay, double az) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Rotate(ax, ay, az);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_reset(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetViewOrientationDefault();
        (*view)->SetViewMappingDefault();
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

// --- Per-Object Properties ---

void ais_set_transparency(void* ctx_ptr, void* obj_ptr, double v) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetTransparency(*obj, v, false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_set_material_by_name(void* ctx_ptr, void* obj_ptr, const char* name) {
    clear_error();
    if (!ctx_ptr || !obj_ptr || !name) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        // Map material name string to Graphic3d_NameOfMaterial
        std::string s(name);
        Graphic3d_NameOfMaterial mat = Graphic3d_NOM_DEFAULT;
        if (s == "brass") mat = Graphic3d_NOM_BRASS;
        else if (s == "bronze") mat = Graphic3d_NOM_BRONZE;
        else if (s == "copper") mat = Graphic3d_NOM_COPPER;
        else if (s == "gold") mat = Graphic3d_NOM_GOLD;
        else if (s == "pewter") mat = Graphic3d_NOM_PEWTER;
        else if (s == "plastic") mat = Graphic3d_NOM_PLASTIC;
        else if (s == "silver") mat = Graphic3d_NOM_SILVER;
        else if (s == "steel") mat = Graphic3d_NOM_STEEL;
        else if (s == "stone") mat = Graphic3d_NOM_STONE;
        else if (s == "shiny-plastic") mat = Graphic3d_NOM_SHINY_PLASTIC;
        else if (s == "satin") mat = Graphic3d_NOM_SATIN;
        else if (s == "metalized") mat = Graphic3d_NOM_METALIZED;
        else if (s == "neon-phc") mat = Graphic3d_NOM_NEON_PHC;
        else if (s == "chrome") mat = Graphic3d_NOM_CHROME;
        else if (s == "aluminium") mat = Graphic3d_NOM_ALUMINIUM;
        else if (s == "obsidian") mat = Graphic3d_NOM_OBSIDIAN;
        else if (s == "glass") mat = Graphic3d_NOM_GLASS;
        else if (s == "jade") mat = Graphic3d_NOM_JADE;
        else if (s == "matte") mat = Graphic3d_NOM_PLASTIC;
        else if (s == "shiny") mat = Graphic3d_NOM_SHINY_PLASTIC;
        else if (s == "default") mat = Graphic3d_NOM_DEFAULT;
        else { set_error("unknown material name", 2); return 0; }
        Graphic3d_MaterialAspect aspect(mat);
        (*ctx)->SetMaterial(*obj, aspect, false);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_material_preset_count(void) {
    return 22; // number of named presets we support
}

const char* ais_material_preset_name(int index) {
    static const char* names[] = {
        "brass", "bronze", "copper", "gold", "pewter", "plastic", "silver",
        "steel", "stone", "shiny-plastic", "satin", "metalized", "neon-phc",
        "chrome", "aluminium", "obsidian", "glass", "jade", "matte", "shiny",
        "default", nullptr
    };
    if (index < 0 || index >= 22) return nullptr;
    return names[index];
}

void ais_set_line_width(void* ctx_ptr, void* obj_ptr, double w) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetWidth(*obj, w, false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_set_edges_display(void* obj_ptr, int on) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*obj)->SetDisplayMode(on != 0 ? AIS_Shaded : AIS_WireFrame);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_set_edge_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_LineAspect) aspect = new Prs3d_LineAspect(
            Quantity_Color(r, g, b, Quantity_TOC_RGB),
            Aspect_TOL_SOLID, 1.0);
        drawer->SetFaceBoundaryAspect(aspect);
        drawer->SetFaceBoundaryDraw(true);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_set_selection_mode(void* ctx_ptr, void* obj_ptr, int mode) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->Activate(*obj, mode);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_deactivate_selection(void* ctx_ptr, void* obj_ptr) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->Deactivate(*obj);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_set_tessellation(void* obj_ptr, double deflection, double deviation) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetDiscretisation(deflection);
        drawer->SetDeviationCoefficient(deviation);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Lighting ---

void* make_light_ambient(double r, double g, double b, double intensity) {
    clear_error();
    try {
        Handle(V3d_AmbientLight)* h = new Handle(V3d_AmbientLight)();
        *h = new V3d_AmbientLight(Quantity_Color(r, g, b, Quantity_TOC_RGB));
        if (intensity != 0.0) (**h).SetIntensity(intensity);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* make_light_directional(double r, double g, double b, double intensity, double dx, double dy, double dz) {
    clear_error();
    try {
        Handle(V3d_DirectionalLight)* h = new Handle(V3d_DirectionalLight)();
        *h = new V3d_DirectionalLight(gp_Dir(dx, dy, dz), Quantity_Color(r, g, b, Quantity_TOC_RGB));
        if (intensity != 0.0) (**h).SetIntensity(intensity);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void light_free(void* light_ptr) {
    if (light_ptr) {
        delete static_cast<Handle(V3d_Light)*>(light_ptr);
    }
}

void v3d_viewer_add_light(void* viewer_ptr, void* light_ptr) {
    clear_error();
    if (!viewer_ptr || !light_ptr) { set_error("null argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*viewer)->AddLight(*light);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_remove_light(void* viewer_ptr, void* light_ptr) {
    clear_error();
    if (!viewer_ptr || !light_ptr) { set_error("null argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*viewer)->DelLight(*light);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_light_on(void* viewer_ptr, void* light_ptr) {
    clear_error();
    if (!viewer_ptr || !light_ptr) { set_error("null argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*viewer)->SetLightOn(*light);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_light_off(void* viewer_ptr, void* light_ptr) {
    clear_error();
    if (!viewer_ptr || !light_ptr) { set_error("null argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*viewer)->SetLightOff(*light);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int light_is_on(void* light_ptr) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return 0; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        return (*light)->IsEnabled() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void light_set_color(void* light_ptr, double r, double g, double b) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_intensity(void* light_ptr, double v) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetIntensity(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_direction(void* light_ptr, double dx, double dy, double dz) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetDirection(gp_Dir(dx, dy, dz));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_position(void* light_ptr, double x, double y, double z) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetPosition(gp_Pnt(x, y, z));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_headlight(void* light_ptr, int on) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetHeadlight(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_shadows(void* light_ptr, int on) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        (*light)->SetCastShadows(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_default_lights(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultLights();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Grid Extensions ---

int v3d_viewer_grid_active(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return 0; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        return (*viewer)->IsGridActive() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Background ---

void v3d_view_set_bg_gradient(void* view_ptr, double r1, double g1, double b1,
                                double r2, double g2, double b2, int style) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetBgGradientColors(
            Quantity_Color(r1, g1, b1, Quantity_TOC_RGB),
            Quantity_Color(r2, g2, b2, Quantity_TOC_RGB),
            static_cast<Aspect_GradientFillMethod>(style),
            true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_reset_background(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetBackgroundColor(Quantity_Color(0.0, 0.0, 0.0, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Rendering ---

void v3d_view_set_computed_mode(void* view_ptr, int on) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetComputedMode(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int v3d_view_computed_mode(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->ComputedMode() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void v3d_view_set_back_face_model(void* view_ptr, int mode) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetBackFacingModel(static_cast<Graphic3d_TypeOfBackfacingModel>(mode));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_frustum_culling(void* view_ptr, int on) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetFrustumCulling(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// SetTransparentShading is not available in OCCT 8.0 V3d_View API.

void v3d_view_redraw(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->Redraw();
        (*view)->RedrawImmediate();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_view_set_immediate_update(void* view_ptr, int on) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetImmediateUpdate(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Text Label Enhancements ---

void ais_text_label_set_angle(void* label_ptr, double rad) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetAngle(rad);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// HJustify, VJustify, SubtitleColor are not available in OCCT 8.0 AIS_TextLabel API.

// --- Viewer Defaults ---

void v3d_viewer_set_default_bg_color(void* viewer_ptr, double r, double g, double b) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultBackgroundColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_set_default_view_proj(void* viewer_ptr, int orientation) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultViewProj(static_cast<V3d_TypeOfOrientation>(orientation));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_set_default_view_size(void* viewer_ptr, double size) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultViewSize(size);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void v3d_viewer_set_default_view_type(void* viewer_ptr, int is_perspective) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultTypeOfView(is_perspective ? V3d_PERSPECTIVE : V3d_ORTHOGRAPHIC);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Drawer (Prs3d) ---

void ais_object_set_line_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetLineAspect(new Prs3d_LineAspect(
            Quantity_Color(r, g, b, Quantity_TOC_RGB), Aspect_TOL_SOLID, 1.0));
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_line_width(void* obj_ptr, double w) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetLineAspect(new Prs3d_LineAspect(
            Quantity_Color(1, 1, 1, Quantity_TOC_RGB), Aspect_TOL_SOLID, w));
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_shading_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetShadingAspect(new Prs3d_ShadingAspect());
        drawer->ShadingAspect()->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_face_boundary_draw(void* obj_ptr, int on) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetFaceBoundaryDraw(on != 0);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_free_boundary_draw(void* obj_ptr, int on) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetFreeBoundaryDraw(on != 0);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Dimensions ---

#include <PrsDim_LengthDimension.hxx>
#include <PrsDim_AngleDimension.hxx>
#include <PrsDim_DiameterDimension.hxx>
#include <PrsDim_RadiusDimension.hxx>

void* prsdim_make_length_2p(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        Handle(PrsDim_LengthDimension)* h = new Handle(PrsDim_LengthDimension)();
        *h = new PrsDim_LengthDimension(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2), gp_Pln(gp_Pnt(0,0,0), gp_Dir(0,0,1)));
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* prsdim_make_angle_3p(double vx, double vy, double vz, double p1x, double p1y, double p1z, double p2x, double p2y, double p2z) {
    clear_error();
    try {
        Handle(PrsDim_AngleDimension)* h = new Handle(PrsDim_AngleDimension)();
        *h = new PrsDim_AngleDimension(gp_Pnt(vx, vy, vz), gp_Pnt(p1x, p1y, p1z), gp_Pnt(p2x, p2y, p2z));
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* prsdim_make_diameter(void* shape_ptr) {
    clear_error();
    if (!shape_ptr) { set_error("null shape argument", 2); return nullptr; }
    try {
        auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
        Handle(PrsDim_DiameterDimension)* h = new Handle(PrsDim_DiameterDimension)();
        *h = new PrsDim_DiameterDimension(*shape);
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* prsdim_make_radius(void* shape_ptr) {
    clear_error();
    if (!shape_ptr) { set_error("null shape argument", 2); return nullptr; }
    try {
        auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
        Handle(PrsDim_RadiusDimension)* h = new Handle(PrsDim_RadiusDimension)();
        *h = new PrsDim_RadiusDimension(*shape);
        return static_cast<void*>(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void prsdim_set_text_position(void* dim_ptr, double x, double y, double z) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).SetTextPosition(gp_Pnt(x, y, z));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_display_units(void* dim_ptr, const char* units) {
    clear_error();
    if (!dim_ptr || !units) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).SetDisplayUnits(TCollection_AsciiString(units));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Custom Material ---

void* make_material(double ar, double ag, double ab, double dr, double dg, double db,
                     double sr, double sg, double sb, double shininess, double transparency) {
    clear_error();
    try {
        Graphic3d_MaterialAspect* mat = new Graphic3d_MaterialAspect(Graphic3d_NOM_DEFAULT);
        mat->SetAmbientColor(Quantity_Color(ar, ag, ab, Quantity_TOC_RGB));
        mat->SetDiffuseColor(Quantity_Color(dr, dg, db, Quantity_TOC_RGB));
        mat->SetSpecularColor(Quantity_Color(sr, sg, sb, Quantity_TOC_RGB));
        mat->SetShininess(shininess);
        mat->SetTransparency(transparency);
        return mat;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_set_custom_material(void* ctx_ptr, void* obj_ptr, void* mat_ptr) {
    clear_error();
    if (!ctx_ptr || !obj_ptr || !mat_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        auto* mat = static_cast<Graphic3d_MaterialAspect*>(mat_ptr);
        (*ctx)->SetMaterial(*obj, *mat, false);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Positional & Spot Lights ---

void* make_light_positional(double r, double g, double b, double intensity, double x, double y, double z) {
    clear_error();
    try {
        Handle(V3d_PositionalLight)* h = new Handle(V3d_PositionalLight)();
        *h = new V3d_PositionalLight(gp_Pnt(x, y, z), Quantity_Color(r, g, b, Quantity_TOC_RGB));
        if (intensity != 0.0) (**h).SetIntensity(intensity);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* make_light_spot(double r, double g, double b, double intensity, double x, double y, double z, double dx, double dy, double dz, double angle, double concentration) {
    clear_error();
    try {
        Handle(V3d_SpotLight)* h = new Handle(V3d_SpotLight)();
        *h = new V3d_SpotLight(gp_Pnt(x, y, z), gp_Dir(dx, dy, dz), Quantity_Color(r, g, b, Quantity_TOC_RGB));
        if (intensity != 0.0) (**h).SetIntensity(intensity);
        if (angle > 0.0) (**h).SetAngle(angle * M_PI / 180.0);
        (**h).SetConcentration(concentration);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void light_set_angle(void* light_ptr, double angle_deg) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        V3d_SpotLight* spot = dynamic_cast<V3d_SpotLight*>(light->get());
        if (spot) spot->SetAngle(angle_deg * M_PI / 180.0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void light_set_concentration(void* light_ptr, double v) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        V3d_SpotLight* spot = dynamic_cast<V3d_SpotLight*>(light->get());
        if (spot) spot->SetConcentration(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Grid Echo ---

void v3d_view_set_grid_echo(void* view_ptr, int on) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetGridActivity(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Background Image ---

void v3d_view_set_bg_image(void* view_ptr, const char* path) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    if (!path) { set_error("null path", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->SetBackgroundImage(path);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Camera handle ---

void v3d_view_get_camera_handle(void* view_ptr, void** out_camera) {
    clear_error();
    if (!view_ptr || !out_camera) { set_error("null argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        Handle(Graphic3d_Camera)* h = new Handle(Graphic3d_Camera)((*view)->Camera());
        *out_camera = h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_camera = nullptr;
    }
}

// --- Viewer Defaults ---

void v3d_viewer_set_default_lights(void* viewer_ptr, int on) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        if (on) (*viewer)->SetDefaultLights();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}



// --- Drawer (Prs3d) ---

void* ais_object_attributes(void* obj_ptr) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return nullptr; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer)* h = new Handle(Prs3d_Drawer)((*obj)->Attributes());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* drawer_shading_aspect(void* drawer_ptr) {
    clear_error();
    if (!drawer_ptr) { set_error("null drawer", 2); return nullptr; }
    try {
        auto* drawer = static_cast<Handle(Prs3d_Drawer)*>(drawer_ptr);
        Handle(Prs3d_ShadingAspect)* h = new Handle(Prs3d_ShadingAspect)((*drawer)->ShadingAspect());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* drawer_line_aspect(void* drawer_ptr) {
    clear_error();
    if (!drawer_ptr) { set_error("null drawer", 2); return nullptr; }
    try {
        auto* drawer = static_cast<Handle(Prs3d_Drawer)*>(drawer_ptr);
        Handle(Prs3d_LineAspect)* h = new Handle(Prs3d_LineAspect)((*drawer)->LineAspect());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void line_aspect_set_color(void* aspect_ptr, double r, double g, double b) {
    clear_error();
    if (!aspect_ptr) { set_error("null aspect", 2); return; }
    try {
        auto* aspect = static_cast<Handle(Prs3d_LineAspect)*>(aspect_ptr);
        (*aspect)->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void line_aspect_set_width(void* aspect_ptr, double w) {
    clear_error();
    if (!aspect_ptr) { set_error("null aspect", 2); return; }
    try {
        auto* aspect = static_cast<Handle(Prs3d_LineAspect)*>(aspect_ptr);
        (*aspect)->SetWidth(w);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void line_aspect_set_type(void* aspect_ptr, int type) {
    clear_error();
    if (!aspect_ptr) { set_error("null aspect", 2); return; }
    try {
        auto* aspect = static_cast<Handle(Prs3d_LineAspect)*>(aspect_ptr);
        (*aspect)->SetTypeOfLine(static_cast<Aspect_TypeOfLine>(type));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void shading_aspect_set_color(void* aspect_ptr, double r, double g, double b) {
    clear_error();
    if (!aspect_ptr) { set_error("null aspect", 2); return; }
    try {
        auto* aspect = static_cast<Handle(Prs3d_ShadingAspect)*>(aspect_ptr);
        (*aspect)->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void shading_aspect_set_material(void* aspect_ptr, double ar, double ag, double ab,
                                  double dr, double dg, double db,
                                  double sr, double sg, double sb,
                                  double shininess, double transparency) {
    clear_error();
    if (!aspect_ptr) { set_error("null aspect", 2); return; }
    try {
        auto* aspect = static_cast<Handle(Prs3d_ShadingAspect)*>(aspect_ptr);
        Graphic3d_MaterialAspect mat(Graphic3d_NOM_DEFAULT);
        mat.SetAmbientColor(Quantity_Color(ar, ag, ab, Quantity_TOC_RGB));
        mat.SetDiffuseColor(Quantity_Color(dr, dg, db, Quantity_TOC_RGB));
        mat.SetSpecularColor(Quantity_Color(sr, sg, sb, Quantity_TOC_RGB));
        mat.SetShininess(shininess);
        mat.SetTransparency(transparency);
        (*aspect)->SetMaterial(mat);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Dimension Styling ---

void prsdim_set_flyout(void* dim_ptr, double v) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).SetFlyout(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Camera handle set ---

void v3d_view_set_camera(void* view_ptr, void* camera_ptr) {
    clear_error();
    if (!view_ptr || !camera_ptr) { set_error("null argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        auto* camera = static_cast<Handle(Graphic3d_Camera)*>(camera_ptr);
        (*view)->SetCamera(*camera);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Transparency method ---

void v3d_view_set_transparency_method(void* view_ptr, int method) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*view)->ChangeRenderingParams().TransparencyMethod =
            static_cast<Graphic3d_RenderTransparentMethod>(method);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Default bg gradient ---

void v3d_viewer_set_default_bg_gradient(void* viewer_ptr, double r1, double g1, double b1,
                                          double r2, double g2, double b2, int style) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetDefaultBgGradientColors(
            Quantity_Color(r1, g1, b1, Quantity_TOC_RGB),
            Quantity_Color(r2, g2, b2, Quantity_TOC_RGB),
            static_cast<Aspect_GradientFillMethod>(style));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Text Label Enhancements ---

void ais_text_label_set_hjustification(void* label_ptr, int align) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetHJustification(static_cast<Graphic3d_HorizontalTextAlignment>(align));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_vjustification(void* label_ptr, int align) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetVJustification(static_cast<Graphic3d_VerticalTextAlignment>(align));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_color_sub_title(void* label_ptr, double r, double g, double b) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetColorSubTitle(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Grid: rectangular grid values ---

void v3d_viewer_set_rectangular_grid_values(void* viewer_ptr, double xOrigin, double yOrigin,
                                              double xStep, double yStep, double rotationAngle) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer argument", 2); return; }
    try {
        auto* viewer = static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        (*viewer)->SetRectangularGridValues(xOrigin, yOrigin, xStep, yStep, rotationAngle);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Grid: GPU shader grid display ---

#include <Aspect_GridParams.hxx>

void v3d_view_grid_display(void* view_ptr, double r, double g, double b, double sizeX, double sizeY) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        Aspect_GridParams params;
        params.SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
        params.SetAccentColor(Quantity_Color(1, 1, 1, Quantity_TOC_RGB));
        if (sizeX > 0) params.SetScale(sizeX);
        if (sizeY > 0) params.SetScaleY(sizeY);
        params.SetDrawMode(Aspect_GDM_Lines);
        (*view)->GridDisplay(params, gp_Ax3(gp_Pnt(0,0,0), gp_Dir(0,0,1)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Default drawer via AIS context ---

void* ais_context_default_drawer(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context argument", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(Prs3d_Drawer)* h = new Handle(Prs3d_Drawer)((*ctx)->DefaultDrawer());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Dimension styling: edge-based measurement, arrows, extension ---

#include <Prs3d_DimensionAspect.hxx>
#include <Prs3d_ArrowAspect.hxx>

void prsdim_set_measured_edge(void* dim_ptr, void* shape_ptr, double px, double py, double pz, double nx, double ny, double nz) {
    clear_error();
    if (!dim_ptr || !shape_ptr) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_LengthDimension)*>(dim_ptr);
        auto* shape = static_cast<TopoDS_Shape*>(shape_ptr);
        (**dim).SetMeasuredGeometry(TopoDS::Edge(*shape), gp_Pln(gp_Pnt(px, py, pz), gp_Dir(nx, ny, nz)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_arrow_length(void* dim_ptr, double v) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).DimensionAspect()->ArrowAspect()->SetLength(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Text Label: SetDisplayType ---

void ais_text_label_set_display_type(void* label_ptr, int type) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetDisplayType(static_cast<Aspect_TypeOfDisplayText>(type));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Dimension: SetCustomValue ---

void prsdim_set_custom_value(void* dim_ptr, const char* value) {
    clear_error();
    if (!dim_ptr || !value) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).SetCustomValue(TCollection_ExtendedString(value));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Dimension: set angle measured edges ---

void prsdim_set_angle_edges(void* dim_ptr, void* edge1_ptr, void* edge2_ptr) {
    clear_error();
    if (!dim_ptr || !edge1_ptr || !edge2_ptr) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_AngleDimension)*>(dim_ptr);
        auto* edge1 = static_cast<TopoDS_Shape*>(edge1_ptr);
        auto* edge2 = static_cast<TopoDS_Shape*>(edge2_ptr);
        (**dim).SetMeasuredGeometry(TopoDS::Edge(*edge1), TopoDS::Edge(*edge2));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Dimension: set extension size ---

void prsdim_set_extension_size(void* dim_ptr, double v) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        (**dim).DimensionAspect()->SetExtensionSize(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

// --- Font & Text ---

typedef opencascade::handle<StdPrs_BRepFont> BRepFontHandle;

occt_brep_font make_brep_font_from_file(const char* font_path, double size, int face_id) {
    clear_error();
    if (!font_path || !*font_path) { set_error("null or empty font path", 2); return nullptr; }
    if (size < Precision::Confusion()) { set_error("non-positive font size", 2); return nullptr; }
    try {
        BRepFontHandle* h = new BRepFontHandle;
        *h = new StdPrs_BRepFont;
        if (!(*h)->Init(NCollection_String(font_path), size, face_id)) {
            delete h;
            set_error("failed to load font from path");
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_brep_font make_brep_font_from_name(const char* font_name, int font_aspect, double size) {
    clear_error();
    if (!font_name || !*font_name) { set_error("null or empty font name", 2); return nullptr; }
    if (size < Precision::Confusion()) { set_error("non-positive font size", 2); return nullptr; }
    try {
        BRepFontHandle* h = new BRepFontHandle;
        *h = StdPrs_BRepFont::FindAndCreate(
            TCollection_AsciiString(font_name),
            static_cast<Font_FontAspect>(font_aspect),
            size,
            Font_StrictLevel_Any);
        if (h->IsNull()) { delete h; set_error("font not found by name"); return nullptr; }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_brep_font(occt_brep_font font) {
    if (font) {
        delete static_cast<BRepFontHandle*>(font);
    }
}

occt_shape make_text_shape(occt_brep_font font, const char* text, int h_align, int v_align) {
    return make_text_shape_on_plane(font, text, h_align, v_align, 0, 0, 0, 0, 0, 1);
}

occt_shape make_text_shape_on_plane(occt_brep_font font, const char* text, int h_align, int v_align,
                                     double px, double py, double pz,
                                     double zx, double zy, double zz) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    if (!text || !*text) { set_error("null or empty text", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        StdPrs_BRepTextBuilder builder;
        gp_Pnt pnt(px, py, pz);
        gp_Dir zDir(zx, zy, zz);
        gp_Ax3 ax3(pnt, zDir);
        TopoDS_Shape result = builder.Perform(
            *hFont,
            NCollection_String(text),
            ax3,
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        if (result.IsNull()) { set_error("text rendering produced null shape"); return nullptr; }
        if (is_empty_shape(result)) { set_error("text rendering produced empty shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_text_shape_on_plane_full(occt_brep_font font, const char* text, int h_align, int v_align,
                                          double px, double py, double pz,
                                          double zx, double zy, double zz,
                                          double xx, double xy, double xz) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    if (!text || !*text) { set_error("null or empty text", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        StdPrs_BRepTextBuilder builder;
        gp_Pnt pnt(px, py, pz);
        gp_Dir zDir(zx, zy, zz);
        gp_Dir xDir(xx, xy, xz);
        gp_Ax3 ax3(pnt, zDir, xDir);
        TopoDS_Shape result = builder.Perform(
            *hFont,
            NCollection_String(text),
            ax3,
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        if (result.IsNull()) { set_error("text rendering produced null shape"); return nullptr; }
        if (is_empty_shape(result)) { set_error("text rendering produced empty shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void text_bounding_box(occt_brep_font font, const char* text,
                       int h_align, int v_align,
                       double* out_width, double* out_height) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    if (!text || !*text) { set_error("null or empty text", 2); *out_width = 0; *out_height = 0; return; }
    if (!out_width || !out_height) { set_error("null output pointer", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        const occ::handle<Font_FTFont>& ftFont = hFont->FTFont();
        Font_Rect box = ftFont->BoundingBox(NCollection_String(text),
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        *out_width = static_cast<double>(box.Width());
        *out_height = static_cast<double>(box.Height());
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

const char* query_font_info(const char* font_name) {
    clear_error();
    try {
        static std::string result;
        result.clear();
        if (!font_name || !*font_name) { set_error("null or empty font name", 2); return nullptr; }
        Handle(Font_FontMgr) mgr = Font_FontMgr::GetInstance();
        if (mgr.IsNull()) { set_error("Font_FontMgr returned null", 2); return nullptr; }
        Handle(Font_SystemFont) font = mgr->GetFont(TCollection_AsciiString(font_name));
        if (font.IsNull()) { set_error("font not found", 2); return nullptr; }
        result = "{\"name\":\"";
        result += font->FontName().ToCString();
        result += "\",\"key\":\"";
        result += font->FontKey().ToCString();
        result += "\"}";
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

const char* enumerate_fonts(void) {
    clear_error();
    try {
        static std::string result;
        result.clear();
        Handle(Font_FontMgr) mgr = Font_FontMgr::GetInstance();
        if (mgr.IsNull()) { set_error("Font_FontMgr returned null"); return nullptr; }
        NCollection_Sequence<Handle(TCollection_HAsciiString)> fontsNames;
        mgr->GetAvailableFontsNames(fontsNames);
        result = "[";
        for (int i = 1; i <= fontsNames.Size(); ++i) {
            if (i > 1) result += ",";
            result += "\"";
            Handle(TCollection_HAsciiString) name = fontsNames.Value(i);
            if (!name.IsNull()) {
                result += name->String().ToCString();
            }
            result += "\"";
        }
        result += "]";
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_text_label_create(const char* text) {
    clear_error();
    try {
        Handle(AIS_TextLabel)* h = new Handle(AIS_TextLabel);
        *h = new AIS_TextLabel();
        if (text && *text) {
            (*h)->SetText(TCollection_ExtendedString(text));
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_text_label_free(void* label) {
    if (label) {
        delete static_cast<Handle(AIS_TextLabel)*>(label);
    }
}

void ais_text_label_set_text(void* label, const char* text) {
    if (!label) { set_error("null label argument", 2); return; }
    if (!text) { set_error("null text argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetText(TCollection_ExtendedString(text));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_position(void* label, double x, double y, double z) {
    if (!label) { set_error("null label argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetPosition(gp_Pnt(x, y, z));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_color(void* label, double r, double g, double b) {
    if (!label) { set_error("null label argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_font(void* label, const char* font_name, double height) {
    if (!label) { set_error("null label argument", 2); return; }
    if (!font_name || !*font_name) { set_error("null or empty font name", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetFont(font_name);
        if (height > Precision::Confusion()) {
            (*h)->SetHeight(height);
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_height(void* label, double height) {
    if (!label) { set_error("null label argument", 2); return; }
    if (height < Precision::Confusion()) { set_error("non-positive height", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetHeight(height);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_shape font_render_glyph(occt_brep_font font, unsigned int codepoint) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        TopoDS_Shape result = hFont->RenderGlyph(codepoint);
        if (result.IsNull()) { set_error("glyph rendering produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

double font_ascender(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->Ascender();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_descender(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->Descender();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_line_spacing(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->LineSpacing();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_advance_x(occt_brep_font font, unsigned int c1, unsigned int c2) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->AdvanceX(c1, c2);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_advance_y(occt_brep_font font, unsigned int c1, unsigned int c2) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->AdvanceY(c1, c2);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void font_set_width_scaling(occt_brep_font font, double scale) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    if (scale < Precision::Confusion()) { set_error("non-positive width scale", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        hFont->SetWidthScaling(static_cast<float>(scale));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void font_set_composite_curve_mode(occt_brep_font font, int on) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        hFont->SetCompositeCurveMode(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int get_error_code(void) {
    return g_error_code;
}

const char* get_error_message(void) {
    return g_error_message;
}

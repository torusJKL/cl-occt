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
#include <Graphic3d_CubeMapSeparate.hxx>
#include <BRepBndLib.hxx>
#include <AIS_Trihedron.hxx>
#include <Geom_Axis2Placement.hxx>
#include <gp_Pnt.hxx>
#include <gp_Dir.hxx>
#include <gp_Ax2.hxx>
#include <gp_Ax3.hxx>
#include <Geom_Line.hxx>
#include <Geom_Circle.hxx>
#include <Geom_Ellipse.hxx>
#include <Geom_Hyperbola.hxx>
#include <Geom_Parabola.hxx>
#include <Geom_BezierCurve.hxx>
#include <Geom_BSplineCurve.hxx>
#include <Geom_Plane.hxx>
#include <Geom_CylindricalSurface.hxx>
#include <Geom_ConicalSurface.hxx>
#include <Geom_SphericalSurface.hxx>
#include <Geom_ToroidalSurface.hxx>
#include <Geom_BezierSurface.hxx>
#include <Geom_BSplineSurface.hxx>
#include <GC_MakeSegment.hxx>
#include <GC_MakeArcOfCircle.hxx>
#include <GeomConvert.hxx>
#include <Bnd_Box.hxx>
#include <BndLib_Add3dCurve.hxx>
#include <GeomBndLib_Surface.hxx>
#include <GeomAPI_ProjectPointOnCurve.hxx>
#include <GeomAPI_ProjectPointOnSurf.hxx>
#include <GeomAPI_IntCS.hxx>
#include <BRepExtrema_ExtCC.hxx>
#include <TopoDS_Edge.hxx>
#include <TopoDS_Vertex.hxx>
#include <BRep_Tool.hxx>
#include <GeomAPI_IntSS.hxx>
#include <GeomAPI_ExtremaCurveCurve.hxx>
#include <GeomAPI_ExtremaCurveSurface.hxx>
#include <Geom2dAPI_InterCurveCurve.hxx>
#include <Geom2dAPI_ProjectPointOnCurve.hxx>
#include <GeomAPI_PointsToBSpline.hxx>
#include <GeomAPI_Interpolate.hxx>
#include <TColgp_Array1OfPnt.hxx>
#include <TColStd_Array1OfReal.hxx>
#include <TColStd_Array1OfInteger.hxx>
#include <TColgp_Array2OfPnt.hxx>
#include <TColStd_Array2OfReal.hxx>
#include <BRep_Tool.hxx>
#include <BRepBuilderAPI_MakeEdge.hxx>
#include <BRepBuilderAPI_MakeWire.hxx>
#include <GeomAdaptor_Curve.hxx>
#include <GeomAdaptor_Surface.hxx>
#include <HelixGeom_BuilderHelix.hxx>
#include <HelixBRep_BuilderHelix.hxx>
#include <Graphic3d_TransformPers.hxx>
#include <Prs3d_DatumMode.hxx>
#include <GProp_GProps.hxx>
#include <GProp_PrincipalProps.hxx>
#include <BRepGProp.hxx>
#include <BRepExtrema_DistShapeShape.hxx>
#include <BRepClass3d_SolidClassifier.hxx>
#include <BRepCheck_Analyzer.hxx>
#include <BRepTools.hxx>
#include <BRepIntCurveSurface_Inter.hxx>
#include <BRepAdaptor_Curve.hxx>
#include <BRepAdaptor_Surface.hxx>
#include <BRepBuilderAPI_MakeVertex.hxx>
#include <BRepBuilderAPI_MakePolygon.hxx>
#include <BRepFilletAPI_MakeFillet.hxx>
#include <BRepFilletAPI_MakeFillet2d.hxx>
#include <BRepFilletAPI_MakeChamfer.hxx>
#include <BRepOffsetAPI_MakePipe.hxx>
#include <BRepOffsetAPI_MakePipeShell.hxx>
#include <BRepOffsetAPI_ThruSections.hxx>
#include <BRepOffsetAPI_MakeThickSolid.hxx>
#include <BRepOffsetAPI_MakeOffsetShape.hxx>
#include <BRepOffsetAPI_MakeOffset.hxx>
#include <BRepOffsetAPI_DraftAngle.hxx>
#include <BRepOffsetAPI_MakeEvolved.hxx>
#include <BRepFeat_MakeCylindricalHole.hxx>
#include <BRepFeat_MakePrism.hxx>
#include <BRepFeat_MakeRevol.hxx>
#include <BRepFeat_MakePipe.hxx>
#include <LocOpe_DPrism.hxx>
#include <LocOpe_Revol.hxx>
#include <TopTools_ListOfShape.hxx>
#include <BRepFill_Filling.hxx>

#include <BRepMesh_IncrementalMesh.hxx>
#include <Poly_Triangulation.hxx>
#include <TopExp_Explorer.hxx>
#include <TopAbs_ShapeEnum.hxx>
#include <TopoDS.hxx>
#include <TopoDS_Face.hxx>
#include <TopoDS_Wire.hxx>
#include <TopoDS_Edge.hxx>
#include <BRep_Tool.hxx>
#include <Geom_Curve.hxx>
#include <Geom_Surface.hxx>
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

// --- 3D Curve types ---

enum GeomCurveKind {
    CURVE_LINE = 0,
    CURVE_CIRCLE,
    CURVE_ELLIPSE,
    CURVE_HYPERBOLA,
    CURVE_PARABOLA,
    CURVE_BEZIER,
    CURVE_BSPLINE,
    CURVE_GC_LINE,
    CURVE_GC_ARC_CIRCLE,
    CURVE_HELIX,
};

struct OccctCurve {
    GeomCurveKind kind;
    void* handle;
};

static OccctCurve* alloc_curve(GeomCurveKind kind, void* handle) {
    OccctCurve* c = new OccctCurve;
    c->kind = kind;
    c->handle = handle;
    return c;
}

static Handle(Geom_Curve)* curve_handle(occt_curve c) {
    return static_cast<Handle(Geom_Curve)*>(static_cast<OccctCurve*>(c)->handle);
}

static gp_Pnt get_pnt(double x, double y, double z) { return gp_Pnt(x, y, z); }
static gp_Dir get_dir(double x, double y, double z) { return gp_Dir(x, y, z); }

occt_curve make_line_3d(double ox, double oy, double oz, double dx, double dy, double dz) {
    clear_error();
    double mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (mag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        Handle(Geom_Line)* h = new Handle(Geom_Line)(new Geom_Line(get_pnt(ox, oy, oz), get_dir(dx, dy, dz)));
        return alloc_curve(CURVE_LINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_circle_3d(double ox, double oy, double oz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Circle)* h = new Handle(Geom_Circle)(new Geom_Circle(ax, radius));
        return alloc_curve(CURVE_CIRCLE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_ellipse_3d(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Ellipse)* h = new Handle(Geom_Ellipse)(new Geom_Ellipse(ax, major_r, minor_r));
        return alloc_curve(CURVE_ELLIPSE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_hyperbola(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Hyperbola)* h = new Handle(Geom_Hyperbola)(new Geom_Hyperbola(ax, major_r, minor_r));
        return alloc_curve(CURVE_HYPERBOLA, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_parabola(double ox, double oy, double oz, double focal) {
    clear_error();
    if (focal < Precision::Confusion()) { set_error("non-positive focal length", 2); return nullptr; }
    try {
        gp_Ax2 ax(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_Parabola)* h = new Handle(Geom_Parabola)(new Geom_Parabola(ax, focal));
        return alloc_curve(CURVE_PARABOLA, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_bezier_curve(double* points, int num_points) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        TColgp_Array1OfPnt arr(1, num_points);
        for (int i = 0; i < num_points; i++)
            arr.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        Handle(Geom_BezierCurve)* h = new Handle(Geom_BezierCurve)(new Geom_BezierCurve(arr));
        return alloc_curve(CURVE_BEZIER, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_bspline_curve(double* poles, int num_poles, double* knots, int* mults, int num_knots, int degree) {
    clear_error();
    if (!poles || num_poles < 2 || !knots || !mults || num_knots < 2 || degree < 1) { set_error("invalid bspline parameters", 2); return nullptr; }
    try {
        TColgp_Array1OfPnt poleArr(1, num_poles);
        for (int i = 0; i < num_poles; i++)
            poleArr.SetValue(i + 1, gp_Pnt(poles[i * 3], poles[i * 3 + 1], poles[i * 3 + 2]));
        TColStd_Array1OfReal knotArr(1, num_knots);
        TColStd_Array1OfInteger multArr(1, num_knots);
        for (int i = 0; i < num_knots; i++) {
            knotArr.SetValue(i + 1, knots[i]);
            multArr.SetValue(i + 1, mults[i]);
        }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(new Geom_BSplineCurve(poleArr, knotArr, multArr, degree));
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void free_curve(occt_curve c) {
    if (!c) return;
    OccctCurve* oc = static_cast<OccctCurve*>(c);
    switch (oc->kind) {
        case CURVE_LINE:        delete static_cast<Handle(Geom_Line)*>(oc->handle); break;
        case CURVE_CIRCLE:      delete static_cast<Handle(Geom_Circle)*>(oc->handle); break;
        case CURVE_ELLIPSE:     delete static_cast<Handle(Geom_Ellipse)*>(oc->handle); break;
        case CURVE_HYPERBOLA:   delete static_cast<Handle(Geom_Hyperbola)*>(oc->handle); break;
        case CURVE_PARABOLA:    delete static_cast<Handle(Geom_Parabola)*>(oc->handle); break;
        case CURVE_BEZIER:      delete static_cast<Handle(Geom_BezierCurve)*>(oc->handle); break;
        case CURVE_BSPLINE:     delete static_cast<Handle(Geom_BSplineCurve)*>(oc->handle); break;
        case CURVE_GC_LINE:
        case CURVE_GC_ARC_CIRCLE: delete static_cast<Handle(Geom_TrimmedCurve)*>(oc->handle); break;
        case CURVE_HELIX:       delete static_cast<Handle(Geom_Curve)*>(oc->handle); break;
    }
    delete oc;
}

int curve_type(occt_curve c) {
    if (!c) return -1;
    return static_cast<OccctCurve*>(c)->kind;
}

occt_curve make_gc_line(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        GC_MakeSegment maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2));
        if (!maker.IsDone()) { set_error("GC_MakeSegment failed"); return nullptr; }
        Handle(Geom_TrimmedCurve)* h = new Handle(Geom_TrimmedCurve)(maker.Value());
        return alloc_curve(CURVE_GC_LINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve make_gc_arc_of_circle(double x1, double y1, double z1,
                                  double x2, double y2, double z2,
                                  double x3, double y3, double z3) {
    clear_error();
    try {
        GC_MakeArcOfCircle maker(gp_Pnt(x1, y1, z1), gp_Pnt(x2, y2, z2), gp_Pnt(x3, y3, z3));
        if (!maker.IsDone()) { set_error("GC_MakeArcOfCircle failed"); return nullptr; }
        Handle(Geom_TrimmedCurve)* h = new Handle(Geom_TrimmedCurve)(maker.Value());
        return alloc_curve(CURVE_GC_ARC_CIRCLE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve convert_curve_to_bspline(occt_curve c) {
    clear_error();
    if (!c) { set_error("null curve", 2); return nullptr; }
    try {
        Handle(Geom_Curve) gc = *curve_handle(c);
        Handle(Geom_BSplineCurve) bs = GeomConvert::CurveToBSplineCurve(gc);
        if (bs.IsNull()) { set_error("curve conversion failed"); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(bs);
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

int curve_bounding_box(occt_curve c,
                       double* xmin, double* ymin, double* zmin,
                       double* xmax, double* ymax, double* zmax) {
    clear_error();
    if (!c || !xmin || !ymin || !zmin || !xmax || !ymax || !zmax) { set_error("null argument", 2); return 0; }
    try {
        Bnd_Box box;
        GeomAdaptor_Curve adaptor(*curve_handle(c));
        BndLib_Add3dCurve::Add(adaptor, Precision::Confusion(), box);
        if (box.IsVoid()) return 0;
        box.Get(*xmin, *ymin, *zmin, *xmax, *ymax, *zmax);
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

// --- 3D Surface types ---

enum GeomSurfaceKind {
    SURFACE_PLANE = 0,
    SURFACE_CYLINDRICAL,
    SURFACE_CONICAL,
    SURFACE_SPHERICAL,
    SURFACE_TOROIDAL,
    SURFACE_BEZIER,
    SURFACE_BSPLINE,
};

struct OccctSurface {
    GeomSurfaceKind kind;
    void* handle;
};

static OccctSurface* alloc_surface(GeomSurfaceKind kind, void* handle) {
    OccctSurface* s = new OccctSurface;
    s->kind = kind;
    s->handle = handle;
    return s;
}

static Handle(Geom_Surface)* surface_handle(occt_surface s) {
    return static_cast<Handle(Geom_Surface)*>(static_cast<OccctSurface*>(s)->handle);
}

occt_surface make_plane(double ox, double oy, double oz, double nx, double ny, double nz) {
    clear_error();
    double nmag = sqrt(nx*nx + ny*ny + nz*nz);
    if (nmag < Precision::Confusion()) { set_error("zero normal vector", 2); return nullptr; }
    try {
        Handle(Geom_Plane)* h = new Handle(Geom_Plane)(new Geom_Plane(get_pnt(ox, oy, oz), get_dir(nx, ny, nz)));
        return alloc_surface(SURFACE_PLANE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_cylindrical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    double dmag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dmag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), get_dir(dx, dy, dz));
        Handle(Geom_CylindricalSurface)* h = new Handle(Geom_CylindricalSurface)(new Geom_CylindricalSurface(ax3, radius));
        return alloc_surface(SURFACE_CYLINDRICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_conical_surface(double ox, double oy, double oz, double dx, double dy, double dz, double radius, double semi_angle) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    double dmag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dmag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), get_dir(dx, dy, dz));
        Handle(Geom_ConicalSurface)* h = new Handle(Geom_ConicalSurface)(new Geom_ConicalSurface(ax3, semi_angle * M_PI / 180.0, radius));
        return alloc_surface(SURFACE_CONICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_spherical_surface(double ox, double oy, double oz, double radius) {
    clear_error();
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_SphericalSurface)* h = new Handle(Geom_SphericalSurface)(new Geom_SphericalSurface(ax3, radius));
        return alloc_surface(SURFACE_SPHERICAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_toroidal_surface(double ox, double oy, double oz, double major_r, double minor_r) {
    clear_error();
    if (major_r < Precision::Confusion() || minor_r < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax3 ax3(get_pnt(ox, oy, oz), gp_Dir(0, 0, 1));
        Handle(Geom_ToroidalSurface)* h = new Handle(Geom_ToroidalSurface)(new Geom_ToroidalSurface(ax3, major_r, minor_r));
        return alloc_surface(SURFACE_TOROIDAL, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_bezier_surface(double* poles, int num_u, int num_v) {
    clear_error();
    if (!poles || num_u < 2 || num_v < 2) { set_error("need at least 2x2 poles", 2); return nullptr; }
    try {
        TColgp_Array2OfPnt arr(1, num_u, 1, num_v);
        for (int u = 0; u < num_u; u++)
            for (int v = 0; v < num_v; v++) {
                int idx = (u * num_v + v) * 3;
                arr.SetValue(u + 1, v + 1, gp_Pnt(poles[idx], poles[idx + 1], poles[idx + 2]));
            }
        Handle(Geom_BezierSurface)* h = new Handle(Geom_BezierSurface)(new Geom_BezierSurface(arr));
        return alloc_surface(SURFACE_BEZIER, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_surface make_bspline_surface(double* poles, int num_u_poles, int num_v_poles,
                                   double* uknots, int* umults, int num_uknots,
                                   double* vknots, int* vmults, int num_vknots,
                                   int udeg, int vdeg) {
    clear_error();
    if (!poles || num_u_poles < 2 || num_v_poles < 2) { set_error("need at least 2x2 poles", 2); return nullptr; }
    if (!uknots || !umults || num_uknots < 2 || !vknots || !vmults || num_vknots < 2) { set_error("invalid knot data", 2); return nullptr; }
    if (udeg < 1 || vdeg < 1) { set_error("degree must be >= 1", 2); return nullptr; }
    try {
        TColgp_Array2OfPnt poleArr(1, num_u_poles, 1, num_v_poles);
        for (int u = 0; u < num_u_poles; u++)
            for (int v = 0; v < num_v_poles; v++) {
                int idx = (u * num_v_poles + v) * 3;
                poleArr.SetValue(u + 1, v + 1, gp_Pnt(poles[idx], poles[idx + 1], poles[idx + 2]));
            }
        TColStd_Array1OfReal uKnotArr(1, num_uknots);
        TColStd_Array1OfInteger uMultArr(1, num_uknots);
        for (int i = 0; i < num_uknots; i++) { uKnotArr.SetValue(i + 1, uknots[i]); uMultArr.SetValue(i + 1, umults[i]); }
        TColStd_Array1OfReal vKnotArr(1, num_vknots);
        TColStd_Array1OfInteger vMultArr(1, num_vknots);
        for (int i = 0; i < num_vknots; i++) { vKnotArr.SetValue(i + 1, vknots[i]); vMultArr.SetValue(i + 1, vmults[i]); }
        Handle(Geom_BSplineSurface)* h = new Handle(Geom_BSplineSurface)(new Geom_BSplineSurface(poleArr, uKnotArr, vKnotArr, uMultArr, vMultArr, udeg, vdeg));
        return alloc_surface(SURFACE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void free_surface(occt_surface s) {
    if (!s) return;
    OccctSurface* os = static_cast<OccctSurface*>(s);
    switch (os->kind) {
        case SURFACE_PLANE:        delete static_cast<Handle(Geom_Plane)*>(os->handle); break;
        case SURFACE_CYLINDRICAL:  delete static_cast<Handle(Geom_CylindricalSurface)*>(os->handle); break;
        case SURFACE_CONICAL:      delete static_cast<Handle(Geom_ConicalSurface)*>(os->handle); break;
        case SURFACE_SPHERICAL:    delete static_cast<Handle(Geom_SphericalSurface)*>(os->handle); break;
        case SURFACE_TOROIDAL:     delete static_cast<Handle(Geom_ToroidalSurface)*>(os->handle); break;
        case SURFACE_BEZIER:       delete static_cast<Handle(Geom_BezierSurface)*>(os->handle); break;
        case SURFACE_BSPLINE:      delete static_cast<Handle(Geom_BSplineSurface)*>(os->handle); break;
    }
    delete os;
}

int surface_type(occt_surface s) {
    if (!s) return -1;
    return static_cast<OccctSurface*>(s)->kind;
}

occt_surface convert_surface_to_bspline(occt_surface s) {
    clear_error();
    if (!s) { set_error("null surface", 2); return nullptr; }
    try {
        Handle(Geom_Surface) gs = *surface_handle(s);
        Handle(Geom_BSplineSurface) bs = GeomConvert::SurfaceToBSplineSurface(gs);
        if (bs.IsNull()) { set_error("surface conversion failed"); return nullptr; }
        Handle(Geom_BSplineSurface)* h = new Handle(Geom_BSplineSurface)(bs);
        return alloc_surface(SURFACE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

int surface_bounding_box(occt_surface s,
                         double* xmin, double* ymin, double* zmin,
                         double* xmax, double* ymax, double* zmax) {
    clear_error();
    if (!s || !xmin || !ymin || !zmin || !xmax || !ymax || !zmax) { set_error("null argument", 2); return 0; }
    try {
        GeomBndLib_Surface bnd(*surface_handle(s));
        Bnd_Box box = bnd.Box(Precision::Confusion());
        if (box.IsVoid()) return 0;
        box.Get(*xmin, *ymin, *zmin, *xmax, *ymax, *zmax);
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

// --- Geometric Algorithms ---

int project_point_on_curve(occt_curve c,
                           double px, double py, double pz,
                           double* out_x, double* out_y, double* out_z,
                           double* out_dist, double* out_param) {
    clear_error();
    if (!c || !out_x || !out_y || !out_z || !out_dist || !out_param) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ProjectPointOnCurve proj(gp_Pnt(px, py, pz), *curve_handle(c));
        if (!proj.NbPoints()) return 0;
        gp_Pnt p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y(); *out_z = p.Z();
        *out_dist = proj.LowerDistance();
        *out_param = proj.LowerDistanceParameter();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int project_point_on_surface(occt_surface s,
                             double px, double py, double pz,
                             double* out_x, double* out_y, double* out_z,
                             double* out_u, double* out_v, double* out_dist) {
    clear_error();
    if (!s || !out_x || !out_y || !out_z || !out_u || !out_v || !out_dist) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ProjectPointOnSurf proj(gp_Pnt(px, py, pz), *surface_handle(s));
        if (!proj.NbPoints()) return 0;
        gp_Pnt p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y(); *out_z = p.Z();
        proj.LowerDistanceParameters(*out_u, *out_v);
        *out_dist = proj.LowerDistance();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_curves(occt_curve c1, occt_curve c2,
                     double* out_points, int max_points) {
    clear_error();
    if (!c1 || !c2 || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        BRepBuilderAPI_MakeEdge edgeMaker1(*curve_handle(c1));
        BRepBuilderAPI_MakeEdge edgeMaker2(*curve_handle(c2));
        if (!edgeMaker1.IsDone() || !edgeMaker2.IsDone()) { set_error("failed to create edges", 2); return 0; }
        const TopoDS_Edge& e1 = edgeMaker1.Edge();
        const TopoDS_Edge& e2 = edgeMaker2.Edge();
        BRepExtrema_ExtCC extrema(e1, e2);
        if (!extrema.IsDone()) return 0;
        if (extrema.IsParallel()) return 0;
        int n = extrema.NbExt();
        int count = 0;
        for (int i = 1; i <= n && (count < max_points || max_points == 0); i++) {
            gp_Pnt p1 = extrema.PointOnE1(i);
            gp_Pnt p2 = extrema.PointOnE2(i);
            double dist = p1.Distance(p2);
            if (dist < Precision::Confusion()) {
                if (out_points && count < max_points) {
                    out_points[count * 3] = p1.X();
                    out_points[count * 3 + 1] = p1.Y();
                    out_points[count * 3 + 2] = p1.Z();
                }
                count++;
            }
        }
        return count;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_curve_surface(occt_curve c, occt_surface s,
                            double* out_points, int max_points) {
    clear_error();
    if (!c || !s || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_IntCS intersector(*curve_handle(c), *surface_handle(s));
        if (!intersector.NbPoints()) return 0;
        int n = intersector.NbPoints();
        if (out_points && max_points > 0) {
            int count = (n < max_points) ? n : max_points;
            for (int i = 0; i < count; i++) {
                gp_Pnt p = intersector.Point(i + 1);
                out_points[i * 3] = p.X();
                out_points[i * 3 + 1] = p.Y();
                out_points[i * 3 + 2] = p.Z();
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int intersect_surfaces(occt_surface s1, occt_surface s2,
                       occt_curve* out_curves, int max_curves) {
    clear_error();
    if (!s1 || !s2 || (!out_curves && max_curves > 0)) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_IntSS intersector(*surface_handle(s1), *surface_handle(s2), Precision::Confusion());
        if (!intersector.NbLines()) return 0;
        int n = intersector.NbLines();
        if (out_curves && max_curves > 0) {
            int count = (n < max_curves) ? n : max_curves;
            for (int i = 0; i < count; i++) {
                Handle(Geom_Curve) curve = intersector.Line(i + 1);
                Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
                out_curves[i] = alloc_curve(CURVE_BSPLINE, h);
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int extrema_curve_curve(occt_curve c1, occt_curve c2,
                        double* out_dist,
                        double* out_p1x, double* out_p1y, double* out_p1z,
                        double* out_p2x, double* out_p2y, double* out_p2z) {
    clear_error();
    if (!c1 || !c2 || !out_dist || !out_p1x || !out_p1y || !out_p1z || !out_p2x || !out_p2y || !out_p2z) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ExtremaCurveCurve extrema(*curve_handle(c1), *curve_handle(c2));
        if (!extrema.NbExtrema()) return 0;
        gp_Pnt p1, p2;
        extrema.NearestPoints(p1, p2);
        *out_p1x = p1.X(); *out_p1y = p1.Y(); *out_p1z = p1.Z();
        *out_p2x = p2.X(); *out_p2y = p2.Y(); *out_p2z = p2.Z();
        *out_dist = extrema.LowerDistance();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int extrema_curve_surface(occt_curve c, occt_surface s,
                          double* out_dist,
                          double* out_px, double* out_py, double* out_pz,
                          double* out_u, double* out_v) {
    clear_error();
    if (!c || !s || !out_dist || !out_px || !out_py || !out_pz || !out_u || !out_v) { set_error("null argument", 2); return 0; }
    try {
        GeomAPI_ExtremaCurveSurface extrema(*curve_handle(c), *surface_handle(s));
        int n = extrema.NbExtrema();
        if (!n) return 0;
        double bestDist = DBL_MAX;
        gp_Pnt bestP;
        double bestU = 0, bestV = 0;
        for (int i = 1; i <= n; i++) {
            gp_Pnt p1, p2;
            double w, u, v;
            extrema.Points(i, p1, p2);
            extrema.Parameters(i, w, u, v);
            double d = p1.Distance(p2);
            if (d < bestDist) {
                bestDist = d;
                bestP = (p1.X() != 0 || p1.Y() != 0 || p1.Z() != 0) ? p1 : p2;
                bestU = u;
                bestV = v;
            }
        }
        *out_dist = bestDist;
        *out_px = bestP.X(); *out_py = bestP.Y(); *out_pz = bestP.Z();
        *out_u = bestU;
        *out_v = bestV;
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

static Handle(Geom2d_Curve) get_geom2d_curve(occt_geom2d g) {
    Geom2dObj* o = static_cast<Geom2dObj*>(g);
    if (o->kind == KIND_LINE2D)
        return *static_cast<Handle(Geom2d_Line)*>(o->obj);
    if (o->kind == KIND_CIRCLE2D)
        return *static_cast<Handle(Geom2d_Circle)*>(o->obj);
    return Handle(Geom2d_Curve)();
}

int intersect_curves_2d(occt_geom2d c1, occt_geom2d c2,
                        double* out_points, int max_points) {
    clear_error();
    if (!c1 || !c2 || (!out_points && max_points > 0)) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom2d_Curve) hc1 = get_geom2d_curve(c1);
        Handle(Geom2d_Curve) hc2 = get_geom2d_curve(c2);
        if (hc1.IsNull() || hc2.IsNull()) { set_error("both arguments must be 2D curves", 2); return 0; }
        Geom2dAPI_InterCurveCurve intersector(hc1, hc2);
        if (!intersector.NbPoints()) return 0;
        int n = intersector.NbPoints();
        if (out_points && max_points > 0) {
            int count = (n < max_points) ? n : max_points;
            for (int i = 0; i < count; i++) {
                gp_Pnt2d p = intersector.Point(i + 1);
                out_points[i * 2] = p.X();
                out_points[i * 2 + 1] = p.Y();
            }
        }
        return n;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

int project_point_on_curve_2d(occt_geom2d curve,
                              double px, double py,
                              double* out_x, double* out_y,
                              double* out_dist, double* out_param) {
    clear_error();
    if (!curve || !out_x || !out_y || !out_dist || !out_param) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom2d_Curve) hc = get_geom2d_curve(curve);
        if (hc.IsNull()) { set_error("must be a 2D curve", 2); return 0; }
        Geom2dAPI_ProjectPointOnCurve proj(gp_Pnt2d(px, py), hc);
        if (!proj.NbPoints()) return 0;
        gp_Pnt2d p = proj.NearestPoint();
        *out_x = p.X(); *out_y = p.Y();
        *out_dist = proj.LowerDistance();
        *out_param = proj.LowerDistanceParameter();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

occt_curve points_to_bspline(double* points, int num_points, int degree) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        TColgp_Array1OfPnt arr(1, num_points);
        for (int i = 0; i < num_points; i++)
            arr.SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        int deg = (degree > 0) ? degree : 3;
        GeomAPI_PointsToBSpline fitter(arr, deg);
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(fitter.Curve());
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_curve interpolate_points(double* points, int num_points,
                              double* init_tangent, double* final_tangent) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        occ::handle<NCollection_HArray1<gp_Pnt>> harr = new NCollection_HArray1<gp_Pnt>(1, num_points);
        for (int i = 0; i < num_points; i++)
            harr->SetValue(i + 1, gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        GeomAPI_Interpolate interpolator(harr, false, Precision::Confusion());
        gp_Vec initV(0, 0, 0), finalV(0, 0, 0);
        bool hasInit = init_tangent != nullptr;
        bool hasFinal = final_tangent != nullptr;
        if (hasInit) initV = gp_Vec(init_tangent[0], init_tangent[1], init_tangent[2]);
        if (hasFinal) finalV = gp_Vec(final_tangent[0], final_tangent[1], final_tangent[2]);
        if (hasInit || hasFinal)
            interpolator.Load(initV, finalV, true);
        interpolator.Perform();
        if (!interpolator.IsDone()) { set_error("interpolation failed", 2); return nullptr; }
        Handle(Geom_BSplineCurve)* h = new Handle(Geom_BSplineCurve)(interpolator.Curve());
        return alloc_curve(CURVE_BSPLINE, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

// --- Helix ---

occt_curve make_helix_curve(double radius, double pitch, double height,
                            int left_handed, double angle) {
    clear_error();
    if (radius < Precision::Confusion() || pitch < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive parameter", 2); return nullptr;
    }
    try {
        double totalAngle = (height / pitch) * 2.0 * M_PI;
        double taperAngle = angle * M_PI / 180.0;
        HelixGeom_BuilderHelix builder;
        builder.SetPosition(gp_Ax2(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1)));
        builder.SetCurveParameters(0.0, totalAngle, pitch, radius, taperAngle, left_handed != 0);
        builder.SetApproxParameters(GeomAbs_C1, 8, 100);
        builder.SetTolerance(Precision::Confusion());
        builder.Perform();
        if (builder.ErrorStatus() != 0) { set_error("helix curve construction failed"); return nullptr; }
        const auto& curves = builder.Curves();
        if (curves.Size() < 1) { set_error("helix produced no curves"); return nullptr; }
        Handle(Geom_Curve) curve = curves.First();
        if (curve.IsNull()) { set_error("helix curve is null"); return nullptr; }
        Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
        return alloc_curve(CURVE_HELIX, h);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

occt_shape make_helix_edge(double radius, double pitch, double height,
                           int left_handed, double angle,
                           occt_surface on_surface) {
    clear_error();
    if (radius < Precision::Confusion() || height < Precision::Confusion()) {
        set_error("non-positive parameter", 2); return nullptr;
    }
    if (fabs(pitch) < Precision::Confusion()) {
        set_error("pitch too small", 2); return nullptr;
    }
    (void)on_surface; // surface constraint for future use
    try {
        gp_Ax3 axis(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1));
        double effectivePitch = left_handed ? -fabs(pitch) : fabs(pitch);
        NCollection_Array1<double> pitches(1, 1);
        pitches(1) = effectivePitch;
        NCollection_Array1<double> nbTurns(1, 1);
        nbTurns(1) = height / fabs(pitch);

        HelixBRep_BuilderHelix builder;
        builder.SetParameters(axis, 2.0 * radius, nbTurns, pitches);
        builder.Perform();
        if (builder.ErrorStatus() != 0) { set_error("helix edge construction failed"); return nullptr; }
        const TopoDS_Shape& shape = builder.Shape();
        if (shape.IsNull()) { set_error("helix edge is null"); return nullptr; }
        return from_shape(shape);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
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

void ais_trihedron_set_wireframe_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null trihedron argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Trihedron)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (**obj).Attributes();
        Handle(Prs3d_LineAspect) aspect = new Prs3d_LineAspect(
            Quantity_Color(r, g, b, Quantity_TOC_RGB), Aspect_TOL_SOLID, 1.0);
        drawer->SetWireAspect(aspect);
        (**obj).Redisplay(true);
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

double v3d_view_get_eye_x(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Eye().X();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_eye_y(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Eye().Y();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_eye_z(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Eye().Z();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
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

double v3d_view_get_target_x(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Center().X();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_target_y(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Center().Y();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_target_z(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Center().Z();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
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

double v3d_view_get_up_x(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Up().X();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_up_y(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Up().Y();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double v3d_view_get_up_z(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->Up().Z();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
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

double v3d_view_get_fov(void* view_ptr) {
    clear_error();
    if (!view_ptr) { set_error("null view argument", 2); return 0; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return (*view)->Camera()->FOVy();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
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

// --- Selection (AIS_InteractiveContext) ---

int ais_context_nb_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->NbSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_init_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->InitSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_context_more_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->MoreSelected() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_next_selected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->NextSelected();
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_context_selected_interactive(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(AIS_InteractiveObject)* h = new Handle(AIS_InteractiveObject);
        *h = (*ctx)->SelectedInteractive();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_context_selected_shape(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return new TopoDS_Shape((*ctx)->SelectedShape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ais_context_has_selected_shape(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->HasSelectedShape() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_set_selected(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetSelected(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_add_or_remove_selected(void* ctx_ptr, void* obj_ptr, int update) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->AddOrRemoveSelected(*obj, update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_clear_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->ClearSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

int ais_context_is_selected(void* ctx_ptr, void* obj_ptr) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        return (*ctx)->IsSelected(*obj) ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_move_to(void* ctx_ptr, void* view_ptr, int x, int y) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        return static_cast<int>((*ctx)->MoveTo(x, y, *view, true));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_select_detected(void* ctx_ptr, int scheme) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return static_cast<int>((*ctx)->SelectDetected(static_cast<AIS_SelectionScheme>(scheme)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ais_context_select_point(void* ctx_ptr, void* view_ptr, int x, int y, int scheme) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        NCollection_Vec2<int> pnt(x, y);
        return static_cast<int>((*ctx)->SelectPoint(pnt, *view, static_cast<AIS_SelectionScheme>(scheme)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_hilight_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->HilightSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_unhilight_selected(void* ctx_ptr, int update) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->UnhilightSelected(update != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_fit_selected(void* ctx_ptr, void* view_ptr, double margin) {
    clear_error();
    if (!ctx_ptr || !view_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        (*ctx)->FitSelected(*view, margin, true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_context_detected_interactive(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return nullptr; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        Handle(AIS_InteractiveObject)* h = new Handle(AIS_InteractiveObject);
        *h = (*ctx)->DetectedInteractive();
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ais_context_has_detected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return 0; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        return (*ctx)->HasDetected() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void ais_context_clear_detected(void* ctx_ptr) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->ClearDetected(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_selection_sensitivity(void* ctx_ptr, void* obj_ptr, int mode, int sensitivity) {
    clear_error();
    if (!ctx_ptr || !obj_ptr) { set_error("null argument", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        (*ctx)->SetSelectionSensitivity(*obj, mode, sensitivity);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_pixel_tolerance(void* ctx_ptr, int pixels) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetPixelTolerance(pixels);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_automatic_hilight(void* ctx_ptr, int on) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetAutomaticHilight(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_context_set_to_hilight_selected(void* ctx_ptr, int on) {
    clear_error();
    if (!ctx_ptr) { set_error("null context", 2); return; }
    try {
        auto* ctx = static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr);
        (*ctx)->SetToHilightSelected(on != 0);
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

void ais_object_set_line_type(void* obj_ptr, int type) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_LineAspect) aspect = drawer->LineAspect();
        if (aspect.IsNull()) {
            drawer->SetLineAspect(new Prs3d_LineAspect(
                Quantity_Color(1, 1, 1, Quantity_TOC_RGB),
                static_cast<Aspect_TypeOfLine>(type), 1.0));
        } else {
            aspect->SetTypeOfLine(static_cast<Aspect_TypeOfLine>(type));
        }
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_point_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_PointAspect) aspect = drawer->PointAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_PointAspect(Aspect_TOM_POINT, Quantity_Color(r, g, b, Quantity_TOC_RGB), 1.0);
            drawer->SetPointAspect(aspect);
        } else {
            aspect->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_point_type(void* obj_ptr, int type) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_PointAspect) aspect = drawer->PointAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_PointAspect(static_cast<Aspect_TypeOfMarker>(type),
                                            Quantity_Color(1, 1, 1, Quantity_TOC_RGB), 1.0);
            drawer->SetPointAspect(aspect);
        } else {
            aspect->SetTypeOfMarker(static_cast<Aspect_TypeOfMarker>(type));
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_point_scale(void* obj_ptr, double scale) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_PointAspect) aspect = drawer->PointAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_PointAspect(Aspect_TOM_POINT, Quantity_Color(1,1,1,Quantity_TOC_RGB), scale);
            drawer->SetPointAspect(aspect);
        } else {
            aspect->SetScale(scale);
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_text_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_TextAspect) aspect = drawer->TextAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_TextAspect();
            drawer->SetTextAspect(aspect);
        }
        aspect->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_text_font(void* obj_ptr, const char* font) {
    clear_error();
    if (!obj_ptr || !font) { set_error("null argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_TextAspect) aspect = drawer->TextAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_TextAspect();
            drawer->SetTextAspect(aspect);
        }
        aspect->SetFont(font);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_text_height(void* obj_ptr, double h) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_TextAspect) aspect = drawer->TextAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_TextAspect();
            drawer->SetTextAspect(aspect);
        }
        aspect->SetHeight(h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_iso_display(void* obj_ptr, int uOn, int vOn) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        drawer->SetIsoOnPlane(uOn != 0);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_object_set_wire_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_InteractiveObject)*>(obj_ptr);
        Handle(Prs3d_Drawer) drawer = (*obj)->Attributes();
        Handle(Prs3d_LineAspect) aspect = drawer->WireAspect();
        if (aspect.IsNull()) {
            aspect = new Prs3d_LineAspect(Quantity_Color(r, g, b, Quantity_TOC_RGB), Aspect_TOL_SOLID, 1.0);
            drawer->SetWireAspect(aspect);
        } else {
            aspect->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
        }
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

// --- Cube-map ---

void* make_cubemap_separate(const char** paths, int count) {
    clear_error();
    if (!paths || count != 6) { set_error("need exactly 6 cube face paths", 2); return nullptr; }
    try {
        NCollection_Array1<TCollection_AsciiString> arr(1, 6);
        arr(1) = TCollection_AsciiString(paths[0]);
        arr(2) = TCollection_AsciiString(paths[1]);
        arr(3) = TCollection_AsciiString(paths[2]);
        arr(4) = TCollection_AsciiString(paths[3]);
        arr(5) = TCollection_AsciiString(paths[4]);
        arr(6) = TCollection_AsciiString(paths[5]);
        Handle(Graphic3d_CubeMapSeparate)* h = new Handle(Graphic3d_CubeMapSeparate)(
            new Graphic3d_CubeMapSeparate(arr));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_cubemap(void* cubemap_ptr) {
    if (cubemap_ptr) {
        delete static_cast<Handle(Graphic3d_CubeMapSeparate)*>(cubemap_ptr);
    }
}

void v3d_view_set_bg_cubemap(void* view_ptr, void* cubemap_ptr) {
    clear_error();
    if (!view_ptr || !cubemap_ptr) { set_error("null argument", 2); return; }
    try {
        auto* view = static_cast<Handle(V3d_View)*>(view_ptr);
        if (view->IsNull()) { set_error("view handle is null", 2); return; }
        auto* cubemap = static_cast<Handle(Graphic3d_CubeMapSeparate)*>(cubemap_ptr);
        if (cubemap->IsNull()) { set_error("cubemap handle is null", 2); return; }
        (*view)->SetBackgroundCubeMap(*cubemap, false, false);
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

// --- Sweep / Pipe ---

occt_shape sweep_pipe(occt_shape profile, occt_shape spine) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipe maker(TopoDS::Wire(*to_shape(spine)), *to_shape(profile));
        if (!maker.IsDone()) { set_error("MakePipe failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_fixed(occt_shape profile, occt_shape spine) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipe maker(TopoDS::Wire(*to_shape(spine)), *to_shape(profile));
        if (!maker.IsDone()) { set_error("MakePipe failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_sliding(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        maker.SetMode(true);
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell sliding failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_fixed(occt_shape spine, occt_shape* sections, double* params, int count) {
    clear_error();
    if (!spine || !sections || !params || count < 1) { set_error("invalid arguments", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(spine)));
        maker.SetMode(false);
        for (int i = 0; i < count; i++) {
            maker.Add(*to_shape(sections[i]), params[i], true);
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell fixed failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape sweep_pipe_shell_aux(occt_shape profile, occt_shape main_spine, occt_shape aux_spine) {
    clear_error();
    if (!profile || !main_spine || !aux_spine) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakePipeShell maker(TopoDS::Wire(*to_shape(main_spine)));
        maker.SetMode(TopoDS::Wire(*to_shape(aux_spine)));
        maker.Add(*to_shape(profile), 0.0, true);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakePipeShell aux spine failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Loft ---

occt_shape loft_sections(occt_shape* wires, int count, int solid) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, false);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_ruled(occt_shape* wires, int count, int solid, int ruled) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, ruled == 0);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections ruled failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_smooth(occt_shape* wires, int count, int solid, int smooth) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, smooth != 0);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections smooth failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape loft_sections_tangency(occt_shape* wires, int count, int solid,
                                   occt_shape init_face, occt_shape final_face) {
    clear_error();
    if (!wires || count < 2) { set_error("need at least 2 wires", 2); return nullptr; }
    (void)init_face;
    (void)final_face;
    try {
        BRepOffsetAPI_ThruSections maker(solid != 0, false);
        for (int i = 0; i < count; i++) {
            if (!wires[i]) { set_error("null wire in loft", 2); return nullptr; }
            maker.AddWire(TopoDS::Wire(*to_shape(wires[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("ThruSections tangency failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Face Filling ---

occt_shape fill_face(occt_shape wire) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        TopExp_Explorer exp(*to_shape(wire), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            filler.Add(TopoDS::Edge(exp.Current()), GeomAbs_C0, false);
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fill_face_constrained(occt_shape wire, occt_shape* support_faces, int* continuities, int count) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        TopExp_Explorer exp(*to_shape(wire), TopAbs_EDGE);
        for (; exp.More(); exp.Next()) {
            filler.Add(TopoDS::Edge(exp.Current()), GeomAbs_C0, false);
        }
        for (int i = 0; i < count; i++) {
            if (support_faces[i]) {
                GeomAbs_Shape cont = GeomAbs_C0;
                if (continuities[i] == 1) cont = GeomAbs_C1;
                else if (continuities[i] == 2) cont = GeomAbs_C2;
                else if (continuities[i] == 3) cont = GeomAbs_C3;
                filler.Add(TopoDS::Face(*to_shape(support_faces[i])), cont);
            }
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling constrained failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fill_n_sided_face(occt_shape* edges, int count, int continuity) {
    clear_error();
    if (!edges || count < 3) { set_error("need at least 3 edges", 2); return nullptr; }
    try {
        BRepFill_Filling filler;
        GeomAbs_Shape cont = GeomAbs_C0;
        if (continuity == 1) cont = GeomAbs_C1;
        else if (continuity == 2) cont = GeomAbs_C2;
        else if (continuity == 3) cont = GeomAbs_C3;
        for (int i = 0; i < count; i++) {
            if (!edges[i]) { set_error("null edge in fill", 2); return nullptr; }
            filler.Add(TopoDS::Edge(*to_shape(edges[i])), cont);
        }
        filler.Build();
        if (!filler.IsDone()) { set_error("BRepFill_Filling N-sided failed"); return nullptr; }
        return from_shape(filler.Face());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Shell / Thicken ---

occt_shape shell_shape(occt_shape shape, occt_shape* faces, int num_faces, double thickness) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        NCollection_List<TopoDS_Shape> facesToRemove;
        for (int i = 0; i < num_faces; i++) {
            if (faces[i]) {
                facesToRemove.Append(*to_shape(faces[i]));
            }
        }
        BRepOffsetAPI_MakeThickSolid maker;
        maker.MakeThickSolidByJoin(*to_shape(shape), facesToRemove, thickness,
                                   Precision::Confusion(), BRepOffset_Skin);
        if (!maker.IsDone()) { set_error("MakeThickSolid failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Offset ---

occt_shape offset_shape_3d(occt_shape shape, double offset, int join) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        GeomAbs_JoinType joinType = GeomAbs_Arc;
        if (join == 1) joinType = GeomAbs_Tangent;
        else if (join == 2) joinType = GeomAbs_Intersection;
        BRepOffsetAPI_MakeOffsetShape maker;
        maker.PerformByJoin(*to_shape(shape), offset, Precision::Confusion(),
                            BRepOffset_Skin, false, false, joinType);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakeOffsetShape failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape offset_wire_2d(occt_shape wire, double offset) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_MakeOffset maker(TopoDS::Wire(*to_shape(wire)), GeomAbs_Arc);
        maker.Perform(offset);
        maker.Build();
        if (!maker.IsDone()) { set_error("MakeOffset failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Draft ---

occt_shape draft_face(occt_shape shape, occt_shape face, double angle,
                      double dx, double dy, double dz,
                      double px, double py, double pz,
                      double nx, double ny, double nz) {
    clear_error();
    if (!shape || !face) { set_error("null argument", 2); return nullptr; }
    try {
        BRepOffsetAPI_DraftAngle maker(*to_shape(shape));
        maker.Add(TopoDS::Face(*to_shape(face)), gp_Dir(dx, dy, dz),
                  angle, gp_Pln(gp_Pnt(px, py, pz), gp_Dir(nx, ny, nz)));
        maker.Build();
        if (!maker.IsDone()) { set_error("DraftAngle failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_evolved(occt_shape profile, occt_shape spine, double offset, int join) {
    clear_error();
    if (!profile || !spine) { set_error("null argument", 2); return nullptr; }
    try {
        GeomAbs_JoinType joinType = GeomAbs_Arc;
        if (join == 1) joinType = GeomAbs_Tangent;
        else if (join == 2) joinType = GeomAbs_Intersection;
        BRepOffsetAPI_MakeEvolved maker(*to_shape(spine),
                                         TopoDS::Wire(*to_shape(profile)),
                                         joinType, true, false, false,
                                         0.0000001, false, false);
        if (!maker.IsDone()) { set_error("MakeEvolved failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
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

// --- Mass Properties (BRepGProp) ---

double shape_volume(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        return props.Mass();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double shape_area(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::SurfaceProperties(*to_shape(shape), props);
        return props.Mass();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_center_of_mass(occt_shape shape, double* out_x, double* out_y, double* out_z) {
    clear_error();
    if (!shape || !out_x || !out_y || !out_z) { set_error("null argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        gp_Pnt cm = props.CentreOfMass();
        *out_x = cm.X(); *out_y = cm.Y(); *out_z = cm.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_inertia(occt_shape shape, double* out_inertia, int inertia_size,
                  double* out_principal_moments, int pm_size,
                  double* out_principal_axes, int pa_size) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        GProp_GProps props;
        BRepGProp::VolumeProperties(*to_shape(shape), props);
        gp_Mat inertia = props.MatrixOfInertia();
        // Inertia matrix: Ixx, Iyy, Izz, Ixy, Ixz, Iyz (6 components)
        if (out_inertia && inertia_size >= 6) {
            out_inertia[0] = inertia(1,1); out_inertia[1] = inertia(2,2); out_inertia[2] = inertia(3,3);
            out_inertia[3] = inertia(1,2); out_inertia[4] = inertia(1,3); out_inertia[5] = inertia(2,3);
        }
        // Principal moments and axes via GProp_PrincipalProps
        if ((out_principal_moments && pm_size >= 3) || (out_principal_axes && pa_size >= 9)) {
            GProp_PrincipalProps pp = props.PrincipalProperties();
            if (out_principal_moments && pm_size >= 3) {
                double Ixx, Iyy, Izz;
                pp.Moments(Ixx, Iyy, Izz);
                out_principal_moments[0] = Ixx;
                out_principal_moments[1] = Iyy;
                out_principal_moments[2] = Izz;
            }
            if (out_principal_axes && pa_size >= 9) {
                gp_Vec v1 = pp.FirstAxisOfInertia();
                gp_Vec v2 = pp.SecondAxisOfInertia();
                gp_Vec v3 = pp.ThirdAxisOfInertia();
                out_principal_axes[0] = v1.X(); out_principal_axes[1] = v1.Y(); out_principal_axes[2] = v1.Z();
                out_principal_axes[3] = v2.X(); out_principal_axes[4] = v2.Y(); out_principal_axes[5] = v2.Z();
                out_principal_axes[6] = v3.X(); out_principal_axes[7] = v3.Y(); out_principal_axes[8] = v3.Z();
            }
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Shape Analysis Queries ---

double shape_distance(occt_shape shape1, occt_shape shape2) {
    clear_error();
    if (!shape1 || !shape2) { set_error("null shape argument", 2); return -1; }
    try {
        BRepExtrema_DistShapeShape extrema(*to_shape(shape1), *to_shape(shape2));
        if (!extrema.IsDone()) { set_error("distance computation failed"); return -1; }
        return extrema.Value();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}

int shape_distance_extrema(occt_shape shape1, occt_shape shape2,
                           double* out_dist,
                           double* out_p1x, double* out_p1y, double* out_p1z,
                           double* out_p2x, double* out_p2y, double* out_p2z) {
    clear_error();
    if (!shape1 || !shape2 || !out_dist || !out_p1x || !out_p1y || !out_p1z || !out_p2x || !out_p2y || !out_p2z) {
        set_error("null argument", 2); return 0;
    }
    try {
        BRepExtrema_DistShapeShape extrema(*to_shape(shape1), *to_shape(shape2));
        if (!extrema.IsDone()) { set_error("distance computation failed"); return 0; }
        *out_dist = extrema.Value();
        if (extrema.NbSolution() >= 1) {
            gp_Pnt p1 = extrema.PointOnShape1(1);
            gp_Pnt p2 = extrema.PointOnShape2(1);
            *out_p1x = p1.X(); *out_p1y = p1.Y(); *out_p1z = p1.Z();
            *out_p2x = p2.X(); *out_p2y = p2.Y(); *out_p2z = p2.Z();
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int classify_point_in_solid(occt_shape shape, double px, double py, double pz,
                            int* out_state, occt_shape* out_face) {
    clear_error();
    if (!shape || !out_state) { set_error("null argument", 2); return 0; }
    try {
        BRepClass3d_SolidClassifier classifier(*to_shape(shape), gp_Pnt(px, py, pz), Precision::Confusion());
        TopAbs_State state = classifier.State();
        // State mapping: 0=IN, 1=OUT, 2=ON, 3=UNKNOWN
        switch (state) {
            case TopAbs_IN:      *out_state = 0; break;
            case TopAbs_OUT:     *out_state = 1; break;
            case TopAbs_ON:      *out_state = 2; break;
            default:             *out_state = 3; break;
        }
        if (out_face && state == TopAbs_ON) {
            TopoDS_Face face = classifier.Face();
            if (!face.IsNull()) {
                *out_face = new TopoDS_Shape(face);
            } else {
                *out_face = nullptr;
            }
        } else if (out_face) {
            *out_face = nullptr;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_is_valid(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepCheck_Analyzer analyzer(*to_shape(shape));
        return analyzer.IsValid() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

const char* shape_analysis_report(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        static std::string result;
        result.clear();
        BRepCheck_Analyzer analyzer(*to_shape(shape));
        if (analyzer.IsValid()) {
            result = "Shape is valid.";
        } else {
            result = "Shape has issues.";
        }
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int intersect_curve_shape(occt_curve curve, occt_shape shape,
                          double* out_points, double* out_params,
                          occt_shape* out_faces, int max_results) {
    clear_error();
    if (!curve || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(Geom_Curve) gc = *curve_handle(curve);
        BRepIntCurveSurface_Inter intersector;
        intersector.Init(*to_shape(shape), gc, Precision::Confusion());
        int count = 0;
        while (intersector.More() && (max_results <= 0 || count < max_results)) {
            if (out_points && count < max_results) {
                gp_Pnt p = intersector.Pnt();
                out_points[count * 3]     = p.X();
                out_points[count * 3 + 1] = p.Y();
                out_points[count * 3 + 2] = p.Z();
            }
            if (out_params && count < max_results) {
                out_params[count * 2]     = intersector.U();
                out_params[count * 2 + 1] = intersector.V();
            }
            if (out_faces && count < max_results) {
                TopoDS_Face face = intersector.Face();
                if (!face.IsNull()) {
                    out_faces[count] = new TopoDS_Shape(face);
                } else {
                    out_faces[count] = nullptr;
                }
            }
            count++;
            intersector.Next();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

// --- Topology Navigation ---

static TopAbs_ShapeEnum topabs_from_int(int type) {
    switch (type) {
        case 0: return TopAbs_COMPOUND;
        case 1: return TopAbs_COMPSOLID;
        case 2: return TopAbs_SOLID;
        case 3: return TopAbs_SHELL;
        case 4: return TopAbs_FACE;
        case 5: return TopAbs_WIRE;
        case 6: return TopAbs_EDGE;
        case 7: return TopAbs_VERTEX;
        case 8: return TopAbs_SHAPE;
        default: return TopAbs_SHAPE;
    }
}

int map_subshapes(occt_shape shape, int shape_type, int stop_at_type,
                  occt_shape* out_shapes, int max_shapes) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopAbs_ShapeEnum type = topabs_from_int(shape_type);
        TopAbs_ShapeEnum stop = topabs_from_int(stop_at_type);
        TopExp_Explorer exp(*to_shape(shape), type, stop);
        int count = 0;
        while (exp.More() && (max_shapes <= 0 || count < max_shapes)) {
            if (out_shapes && count < max_shapes) {
                out_shapes[count] = new TopoDS_Shape(exp.Current());
            }
            count++;
            exp.Next();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int count_subshapes(occt_shape shape, int shape_type, int stop_at_type) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        TopAbs_ShapeEnum type = topabs_from_int(shape_type);
        TopAbs_ShapeEnum stop = topabs_from_int(stop_at_type);
        TopExp_Explorer exp(*to_shape(shape), type, stop);
        int count = 0;
        while (exp.More()) { count++; exp.Next(); }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

const char* dump_shape(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        static std::string result;
        result.clear();
        std::ostringstream oss;
        BRepTools::Dump(*to_shape(shape), oss);
        result = oss.str();
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int shape_triangle_count(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepMesh_IncrementalMesh mesh(*to_shape(shape), 0.1);
        TopExp_Explorer exp(*to_shape(shape), TopAbs_FACE);
        int total = 0;
        while (exp.More()) {
            TopoDS_Face face = TopoDS::Face(exp.Current());
            TopLoc_Location loc;
            Handle(Poly_Triangulation) tri = BRep_Tool::Triangulation(face, loc);
            if (!tri.IsNull()) {
                total += tri->NbTriangles();
            }
            exp.Next();
        }
        return total;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int wire_order_check(occt_shape wire, occt_shape face) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return 0; }
    try {
        TopoDS_Wire w = TopoDS::Wire(*to_shape(wire));
        if (face) {
            TopoDS_Face f = TopoDS::Face(*to_shape(face));
            // Check wire validity relative to face using BRepCheck
            BRepCheck_Analyzer analyzer(w);
            BRepCheck_Analyzer faceAnalyzer(f);
            return (analyzer.IsValid() && faceAnalyzer.IsValid()) ? 1 : 0;
        }
        // Without face, just check basic wire structure
        BRepCheck_Analyzer analyzer(w);
        return analyzer.IsValid() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_curve edge_to_curve(occt_shape edge) {
    clear_error();
    if (!edge) { set_error("null edge argument", 2); return nullptr; }
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        BRepAdaptor_Curve adaptor(e);
        Handle(Geom_Curve) curve = adaptor.Curve().Curve();
        if (curve.IsNull()) { set_error("edge has no curve"); return nullptr; }
        // Classify the curve type
        GeomCurveKind kind;
        if (curve->DynamicType() == STANDARD_TYPE(Geom_Line))
            kind = CURVE_LINE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Circle))
            kind = CURVE_CIRCLE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Ellipse))
            kind = CURVE_ELLIPSE;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Parabola))
            kind = CURVE_PARABOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_Hyperbola))
            kind = CURVE_HYPERBOLA;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BezierCurve))
            kind = CURVE_BEZIER;
        else if (curve->DynamicType() == STANDARD_TYPE(Geom_BSplineCurve))
            kind = CURVE_BSPLINE;
        else
            kind = CURVE_BSPLINE;
        Handle(Geom_Curve)* h = new Handle(Geom_Curve)(curve);
        return alloc_curve(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_surface face_to_surface(occt_shape face) {
    clear_error();
    if (!face) { set_error("null face argument", 2); return nullptr; }
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface adaptor(f);
        Handle(Geom_Surface) surface = adaptor.Surface().Surface();
        if (surface.IsNull()) { set_error("face has no surface"); return nullptr; }
        GeomSurfaceKind kind;
        if (surface->DynamicType() == STANDARD_TYPE(Geom_Plane))
            kind = SURFACE_PLANE;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_CylindricalSurface))
            kind = SURFACE_CYLINDRICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ConicalSurface))
            kind = SURFACE_CONICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_SphericalSurface))
            kind = SURFACE_SPHERICAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_ToroidalSurface))
            kind = SURFACE_TOROIDAL;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BezierSurface))
            kind = SURFACE_BEZIER;
        else if (surface->DynamicType() == STANDARD_TYPE(Geom_BSplineSurface))
            kind = SURFACE_BSPLINE;
        else
            kind = SURFACE_BSPLINE;
        Handle(Geom_Surface)* h = new Handle(Geom_Surface)(surface);
        return alloc_surface(kind, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_vertex(double x, double y, double z) {
    clear_error();
    try {
        BRepBuilderAPI_MakeVertex maker(gp_Pnt(x, y, z));
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_polygon(double* points, int num_points, int closed) {
    clear_error();
    if (!points || num_points < 2) { set_error("need at least 2 points", 2); return nullptr; }
    try {
        BRepBuilderAPI_MakePolygon maker;
        for (int i = 0; i < num_points; i++) {
            maker.Add(gp_Pnt(points[i * 3], points[i * 3 + 1], points[i * 3 + 2]));
        }
        if (closed) maker.Close();
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// ---------------------------------------------------------------------------
//  Fillet / Chamfer / Blend
// ---------------------------------------------------------------------------

occt_shape fillet_edge_constant(occt_shape shape, occt_shape edge, double radius) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        maker.Add(radius, TopoDS::Edge(*to_shape(edge)));
        maker.Build();
        if (!maker.IsDone()) { set_error("fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_edges_constant(occt_shape shape, occt_shape* edges, int num_edges, double radius) {
    clear_error();
    if (!shape || !edges || num_edges < 1) { set_error("invalid arguments", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        for (int i = 0; i < num_edges; i++) {
            if (!edges[i]) { set_error("null edge in array", 2); return nullptr; }
            maker.Add(radius, TopoDS::Edge(*to_shape(edges[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_edge_variable(occt_shape shape, occt_shape edge, double* params_and_radii, int num_pairs) {
    clear_error();
    if (!shape || !edge || !params_and_radii || num_pairs < 1) {
        set_error("invalid arguments", 2); return nullptr;
    }
    try {
        BRepFilletAPI_MakeFillet maker(*to_shape(shape));
        const TopoDS_Edge& edgeRef = TopoDS::Edge(*to_shape(edge));
        // Build array of (parameter, radius) pairs for OCCT
        NCollection_Array1<gp_Pnt2d> uAndR(0, num_pairs - 1);
        for (int i = 0; i < num_pairs; i++) {
            uAndR[i].SetX(params_and_radii[i * 2]);
            uAndR[i].SetY(params_and_radii[i * 2 + 1]);
        }
        maker.Add(uAndR, edgeRef);
        maker.Build();
        if (!maker.IsDone()) { set_error("variable fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_wire_corner(occt_shape wire, double radius) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        // Build a planar face from the wire, then fillet its vertices
        BRepBuilderAPI_MakeFace faceMaker(TopoDS::Wire(*to_shape(wire)));
        if (!faceMaker.IsDone()) { set_error("cannot make face from wire", 2); return nullptr; }
        TopoDS_Face face = faceMaker.Face();

        BRepFilletAPI_MakeFillet2d maker(face);
        // Find first vertex and fillet it
        TopExp_Explorer exp(face, TopAbs_VERTEX);
        if (!exp.More()) { set_error("no vertices in wire", 2); return nullptr; }
        maker.AddFillet(TopoDS::Vertex(exp.Current()), radius);
        if (!maker.IsDone()) { set_error("2D fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape fillet_wire_all_corners(occt_shape wire, double radius) {
    clear_error();
    if (!wire) { set_error("null wire argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        BRepBuilderAPI_MakeFace faceMaker(TopoDS::Wire(*to_shape(wire)));
        if (!faceMaker.IsDone()) { set_error("cannot make face from wire", 2); return nullptr; }
        TopoDS_Face face = faceMaker.Face();

        BRepFilletAPI_MakeFillet2d maker(face);
        // Fillet every vertex
        TopExp_Explorer exp(face, TopAbs_VERTEX);
        int vertexCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.AddFillet(TopoDS::Vertex(exp.Current()), radius);
            vertexCount++;
        }
        if (vertexCount == 0) { set_error("no vertices in wire", 2); return nullptr; }
        if (!maker.IsDone()) { set_error("2D fillet not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_equal(occt_shape shape, occt_shape edge, double distance) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        maker.Add(distance, TopoDS::Edge(*to_shape(edge)));
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edges_equal(occt_shape shape, occt_shape* edges, int num_edges, double distance) {
    clear_error();
    if (!shape || !edges || num_edges < 1) { set_error("invalid arguments", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        for (int i = 0; i < num_edges; i++) {
            if (!edges[i]) { set_error("null edge in array", 2); return nullptr; }
            maker.Add(distance, TopoDS::Edge(*to_shape(edges[i])));
        }
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_asym(occt_shape shape, occt_shape edge, double distance1, double distance2) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance1 <= 0 || distance2 <= 0) { set_error("distances must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        // For asymmetric chamfer, use Add with two distances and a null face
        TopoDS_Face nullFace;
        maker.Add(distance1, distance2, TopoDS::Edge(*to_shape(edge)), nullFace);
        maker.Build();
        if (!maker.IsDone()) { set_error("asymmetric chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape chamfer_edge_on_face(occt_shape shape, occt_shape edge, double distance, occt_shape face) {
    clear_error();
    if (!shape || !edge) { set_error("null shape argument", 2); return nullptr; }
    if (distance <= 0) { set_error("distance must be positive", 2); return nullptr; }
    try {
        BRepFilletAPI_MakeChamfer maker(*to_shape(shape));
        TopoDS_Face faceRef;
        if (face) {
            faceRef = TopoDS::Face(*to_shape(face));
        }
        // Use asymmetric Add with second distance = first (equal), specifying the face
        maker.Add(distance, distance, TopoDS::Edge(*to_shape(edge)), faceRef);
        maker.Build();
        if (!maker.IsDone()) { set_error("chamfer not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape blend_faces_constant(occt_shape face1, occt_shape face2, double radius) {
    clear_error();
    if (!face1 || !face2) { set_error("null face argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        // Build a shell from the two faces and fillet the shared edge
        TopoDS_Shell shell;
        BRep_Builder builder;
        builder.MakeShell(shell);
        builder.Add(shell, TopoDS::Face(*to_shape(face1)));
        builder.Add(shell, TopoDS::Face(*to_shape(face2)));

        BRepFilletAPI_MakeFillet maker(shell);
        TopExp_Explorer exp(shell, TopAbs_EDGE);
        int edgeCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.Add(radius, TopoDS::Edge(exp.Current()));
            edgeCount++;
        }
        if (edgeCount == 0) { set_error("no edges between faces", 2); return nullptr; }

        maker.Build();
        if (!maker.IsDone()) { set_error("blend not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape blend_make_constant(occt_shape face1, occt_shape face2, double radius) {
    clear_error();
    if (!face1 || !face2) { set_error("null face argument", 2); return nullptr; }
    if (radius <= 0) { set_error("radius must be positive", 2); return nullptr; }
    try {
        TopoDS_Shell shell;
        BRep_Builder builder;
        builder.MakeShell(shell);
        builder.Add(shell, TopoDS::Face(*to_shape(face1)));
        builder.Add(shell, TopoDS::Face(*to_shape(face2)));

        BRepFilletAPI_MakeFillet maker(shell);
        TopExp_Explorer exp(shell, TopAbs_EDGE);
        int edgeCount = 0;
        for (; exp.More(); exp.Next()) {
            maker.Add(radius, TopoDS::Edge(exp.Current()));
            edgeCount++;
        }
        if (edgeCount == 0) { set_error("no edges between faces", 2); return nullptr; }

        maker.Build();
        if (!maker.IsDone()) { set_error("blend not done"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}
// --- Mechanical Features (BRepFeat) ---

// Compute hole axis from face: use face center and normal.
static gp_Ax1 face_to_axis(const TopoDS_Face& face) {
    BRepAdaptor_Surface adaptor(face);
    double u1, u2, v1, v2;
    adaptor.Surface().Bounds(u1, u2, v1, v2);
    double u = (u1 + u2) / 2.0;
    double v = (v1 + v2) / 2.0;
    gp_Pnt pt = adaptor.Value(u, v);
    gp_Dir normal = adaptor.Plane().Axis().Direction();
    if (face.Orientation() == TopAbs_REVERSED) {
        normal.Reverse();
    }
    return gp_Ax1(pt, normal);
}

occt_shape make_cylindrical_hole(occt_shape shape, occt_shape face,
                                 double radius, double depth, int through) {
    clear_error();
    if (!shape || !face) { set_error("null shape or face", 2); return nullptr; }
    if (radius < Precision::Confusion()) { set_error("non-positive radius", 2); return nullptr; }
    try {
        TopoDS_Face faceShape = TopoDS::Face(*to_shape(face));
        gp_Ax1 axis = face_to_axis(faceShape);
        BRepFeat_MakeCylindricalHole feat;
        feat.Init(*to_shape(shape), axis);
        if (through) {
            feat.PerformThruNext(radius, true);
        } else {
            feat.PerformBlind(radius, depth, true);
        }
        feat.Build();
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakeCylindricalHole produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_prism_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double height, double dx, double dy, double dz, int operation) {
    clear_error();
    if (!shape || !base_face || !profile) { set_error("null argument", 2); return nullptr; }
    double dir_mag = sqrt(dx*dx + dy*dy + dz*dz);
    try {
        gp_Dir dir(0, 0, 1);
        if (dir_mag >= Precision::Confusion()) {
            dir = gp_Dir(dx, dy, dz);
        }
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakePrism feat(*to_shape(shape), profShape,
                                 TopoDS::Face(*to_shape(base_face)),
                                 dir, fuse, false);
        feat.Perform(height);
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakePrism produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_revol_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double ax, double ay, double az, double angle, int operation) {
    clear_error();
    if (!shape || !base_face || !profile) { set_error("null argument", 2); return nullptr; }
    double axis_mag = sqrt(ax*ax + ay*ay + az*az);
    if (axis_mag < Precision::Confusion()) { set_error("zero axis direction", 2); return nullptr; }
    double ang = angle * M_PI / 180.0;
    if (fabs(ang) < Precision::Confusion()) { set_error("zero revolution angle", 2); return nullptr; }
    try {
        gp_Ax1 axis(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az));
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakeRevol feat(*to_shape(shape), profShape,
                                 TopoDS::Face(*to_shape(base_face)),
                                 axis, fuse, false);
        feat.Perform(ang);
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakeRevol produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_pipe_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                             occt_shape path, int operation) {
    clear_error();
    if (!shape || !base_face || !profile || !path) { set_error("null argument", 2); return nullptr; }
    try {
        TopoDS_Shape profShape = *to_shape(profile);
        int fuse = (operation != 0) ? 1 : 0;
        BRepFeat_MakePipe feat(*to_shape(shape), profShape,
                                TopoDS::Face(*to_shape(base_face)),
                                TopoDS::Wire(*to_shape(path)),
                                fuse, false);
        feat.Perform();
        TopoDS_Shape result = feat.Shape();
        if (result.IsNull()) { set_error("MakePipe produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

// --- Local Operations (LocOpe) ---

occt_shape local_extrude(occt_shape face, double height, double dx, double dy, double dz) {
    clear_error();
    if (!face) { set_error("null face", 2); return nullptr; }
    if (height < Precision::Confusion()) { set_error("non-positive height", 2); return nullptr; }
    try {
        LocOpe_DPrism prism(TopoDS::Face(*to_shape(face)), height, 0.0);
        if (!prism.IsDone()) { set_error("LocOpe_DPrism not done"); return nullptr; }
        TopoDS_Shape result = prism.Shape();
        if (result.IsNull()) { set_error("LocOpe_DPrism produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_groove(occt_shape shape, occt_shape face,
                        double ax, double ay, double az, double angle) {
    clear_error();
    if (!shape || !face) { set_error("null argument", 2); return nullptr; }
    double axis_mag = sqrt(ax*ax + ay*ay + az*az);
    if (axis_mag < Precision::Confusion()) { set_error("zero axis direction", 2); return nullptr; }
    if (angle < Precision::Confusion()) { set_error("non-positive angle", 2); return nullptr; }
    try {
        gp_Ax1 axis(gp_Pnt(0, 0, 0), gp_Dir(ax, ay, az));
        double ang = angle * M_PI / 180.0;
        LocOpe_Revol rev;
        rev.Perform(*to_shape(face), axis, ang);
        TopoDS_Shape revShape = rev.Shape();
        if (revShape.IsNull()) { set_error("LocOpe_Revol produced null shape"); return nullptr; }
        BRepAlgoAPI_Cut cut(*to_shape(shape), revShape);
        if (!cut.IsDone()) { set_error("Groove boolean cut not done"); return nullptr; }
        TopoDS_Shape cutResult = cut.Shape();
        if (cutResult.IsNull() || is_empty_shape(cutResult)) { set_error("Groove produced empty result"); return nullptr; }
        return from_shape(cutResult);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_rib(occt_shape shape, occt_shape profile_face, double thickness,
                    double dx, double dy, double dz) {
    clear_error();
    if (!shape || !profile_face) { set_error("null argument", 2); return nullptr; }
    if (thickness < Precision::Confusion()) { set_error("non-positive thickness", 2); return nullptr; }
    try {
        gp_Vec dir(dx, dy, dz);
        dir.Multiply(thickness);
        TopoDS_Shape profShape = *to_shape(profile_face);
        BRepPrimAPI_MakePrism prism(TopoDS::Face(profShape), dir);
        if (!prism.IsDone()) { set_error("rib prism not done"); return nullptr; }
        TopoDS_Shape ribShape = prism.Shape();
        if (ribShape.IsNull()) { set_error("rib prism produced null"); return nullptr; }
        BRepAlgoAPI_Fuse fuse(*to_shape(shape), ribShape);
        if (!fuse.IsDone()) { set_error("rib fuse not done"); return nullptr; }
        TopoDS_Shape result = fuse.Shape();
        if (result.IsNull() || is_empty_shape(result)) { set_error("rib produced empty result"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

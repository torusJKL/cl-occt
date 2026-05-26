#ifndef OCCT_WRAP_INTERNAL_H
#define OCCT_WRAP_INTERNAL_H

#include "occt_wrap_types.h"
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
#include <BRepAlgoAPI_Defeaturing.hxx>
#include <BRepAlgoAPI_Check.hxx>
#include <BRepAlgoAPI_BuilderAlgo.hxx>
#include <BRepBuilderAPI_Transform.hxx>
#include <BRepBuilderAPI_MakeEdge.hxx>
#include <BRepBuilderAPI_MakeWire.hxx>
#include <BRepBuilderAPI_MakeFace.hxx>
#include <BRepBuilderAPI_Sewing.hxx>
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
#include <AIS_ColoredShape.hxx>
#include <AIS_Manipulator.hxx>
#include <AIS_ConnectedInteractive.hxx>
#include <AIS_PointCloud.hxx>
#include <AIS_Plane.hxx>
#include <AIS_Axis.hxx>
#include <AIS_Line.hxx>
#include <AIS_Circle.hxx>
#include <AIS_TexturedShape.hxx>
#include <AIS_ViewCube.hxx>
#include <AIS_Triangulation.hxx>
#include <AIS_ColorScale.hxx>
#include <AIS_LightSource.hxx>
#include <AIS_MultipleConnectedInteractive.hxx>
#include <Image_AlienPixMap.hxx>
#include <Graphic3d_Texture2D.hxx>
#include <Graphic3d_Texture2Dplane.hxx>
#include <Graphic3d_TextureParams.hxx>
#include <Graphic3d_PBRMaterial.hxx>
#include <Graphic3d_BSDF.hxx>
#include <AIS_ManipulatorMode.hxx>
#include <Graphic3d_ArrayOfTriangles.hxx>
#include <Graphic3d_ArrayOfPoints.hxx>
#include <Poly_Triangulation.hxx>
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
#include <NCollection_Array1.hxx>
#include <NCollection_Array2.hxx>
#include <BRepBuilderAPI_MakeEdge.hxx>
#include <BRepBuilderAPI_MakeWire.hxx>
#include <GeomAdaptor_Curve.hxx>
#include <GeomAdaptor_Surface.hxx>
#include <HelixGeom_BuilderHelix.hxx>
#include <HelixBRep_BuilderHelix.hxx>
#include <Graphic3d_TransformPers.hxx>
#include <Graphic3d_ClipPlane.hxx>
#include <Graphic3d_ShaderProgram.hxx>
#include <Graphic3d_Text.hxx>
#include <Graphic3d_AspectFillArea3d.hxx>
#include <Graphic3d_AspectLine3d.hxx>
#include <Graphic3d_AspectMarker3d.hxx>
#include <Graphic3d_AspectText3d.hxx>
#include <Graphic3d_Structure.hxx>
#include <Graphic3d_Group.hxx>
#include <Graphic3d_ArrayOfSegments.hxx>
#include <Graphic3d_RenderingParams.hxx>
#include <Aspect_InteriorStyle.hxx>
#include <Aspect_TypeOfLine.hxx>
#include <Aspect_TypeOfMarker.hxx>
#include <Aspect_TypeOfStyleText.hxx>
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
#include <HLRBRep_Algo.hxx>
#include <HLRBRep_HLRToShape.hxx>
#include <BRepFeat_MakeCylindricalHole.hxx>
#include <BRepFeat_MakePrism.hxx>
#include <BRepFeat_MakeRevol.hxx>
#include <BRepFeat_MakePipe.hxx>
#include <LocOpe_DPrism.hxx>
#include <LocOpe_Revol.hxx>
#include <NCollection_List.hxx>
#include <BRepFill_Filling.hxx>
#include <ShapeFix_Shape.hxx>
#include <ShapeFix_Wire.hxx>
#include <ShapeFix_Solid.hxx>
#include <ShapeFix_Edge.hxx>
#include <ShapeFix_Face.hxx>
#include <ShapeAnalysis_FreeBounds.hxx>
#include <ShapeAnalysis_Wire.hxx>
#include <ShapeAnalysis_ShapeContents.hxx>
#include <ShapeBuild_ReShape.hxx>
#include <ShapeCustom.hxx>
#include <ShapeCustom_BSplineRestriction.hxx>
#include <ShapeCustom_ConvertToRevolution.hxx>
#include <ShapeCustom_SweptToElementary.hxx>
#include <ShapeUpgrade_ShapeDivideContinuity.hxx>
#include <ShapeProcess.hxx>
#include <ShapeProcess_ShapeContext.hxx>
#include <ShapeProcessAPI_ApplySequence.hxx>
#include <BRepClass_FaceClassifier.hxx>
#include <StdSelect_EdgeFilter.hxx>
#include <StdSelect_FaceFilter.hxx>
#include <StdSelect_ShapeTypeFilter.hxx>
#include <StdSelect_BRepOwner.hxx>
#include <SelectMgr_EntityOwner.hxx>
#include <SelectMgr_Filter.hxx>
#include <Poly_Triangulation.hxx>
#include <TopoDS_Face.hxx>
#include <Geom_Curve.hxx>
#include <Geom_Surface.hxx>
#include <Poly_Connect.hxx>
#include <Poly_Triangle.hxx>
#include <MeshVS_Mesh.hxx>
#include <MeshVS_DataSource.hxx>
#include <XCAFDoc_LayerTool.hxx>
#include <XCAFDoc_MaterialTool.hxx>
#include <XCAFDoc_DimTolTool.hxx>
#include <XCAFDoc_ViewTool.hxx>
#include <XCAFDoc_NotesTool.hxx>
#include <XCAFDoc_VisMaterialTool.hxx>
#include <XCAFDoc_ClippingPlaneTool.hxx>
#include <XCAFDoc_Editor.hxx>
#include <XCAFApp_Application.hxx>
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
#include <AIS_Animation.hxx>
#include <AIS_AnimationObject.hxx>
#include <AIS_AnimationCamera.hxx>
#include <AIS_AnimationAxisRotation.hxx>
#include <V3d_AmbientLight.hxx>
#include <V3d_DirectionalLight.hxx>
#include <V3d_PositionalLight.hxx>
#include <V3d_SpotLight.hxx>
#include <V3d_Light.hxx>
#include <Prs3d_PointAspect.hxx>
#include <Font_TextFormatter.hxx>
#include <PrsDim_LengthDimension.hxx>
#include <PrsDim_AngleDimension.hxx>
#include <PrsDim_DiameterDimension.hxx>
#include <PrsDim_RadiusDimension.hxx>
#include <Aspect_GridParams.hxx>
#include <Prs3d_DimensionAspect.hxx>
#include <Prs3d_ArrowAspect.hxx>
#include <Prs3d_ToolCylinder.hxx>
#include <Prs3d_ToolSphere.hxx>
#include <Prs3d_ToolTorus.hxx>
#include <Prs3d_ToolDisk.hxx>
#include <Prs3d_Arrow.hxx>
#include <Prs3d_BndBox.hxx>
#include <math_BFGS.hxx>
#include <math_FRPR.hxx>
#include <math_PSO.hxx>
#include <math_GlobOptMin.hxx>
#include <math_MultipleVarFunction.hxx>
#include <math_Vector.hxx>
#include <IntTools_EdgeEdge.hxx>
#include <IntTools_EdgeFace.hxx>
#include <IntTools_FaceFace.hxx>
#include <IntTools_CommonPrt.hxx>
#include <IntTools_Range.hxx>
#include <IntTools_Curve.hxx>
#include <IntTools_PntOn2Faces.hxx>
#include <IntTools_PntOnFace.hxx>
#include <IntTools_Root.hxx>
#include <IGESControl_Writer.hxx>
#include <IGESControl_Reader.hxx>
#include <IGESCAFControl_Writer.hxx>
#include <IGESCAFControl_Reader.hxx>
#include <RWObj_CafWriter.hxx>
#include <RWObj_CafReader.hxx>
#include <RWMesh_CoordinateSystem.hxx>
#include <RWMesh_NameFormat.hxx>
#include <VrmlAPI_Writer.hxx>
#include <RWGltf_CafWriter.hxx>
#include <RWGltf_CafReader.hxx>
#include <RWPly_CafWriter.hxx>
#include <iostream>
#include <cstring>
#include <cmath>
#include <string>
#include <sstream>
#include <cstdio>
#include <unistd.h>

typedef NCollection_Sequence<TDF_Label> LabelSeq;
typedef opencascade::handle<StdPrs_BRepFont> BRepFontHandle;

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

static inline Geom2dObj* alloc_geom2d(Geom2dKind kind, void* obj) {
    Geom2dObj* g = new Geom2dObj;
    g->kind = kind;
    g->obj = obj;
    return g;
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

static inline OccctCurve* alloc_curve(GeomCurveKind kind, void* handle) {
    OccctCurve* c = new OccctCurve;
    c->kind = kind;
    c->handle = handle;
    return c;
}

static inline Handle(Geom_Curve)* curve_handle(occt_curve c) {
    return static_cast<Handle(Geom_Curve)*>(static_cast<OccctCurve*>(c)->handle);
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

static inline OccctSurface* alloc_surface(GeomSurfaceKind kind, void* handle) {
    OccctSurface* s = new OccctSurface;
    s->kind = kind;
    s->handle = handle;
    return s;
}

static inline Handle(Geom_Surface)* surface_handle(occt_surface s) {
    return static_cast<Handle(Geom_Surface)*>(static_cast<OccctSurface*>(s)->handle);
}

// --- Global error state ---
static thread_local int g_error_code = 0;
static thread_local char g_error_message[512];

static inline void set_error(const char* msg, int code = 1) {
    g_error_code = code;
    strncpy(g_error_message, msg, sizeof(g_error_message) - 1);
    g_error_message[sizeof(g_error_message) - 1] = '\0';
}

static inline void clear_error() {
    g_error_code = 0;
    g_error_message[0] = '\0';
}

// --- Shape conversion helpers ---
static inline TopoDS_Shape* to_shape(occt_shape s) {
    return static_cast<TopoDS_Shape*>(s);
}

static inline occt_shape from_shape(const TopoDS_Shape& s) {
    return new TopoDS_Shape(s);
}

static inline bool is_empty_shape(const TopoDS_Shape& s) {
    if (s.IsNull()) return true;
    TopExp_Explorer exp(s, TopAbs_FACE);
    return !exp.More();
}

static inline bool is_empty_edge_shape(const TopoDS_Shape& shape) {
    TopExp_Explorer exp(shape, TopAbs_EDGE);
    return !exp.More();
}

// --- Point / Direction helpers ---
static inline gp_Pnt get_pnt(double x, double y, double z) { return gp_Pnt(x, y, z); }
static inline gp_Dir get_dir(double x, double y, double z) { return gp_Dir(x, y, z); }

// --- Geom2d helpers ---
static inline Handle(Geom2d_Curve) get_geom2d_curve(occt_geom2d g) {
    if (!g) return nullptr;
    return *static_cast<Handle(Geom2d_Curve)*>(static_cast<Geom2dObj*>(g)->obj);
}

// --- XDE helpers ---
static inline TDF_Label resolve_label(const Handle(TDocStd_Document)& doc, const char* path) {
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

// --- Topology helpers ---
static inline TopAbs_ShapeEnum topabs_from_int(int type) {
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

// --- Helper for compound-of-faces ---
static inline TopoDS_Shape make_shape_compound_of_faces(const TopoDS_Shape& shape) {
    TopoDS_Compound comp;
    BRep_Builder builder;
    builder.MakeCompound(comp);
    TopExp_Explorer exp(shape, TopAbs_FACE);
    for (; exp.More(); exp.Next()) {
        builder.Add(comp, exp.Current());
    }
    return comp;
}

// --- XCAF helpers ---
static inline TDF_Label xcaf_find_shape_label(const Handle(TDocStd_Document)& doc, const TopoDS_Shape& shape) {
    Handle(XCAFDoc_ShapeTool) ST = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
    TDF_Label L;
    ST->Search(shape, L);
    return L;
}

// --- Math helpers ---
static inline gp_Trsf no_trsf() { return gp_Trsf(); }

// --- IntTools helpers ---
static inline void eval_edge_point(const TopoDS_Edge& e, double param, double* out, int idx) {
    double f, l;
    Handle(Geom_Curve) c = BRep_Tool::Curve(e, f, l);
    if (!c.IsNull()) {
        gp_Pnt pt;
        c->D0(param, pt);
        out[idx * 3] = pt.X();
        out[idx * 3 + 1] = pt.Y();
        out[idx * 3 + 2] = pt.Z();
    }
}

// --- MeshVS_DataSourceWrapper ---
class MeshVS_DataSourceWrapper : public MeshVS_DataSource {
public:
    MeshVS_DataSourceWrapper(double* verts, int vcount, int* tris, int tcount, double* colors)
        : myVerts(verts), myVCount(vcount), myTris(tris), myTCount(tcount), myColors(colors) {}

    bool GetGeom(const int ID, const bool IsElement,
                 NCollection_Array1<double>& Coords,
                 int&, MeshVS_EntityType&) const override {
        if (IsElement) return false;
        if (ID < 1 || ID > myVCount) return false;
        int idx = (ID - 1) * 3;
        Coords.SetValue(1, myVerts[idx]);
        Coords.SetValue(2, myVerts[idx + 1]);
        Coords.SetValue(3, myVerts[idx + 2]);
        return true;
    }

    bool GetGeomType(const int ID, const bool IsElement,
                     MeshVS_EntityType& Type) const override {
        if (IsElement) {
            Type = MeshVS_ET_Face;
        } else {
            Type = MeshVS_ET_Node;
        }
        return true;
    }

    void* GetAddr(const int ID, const bool IsElement) const override {
        (void)ID; (void)IsElement;
        return nullptr;
    }

    bool GetNodesByElement(const int ID,
                           NCollection_Array1<int>& NodeIDs,
                           int& NbNodes) const override {
        if (ID < 1 || ID > myTCount) return false;
        int idx = (ID - 1) * 3;
        NodeIDs.SetValue(1, myTris[idx] + 1);
        NodeIDs.SetValue(2, myTris[idx + 1] + 1);
        NodeIDs.SetValue(3, myTris[idx + 2] + 1);
        NbNodes = 3;
        return true;
    }

    const TColStd_PackedMapOfInteger& GetAllNodes() const override {
        static TColStd_PackedMapOfInteger nodes;
        nodes.Clear();
        for (int i = 1; i <= myVCount; i++) nodes.Add(i);
        return nodes;
    }

    const TColStd_PackedMapOfInteger& GetAllElements() const override {
        static TColStd_PackedMapOfInteger elems;
        elems.Clear();
        for (int i = 1; i <= myTCount; i++) elems.Add(i);
        return elems;
    }

    int myVCount;
    int myTCount;

private:
    double* myVerts;
    int* myTris;
    double* myColors;
};

#endif /* OCCT_WRAP_INTERNAL_H */

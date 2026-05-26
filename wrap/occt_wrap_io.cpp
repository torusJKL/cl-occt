#include "occt_wrap_internal.h"
#include "occt_wrap_io.h"

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

int write_stl(occt_shape shape, const char* filename, double deflection, double angle, int relative) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        BRepMesh_IncrementalMesh mesh(*to_shape(shape), deflection, relative != 0, angle, true);
        mesh.Perform();
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

int write_iges(occt_shape shape, const char* filename) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        IGESControl_Writer writer("MM", 1 /*BRep mode*/);
        if (!writer.AddShape(*to_shape(shape))) {
            set_error("IGES transfer failed");
            return 0;
        }
        if (!writer.Write(filename)) {
            set_error("IGES write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape read_iges(const char* filename) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        IGESControl_Reader reader;
        IFSelect_ReturnStatus stat = reader.ReadFile(filename);
        if (stat != IFSelect_RetDone) {
            set_error("IGES read failed");
            return nullptr;
        }
        reader.TransferRoots();
        TopoDS_Shape shape = reader.OneShape();
        if (shape.IsNull()) {
            set_error("IGES file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

xde_doc xde_read_iges(const char* filename) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        IGESCAFControl_Reader reader;
        if (!reader.Perform(filename, doc)) {
            set_error("IGES assembly read failed");
            return nullptr;
        }
        return new Handle(TDocStd_Document)(doc);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int xde_write_iges(xde_doc doc, const char* filename) {
    clear_error();
    if (!doc) { set_error("null doc argument", 2); return 0; }
    try {
        IGESCAFControl_Writer writer;
        if (!writer.Perform(*(Handle(TDocStd_Document)*)doc, filename)) {
            set_error("IGES assembly write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int write_obj(occt_shape shape, const char* filename,
              int coordinate_system, int name_format, int per_vertex_colors) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        Handle(XCAFDoc_ShapeTool) shapeTool = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
        TDF_Label label = shapeTool->NewShape();
        shapeTool->SetShape(label, *to_shape(shape));
        BRepMesh_IncrementalMesh(*to_shape(shape), 0.1);
        LabelSeq rootLabels;
        shapeTool->GetFreeShapes(rootLabels);
        RWObj_CafWriter writer{TCollection_AsciiString(filename)};
        RWMesh_CoordinateSystemConverter csConv;
        csConv.SetOutputCoordinateSystem((RWMesh_CoordinateSystem)coordinate_system);
        writer.SetCoordinateSystemConverter(csConv);
        NCollection_IndexedDataMap<TCollection_AsciiString, TCollection_AsciiString> fileInfo;
        if (!writer.Perform(doc, rootLabels, nullptr, fileInfo, Message_ProgressRange())) {
            set_error("OBJ write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape read_obj(const char* filename, int coordinate_system) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        RWObj_CafReader reader;
        reader.SetDocument(doc);
        reader.SetSystemCoordinateSystem((RWMesh_CoordinateSystem)coordinate_system);
        if (!reader.Perform(TCollection_AsciiString(filename), Message_ProgressRange())) {
            set_error("OBJ read failed");
            return nullptr;
        }
        Handle(XCAFDoc_ShapeTool) shapeTool = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
        LabelSeq labels;
        shapeTool->GetFreeShapes(labels);
        if (labels.Length() == 0) {
            set_error("OBJ file contains no shapes");
            return nullptr;
        }
        TopoDS_Shape shape = shapeTool->GetShape(labels.First());
        if (shape.IsNull()) {
            set_error("OBJ file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int write_vrml(occt_shape shape, const char* filename, double deflection) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        VrmlAPI_Writer writer;
        writer.SetDeflection(deflection);
        if (!writer.Write(*to_shape(shape), filename, 2)) {
            set_error("VRML write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int write_gltf(occt_shape shape, const char* filename,
               int coordinate_system, int per_vertex_colors) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        Handle(XCAFDoc_ShapeTool) shapeTool = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
        TDF_Label label = shapeTool->NewShape();
        shapeTool->SetShape(label, *to_shape(shape));
        BRepMesh_IncrementalMesh(*to_shape(shape), 0.1);
        LabelSeq rootLabels;
        shapeTool->GetFreeShapes(rootLabels);
        RWGltf_CafWriter writer(TCollection_AsciiString(filename), false);
        RWMesh_CoordinateSystemConverter csConv;
        csConv.SetOutputCoordinateSystem((RWMesh_CoordinateSystem)coordinate_system);
        writer.SetCoordinateSystemConverter(csConv);
        NCollection_IndexedDataMap<TCollection_AsciiString, TCollection_AsciiString> fileInfo;
        if (!writer.Perform(doc, rootLabels, nullptr, fileInfo, Message_ProgressRange())) {
            set_error("glTF write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_shape read_gltf(const char* filename, int coordinate_system) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        RWGltf_CafReader reader;
        reader.SetDocument(doc);
        reader.SetSystemCoordinateSystem((RWMesh_CoordinateSystem)coordinate_system);
        if (!reader.Perform(TCollection_AsciiString(filename), Message_ProgressRange())) {
            set_error("glTF read failed");
            return nullptr;
        }
        Handle(XCAFDoc_ShapeTool) shapeTool = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
        LabelSeq labels;
        shapeTool->GetFreeShapes(labels);
        if (labels.Length() == 0) {
            set_error("glTF file contains no shapes");
            return nullptr;
        }
        TopoDS_Shape shape = shapeTool->GetShape(labels.First());
        if (shape.IsNull()) {
            set_error("glTF file contains no shape");
            return nullptr;
        }
        return from_shape(shape);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int write_ply(occt_shape shape, const char* filename,
              int coordinate_system, int per_vertex_colors) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return 0; }
    try {
        Handle(TDocStd_Document) doc = new TDocStd_Document("MDTV-XCAF");
        Handle(XCAFDoc_ShapeTool) shapeTool = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
        TDF_Label label = shapeTool->NewShape();
        shapeTool->SetShape(label, *to_shape(shape));
        BRepMesh_IncrementalMesh(*to_shape(shape), 0.1);
        LabelSeq rootLabels;
        shapeTool->GetFreeShapes(rootLabels);
        RWPly_CafWriter writer{TCollection_AsciiString(filename)};
        RWMesh_CoordinateSystemConverter csConv;
        csConv.SetOutputCoordinateSystem((RWMesh_CoordinateSystem)coordinate_system);
        writer.SetCoordinateSystemConverter(csConv);
        writer.SetColors(per_vertex_colors != 0);
        writer.SetNormals(true);
        NCollection_IndexedDataMap<TCollection_AsciiString, TCollection_AsciiString> fileInfo;
        if (!writer.Perform(doc, rootLabels, nullptr, fileInfo, Message_ProgressRange())) {
            set_error("PLY write failed");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int rwmesh_coordinate_system_zup(void) {
    return 0; // RWMesh_CoordinateSystem_Zup
}

int rwmesh_coordinate_system_yup(void) {
    return 1; // RWMesh_CoordinateSystem_Yup
}

int rwmesh_name_format_auto(void) {
    return 0; // RWMesh_NameFormat_Auto
}

int rwmesh_name_format_short(void) {
    return 1; // RWMesh_NameFormat_Short
}

int rwmesh_name_format_full(void) {
    return 2; // RWMesh_NameFormat_Full
}


#include "occt_wrap_internal.h"
#include "occt_wrap_xcaf_dimtol.h"

#include <XCAFDimTolObjects_DimensionObject.hxx>
#include <XCAFDimTolObjects_GeomToleranceObject.hxx>
#include <XCAFDoc_Dimension.hxx>
#include <XCAFDoc_GeomTolerance.hxx>
#include <XCAFDoc_DimTol.hxx>
#include <gp_Pnt.hxx>

static TDF_Label find_shape_label(const Handle(TDocStd_Document)& doc, const TopoDS_Shape& shape)
{
    Handle(XCAFDoc_ShapeTool) ST = XCAFDoc_DocumentTool::ShapeTool(doc->Main());
    TDF_Label L;
    ST->Search(shape, L);
    return L;
}

int xcaf_add_linear_dimension(xde_doc doc, occt_shape shape,
                               double* point_coords, int num_points,
                               double value) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    if (!point_coords || num_points < 2) { set_error("need at least 2 points", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<XCAFDimTolObjects_DimensionObject> dimObj =
            new XCAFDimTolObjects_DimensionObject();
        dimObj->SetType(XCAFDimTolObjects_DimensionType_Location_LinearDistance);
        dimObj->SetValue(value);
        dimObj->SetPoint(gp_Pnt(point_coords[0], point_coords[1], point_coords[2]));
        dimObj->SetPoint2(gp_Pnt(point_coords[3], point_coords[4], point_coords[5]));

        TDF_Label dimLabel = tool->AddDimension();
        XCAFDoc_Dimension::Set(dimLabel)->SetObject(dimObj);
        tool->SetDimension(shapeLabel, dimLabel);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_angular_dimension(xde_doc doc, occt_shape shape,
                                occt_shape* edges, int num_edges,
                                double value) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    if (!edges || num_edges < 2) { set_error("need at least 2 edges", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<XCAFDimTolObjects_DimensionObject> dimObj =
            new XCAFDimTolObjects_DimensionObject();
        dimObj->SetType(XCAFDimTolObjects_DimensionType_Location_Angular);
        dimObj->SetValue(value);

        TDF_Label dimLabel = tool->AddDimension();
        XCAFDoc_Dimension::Set(dimLabel)->SetObject(dimObj);
        tool->SetDimension(shapeLabel, dimLabel);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_diameter_dimension(xde_doc doc, occt_shape shape,
                                 occt_shape subshape, double value) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    if (!subshape) { set_error("null subshape", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<XCAFDimTolObjects_DimensionObject> dimObj =
            new XCAFDimTolObjects_DimensionObject();
        dimObj->SetType(XCAFDimTolObjects_DimensionType_Size_Diameter);
        dimObj->SetValue(value);

        TDF_Label dimLabel = tool->AddDimension();
        XCAFDoc_Dimension::Set(dimLabel)->SetObject(dimObj);
        tool->SetDimension(shapeLabel, dimLabel);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_tolerance(xde_doc doc, occt_shape shape,
                        int type_code, double value,
                        int modifier_flags) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<NCollection_HArray1<double> > valArr =
            new NCollection_HArray1<double>(1, 1);
        valArr->SetValue(1, value);

        occ::handle<TCollection_HAsciiString> name(new TCollection_HAsciiString(""));
        occ::handle<TCollection_HAsciiString> desc;
        if (modifier_flags != 0) {
            char buf[64];
            snprintf(buf, sizeof(buf), "modifiers=%d", modifier_flags);
            desc = new TCollection_HAsciiString(buf);
        } else {
            desc = new TCollection_HAsciiString("");
        }

        TDF_Label tolLabel = tool->SetDimTol(shapeLabel, type_code, valArr, name, desc);
        return !tolLabel.IsNull() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_datum(xde_doc doc, occt_shape shape,
                    const char* label_str) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    if (!label_str || label_str[0] == '\0') { set_error("null or empty label", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<TCollection_HAsciiString> name(new TCollection_HAsciiString(label_str));
        occ::handle<TCollection_HAsciiString> emptyDesc(new TCollection_HAsciiString(""));

        TDF_Label datumLabel = tool->AddDatum(name, emptyDesc, name);

        NCollection_Sequence<TDF_Label> shapeLabels;
        shapeLabels.Append(shapeLabel);
        tool->SetDatum(shapeLabels, datumLabel);

        return !datumLabel.IsNull() ? 1 : 0;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int xcaf_add_geometric_tolerance(xde_doc doc, occt_shape shape,
                                  int type_code, double value,
                                  const char** datum_labels, int num_datums) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { set_error("shape not found in document"); return 0; }

        occ::handle<XCAFDimTolObjects_GeomToleranceObject> gtObj =
            new XCAFDimTolObjects_GeomToleranceObject();
        gtObj->SetType((XCAFDimTolObjects_GeomToleranceType)type_code);
        gtObj->SetValue(value);

        TDF_Label gtLabel = tool->AddGeomTolerance();
        XCAFDoc_GeomTolerance::Set(gtLabel)->SetObject(gtObj);
        tool->SetGeomTolerance(shapeLabel, gtLabel);

        for (int i = 0; i < num_datums && datum_labels && datum_labels[i]; i++) {
            occ::handle<TCollection_HAsciiString> dName(new TCollection_HAsciiString(datum_labels[i]));
            occ::handle<TCollection_HAsciiString> emptyStr(new TCollection_HAsciiString(""));
            TDF_Label datumLabel = tool->AddDatum(dName, emptyStr, dName);
            tool->SetDatumToGeomTol(datumLabel, gtLabel);
        }

        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double* xcaf_get_dimensions(xde_doc doc, occt_shape shape, int* out_count) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); *out_count = 0; return NULL; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { *out_count = 0; return NULL; }

        NCollection_Sequence<TDF_Label> dimLabels;
        tool->GetRefDimensionLabels(shapeLabel, dimLabels);

        int n = dimLabels.Size();
        if (n == 0) { *out_count = 0; return NULL; }

        int total = 0;
        for (int i = 0; i < n; i++) {
            occ::handle<XCAFDoc_Dimension> dimAttr;
            if (dimLabels.Value(i + 1).FindAttribute(XCAFDoc_Dimension::GetID(), dimAttr)) {
                occ::handle<XCAFDimTolObjects_DimensionObject> dimObj = dimAttr->GetObject();
                if (!dimObj.IsNull()) {
                    int nbPts = 0;
                    if (dimObj->HasPoint()) nbPts++;
                    if (dimObj->HasPoint2()) nbPts++;
                    total += 2 + 1 + nbPts * 3;
                }
            }
        }

        if (total == 0) { *out_count = 0; return NULL; }

        double* result = (double*)malloc(total * sizeof(double));
        int idx = 0;
        for (int i = 0; i < n; i++) {
            occ::handle<XCAFDoc_Dimension> dimAttr;
            if (dimLabels.Value(i + 1).FindAttribute(XCAFDoc_Dimension::GetID(), dimAttr)) {
                occ::handle<XCAFDimTolObjects_DimensionObject> dimObj = dimAttr->GetObject();
                if (!dimObj.IsNull()) {
                    int typeCode = (int)dimObj->GetType();
                    double val = dimObj->GetValue();
                    int nbPts = 0;
                    if (dimObj->HasPoint()) nbPts++;
                    if (dimObj->HasPoint2()) nbPts++;

                    int needed = 2 + 1 + nbPts * 3;
                    if (idx + needed > total) break;

                    result[idx++] = (double)typeCode;
                    result[idx++] = val;
                    result[idx++] = (double)nbPts;

                    if (dimObj->HasPoint()) {
                        gp_Pnt p = dimObj->GetPoint();
                        result[idx++] = p.X();
                        result[idx++] = p.Y();
                        result[idx++] = p.Z();
                    }
                    if (dimObj->HasPoint2()) {
                        gp_Pnt p = dimObj->GetPoint2();
                        result[idx++] = p.X();
                        result[idx++] = p.Y();
                        result[idx++] = p.Z();
                    }
                }
            }
        }

        *out_count = idx;
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return NULL;
    }
}

double* xcaf_get_tolerances(xde_doc doc, occt_shape shape, int* out_count) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); *out_count = 0; return NULL; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { *out_count = 0; return NULL; }

        NCollection_Sequence<TDF_Label> tolLabels;
        tool->GetRefGeomToleranceLabels(shapeLabel, tolLabels);
        NCollection_Sequence<TDF_Label> dimTolLabels;
        tool->GetDimTolLabels(dimTolLabels);

        int n = tolLabels.Size() + dimTolLabels.Size();
        if (n == 0) { *out_count = 0; return NULL; }

        double* result = (double*)malloc(n * 2 * sizeof(double));
        int idx = 0;

        for (int i = 1; i <= tolLabels.Size(); i++) {
            occ::handle<XCAFDoc_GeomTolerance> gtAttr;
            if (tolLabels.Value(i).FindAttribute(XCAFDoc_GeomTolerance::GetID(), gtAttr)) {
                occ::handle<XCAFDimTolObjects_GeomToleranceObject> gtObj = gtAttr->GetObject();
                if (!gtObj.IsNull()) {
                    result[idx++] = (double)(-(int)gtObj->GetType());
                    result[idx++] = gtObj->GetValue();
                }
            }
        }

        *out_count = idx / 2;
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return NULL;
    }
}

char** xcaf_get_datums(xde_doc doc, occt_shape shape, int* out_count) {
    clear_error();
    if (!doc || !shape) { set_error("null argument", 2); *out_count = 0; return NULL; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        Handle(XCAFDoc_DimTolTool) tool = XCAFDoc_DimTolTool::Set(hDoc->Main());
        TDF_Label shapeLabel = find_shape_label(hDoc, *to_shape(shape));
        if (shapeLabel.IsNull()) { *out_count = 0; return NULL; }

        NCollection_Sequence<TDF_Label> datumLabels;
        tool->GetRefDatumLabel(shapeLabel, datumLabels);

        int n = datumLabels.Size();
        if (n == 0) { *out_count = 0; return NULL; }

        char** result = (char**)malloc(n * sizeof(char*));
        int count = 0;
        for (int i = 1; i <= n; i++) {
            occ::handle<TCollection_HAsciiString> name, desc, ident;
            if (tool->GetDatum(datumLabels.Value(i), name, desc, ident)) {
                if (!name.IsNull()) {
                    const char* cstr = name->ToCString();
                    result[count] = (char*)malloc(strlen(cstr) + 1);
                    strcpy(result[count], cstr);
                    count++;
                }
            }
        }

        *out_count = count;
        return result;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        *out_count = 0;
        return NULL;
    }
}

void xcaf_free_double_array(double* arr) {
    free(arr);
}

void xcaf_free_string_array(char** arr, int count) {
    if (arr) {
        for (int i = 0; i < count; i++) {
            free(arr[i]);
        }
        free(arr);
    }
}

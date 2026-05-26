#include "occt_wrap_internal.h"
#include "occt_wrap_dimensions.h"

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
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
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
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        (**dim).SetDisplayUnits(TCollection_AsciiString(units));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_flyout(void* dim_ptr, double v) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        (**dim).SetFlyout(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_measured_edge(void* dim_ptr, void* shape_ptr, double px, double py, double pz, double nx, double ny, double nz) {
    clear_error();
    if (!dim_ptr || !shape_ptr) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_LengthDimension)*>(dim_ptr);
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
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
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        const Handle(Prs3d_DimensionAspect)& aspect = (**dim).DimensionAspect();
        if (aspect.IsNull()) { set_error("null dimension aspect", 2); return; }
        const Handle(Prs3d_ArrowAspect)& arrow = aspect->ArrowAspect();
        if (arrow.IsNull()) { set_error("null arrow aspect", 2); return; }
        arrow->SetLength(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_extension_size(void* dim_ptr, double v) {
    clear_error();
    if (!dim_ptr) { set_error("null dimension argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        const Handle(Prs3d_DimensionAspect)& aspect = (**dim).DimensionAspect();
        if (aspect.IsNull()) { set_error("null dimension aspect", 2); return; }
        aspect->SetExtensionSize(v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_custom_value(void* dim_ptr, const char* value) {
    clear_error();
    if (!dim_ptr || !value) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_Dimension)*>(dim_ptr);
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        (**dim).SetCustomValue(TCollection_ExtendedString(value));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void prsdim_set_angle_edges(void* dim_ptr, void* edge1_ptr, void* edge2_ptr) {
    clear_error();
    if (!dim_ptr || !edge1_ptr || !edge2_ptr) { set_error("null argument", 2); return; }
    try {
        auto* dim = static_cast<Handle(PrsDim_AngleDimension)*>(dim_ptr);
        if (dim->IsNull()) { set_error("null dimension", 2); return; }
        auto* edge1 = static_cast<TopoDS_Shape*>(edge1_ptr);
        auto* edge2 = static_cast<TopoDS_Shape*>(edge2_ptr);
        (**dim).SetMeasuredGeometry(TopoDS::Edge(*edge1), TopoDS::Edge(*edge2));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}


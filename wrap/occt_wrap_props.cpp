#include "occt_wrap_internal.h"
#include "occt_wrap_props.h"
#include <BRepGProp.hxx>
#include <BRepGProp_Face.hxx>
#include <BRepLProp_SLProps.hxx>
#include <BRepAdaptor_Surface.hxx>
#include <BRepAdaptor_Curve.hxx>
#include <BRepBndLib.hxx>
#include <Bnd_Box.hxx>
#include <GProp_GProps.hxx>

int face_area(occt_shape face, double* out_area) {
    clear_error();
    *out_area = 0.0;
    if (!face) return 0;
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        GProp_GProps props;
        BRepGProp::SurfaceProperties(f, props);
        *out_area = props.Mass();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int edge_length(occt_shape edge, double* out_length) {
    clear_error();
    *out_length = 0.0;
    if (!edge) return 0;
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        GProp_GProps props;
        BRepGProp::LinearProperties(e, props);
        *out_length = props.Mass();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_normal_at_center(occt_shape face, double* out_nx, double* out_ny, double* out_nz) {
    clear_error();
    *out_nx = *out_ny = *out_nz = 0.0;
    if (!face) return 0;
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface surf(f);
        double u1 = surf.FirstUParameter();
        double u2 = surf.LastUParameter();
        double v1 = surf.FirstVParameter();
        double v2 = surf.LastVParameter();
        double u_mid = (u1 + u2) / 2.0;
        double v_mid = (v1 + v2) / 2.0;
        BRepLProp_SLProps lprop(surf, 2, Precision::Confusion());
        lprop.SetParameters(u_mid, v_mid);
        if (!lprop.IsNormalDefined()) return 0;
        gp_Dir n = lprop.Normal();
        if (f.Orientation() == TopAbs_REVERSED) n.Reverse();
        *out_nx = n.X();
        *out_ny = n.Y();
        *out_nz = n.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_surface_type(occt_shape face) {
    clear_error();
    if (!face) return -1;
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface surf(f);
        return (int)surf.GetType();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}

int edge_curve_type(occt_shape edge) {
    clear_error();
    if (!edge) return -1;
    try {
        TopoDS_Edge e = TopoDS::Edge(*to_shape(edge));
        BRepAdaptor_Curve curv(e);
        return (int)curv.GetType();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return -1;
    }
}

int subshape_bounding_box(occt_shape shape, double* out_xmin, double* out_ymin, double* out_zmin,
                           double* out_xmax, double* out_ymax, double* out_zmax) {
    clear_error();
    *out_xmin = *out_ymin = *out_zmin = 0.0;
    *out_xmax = *out_ymax = *out_zmax = 0.0;
    if (!shape) return 0;
    try {
        Bnd_Box box;
        BRepBndLib::Add(*to_shape(shape), box);
        if (box.IsVoid()) return 0;
        box.Get(*out_xmin, *out_ymin, *out_zmin, *out_xmax, *out_ymax, *out_zmax);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int face_center(occt_shape face, double* out_x, double* out_y, double* out_z) {
    clear_error();
    *out_x = *out_y = *out_z = 0.0;
    if (!face) return 0;
    try {
        TopoDS_Face f = TopoDS::Face(*to_shape(face));
        BRepAdaptor_Surface surf(f);
        double u1 = surf.FirstUParameter();
        double u2 = surf.LastUParameter();
        double v1 = surf.FirstVParameter();
        double v2 = surf.LastVParameter();
        double u_mid = (u1 + u2) / 2.0;
        double v_mid = (v1 + v2) / 2.0;
        gp_Pnt center = surf.Value(u_mid, v_mid);
        *out_x = center.X();
        *out_y = center.Y();
        *out_z = center.Z();
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int shape_extent_along(occt_shape shape, double dx, double dy, double dz,
                        double* out_min, double* out_max) {
    clear_error();
    *out_min = *out_max = 0.0;
    if (!shape) return 0;
    try {
        Bnd_Box box;
        BRepBndLib::Add(*to_shape(shape), box);
        if (box.IsVoid()) return 0;
        double xmin, ymin, zmin, xmax, ymax, zmax;
        box.Get(xmin, ymin, zmin, xmax, ymax, zmax);
        gp_Dir dir(dx, dy, dz);
        double min_proj = std::numeric_limits<double>::max();
        double max_proj = -std::numeric_limits<double>::max();
        gp_Pnt corners[8] = {
            gp_Pnt(xmin, ymin, zmin), gp_Pnt(xmax, ymin, zmin),
            gp_Pnt(xmin, ymax, zmin), gp_Pnt(xmax, ymax, zmin),
            gp_Pnt(xmin, ymin, zmax), gp_Pnt(xmax, ymin, zmax),
            gp_Pnt(xmin, ymax, zmax), gp_Pnt(xmax, ymax, zmax)
        };
        for (int i = 0; i < 8; i++) {
            gp_XYZ p = corners[i].XYZ();
            double proj = p.Dot(dir.XYZ());
            if (proj < min_proj) min_proj = proj;
            if (proj > max_proj) max_proj = proj;
        }
        *out_min = min_proj;
        *out_max = max_proj;
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

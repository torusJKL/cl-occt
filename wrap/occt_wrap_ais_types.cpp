#include "occt_wrap_internal.h"
#include "occt_wrap_ais_types.h"

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

void* ais_create_colored_shape(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        Handle(AIS_ColoredShape)* h = new Handle(AIS_ColoredShape)(new AIS_ColoredShape(*to_shape(shape)));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

int ais_colored_shape_set_color(void* obj_ptr, occt_shape sub, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null colored shape argument", 2); return 0; }
    if (!sub) { set_error("null sub-shape argument", 2); return 0; }
    try {
        auto* obj = static_cast<Handle(AIS_ColoredShape)*>(obj_ptr);
        (*obj)->SetCustomColor(*to_shape(sub), Quantity_Color(r, g, b, Quantity_TOC_RGB));
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void* ais_create_manipulator(void) {
    clear_error();
    try {
        Handle(AIS_Manipulator)* h = new Handle(AIS_Manipulator)(new AIS_Manipulator());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_manipulator_attach(void* obj_ptr, void* ais_obj_ptr) {
    clear_error();
    if (!obj_ptr) { set_error("null manipulator argument", 2); return; }
    if (!ais_obj_ptr) { set_error("null ais-object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Manipulator)*>(obj_ptr);
        auto* ais = static_cast<Handle(AIS_InteractiveObject)*>(ais_obj_ptr);
        (*obj)->Attach(*ais);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_manipulator_set_position(void* obj_ptr, double x, double y, double z) {
    clear_error();
    if (!obj_ptr) { set_error("null manipulator argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Manipulator)*>(obj_ptr);
        (*obj)->SetPosition(gp_Ax2(gp_Pnt(x, y, z), gp_Dir(0, 0, 1)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_manipulator_set_size(void* obj_ptr, double size) {
    clear_error();
    if (!obj_ptr) { set_error("null manipulator argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Manipulator)*>(obj_ptr);
        (*obj)->SetSize(size);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_manipulator_set_active_axes(void* obj_ptr, int translate, int rotate, int scale) {
    clear_error();
    if (!obj_ptr) { set_error("null manipulator argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_Manipulator)*>(obj_ptr);
        (*obj)->SetPart(AIS_MM_Translation, translate != 0);
        (*obj)->SetPart(AIS_MM_Rotation, rotate != 0);
        (*obj)->SetPart(AIS_MM_Scaling, scale != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_connected(void* src_ptr) {
    clear_error();
    if (!src_ptr) { set_error("null source object argument", 2); return nullptr; }
    try {
        auto* src = static_cast<Handle(AIS_InteractiveObject)*>(src_ptr);
        Handle(AIS_ConnectedInteractive)* h = new Handle(AIS_ConnectedInteractive)(new AIS_ConnectedInteractive());
        (*h)->Connect(*src);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_multiple_connected(void) {
    clear_error();
    try {
        Handle(AIS_MultipleConnectedInteractive)* h =
            new Handle(AIS_MultipleConnectedInteractive)(new AIS_MultipleConnectedInteractive());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_multiple_connected_connect(void* obj_ptr, void* src_ptr) {
    clear_error();
    if (!obj_ptr) { set_error("null multiple-connected argument", 2); return; }
    if (!src_ptr) { set_error("null source object argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_MultipleConnectedInteractive)*>(obj_ptr);
        auto* src = static_cast<Handle(AIS_InteractiveObject)*>(src_ptr);
        (*obj)->Connect(*src);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_point_cloud(double* verts, int count) {
    clear_error();
    if (!verts || count <= 0) { set_error("invalid point array", 2); return nullptr; }
    try {
        Handle(Graphic3d_ArrayOfPoints) arr = new Graphic3d_ArrayOfPoints(count);
        for (int i = 0; i < count; i++) {
            arr->AddVertex(gp_Pnt(verts[i * 3], verts[i * 3 + 1], verts[i * 3 + 2]));
        }
        Handle(AIS_PointCloud)* h = new Handle(AIS_PointCloud)(new AIS_PointCloud());
        (*h)->SetPoints(arr);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_point_cloud_set_colors(void* obj_ptr, double* colors, int count) {
    clear_error();
    if (!obj_ptr) { set_error("null point cloud argument", 2); return; }
    if (!colors || count <= 0) { set_error("invalid color array", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_PointCloud)*>(obj_ptr);
        Handle(Graphic3d_ArrayOfPoints) arr = new Graphic3d_ArrayOfPoints(count, true, false);
        for (int i = 0; i < count; i++) {
            arr->AddVertex(gp_Pnt(0, 0, 0),
                           Quantity_Color(colors[i * 3], colors[i * 3 + 1], colors[i * 3 + 2],
                                          Quantity_TOC_RGB));
        }
        (*obj)->SetPoints(arr);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_point_cloud_set_size(void* obj_ptr, double size) {
    clear_error();
    if (!obj_ptr) { set_error("null point cloud argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_PointCloud)*>(obj_ptr);
        // Point size not directly available in OCCT 8.0 AIS_PointCloud API
        // Set via aspect attributes in the future
        (void)size;
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_triangulation(double* verts, int vcount, int* tris, int tcount, double* colors) {
    clear_error();
    if (!verts || vcount <= 0 || !tris || tcount <= 0) {
        set_error("invalid vertex or triangle array", 2); return nullptr;
    }
    try {
        NCollection_Array1<gp_Pnt> pntArr(1, vcount);
        for (int i = 0; i < vcount; i++) {
            pntArr.SetValue(i + 1, gp_Pnt(verts[i * 3], verts[i * 3 + 1], verts[i * 3 + 2]));
        }
        NCollection_Array1<Poly_Triangle> triArr(1, tcount);
        for (int i = 0; i < tcount; i++) {
            triArr.SetValue(i + 1, Poly_Triangle(tris[i * 3] + 1, tris[i * 3 + 1] + 1, tris[i * 3 + 2] + 1));
        }
        Handle(Poly_Triangulation) polyTri = new Poly_Triangulation(pntArr, triArr);
        Handle(AIS_Triangulation)* h = new Handle(AIS_Triangulation)(new AIS_Triangulation(polyTri));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_plane(double ox, double oy, double oz, double nx, double ny, double nz, double size) {
    clear_error();
    try {
        gp_Ax2 axes(get_pnt(ox, oy, oz), get_dir(nx, ny, nz));
        Handle(Geom_Plane) geomPlane = new Geom_Plane(axes);
        Handle(AIS_Plane)* h = new Handle(AIS_Plane)(new AIS_Plane(geomPlane));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_axis(double ox, double oy, double oz, double dx, double dy, double dz) {
    clear_error();
    try {
        gp_Pnt origin(ox, oy, oz);
        gp_Dir dir(dx, dy, dz);
        Handle(Geom_Line) geomLine = new Geom_Line(origin, dir);
        Handle(AIS_Axis)* h = new Handle(AIS_Axis)(new AIS_Axis(geomLine));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_line(double x1, double y1, double z1, double x2, double y2, double z2) {
    clear_error();
    try {
        gp_Pnt p1(x1, y1, z1);
        gp_Pnt p2(x2, y2, z2);
        Handle(Geom_Line) geomLine = new Geom_Line(p1, gp_Dir(gp_Vec(p1, p2)));
        Handle(AIS_Line)* h = new Handle(AIS_Line)(new AIS_Line(geomLine));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_circle(double cx, double cy, double cz, double nx, double ny, double nz, double radius) {
    clear_error();
    if (radius <= 0) { set_error("non-positive radius", 2); return nullptr; }
    try {
        gp_Ax2 axes(get_pnt(cx, cy, cz), get_dir(nx, ny, nz));
        Handle(Geom_Circle) geomCirc = new Geom_Circle(axes, radius);
        Handle(AIS_Circle)* h = new Handle(AIS_Circle)(new AIS_Circle(geomCirc));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_create_textured_shape(occt_shape shape, const char* filename) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    if (!filename) { set_error("null filename argument", 2); return nullptr; }
    try {
        Handle(AIS_TexturedShape)* h = new Handle(AIS_TexturedShape)(new AIS_TexturedShape(*to_shape(shape)));
        (*h)->SetTextureFileName(TCollection_AsciiString(filename));
        (*h)->SetDisplayMode(1);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_textured_shape_set_repeat(void* obj_ptr, double u, double v) {
    clear_error();
    if (!obj_ptr) { set_error("null textured shape argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_TexturedShape)*>(obj_ptr);
        (*obj)->SetTextureRepeat(u, v);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_textured_shape_set_origin(void* obj_ptr, double u, double v) {
    clear_error();
    if (!obj_ptr) { set_error("null textured shape argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_TexturedShape)*>(obj_ptr);
        (*obj)->SetTextureOrigin(u, v);
        (*obj)->Redisplay(true);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_view_cube(void) {
    clear_error();
    try {
        Handle(AIS_ViewCube)* h = new Handle(AIS_ViewCube)(new AIS_ViewCube());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_view_cube_set_size(void* obj_ptr, double size) {
    clear_error();
    if (!obj_ptr) { set_error("null view cube argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ViewCube)*>(obj_ptr);
        (*obj)->SetSize(size);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_view_cube_set_box_color(void* obj_ptr, double r, double g, double b) {
    clear_error();
    if (!obj_ptr) { set_error("null view cube argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ViewCube)*>(obj_ptr);
        (*obj)->SetBoxColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_view_cube_set_corner(void* obj_ptr, int corner) {
    clear_error();
    if (!obj_ptr) { set_error("null view cube argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ViewCube)*>(obj_ptr);
        Handle(Graphic3d_TransformPers) pers =
            new Graphic3d_TransformPers(Graphic3d_TMF_TriedronPers,
                                         static_cast<Aspect_TypeOfTriedronPosition>(corner),
                                         NCollection_Vec2<int>(0, 0));
        (*obj)->SetTransformPersistence(pers);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_color_scale(void) {
    clear_error();
    try {
        Handle(AIS_ColorScale)* h = new Handle(AIS_ColorScale)(new AIS_ColorScale());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_color_scale_set_range(void* obj_ptr, double min, double max) {
    clear_error();
    if (!obj_ptr) { set_error("null color scale argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ColorScale)*>(obj_ptr);
        (*obj)->SetRange(min, max);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_color_scale_set_size(void* obj_ptr, double w, double h) {
    clear_error();
    if (!obj_ptr) { set_error("null color scale argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ColorScale)*>(obj_ptr);
        (*obj)->SetSize(w, h);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_color_scale_set_title(void* obj_ptr, const char* title) {
    clear_error();
    if (!obj_ptr) { set_error("null color scale argument", 2); return; }
    if (!title) { set_error("null title argument", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ColorScale)*>(obj_ptr);
        (*obj)->SetTitle(TCollection_AsciiString(title));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_color_scale_set_intervals(void* obj_ptr, int n) {
    clear_error();
    if (!obj_ptr) { set_error("null color scale argument", 2); return; }
    if (n < 1) { set_error("invalid number of intervals", 2); return; }
    try {
        auto* obj = static_cast<Handle(AIS_ColorScale)*>(obj_ptr);
        (*obj)->SetNumberOfIntervals(n);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void* ais_create_light_source(void* light_ptr) {
    clear_error();
    if (!light_ptr) { set_error("null light argument", 2); return nullptr; }
    try {
        auto* light = static_cast<Handle(V3d_Light)*>(light_ptr);
        Handle(AIS_LightSource)* h = new Handle(AIS_LightSource)(new AIS_LightSource(*light));
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

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


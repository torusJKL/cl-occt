#include "occt_wrap_internal.h"
#include "occt_wrap_lighting.h"

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


#include "occt_wrap_internal.h"
#include "occt_wrap_visual.h"

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


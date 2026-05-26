#include "occt_wrap_internal.h"
#include "occt_wrap_animation.h"

struct OccAnimation {
    Handle(AIS_Animation) handle;
    Handle(AIS_InteractiveObject) object;
    double lastPts;
};

static OccAnimation* to_anim(occt_ais_animation a) {
    return static_cast<OccAnimation*>(a);
}

occt_ais_animation ais_animation_create(const char* name) {
    clear_error();
    if (!name) { set_error("null name", 2); return nullptr; }
    try {
        OccAnimation* anim = new OccAnimation();
        anim->handle = new AIS_Animation(TCollection_AsciiString(name));
        anim->lastPts = 0.0;
        return (occt_ais_animation)anim;
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void ais_animation_free(occt_ais_animation anim) {
    if (!anim) return;
    delete to_anim(anim);
}

void ais_animation_start(occt_ais_animation anim) {
    if (!anim) return;
    try {
        to_anim(anim)->handle->StartTimer(0.0, 1.0, true);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void ais_animation_stop(occt_ais_animation anim) {
    if (!anim) return;
    try {
        to_anim(anim)->handle->Stop();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

int ais_animation_is_playing(occt_ais_animation anim) {
    if (!anim) return 0;
    try {
        return to_anim(anim)->handle->IsStopped() ? 0 : 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}

void ais_animation_set_duration(occt_ais_animation anim, double seconds) {
    if (!anim) return;
    try {
        to_anim(anim)->handle->SetOwnDuration(seconds);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

double ais_animation_duration(occt_ais_animation anim) {
    if (!anim) return 0.0;
    try {
        return to_anim(anim)->handle->Duration();
    } catch (Standard_Failure& e) { set_error(e.what()); return 0.0; }
}

void ais_animation_set_progress(occt_ais_animation anim, double progress) {
    if (!anim) return;
    try {
        OccAnimation* a = to_anim(anim);
        double pts = progress * a->handle->Duration();
        a->handle->Update(pts);
        a->lastPts = pts;
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

double ais_animation_progress(occt_ais_animation anim) {
    if (!anim) return 0.0;
    try {
        OccAnimation* a = to_anim(anim);
        double dur = a->handle->Duration();
        return dur > 0.0 ? a->lastPts / dur : 0.0;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0.0; }
}

void ais_animation_set_start_pause(occt_ais_animation anim, double seconds) {
    if (!anim) return;
    try {
        to_anim(anim)->handle->SetStartPts(seconds);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void ais_animation_add(occt_ais_animation parent, occt_ais_animation child) {
    if (!parent || !child) return;
    try {
        to_anim(parent)->handle->Add(to_anim(child)->handle);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void ais_animation_remove(occt_ais_animation parent, occt_ais_animation child) {
    if (!parent || !child) return;
    try {
        to_anim(parent)->handle->Remove(to_anim(child)->handle);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void* ais_animation_object_create(const char* name, void* ctx_ptr, void* ais_obj_ptr,
                                    double tx, double ty, double tz,
                                    double rx, double ry, double rz, double angle_deg) {
    clear_error();
    if (!name || !ctx_ptr || !ais_obj_ptr) { set_error("null argument", 2); return nullptr; }
    double dmag = sqrt(rx*rx + ry*ry + rz*rz);
    if (dmag < Precision::Confusion()) { rx = 0.0; ry = 0.0; rz = 1.0; }
    try {
        gp_Trsf trsfEnd;
        trsfEnd.SetTranslation(gp_Vec(tx, ty, tz));
        if (fabs(angle_deg) > Precision::Angular()) {
            trsfEnd.SetRotation(gp_Ax1(gp_Pnt(0,0,0), gp_Dir(rx, ry, rz)), angle_deg * M_PI / 180.0);
        }
        OccAnimation* anim = new OccAnimation();
        anim->object = *static_cast<Handle(AIS_InteractiveObject)*>(ais_obj_ptr);
        anim->handle = new AIS_AnimationObject(TCollection_AsciiString(name),
                                                *static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr),
                                                anim->object,
                                                gp_Trsf(), trsfEnd);
        anim->lastPts = 0.0;
        return (occt_ais_animation)anim;
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void* ais_animation_object_get_object(occt_ais_animation anim) {
    if (!anim) return nullptr;
    OccAnimation* a = to_anim(anim);
    if (a->object.IsNull()) return nullptr;
    try {
        return (void*)new Handle(AIS_InteractiveObject)(a->object);
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void* ais_animation_camera_create(const char* name, void* view_ptr,
                                    double sex, double sey, double sez,
                                    double stx, double sty, double stz,
                                    double sux, double suy, double suz,
                                    double eex, double eey, double eez,
                                    double etx, double ety, double etz,
                                    double eux, double euy, double euz) {
    clear_error();
    if (!name || !view_ptr) { set_error("null argument", 2); return nullptr; }
    try {
        Handle(V3d_View)& view = *static_cast<Handle(V3d_View)*>(view_ptr);
        Handle(Graphic3d_Camera) startCam = new Graphic3d_Camera();
        startCam->SetEye(gp_Pnt(sex, sey, sez));
        startCam->SetCenter(gp_Pnt(stx, sty, stz));
        startCam->SetUp(gp_Dir(sux, suy, suz));
        Handle(Graphic3d_Camera) endCam = new Graphic3d_Camera();
        endCam->SetEye(gp_Pnt(eex, eey, eez));
        endCam->SetCenter(gp_Pnt(etx, ety, etz));
        endCam->SetUp(gp_Dir(eux, euy, euz));
        OccAnimation* anim = new OccAnimation();
        anim->handle = new AIS_AnimationCamera(TCollection_AsciiString(name), view);
        Handle(AIS_AnimationCamera)::DownCast(anim->handle)->SetCameraStart(startCam);
        Handle(AIS_AnimationCamera)::DownCast(anim->handle)->SetCameraEnd(endCam);
        anim->lastPts = 0.0;
        return (occt_ais_animation)anim;
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void* ais_animation_axis_rotation_create(const char* name, void* ctx_ptr, void* ais_obj_ptr,
                                          double ox, double oy, double oz,
                                          double dx, double dy, double dz,
                                          double angle_start_deg, double angle_end_deg) {
    clear_error();
    if (!name || !ctx_ptr || !ais_obj_ptr) { set_error("null argument", 2); return nullptr; }
    double dmag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dmag < Precision::Confusion()) { set_error("zero axis direction", 2); return nullptr; }
    try {
        gp_Ax1 axis(gp_Pnt(ox, oy, oz), gp_Dir(dx, dy, dz));
        OccAnimation* anim = new OccAnimation();
        anim->object = *static_cast<Handle(AIS_InteractiveObject)*>(ais_obj_ptr);
        anim->handle = new AIS_AnimationAxisRotation(
            TCollection_AsciiString(name),
            *static_cast<Handle(AIS_InteractiveContext)*>(ctx_ptr),
            anim->object,
            axis, angle_start_deg * M_PI / 180.0, angle_end_deg * M_PI / 180.0);
        anim->lastPts = 0.0;
        return (occt_ais_animation)anim;
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}


#include "occt_wrap_internal.h"
#include "occt_wrap_image_texture.h"

occt_image image_from_file(const char* filename) {
    clear_error();
    if (!filename || access(filename, F_OK) != 0) {
        set_error("file not found");
        return nullptr;
    }
    try {
        occ::handle<Image_AlienPixMap>* h = new occ::handle<Image_AlienPixMap>(new Image_AlienPixMap());
        if (!(*h)->Load(TCollection_AsciiString(filename))) {
            set_error("failed to load image");
            delete h;
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_image(occt_image img) {
    if (img) {
        delete static_cast<occ::handle<Image_AlienPixMap>*>(img);
    }
}

int image_save(occt_image img, const char* filename) {
    clear_error();
    if (!img || !filename) { set_error("null argument", 2); return 0; }
    try {
        occ::handle<Image_AlienPixMap>& hImg = *static_cast<occ::handle<Image_AlienPixMap>*>(img);
        if (!hImg->Save(TCollection_AsciiString(filename))) {
            set_error("failed to save image");
            return 0;
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int image_width(occt_image img) {
    clear_error();
    if (!img) { set_error("null image", 2); return 0; }
    try {
        occ::handle<Image_AlienPixMap>& hImg = *static_cast<occ::handle<Image_AlienPixMap>*>(img);
        return (int)hImg->Width();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int image_height(occt_image img) {
    clear_error();
    if (!img) { set_error("null image", 2); return 0; }
    try {
        occ::handle<Image_AlienPixMap>& hImg = *static_cast<occ::handle<Image_AlienPixMap>*>(img);
        return (int)hImg->Height();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

occt_texture texture_2d_from_file(const char* filename) {
    clear_error();
    if (!filename) { set_error("null filename", 2); return nullptr; }
    try {
        occ::handle<Graphic3d_Texture2D>* h = new occ::handle<Graphic3d_Texture2D>(
            new Graphic3d_Texture2D(TCollection_AsciiString(filename)));
        if (h->IsNull()) {
            set_error("texture creation failed");
            delete h;
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_texture texture_2d_from_image(occt_image img) {
    clear_error();
    if (!img) { set_error("null image", 2); return nullptr; }
    try {
        occ::handle<Image_PixMap> hImg = *static_cast<occ::handle<Image_AlienPixMap>*>(img);
        occ::handle<Graphic3d_Texture2D>* h = new occ::handle<Graphic3d_Texture2D>(
            new Graphic3d_Texture2D(hImg));
        if (h->IsNull()) {
            set_error("texture creation failed");
            delete h;
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_texture(occt_texture tex) {
    if (tex) {
        delete static_cast<occ::handle<Graphic3d_Texture2D>*>(tex);
    }
}

occt_tex_params texture_get_params(occt_texture tex) {
    clear_error();
    if (!tex) { set_error("null texture", 2); return nullptr; }
    try {
        occ::handle<Graphic3d_Texture2D>& hTex = *static_cast<occ::handle<Graphic3d_Texture2D>*>(tex);
        const occ::handle<Graphic3d_TextureParams>& params = hTex->GetParams();
        if (params.IsNull()) { set_error("texture has no params"); return nullptr; }
        // Return a new handle to the same params object (refcounted)
        // The texture owns the original, but we increment the refcount
        occ::handle<Graphic3d_TextureParams>* h = new occ::handle<Graphic3d_TextureParams>(params);
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_texture texture_2dplane_from_file(const char* filename) {
    clear_error();
    if (!filename) { set_error("null filename", 2); return nullptr; }
    try {
        occ::handle<Graphic3d_Texture2Dplane>* h = new occ::handle<Graphic3d_Texture2Dplane>(
            new Graphic3d_Texture2Dplane(TCollection_AsciiString(filename)));
        if (h->IsNull()) {
            set_error("texture plane creation failed");
            delete h;
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void texture_2dplane_set_repeat(void* tex, int uRepeat, int vRepeat) {
    clear_error();
    if (!tex) { set_error("null texture", 2); return; }
    try {
        // Not available on Graphic3d_Texture2Dplane in this OCCT version
        // Use texture params wrapping instead
        set_error("texture plane set_repeat not supported");
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void texture_2dplane_set_origin(void* tex, double u, double v) {
    clear_error();
    if (!tex) { set_error("null texture", 2); return; }
    try {
        occ::handle<Graphic3d_Texture2Dplane>& p = *static_cast<occ::handle<Graphic3d_Texture2Dplane>*>(tex);
        p->SetTranslateS((float)u);
        p->SetTranslateT((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void texture_2dplane_set_scale(void* tex, double u, double v) {
    clear_error();
    if (!tex) { set_error("null texture", 2); return; }
    try {
        occ::handle<Graphic3d_Texture2Dplane>& p = *static_cast<occ::handle<Graphic3d_Texture2Dplane>*>(tex);
        p->SetScaleS((float)u);
        p->SetScaleT((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void texture_2dplane_set_rotation(void* tex, double angle_deg) {
    clear_error();
    if (!tex) { set_error("null texture", 2); return; }
    try {
        occ::handle<Graphic3d_Texture2Dplane>& p = *static_cast<occ::handle<Graphic3d_Texture2Dplane>*>(tex);
        p->SetRotation((float)angle_deg);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_tex_params texture_params_create(void) {
    clear_error();
    try {
        occ::handle<Graphic3d_TextureParams>* h = new occ::handle<Graphic3d_TextureParams>(new Graphic3d_TextureParams());
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_texture_params(occt_tex_params params) {
    if (params) {
        delete static_cast<occ::handle<Graphic3d_TextureParams>*>(params);
    }
}

void texture_params_set_filter(void* params, int filter) {
    clear_error();
    if (!params) { set_error("null params", 2); return; }
    try {
        occ::handle<Graphic3d_TextureParams>& p = *static_cast<occ::handle<Graphic3d_TextureParams>*>(params);
        p->SetFilter((Graphic3d_TypeOfTextureFilter)filter);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void texture_params_set_repeat(void* params, int on) {
    clear_error();
    if (!params) { set_error("null params", 2); return; }
    try {
        occ::handle<Graphic3d_TextureParams>& p = *static_cast<occ::handle<Graphic3d_TextureParams>*>(params);
        p->SetRepeat(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void texture_params_set_aniso(void* params, int level) {
    clear_error();
    if (!params) { set_error("null params", 2); return; }
    try {
        occ::handle<Graphic3d_TextureParams>& p = *static_cast<occ::handle<Graphic3d_TextureParams>*>(params);
        p->SetAnisoFilter((Graphic3d_LevelOfTextureAnisotropy)level);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_pbr_material pbr_material_create(void) {
    clear_error();
    try {
        Graphic3d_PBRMaterial* mat = new Graphic3d_PBRMaterial();
        return mat;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_pbr_material(occt_pbr_material mat) {
    if (mat) {
        delete static_cast<Graphic3d_PBRMaterial*>(mat);
    }
}

void pbr_material_set_albedo(void* mat, double r, double g, double b) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetColor(Quantity_Color((float)r, (float)g, (float)b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void pbr_material_set_metallic(void* mat, double v) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetMetallic((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void pbr_material_set_roughness(void* mat, double v) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetRoughness((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void pbr_material_set_emissive(void* mat, double r, double g, double b) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetEmission(NCollection_Vec3<float>((float)r, (float)g, (float)b));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void pbr_material_set_refraction_index(void* mat, double v) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetIOR((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void pbr_material_set_transparency(void* mat, double v) {
    clear_error();
    if (!mat) { set_error("null material", 2); return; }
    try {
        Graphic3d_PBRMaterial* m = static_cast<Graphic3d_PBRMaterial*>(mat);
        m->SetAlpha((float)(1.0 - v));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_bsdf bsdf_create(void) {
    clear_error();
    try {
        Graphic3d_BSDF* bsdf = new Graphic3d_BSDF();
        return bsdf;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_bsdf(occt_bsdf bsdf) {
    if (bsdf) {
        delete static_cast<Graphic3d_BSDF*>(bsdf);
    }
}

void bsdf_set_ambient(void* bsdfPtr, double r, double g, double b) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Kd = NCollection_Vec3<float>((float)r, (float)g, (float)b);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_diffuse(void* bsdfPtr, double r, double g, double b) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Kd = NCollection_Vec3<float>((float)r, (float)g, (float)b);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_specular(void* bsdfPtr, double r, double g, double b) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Ks = NCollection_Vec4<float>((float)r, (float)g, (float)b, 1.0f);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_transmission(void* bsdfPtr, double r, double g, double b) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Kt = NCollection_Vec3<float>((float)r, (float)g, (float)b);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_reflection(void* bsdfPtr, double r, double g, double b) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Kc = NCollection_Vec4<float>((float)r, (float)g, (float)b, 1.0f);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_refraction_index(void* bsdfPtr, double v) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->FresnelBase = Graphic3d_Fresnel::CreateDielectric((float)v);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void bsdf_set_absorption(void* bsdfPtr, double r, double g, double b, double coeff) {
    clear_error();
    if (!bsdfPtr) { set_error("null bsdf", 2); return; }
    try {
        Graphic3d_BSDF* bsdfMat = static_cast<Graphic3d_BSDF*>(bsdfPtr);
        bsdfMat->Absorption = NCollection_Vec4<float>((float)r, (float)g, (float)b, (float)coeff);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}


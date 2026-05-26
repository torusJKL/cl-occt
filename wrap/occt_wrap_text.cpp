#include "occt_wrap_internal.h"
#include "occt_wrap_text.h"

occt_brep_font make_brep_font_from_file(const char* font_path, double size, int face_id) {
    clear_error();
    if (!font_path || !*font_path) { set_error("null or empty font path", 2); return nullptr; }
    if (size < Precision::Confusion()) { set_error("non-positive font size", 2); return nullptr; }
    try {
        BRepFontHandle* h = new BRepFontHandle;
        *h = new StdPrs_BRepFont;
        if (!(*h)->Init(NCollection_String(font_path), size, face_id)) {
            delete h;
            set_error("failed to load font from path");
            return nullptr;
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_brep_font make_brep_font_from_name(const char* font_name, int font_aspect, double size) {
    clear_error();
    if (!font_name || !*font_name) { set_error("null or empty font name", 2); return nullptr; }
    if (size < Precision::Confusion()) { set_error("non-positive font size", 2); return nullptr; }
    try {
        BRepFontHandle* h = new BRepFontHandle;
        *h = StdPrs_BRepFont::FindAndCreate(
            TCollection_AsciiString(font_name),
            static_cast<Font_FontAspect>(font_aspect),
            size,
            Font_StrictLevel_Any);
        if (h->IsNull()) { delete h; set_error("font not found by name"); return nullptr; }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void free_brep_font(occt_brep_font font) {
    if (font) {
        delete static_cast<BRepFontHandle*>(font);
    }
}

occt_shape make_text_shape(occt_brep_font font, const char* text, int h_align, int v_align) {
    return make_text_shape_on_plane(font, text, h_align, v_align, 0, 0, 0, 0, 0, 1);
}

occt_shape make_text_shape_on_plane(occt_brep_font font, const char* text, int h_align, int v_align,
                                     double px, double py, double pz,
                                     double zx, double zy, double zz) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    if (!text || !*text) { set_error("null or empty text", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        StdPrs_BRepTextBuilder builder;
        gp_Pnt pnt(px, py, pz);
        gp_Dir zDir(zx, zy, zz);
        gp_Ax3 ax3(pnt, zDir);
        TopoDS_Shape result = builder.Perform(
            *hFont,
            NCollection_String(text),
            ax3,
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        if (result.IsNull()) { set_error("text rendering produced null shape"); return nullptr; }
        if (is_empty_shape(result)) { set_error("text rendering produced empty shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_text_shape_on_plane_full(occt_brep_font font, const char* text, int h_align, int v_align,
                                          double px, double py, double pz,
                                          double zx, double zy, double zz,
                                          double xx, double xy, double xz) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    if (!text || !*text) { set_error("null or empty text", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        StdPrs_BRepTextBuilder builder;
        gp_Pnt pnt(px, py, pz);
        gp_Dir zDir(zx, zy, zz);
        gp_Dir xDir(xx, xy, xz);
        gp_Ax3 ax3(pnt, zDir, xDir);
        TopoDS_Shape result = builder.Perform(
            *hFont,
            NCollection_String(text),
            ax3,
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        if (result.IsNull()) { set_error("text rendering produced null shape"); return nullptr; }
        if (is_empty_shape(result)) { set_error("text rendering produced empty shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void text_bounding_box(occt_brep_font font, const char* text,
                       int h_align, int v_align,
                       double* out_width, double* out_height) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    if (!text || !*text) { set_error("null or empty text", 2); *out_width = 0; *out_height = 0; return; }
    if (!out_width || !out_height) { set_error("null output pointer", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        const occ::handle<Font_FTFont>& ftFont = hFont->FTFont();
        Font_Rect box = ftFont->BoundingBox(NCollection_String(text),
            static_cast<Graphic3d_HorizontalTextAlignment>(h_align),
            static_cast<Graphic3d_VerticalTextAlignment>(v_align));
        *out_width = static_cast<double>(box.Width());
        *out_height = static_cast<double>(box.Height());
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

const char* enumerate_fonts(void) {
    clear_error();
    try {
        static std::string result;
        result.clear();
        Handle(Font_FontMgr) mgr = Font_FontMgr::GetInstance();
        if (mgr.IsNull()) { set_error("Font_FontMgr returned null"); return nullptr; }
        NCollection_Sequence<Handle(TCollection_HAsciiString)> fontsNames;
        mgr->GetAvailableFontsNames(fontsNames);
        result = "[";
        for (int i = 1; i <= fontsNames.Size(); ++i) {
            if (i > 1) result += ",";
            result += "\"";
            Handle(TCollection_HAsciiString) name = fontsNames.Value(i);
            if (!name.IsNull()) {
                result += name->String().ToCString();
            }
            result += "\"";
        }
        result += "]";
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

const char* query_font_info(const char* font_name) {
    clear_error();
    try {
        static std::string result;
        result.clear();
        if (!font_name || !*font_name) { set_error("null or empty font name", 2); return nullptr; }
        Handle(Font_FontMgr) mgr = Font_FontMgr::GetInstance();
        if (mgr.IsNull()) { set_error("Font_FontMgr returned null", 2); return nullptr; }
        Handle(Font_SystemFont) font = mgr->GetFont(TCollection_AsciiString(font_name));
        if (font.IsNull()) { set_error("font not found", 2); return nullptr; }
        result = "{\"name\":\"";
        result += font->FontName().ToCString();
        result += "\",\"key\":\"";
        result += font->FontKey().ToCString();
        result += "\"}";
        return result.c_str();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void* ais_text_label_create(const char* text) {
    clear_error();
    try {
        Handle(AIS_TextLabel)* h = new Handle(AIS_TextLabel);
        *h = new AIS_TextLabel();
        if (text && *text) {
            (*h)->SetText(TCollection_ExtendedString(text));
        }
        return h;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

void ais_text_label_free(void* label) {
    if (label) {
        delete static_cast<Handle(AIS_TextLabel)*>(label);
    }
}

void ais_text_label_set_text(void* label, const char* text) {
    if (!label) { set_error("null label argument", 2); return; }
    if (!text) { set_error("null text argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetText(TCollection_ExtendedString(text));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_position(void* label, double x, double y, double z) {
    if (!label) { set_error("null label argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetPosition(gp_Pnt(x, y, z));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_color(void* label, double r, double g, double b) {
    if (!label) { set_error("null label argument", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetColor(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_font(void* label, const char* font_name, double height) {
    if (!label) { set_error("null label argument", 2); return; }
    if (!font_name || !*font_name) { set_error("null or empty font name", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetFont(font_name);
        if (height > Precision::Confusion()) {
            (*h)->SetHeight(height);
        }
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_height(void* label, double height) {
    if (!label) { set_error("null label argument", 2); return; }
    if (height < Precision::Confusion()) { set_error("non-positive height", 2); return; }
    try {
        auto* h = static_cast<Handle(AIS_TextLabel)*>(label);
        (*h)->SetHeight(height);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_angle(void* label_ptr, double rad) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetAngle(rad);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_hjustification(void* label_ptr, int align) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetHJustification(static_cast<Graphic3d_HorizontalTextAlignment>(align));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_vjustification(void* label_ptr, int align) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetVJustification(static_cast<Graphic3d_VerticalTextAlignment>(align));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_color_sub_title(void* label_ptr, double r, double g, double b) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetColorSubTitle(Quantity_Color(r, g, b, Quantity_TOC_RGB));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void ais_text_label_set_display_type(void* label_ptr, int type) {
    clear_error();
    if (!label_ptr) { set_error("null label argument", 2); return; }
    try {
        auto* label = static_cast<Handle(AIS_TextLabel)*>(label_ptr);
        (*label)->SetDisplayType(static_cast<Aspect_TypeOfDisplayText>(type));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

occt_shape font_render_glyph(occt_brep_font font, unsigned int codepoint) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return nullptr; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        TopoDS_Shape result = hFont->RenderGlyph(codepoint);
        if (result.IsNull()) { set_error("glyph rendering produced null shape"); return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

double font_ascender(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->Ascender();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_descender(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->Descender();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_line_spacing(occt_brep_font font) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->LineSpacing();
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_advance_x(occt_brep_font font, unsigned int c1, unsigned int c2) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->AdvanceX(c1, c2);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

double font_advance_y(occt_brep_font font, unsigned int c1, unsigned int c2) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return 0; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        return hFont->AdvanceY(c1, c2);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

void font_set_width_scaling(occt_brep_font font, double scale) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    if (scale < Precision::Confusion()) { set_error("non-positive width scale", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        hFont->SetWidthScaling(static_cast<float>(scale));
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}

void font_set_composite_curve_mode(occt_brep_font font, int on) {
    clear_error();
    if (!font) { set_error("null font argument", 2); return; }
    try {
        BRepFontHandle& hFont = *static_cast<BRepFontHandle*>(font);
        hFont->SetCompositeCurveMode(on != 0);
    } catch (Standard_Failure& e) {
        set_error(e.what());
    }
}


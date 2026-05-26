#include "occt_wrap_internal.h"
#include "occt_wrap_graphic3d.h"

void* graphic3d_clip_plane_new(double a, double b, double c, double d) {
    clear_error();
    try {
        gp_Pln plane(a, b, c, d);
        return (void*)new Handle(Graphic3d_ClipPlane)(new Graphic3d_ClipPlane(plane));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_clip_plane_free(void* p) {
    clear_error();
    if (!p) return;
    delete static_cast<Handle(Graphic3d_ClipPlane)*>(p);
}

void graphic3d_clip_plane_set_equation(void* p, double a, double b, double c, double d) {
    clear_error();
    if (!p) return;
    try {
        gp_Pln plane(a, b, c, d);
        (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->SetEquation(plane);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_clip_plane_get_equation(void* p, double* a, double* b, double* c, double* d) {
    clear_error();
    if (!p || !a || !b || !c || !d) return;
    try {
        const NCollection_Vec4<double>& eq = (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->GetEquation();
        *a = eq.x(); *b = eq.y(); *c = eq.z(); *d = eq.w();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_clip_plane_set_on(void* p, int on) {
    clear_error();
    if (!p) return;
    (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->SetOn(on != 0);
}

int graphic3d_clip_plane_is_on(void* p) {
    clear_error();
    if (!p) return 0;
    return (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->IsOn() ? 1 : 0;
}

void graphic3d_clip_plane_set_capping(void* p, int on) {
    clear_error();
    if (!p) return;
    (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->SetCapping(on != 0);
}

void graphic3d_clip_plane_set_cap_color(void* p, double r, double g, double b) {
    clear_error();
    if (!p) return;
    (*static_cast<Handle(Graphic3d_ClipPlane)*>(p))->SetCappingColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
}

void* graphic3d_shader_program_new() {
    clear_error();
    try {
        return (void*)new Handle(Graphic3d_ShaderProgram)(new Graphic3d_ShaderProgram());
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_shader_program_free(void* p) {
    clear_error();
    if (!p) return;
    delete static_cast<Handle(Graphic3d_ShaderProgram)*>(p);
}

void graphic3d_shader_program_set_vertex_source(void* p, const char* src) {
    clear_error();
    if (!p || !src) return;
    try {
        Handle(Graphic3d_ShaderObject) obj = Graphic3d_ShaderObject::CreateFromSource(
            Graphic3d_TOS_VERTEX, TCollection_AsciiString(src));
        (*static_cast<Handle(Graphic3d_ShaderProgram)*>(p))->AttachShader(obj);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_shader_program_set_fragment_source(void* p, const char* src) {
    clear_error();
    if (!p || !src) return;
    try {
        Handle(Graphic3d_ShaderObject) obj = Graphic3d_ShaderObject::CreateFromSource(
            Graphic3d_TOS_FRAGMENT, TCollection_AsciiString(src));
        (*static_cast<Handle(Graphic3d_ShaderProgram)*>(p))->AttachShader(obj);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_shader_program_set_header(void* p, const char* hdr) {
    clear_error();
    if (!p || !hdr) return;
    try {
        (*static_cast<Handle(Graphic3d_ShaderProgram)*>(p))->SetHeader(TCollection_AsciiString(hdr));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void* graphic3d_aspect_fill_area_new(int interior, double r, double g, double b,
                                       double er, double eg, double eb, int edge_line_type,
                                       double edge_width) {
    clear_error();
    try {
        Quantity_Color color(r, g, b, Quantity_TOC_sRGB);
        Quantity_Color edgeColor(er, eg, eb, Quantity_TOC_sRGB);
        Graphic3d_MaterialAspect frontMat(Graphic3d_NOM_DEFAULT);
        Graphic3d_MaterialAspect backMat(Graphic3d_NOM_DEFAULT);
        return (void*)new Handle(Graphic3d_AspectFillArea3d)(
            new Graphic3d_AspectFillArea3d(
                static_cast<Aspect_InteriorStyle>(interior),
                color, edgeColor, static_cast<Aspect_TypeOfLine>(edge_line_type),
                edge_width, frontMat, backMat));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_aspect_fill_area_free(void* a) {
    clear_error();
    if (!a) return;
    delete static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
}

void graphic3d_aspect_fill_area_set_interior_color(void* a, double r, double g, double b) {
    clear_error();
    if (!a) return;
    try {
        Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
        h->SetInteriorColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_fill_area_get_interior_color(void* a, double* r, double* g, double* b) {
    clear_error();
    if (!a || !r || !g || !b) return;
    try {
        Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
        Quantity_Color c = h->InteriorColor();
        *r = c.Red(); *g = c.Green(); *b = c.Blue();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_fill_area_set_edge_color(void* a, double r, double g, double b) {
    clear_error();
    if (!a) return;
    try {
        Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
        h->SetEdgeColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_fill_area_get_edge_color(void* a, double* r, double* g, double* b) {
    clear_error();
    if (!a || !r || !g || !b) return;
    try {
        Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
        Quantity_Color c = h->EdgeColor();
        *r = c.Red(); *g = c.Green(); *b = c.Blue();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

int graphic3d_aspect_fill_area_get_interior_style(void* a) {
    clear_error();
    if (!a) return 0;
    Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(a);
    return static_cast<int>(h->InteriorStyle());
}

void* graphic3d_aspect_line_new(double r, double g, double b, int line_type, double width) {
    clear_error();
    try {
        Quantity_Color color(r, g, b, Quantity_TOC_sRGB);
        return (void*)new Handle(Graphic3d_AspectLine3d)(
            new Graphic3d_AspectLine3d(color, static_cast<Aspect_TypeOfLine>(line_type), width));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_aspect_line_free(void* a) {
    clear_error();
    if (!a) return;
    delete static_cast<Handle(Graphic3d_AspectLine3d)*>(a);
}

void graphic3d_aspect_line_set_color(void* a, double r, double g, double b) {
    clear_error();
    if (!a) return;
    try {
        Handle(Graphic3d_AspectLine3d)& h = *static_cast<Handle(Graphic3d_AspectLine3d)*>(a);
        h->SetColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_line_get_color(void* a, double* r, double* g, double* b) {
    clear_error();
    if (!a || !r || !g || !b) return;
    try {
        Handle(Graphic3d_AspectLine3d)& h = *static_cast<Handle(Graphic3d_AspectLine3d)*>(a);
        const Quantity_Color& c = h->Color();
        *r = c.Red(); *g = c.Green(); *b = c.Blue();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

int graphic3d_aspect_line_get_type(void* a) {
    clear_error();
    if (!a) return 0;
    Handle(Graphic3d_AspectLine3d)& h = *static_cast<Handle(Graphic3d_AspectLine3d)*>(a);
    return static_cast<int>(h->Type());
}

double graphic3d_aspect_line_get_width(void* a) {
    clear_error();
    if (!a) return 0.0;
    Handle(Graphic3d_AspectLine3d)& h = *static_cast<Handle(Graphic3d_AspectLine3d)*>(a);
    return h->Width();
}

void* graphic3d_aspect_marker_new(int marker_type, double r, double g, double b, double scale) {
    clear_error();
    try {
        Quantity_Color color(r, g, b, Quantity_TOC_sRGB);
        return (void*)new Handle(Graphic3d_AspectMarker3d)(
            new Graphic3d_AspectMarker3d(
                static_cast<Aspect_TypeOfMarker>(marker_type), color, scale));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_aspect_marker_free(void* a) {
    clear_error();
    if (!a) return;
    delete static_cast<Handle(Graphic3d_AspectMarker3d)*>(a);
}

void graphic3d_aspect_marker_set_color(void* a, double r, double g, double b) {
    clear_error();
    if (!a) return;
    try {
        Handle(Graphic3d_AspectMarker3d)& h = *static_cast<Handle(Graphic3d_AspectMarker3d)*>(a);
        h->SetColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_marker_get_color(void* a, double* r, double* g, double* b) {
    clear_error();
    if (!a || !r || !g || !b) return;
    try {
        Handle(Graphic3d_AspectMarker3d)& h = *static_cast<Handle(Graphic3d_AspectMarker3d)*>(a);
        const Quantity_Color& c = h->Color();
        *r = c.Red(); *g = c.Green(); *b = c.Blue();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

int graphic3d_aspect_marker_get_type(void* a) {
    clear_error();
    if (!a) return 0;
    Handle(Graphic3d_AspectMarker3d)& h = *static_cast<Handle(Graphic3d_AspectMarker3d)*>(a);
    return static_cast<int>(h->Type());
}

double graphic3d_aspect_marker_get_scale(void* a) {
    clear_error();
    if (!a) return 0.0;
    Handle(Graphic3d_AspectMarker3d)& h = *static_cast<Handle(Graphic3d_AspectMarker3d)*>(a);
    return h->Scale();
}

void* graphic3d_aspect_text_new(double r, double g, double b, const char* font, int style) {
    clear_error();
    if (!font) { set_error("null font", 2); return nullptr; }
    try {
        Quantity_Color color(r, g, b, Quantity_TOC_sRGB);
        return (void*)new Handle(Graphic3d_AspectText3d)(
            new Graphic3d_AspectText3d(color, font, 1.0, 0.0,
                static_cast<Aspect_TypeOfStyleText>(style)));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_aspect_text_free(void* a) {
    clear_error();
    if (!a) return;
    delete static_cast<Handle(Graphic3d_AspectText3d)*>(a);
}

void graphic3d_aspect_text_set_color(void* a, double r, double g, double b) {
    clear_error();
    if (!a) return;
    try {
        Handle(Graphic3d_AspectText3d)& h = *static_cast<Handle(Graphic3d_AspectText3d)*>(a);
        h->SetColor(Quantity_Color(r, g, b, Quantity_TOC_sRGB));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_aspect_text_get_color(void* a, double* r, double* g, double* b) {
    clear_error();
    if (!a || !r || !g || !b) return;
    try {
        Handle(Graphic3d_AspectText3d)& h = *static_cast<Handle(Graphic3d_AspectText3d)*>(a);
        const Quantity_Color& c = h->Color();
        *r = c.Red(); *g = c.Green(); *b = c.Blue();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

const char* graphic3d_aspect_text_get_font(void* a) {
    clear_error();
    if (!a) return nullptr;
    try {
        Handle(Graphic3d_AspectText3d)& h = *static_cast<Handle(Graphic3d_AspectText3d)*>(a);
        const TCollection_AsciiString& font = h->Font();
        return font.ToCString();
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

int graphic3d_aspect_text_get_style(void* a) {
    clear_error();
    if (!a) return 0;
    Handle(Graphic3d_AspectText3d)& h = *static_cast<Handle(Graphic3d_AspectText3d)*>(a);
    return static_cast<int>(h->Style());
}

void* graphic3d_structure_new(void* viewer_ptr) {
    clear_error();
    if (!viewer_ptr) { set_error("null viewer", 2); return nullptr; }
    try {
        Handle(V3d_Viewer)& viewer = *static_cast<Handle(V3d_Viewer)*>(viewer_ptr);
        Handle(Graphic3d_StructureManager) mgr = viewer->StructureManager();
        return (void*)new Handle(Graphic3d_Structure)(new Graphic3d_Structure(mgr));
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_structure_free(void* s) {
    clear_error();
    if (!s) return;
    delete static_cast<Handle(Graphic3d_Structure)*>(s);
}

void graphic3d_structure_set_visible(void* s, int visible) {
    clear_error();
    if (!s) return;
    try {
        (*static_cast<Handle(Graphic3d_Structure)*>(s))->SetVisible(visible != 0);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_set_transform(void* s, double* mat16) {
    clear_error();
    if (!s || !mat16) return;
    try {
        gp_Trsf trsf;
        trsf.SetValues(mat16[0], mat16[1], mat16[2], mat16[3],
                        mat16[4], mat16[5], mat16[6], mat16[7],
                        mat16[8], mat16[9], mat16[10], mat16[11]);
        Handle(TopLoc_Datum3D) datum = new TopLoc_Datum3D(trsf);
        (*static_cast<Handle(Graphic3d_Structure)*>(s))->SetTransformation(datum);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_remove_transform(void* s) {
    clear_error();
    if (!s) return;
    try {
        (*static_cast<Handle(Graphic3d_Structure)*>(s))->SetTransformation(nullptr);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_add_child(void* parent, void* child) {
    clear_error();
    if (!parent || !child) return;
    try {
        (*static_cast<Handle(Graphic3d_Structure)*>(parent))->Connect(
            *static_cast<Handle(Graphic3d_Structure)*>(child));
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_remove_child(void* parent, void* child) {
    clear_error();
    if (!parent || !child) return;
    try {
        Handle(Graphic3d_Structure)& hChild = *static_cast<Handle(Graphic3d_Structure)*>(child);
        (*static_cast<Handle(Graphic3d_Structure)*>(parent))->Disconnect(hChild.get());
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_display(void* s) {
    clear_error();
    if (!s) return;
    try {
        (*static_cast<Handle(Graphic3d_Structure)*>(s))->Display();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_structure_erase(void* s) {
    clear_error();
    if (!s) return;
    try {
        (*static_cast<Handle(Graphic3d_Structure)*>(s))->Remove();
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void* graphic3d_group_new(void* struct_ptr) {
    clear_error();
    if (!struct_ptr) { set_error("null structure", 2); return nullptr; }
    try {
        Handle(Graphic3d_Structure)& gs = *static_cast<Handle(Graphic3d_Structure)*>(struct_ptr);
        return (void*)new Handle(Graphic3d_Group)(gs->NewGroup());
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_group_free(void* g) {
    clear_error();
    if (!g) return;
    delete static_cast<Handle(Graphic3d_Group)*>(g);
}

void graphic3d_group_set_visible(void* g, int visible) {
    clear_error();
    if (!g) return;
    (void)visible;
}

void graphic3d_group_add_triangles(void* g, float* verts, const float* norms, int count) {
    clear_error();
    if (!g || !verts) return;
    try {
        Handle(Graphic3d_ArrayOfTriangles) arr = new Graphic3d_ArrayOfTriangles(count, norms != nullptr, false);
        for (int i = 0; i < count; i++) {
            int i3 = i * 3;
            if (norms) {
                arr->AddVertex(verts[i3], verts[i3+1], verts[i3+2],
                               norms[i3], norms[i3+1], norms[i3+2]);
            } else {
                arr->AddVertex(verts[i3], verts[i3+1], verts[i3+2]);
            }
        }
        (*static_cast<Handle(Graphic3d_Group)*>(g))->AddPrimitiveArray(arr);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_group_add_lines(void* g, float* verts, int count) {
    clear_error();
    if (!g || !verts) return;
    try {
        Handle(Graphic3d_ArrayOfSegments) arr = new Graphic3d_ArrayOfSegments(count);
        for (int i = 0; i < count; i++) {
            int i3 = i * 3;
            arr->AddVertex(verts[i3], verts[i3+1], verts[i3+2]);
        }
        (*static_cast<Handle(Graphic3d_Group)*>(g))->AddPrimitiveArray(arr);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_group_add_points(void* g, float* verts, int count) {
    clear_error();
    if (!g || !verts) return;
    try {
        Handle(Graphic3d_ArrayOfPoints) arr = new Graphic3d_ArrayOfPoints(count);
        for (int i = 0; i < count; i++) {
            int i3 = i * 3;
            arr->AddVertex(verts[i3], verts[i3+1], verts[i3+2]);
        }
        (*static_cast<Handle(Graphic3d_Group)*>(g))->AddPrimitiveArray(arr);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_group_add_text(void* g, const char* text, double x, double y, double z) {
    clear_error();
    if (!g || !text) return;
    try {
        Handle(Graphic3d_Text) textParams = new Graphic3d_Text(1.0f);
        textParams->SetText(TCollection_AsciiString(text));
        textParams->SetPosition(gp_Pnt(x, y, z));
        (*static_cast<Handle(Graphic3d_Group)*>(g))->AddText(textParams, false);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_group_set_aspect(void* g, void* aspect) {
    clear_error();
    if (!g || !aspect) return;
    try {
        Handle(Graphic3d_AspectFillArea3d)& h = *static_cast<Handle(Graphic3d_AspectFillArea3d)*>(aspect);
        (*static_cast<Handle(Graphic3d_Group)*>(g))->SetPrimitivesAspect(h);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void graphic3d_group_set_line_aspect(void* g, void* aspect) {
    clear_error();
    if (!g || !aspect) return;
    try {
        Handle(Graphic3d_AspectLine3d)& h = *static_cast<Handle(Graphic3d_AspectLine3d)*>(aspect);
        (*static_cast<Handle(Graphic3d_Group)*>(g))->SetPrimitivesAspect(h);
    } catch (Standard_Failure& e) { set_error(e.what()); }
}

void* graphic3d_view_rendering_params(void* view_ptr) {
    clear_error();
    if (!view_ptr) return nullptr;
    try {
        Handle(V3d_View)& view = *static_cast<Handle(V3d_View)*>(view_ptr);
        return &view->ChangeRenderingParams();
    } catch (Standard_Failure& e) { set_error(e.what()); return nullptr; }
}

void graphic3d_rendering_params_set_method(void* p, int method) {
    if (!p) return;
    static_cast<Graphic3d_RenderingParams*>(p)->Method =
        static_cast<Graphic3d_RenderingMode>(method);
}

int graphic3d_rendering_params_get_method(void* p) {
    if (!p) return 0;
    return static_cast<int>(static_cast<Graphic3d_RenderingParams*>(p)->Method);
}

void graphic3d_rendering_params_set_raytracing_depth(void* p, int depth) {
    if (!p) return;
    static_cast<Graphic3d_RenderingParams*>(p)->RaytracingDepth = depth;
}

int graphic3d_rendering_params_get_raytracing_depth(void* p) {
    if (!p) return 0;
    return static_cast<Graphic3d_RenderingParams*>(p)->RaytracingDepth;
}

void graphic3d_rendering_params_set_shadows(void* p, int on) {
    if (!p) return;
    static_cast<Graphic3d_RenderingParams*>(p)->IsShadowEnabled = (on != 0);
}

int graphic3d_rendering_params_get_shadows(void* p) {
    if (!p) return 0;
    return static_cast<Graphic3d_RenderingParams*>(p)->IsShadowEnabled ? 1 : 0;
}

void graphic3d_rendering_params_set_reflections(void* p, int on) {
    if (!p) return;
    static_cast<Graphic3d_RenderingParams*>(p)->IsReflectionEnabled = (on != 0);
}

int graphic3d_rendering_params_get_reflections(void* p) {
    if (!p) return 0;
    return static_cast<Graphic3d_RenderingParams*>(p)->IsReflectionEnabled ? 1 : 0;
}

void graphic3d_rendering_params_set_antialiasing(void* p, int on) {
    if (!p) return;
    static_cast<Graphic3d_RenderingParams*>(p)->IsAntialiasingEnabled = (on != 0);
}

int graphic3d_rendering_params_get_antialiasing(void* p) {
    if (!p) return 0;
    return static_cast<Graphic3d_RenderingParams*>(p)->IsAntialiasingEnabled ? 1 : 0;
}


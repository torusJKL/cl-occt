(in-package :cl-occt.impl)

;; --- Graphic3d_ClipPlane ---

(defcfun (%graphic3d-clip-plane-new "graphic3d_clip_plane_new") :pointer
  (a :double) (b :double) (c :double) (d :double))

(defcfun (%graphic3d-clip-plane-free "graphic3d_clip_plane_free") :void
  (p :pointer))

(defcfun (%graphic3d-clip-plane-set-equation "graphic3d_clip_plane_set_equation") :void
  (p :pointer) (a :double) (b :double) (c :double) (d :double))

(defcfun (%graphic3d-clip-plane-get-equation "graphic3d_clip_plane_get_equation") :void
  (p :pointer) (a :pointer) (b :pointer) (c :pointer) (d :pointer))

(defcfun (%graphic3d-clip-plane-set-on "graphic3d_clip_plane_set_on") :void
  (p :pointer) (on :int))

(defcfun (%graphic3d-clip-plane-is-on "graphic3d_clip_plane_is_on") :int
  (p :pointer))

(defcfun (%graphic3d-clip-plane-set-capping "graphic3d_clip_plane_set_capping") :void
  (p :pointer) (on :int))

(defcfun (%graphic3d-clip-plane-set-cap-color "graphic3d_clip_plane_set_cap_color") :void
  (p :pointer) (r :double) (g :double) (b :double))

;; --- Graphic3d_ShaderProgram ---

(defcfun (%graphic3d-shader-program-new "graphic3d_shader_program_new") :pointer)

(defcfun (%graphic3d-shader-program-free "graphic3d_shader_program_free") :void
  (p :pointer))

(defcfun (%graphic3d-shader-program-set-vertex-source "graphic3d_shader_program_set_vertex_source") :void
  (p :pointer) (src :string))

(defcfun (%graphic3d-shader-program-set-fragment-source "graphic3d_shader_program_set_fragment_source") :void
  (p :pointer) (src :string))

(defcfun (%graphic3d-shader-program-set-header "graphic3d_shader_program_set_header") :void
  (p :pointer) (hdr :string))

;; --- Graphic3d_AspectFillArea3d ---

(defcfun (%graphic3d-aspect-fill-area-new "graphic3d_aspect_fill_area_new") :pointer
  (interior :int) (r :double) (g :double) (b :double)
  (er :double) (eg :double) (eb :double) (edge-line-type :int) (edge-width :double))

(defcfun (%graphic3d-aspect-fill-area-free "graphic3d_aspect_fill_area_free") :void
  (a :pointer))

(defcfun (%graphic3d-aspect-fill-area-set-interior-color "graphic3d_aspect_fill_area_set_interior_color") :void
  (a :pointer) (r :double) (g :double) (b :double))

(defcfun (%graphic3d-aspect-fill-area-get-interior-color "graphic3d_aspect_fill_area_get_interior_color") :void
  (a :pointer) (r :pointer) (g :pointer) (b :pointer))

(defcfun (%graphic3d-aspect-fill-area-set-edge-color "graphic3d_aspect_fill_area_set_edge_color") :void
  (a :pointer) (r :double) (g :double) (b :double))

(defcfun (%graphic3d-aspect-fill-area-get-edge-color "graphic3d_aspect_fill_area_get_edge_color") :void
  (a :pointer) (r :pointer) (g :pointer) (b :pointer))

(defcfun (%graphic3d-aspect-fill-area-get-interior-style "graphic3d_aspect_fill_area_get_interior_style") :int
  (a :pointer))

;; --- Graphic3d_AspectLine3d ---

(defcfun (%graphic3d-aspect-line-new "graphic3d_aspect_line_new") :pointer
  (r :double) (g :double) (b :double) (line-type :int) (width :double))

(defcfun (%graphic3d-aspect-line-free "graphic3d_aspect_line_free") :void
  (a :pointer))

(defcfun (%graphic3d-aspect-line-set-color "graphic3d_aspect_line_set_color") :void
  (a :pointer) (r :double) (g :double) (b :double))

(defcfun (%graphic3d-aspect-line-get-color "graphic3d_aspect_line_get_color") :void
  (a :pointer) (r :pointer) (g :pointer) (b :pointer))

(defcfun (%graphic3d-aspect-line-get-type "graphic3d_aspect_line_get_type") :int
  (a :pointer))

(defcfun (%graphic3d-aspect-line-get-width "graphic3d_aspect_line_get_width") :double
  (a :pointer))

;; --- Graphic3d_AspectMarker3d ---

(defcfun (%graphic3d-aspect-marker-new "graphic3d_aspect_marker_new") :pointer
  (marker-type :int) (r :double) (g :double) (b :double) (scale :double))

(defcfun (%graphic3d-aspect-marker-free "graphic3d_aspect_marker_free") :void
  (a :pointer))

(defcfun (%graphic3d-aspect-marker-set-color "graphic3d_aspect_marker_set_color") :void
  (a :pointer) (r :double) (g :double) (b :double))

(defcfun (%graphic3d-aspect-marker-get-color "graphic3d_aspect_marker_get_color") :void
  (a :pointer) (r :pointer) (g :pointer) (b :pointer))

(defcfun (%graphic3d-aspect-marker-get-type "graphic3d_aspect_marker_get_type") :int
  (a :pointer))

(defcfun (%graphic3d-aspect-marker-get-scale "graphic3d_aspect_marker_get_scale") :double
  (a :pointer))

;; --- Graphic3d_AspectText3d ---

(defcfun (%graphic3d-aspect-text-new "graphic3d_aspect_text_new") :pointer
  (r :double) (g :double) (b :double) (font :string) (style :int))

(defcfun (%graphic3d-aspect-text-free "graphic3d_aspect_text_free") :void
  (a :pointer))

(defcfun (%graphic3d-aspect-text-set-color "graphic3d_aspect_text_set_color") :void
  (a :pointer) (r :double) (g :double) (b :double))

(defcfun (%graphic3d-aspect-text-get-color "graphic3d_aspect_text_get_color") :void
  (a :pointer) (r :pointer) (g :pointer) (b :pointer))

(defcfun (%graphic3d-aspect-text-get-font "graphic3d_aspect_text_get_font") :string
  (a :pointer))

(defcfun (%graphic3d-aspect-text-get-style "graphic3d_aspect_text_get_style") :int
  (a :pointer))

;; --- Graphic3d_Structure ---

(defcfun (%graphic3d-structure-new "graphic3d_structure_new") :pointer
  (driver-ptr :pointer))

(defcfun (%graphic3d-structure-free "graphic3d_structure_free") :void
  (s :pointer))

(defcfun (%graphic3d-structure-set-visible "graphic3d_structure_set_visible") :void
  (s :pointer) (visible :int))

(defcfun (%graphic3d-structure-set-transform "graphic3d_structure_set_transform") :void
  (s :pointer) (mat16 :pointer))

(defcfun (%graphic3d-structure-remove-transform "graphic3d_structure_remove_transform") :void
  (s :pointer))

(defcfun (%graphic3d-structure-add-child "graphic3d_structure_add_child") :void
  (parent :pointer) (child :pointer))

(defcfun (%graphic3d-structure-remove-child "graphic3d_structure_remove_child") :void
  (parent :pointer) (child :pointer))

(defcfun (%graphic3d-structure-display "graphic3d_structure_display") :void
  (s :pointer))

(defcfun (%graphic3d-structure-erase "graphic3d_structure_erase") :void
  (s :pointer))

;; --- Graphic3d_Group ---

(defcfun (%graphic3d-group-new "graphic3d_group_new") :pointer
  (struct-ptr :pointer))

(defcfun (%graphic3d-group-free "graphic3d_group_free") :void
  (g :pointer))

(defcfun (%graphic3d-group-set-visible "graphic3d_group_set_visible") :void
  (g :pointer) (visible :int))

(defcfun (%graphic3d-group-add-triangles "graphic3d_group_add_triangles") :void
  (g :pointer) (verts :pointer) (norms :pointer) (count :int))

(defcfun (%graphic3d-group-add-lines "graphic3d_group_add_lines") :void
  (g :pointer) (verts :pointer) (count :int))

(defcfun (%graphic3d-group-add-points "graphic3d_group_add_points") :void
  (g :pointer) (verts :pointer) (count :int))

(defcfun (%graphic3d-group-add-text "graphic3d_group_add_text") :void
  (g :pointer) (text :string) (x :double) (y :double) (z :double))

(defcfun (%graphic3d-group-set-aspect "graphic3d_group_set_aspect") :void
  (g :pointer) (aspect :pointer))

(defcfun (%graphic3d-group-set-line-aspect "graphic3d_group_set_line_aspect") :void
  (g :pointer) (aspect :pointer))

;; --- Graphic3d_RenderingParams ---

(defcfun (%graphic3d-view-rendering-params "graphic3d_view_rendering_params") :pointer
  (view-ptr :pointer))

(defcfun (%graphic3d-rendering-params-set-method "graphic3d_rendering_params_set_method") :void
  (p :pointer) (method :int))

(defcfun (%graphic3d-rendering-params-get-method "graphic3d_rendering_params_get_method") :int
  (p :pointer))

(defcfun (%graphic3d-rendering-params-set-raytracing-depth "graphic3d_rendering_params_set_raytracing_depth") :void
  (p :pointer) (depth :int))

(defcfun (%graphic3d-rendering-params-get-raytracing-depth "graphic3d_rendering_params_get_raytracing_depth") :int
  (p :pointer))

(defcfun (%graphic3d-rendering-params-set-shadows "graphic3d_rendering_params_set_shadows") :void
  (p :pointer) (on :int))

(defcfun (%graphic3d-rendering-params-get-shadows "graphic3d_rendering_params_get_shadows") :int
  (p :pointer))

(defcfun (%graphic3d-rendering-params-set-reflections "graphic3d_rendering_params_set_reflections") :void
  (p :pointer) (on :int))

(defcfun (%graphic3d-rendering-params-get-reflections "graphic3d_rendering_params_get_reflections") :int
  (p :pointer))

(defcfun (%graphic3d-rendering-params-set-antialiasing "graphic3d_rendering_params_set_antialiasing") :void
  (p :pointer) (on :int))

(defcfun (%graphic3d-rendering-params-get-antialiasing "graphic3d_rendering_params_get_antialiasing") :int
  (p :pointer))

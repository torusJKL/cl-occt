(in-package :cl-occt.impl)

;; --- Text Label Enhancements ---

(defcfun (%ais-text-label-set-hjustification "ais_text_label_set_hjustification") :void
  (label :pointer) (align :int))

(defcfun (%ais-text-label-set-vjustification "ais_text_label_set_vjustification") :void
  (label :pointer) (align :int))

(defcfun (%ais-text-label-set-color-sub-title "ais_text_label_set_color_sub_title") :void
  (label :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-text-label-set-display-type "ais_text_label_set_display_type") :void
  (label :pointer) (type :int))

(defcfun (%ais-text-label-set-angle "ais_text_label_set_angle") :void
  (label :pointer) (rad :double))

;; --- Font & Text ---

(defcfun (%make-brep-font-from-file "make_brep_font_from_file") :pointer
  (font-path :string)
  (size :double)
  (face-id :int))

(defcfun (%make-brep-font-from-name "make_brep_font_from_name") :pointer
  (font-name :string)
  (font-aspect :int)
  (size :double))

(defcfun (%free-brep-font "free_brep_font") :void
  (font :pointer))

(defcfun (%make-text-shape "make_text_shape") :pointer
  (font :pointer)
  (text :string)
  (h-align :int)
  (v-align :int))

(defcfun (%make-text-shape-on-plane "make_text_shape_on_plane") :pointer
  (font :pointer)
  (text :string)
  (h-align :int)
  (v-align :int)
  (px :double) (py :double) (pz :double)
  (zx :double) (zy :double) (zz :double))

(defcfun (%make-text-shape-on-plane-full "make_text_shape_on_plane_full") :pointer
  (font :pointer)
  (text :string)
  (h-align :int)
  (v-align :int)
  (px :double) (py :double) (pz :double)
  (zx :double) (zy :double) (zz :double)
  (xx :double) (xy :double) (xz :double))

(defcfun (%text-bounding-box "text_bounding_box") :void
  (font :pointer)
  (text :string)
  (h-align :int)
  (v-align :int)
  (out-width :pointer)
  (out-height :pointer))

(defcfun (%enumerate-fonts "enumerate_fonts") :pointer)

(defcfun (%query-font-info "query_font_info") :pointer
  (font-name :string))

(defcfun (%ais-text-label-create "ais_text_label_create") :pointer
  (text :string))

(defcfun (%ais-text-label-free "ais_text_label_free") :void
  (label :pointer))

(defcfun (%ais-text-label-set-text "ais_text_label_set_text") :void
  (label :pointer) (text :string))

(defcfun (%ais-text-label-set-position "ais_text_label_set_position") :void
  (label :pointer) (x :double) (y :double) (z :double))

(defcfun (%ais-text-label-set-color "ais_text_label_set_color") :void
  (label :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-text-label-set-font "ais_text_label_set_font") :void
  (label :pointer) (font-name :string) (height :double))

(defcfun (%ais-text-label-set-height "ais_text_label_set_height") :void
  (label :pointer) (height :double))

(defcfun (%font-render-glyph "font_render_glyph") :pointer
  (font :pointer) (codepoint :unsigned-int))

(defcfun (%font-ascender "font_ascender") :double
  (font :pointer))

(defcfun (%font-descender "font_descender") :double
  (font :pointer))

(defcfun (%font-line-spacing "font_line_spacing") :double
  (font :pointer))

(defcfun (%font-advance-x "font_advance_x") :double
  (font :pointer) (c1 :unsigned-int) (c2 :unsigned-int))

(defcfun (%font-advance-y "font_advance_y") :double
  (font :pointer) (c1 :unsigned-int) (c2 :unsigned-int))

(defcfun (%font-set-width-scaling "font_set_width_scaling") :void
  (font :pointer) (scale :double))

(defcfun (%font-set-composite-curve-mode "font_set_composite_curve_mode") :void
  (font :pointer) (on :int))

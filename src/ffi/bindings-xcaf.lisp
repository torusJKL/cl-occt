(in-package :cl-occt.impl)

;; --- XCAF Document Tools ---

(defcfun (%xcaf-new-doc "xcaf_new_doc") :int
  (out-doc :pointer))

(defcfun (%xcaf-free-doc "xcaf_free_doc") :void
  (doc :pointer))

(defcfun (%xcaf-save-shape-to-doc "xcaf_save_shape_to_doc") :int
  (doc :pointer)
  (shape :pointer))

(defcfun (%xcaf-set-layer "xcaf_set_layer") :int
  (doc :pointer)
  (shape :pointer)
  (layer :string))

(defcfun (%xcaf-unset-one-layer "xcaf_unset_one_layer") :int
  (doc :pointer)
  (shape :pointer)
  (layer :string))

(defcfun (%xcaf-unset-all-layers "xcaf_unset_all_layers") :int
  (doc :pointer)
  (shape :pointer))

(defcfun (%xcaf-get-layer-count "xcaf_get_layer_count") :int
  (doc :pointer)
  (shape :pointer))

(defcfun (%xcaf-has-material "xcaf_has_material") :int
  (doc :pointer)
  (shape :pointer))

(defcfun (%xcaf-add-view "xcaf_add_view") :int
  (doc :pointer))

(defcfun (%xcaf-get-view-count "xcaf_get_view_count") :int
  (doc :pointer))

(defcfun (%xcaf-get-visual-material-count "xcaf_get_visual_material_count") :int
  (doc :pointer))

(defcfun (%xcaf-get-visual-material "xcaf_get_visual_material") :int
  (doc :pointer)
  (shape :pointer)
  (out-r :pointer)
  (out-g :pointer)
  (out-b :pointer)
  (out-a :pointer))

(defcfun (%xcaf-get-clipping-plane-count "xcaf_get_clipping_plane_count") :int
  (doc :pointer))

(defcfun (%xcaf-expand-assembly "xcaf_expand_assembly") :int
  (doc :pointer))

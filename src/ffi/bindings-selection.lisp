(in-package :cl-occt.impl)

;; --- Selection iteration ---

(defcfun (%ais-context-nb-selected "ais_context_nb_selected") :int
  (ctx :pointer))

(defcfun (%ais-context-init-selected "ais_context_init_selected") :void
  (ctx :pointer))

(defcfun (%ais-context-more-selected "ais_context_more_selected") :int
  (ctx :pointer))

(defcfun (%ais-context-next-selected "ais_context_next_selected") :void
  (ctx :pointer))

(defcfun (%ais-context-selected-interactive "ais_context_selected_interactive") :pointer
  (ctx :pointer))

(defcfun (%ais-context-selected-shape "ais_context_selected_shape") :pointer
  (ctx :pointer))

(defcfun (%ais-context-has-selected-shape "ais_context_has_selected_shape") :int
  (ctx :pointer))

;; --- Selection management ---

(defcfun (%ais-context-set-selected "ais_context_set_selected") :void
  (ctx :pointer) (obj :pointer) (update :int))

(defcfun (%ais-context-add-or-remove-selected "ais_context_add_or_remove_selected") :void
  (ctx :pointer) (obj :pointer) (update :int))

(defcfun (%ais-context-clear-selected "ais_context_clear_selected") :void
  (ctx :pointer) (update :int))

(defcfun (%ais-context-is-selected "ais_context_is_selected") :int
  (ctx :pointer) (obj :pointer))

;; --- Mouse detection ---

(defcfun (%ais-context-move-to "ais_context_move_to") :int
  (ctx :pointer) (view :pointer) (x :int) (y :int))

(defcfun (%ais-context-select-detected "ais_context_select_detected") :int
  (ctx :pointer) (scheme :int))

(defcfun (%ais-context-select-point "ais_context_select_point") :int
  (ctx :pointer) (view :pointer) (x :int) (y :int) (scheme :int))

;; --- Highlight ---

(defcfun (%ais-context-hilight-selected "ais_context_hilight_selected") :void
  (ctx :pointer) (update :int))

(defcfun (%ais-context-unhilight-selected "ais_context_unhilight_selected") :void
  (ctx :pointer) (update :int))

;; --- Tier 2 ---

(defcfun (%ais-context-fit-selected "ais_context_fit_selected") :void
  (ctx :pointer) (view :pointer) (margin :double))

(defcfun (%ais-context-detected-interactive "ais_context_detected_interactive") :pointer
  (ctx :pointer))

(defcfun (%ais-context-has-detected "ais_context_has_detected") :int
  (ctx :pointer))

(defcfun (%ais-context-clear-detected "ais_context_clear_detected") :void
  (ctx :pointer))

(defcfun (%ais-context-set-selection-sensitivity "ais_context_set_selection_sensitivity") :void
  (ctx :pointer) (obj :pointer) (mode :int) (sensitivity :int))

(defcfun (%ais-context-set-pixel-tolerance "ais_context_set_pixel_tolerance") :void
  (ctx :pointer) (pixels :int))

(defcfun (%ais-context-set-automatic-hilight "ais_context_set_automatic_hilight") :void
  (ctx :pointer) (on :int))

(defcfun (%ais-context-set-to-hilight-selected "ais_context_set_to_hilight_selected") :void
  (ctx :pointer) (on :int))

;; --- Selection Filters (StdSelect) ---

(defcfun (%make-edge-filter "make_edge_filter") :pointer)

(defcfun (%make-face-filter "make_face_filter") :pointer)

(defcfun (%make-shape-type-filter "make_shape_type_filter") :pointer
  (shape-type :int))

(defcfun (%ais-context-add-filter "ais_context_add_filter") :void
  (ctx :pointer) (filter :pointer))

(defcfun (%ais-context-remove-filter "ais_context_remove_filter") :void
  (ctx :pointer) (filter :pointer))

(defcfun (%filter-set-edge-type "filter_set_edge_type") :void
  (filter :pointer) (edge-type :int))

(defcfun (%filter-set-face-type "filter_set_face_type") :void
  (filter :pointer) (face-type :int))

(defcfun (%free-filter "free_filter") :void
  (filter :pointer))

;; --- Entity Owners (SelectMgr / StdSelect) ---

(defcfun (%ais-context-selected-owner "ais_context_selected_owner") :pointer
  (ctx :pointer))

(defcfun (%owner-priority "owner_priority") :int
  (owner :pointer))

(defcfun (%brep-owner-has-shape "owner_has_shape") :int
  (owner :pointer))

(defcfun (%brep-owner-shape "brep_owner_shape") :pointer
  (owner :pointer))

(defcfun (%owner-location "owner_location") :int
  (owner :pointer) (matrix :pointer))

(defcfun (%free-owner "free_owner") :void
  (owner :pointer))

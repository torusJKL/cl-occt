(in-package :cl-occt.impl)

(defcfun (%make-box "make_box") :pointer
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-cylinder "make_cylinder") :pointer
  (radius :double)
  (height :double))

(defcfun (%make-sphere "make_sphere") :pointer
  (radius :double))

(defcfun (%make-cone "make_cone") :pointer
  (r1 :double)
  (r2 :double)
  (height :double))

(defcfun (%make-torus "make_torus") :pointer
  (major-radius :double)
  (minor-radius :double))

(defcfun (%make-prism "make_prism") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-revol "make_revol") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

(defcfun (%boolean-cut "boolean_cut") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-fuse "boolean_fuse") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-common "boolean_common") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-section "boolean_section") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%translate "translate") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%rotate "rotate") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

(defcfun (%write-step "write_step") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-step "read_step") :pointer
  (filename :string))

(defcfun (%make-pnt2d "make_pnt2d") :pointer
  (x :double)
  (y :double))

(defcfun (%make-vec2d "make_vec2d") :pointer
  (x :double)
  (y :double))

(defcfun (%make-dir2d "make_dir2d") :pointer
  (x :double)
  (y :double))

(defcfun (%free-geom2d "free_geom2d") :void
  (g :pointer))

(defcfun (%make-line-2d "make_line_2d") :pointer
  (x :double)
  (y :double)
  (dx :double)
  (dy :double))

(defcfun (%make-circle-2d "make_circle_2d") :pointer
  (x :double)
  (y :double)
  (radius :double))

(defcfun (%make-edge-line-2d "make_edge_line_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double))

(defcfun (%make-edge-line-3d "make_edge_line_3d") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%make-edge-circle-2d "make_edge_circle_2d") :pointer
  (x :double) (y :double)
  (radius :double))

(defcfun (%make-edge-arc-2d "make_edge_arc_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double)
  (x3 :double) (y3 :double))

(defcfun (%make-compound "make_compound") :pointer
  (shapes :pointer)
  (count :int))

(defcfun (%add-to-compound "add_to_compound") :pointer
  (compound :pointer)
  (shape :pointer))

(defcfun (%compound-is-empty "compound_is_empty") :int
  (shape :pointer))

(defcfun (%shape-is-compound "shape_is_compound") :int
  (shape :pointer))

(defcfun (%make-wire "make_wire") :pointer
  (edges :pointer)
  (count :int))

(defcfun (%make-face "make_face") :pointer
  (wire :pointer))

(defcfun (%make-face-on-plane "make_face_on_plane") :pointer
  (wire :pointer)
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))

;; --- XDE Document Lifecycle ---

(defcfun (%xde-new-doc "xde_new_doc") :pointer)

(defcfun (%xde-free-doc "xde_free_doc") :void
  (doc :pointer))

(defcfun (%xde-read-step "xde_read_step") :pointer
  (filename :string))

(defcfun (%xde-write-step "xde_write_step") :int
  (doc :pointer)
  (filename :string))

;; --- Label Navigation ---

(defcfun (%xde-get-root-count "xde_get_root_count") :int
  (doc :pointer))

(defcfun (%xde-get-root-path "xde_get_root_path") :void
  (doc :pointer)
  (index :int)
  (buf :pointer)
  (buf-size :int))

(defcfun (%xde-get-child-count "xde_get_child_count") :int
  (doc :pointer)
  (path :string))

(defcfun (%xde-get-child-path "xde_get_child_path") :void
  (doc :pointer)
  (parent-path :string)
  (index :int)
  (buf :pointer)
  (buf-size :int))

;; --- Attribute Read ---

(defcfun (%xde-get-shape-at "xde_get_shape_at") :pointer
  (doc :pointer)
  (path :string))

(defcfun (%xde-get-name-at "xde_get_name_at") :void
  (doc :pointer)
  (path :string)
  (buf :pointer)
  (buf-size :int))

(defcfun (%xde-get-color-at "xde_get_color_at") :int
  (doc :pointer)
  (path :string)
  (type :pointer)
  (r :pointer)
  (g :pointer)
  (b :pointer)
  (a :pointer))

(defcfun (%xde-get-location-at "xde_get_location_at") :int
  (doc :pointer)
  (path :string)
  (matrix :pointer))

;; --- Attribute Write ---

(defcfun (%xde-add-part "xde_add_part") :void
  (doc :pointer)
  (parent-path :string)
  (shape :pointer)
  (name :string)
  (color-type :int)
  (r :double)
  (g :double)
  (b :double)
  (a :double)
  (matrix :pointer)
  (buf :pointer)
  (buf-size :int))

(defcfun (%free-shape "free_shape") :void
  (shape :pointer))

(defcfun (%write-stl "write_stl") :int
  (shape :pointer)
  (filename :string)
  (deflection :double))

(defcfun (%read-stl "read_stl") :pointer
  (filename :string))

(defcfun (%get-error-code "get_error_code") :int)

(defcfun (%get-error-message "get_error_message") :string)

;; --- Visualization ---

(defcfun (%create-graphic-driver "create_graphic_driver") :pointer)

(defcfun (%free-graphic-driver "free_graphic_driver") :void
  (driver :pointer))

(defcfun (%v3d-create-viewer "v3d_create_viewer") :pointer
  (driver :pointer))

(defcfun (%v3d-free-viewer "v3d_free_viewer") :void
  (viewer :pointer))

(defcfun (%v3d-create-view "v3d_create_view") :pointer
  (viewer :pointer))

(defcfun (%v3d-free-view "v3d_free_view") :void
  (view :pointer))

(defcfun (%v3d-fit-all "v3d_fit_all") :void
  (view :pointer))

(defcfun (%v3d-view-must-be-resized "v3d_view_must_be_resized") :void
  (view :pointer))

(defcfun (%create-neutral-window "create_neutral_window") :pointer
  (native-handle :pointer))

(defcfun (%free-neutral-window "free_neutral_window") :void
  (window :pointer))

;; --- AIS Visualization (Display Objects) ---

(defcfun (%ais-create-context "ais_create_context") :pointer
  (viewer :pointer))

(defcfun (%ais-free-context "ais_free_context") :void
  (ctx :pointer))

(defcfun (%ais-create-shape "ais_create_shape") :pointer
  (shape :pointer))

(defcfun (%ais-free-shape "ais_free_shape") :void
  (obj :pointer))

(defcfun (%ais-context-display "ais_context_display") :void
  (ctx :pointer) (obj :pointer) (update :int))

(defcfun (%ais-context-erase "ais_context_erase") :void
  (ctx :pointer) (obj :pointer) (update :int))

(defcfun (%ais-context-remove "ais_context_remove") :void
  (ctx :pointer) (obj :pointer) (update :int))

(defcfun (%ais-context-remove-all "ais_context_remove_all") :void
  (ctx :pointer) (update :int))

(defcfun (%ais-context-is-displayed "ais_context_is_displayed") :int
  (ctx :pointer) (obj :pointer))

;; --- Visualization — Styling, Camera, MSAA, Grid ---

(defcfun (%v3d-view-set-bg-color "v3d_view_set_bg_color") :void
  (view :pointer)
  (r :double) (g :double) (b :double))

(defcfun (%ais-context-set-color "ais_context_set_color") :void
  (ctx :pointer) (obj :pointer)
  (r :double) (g :double) (b :double))

(defcfun (%ais-context-unset-color "ais_context_unset_color") :void
  (ctx :pointer) (obj :pointer))

(defcfun (%ais-context-set-display-mode "ais_context_set_display_mode") :void
  (ctx :pointer) (obj :pointer) (mode :int))

(defcfun (%v3d-view-set-proj "v3d_view_set_proj") :void
  (view :pointer) (orientation :int))

(defcfun (%v3d-view-set-msaa "v3d_view_set_msaa") :void
  (view :pointer) (samples :int))

(defcfun (%v3d-view-get-msaa "v3d_view_get_msaa") :int
  (view :pointer))

(defcfun (%v3d-view-set-antialiasing "v3d_view_set_antialiasing") :void
  (view :pointer) (on :int))

(defcfun (%v3d-view-get-antialiasing "v3d_view_get_antialiasing") :int
  (view :pointer))

(defcfun (%v3d-viewer-activate-grid "v3d_viewer_activate_grid") :void
  (viewer :pointer) (grid-type :int) (draw-mode :int))

(defcfun (%v3d-viewer-deactivate-grid "v3d_viewer_deactivate_grid") :void
  (viewer :pointer))

(defcfun (%v3d-view-invalidate "v3d_view_invalidate") :void
  (view :pointer))

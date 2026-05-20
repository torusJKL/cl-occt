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

(defcfun (%v3d-view-set-eye "v3d_view_set_eye") :void
  (view :pointer) (x :double) (y :double) (z :double))

(defcfun (%v3d-view-set-target "v3d_view_set_target") :void
  (view :pointer) (x :double) (y :double) (z :double))

(defcfun (%v3d-view-set-up "v3d_view_set_up") :void
  (view :pointer) (x :double) (y :double) (z :double))

(defcfun (%v3d-view-set-projection-type "v3d_view_set_projection_type") :void
  (view :pointer) (is-perspective :int))

(defcfun (%v3d-view-get-projection-type "v3d_view_get_projection_type") :int
  (view :pointer))

(defcfun (%v3d-view-set-fov "v3d_view_set_fov") :void
  (view :pointer) (fov-rad :double))

(defcfun (%v3d-view-set-clip-planes "v3d_view_set_clip_planes") :void
  (view :pointer) (near :double) (far :double))

(defcfun (%v3d-view-fit-all-shape "v3d_view_fit_all_shape") :void
  (view :pointer) (shape :pointer))

(defcfun (%v3d-view-pan "v3d_view_pan") :void
  (view :pointer) (dx :double) (dy :double))

(defcfun (%v3d-view-zoom "v3d_view_zoom") :void
  (view :pointer) (factor :double))

(defcfun (%v3d-view-rotate "v3d_view_rotate") :void
  (view :pointer) (ax :double) (ay :double) (az :double))

(defcfun (%v3d-view-reset "v3d_view_reset") :void
  (view :pointer))

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

;; --- Trihedron ---

(defcfun (%ais-create-trihedron "ais_create_trihedron") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (ux :double) (uy :double) (uz :double))

(defcfun (%ais-trihedron-set-datum-mode "ais_trihedron_set_datum_mode") :void
  (obj :pointer) (mode :int))

(defcfun (%ais-trihedron-set-draw-arrows "ais_trihedron_set_draw_arrows") :void
  (obj :pointer) (on :int))

(defcfun (%ais-trihedron-set-size "ais_trihedron_set_size") :void
  (obj :pointer) (size :double))

(defcfun (%ais-trihedron-set-transform-pers "ais_trihedron_set_transform_pers") :void
  (obj :pointer) (corner :int) (x-off :int) (y-off :int))

(defcfun (%ais-trihedron-set-datum-part-color "ais_trihedron_set_datum_part_color") :int
  (obj :pointer) (part :int)
  (r :double) (g :double) (b :double))

(defcfun (%ais-trihedron-set-text-color "ais_trihedron_set_text_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

;; --- Per-Object Properties ---

(defcfun (%make-material "make_material") :pointer
  (ar :double) (ag :double) (ab :double)
  (dr :double) (dg :double) (db :double)
  (sr :double) (sg :double) (sb :double)
  (shininess :double) (transparency :double))

(defcfun (%ais-set-custom-material "ais_set_custom_material") :void
  (ctx :pointer) (obj :pointer) (mat :pointer))

(defcfun (%ais-set-transparency "ais_set_transparency") :void
  (ctx :pointer) (obj :pointer) (v :double))

(defcfun (%ais-set-material-by-name "ais_set_material_by_name") :int
  (ctx :pointer) (obj :pointer) (name :string))

(defcfun (%ais-material-preset-count "ais_material_preset_count") :int)

(defcfun (%ais-material-preset-name "ais_material_preset_name") :string
  (index :int))

(defcfun (%ais-set-line-width "ais_set_line_width") :void
  (ctx :pointer) (obj :pointer) (w :double))

(defcfun (%ais-set-edges-display "ais_set_edges_display") :void
  (obj :pointer) (on :int))

(defcfun (%ais-set-edge-color "ais_set_edge_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-set-selection-mode "ais_set_selection_mode") :void
  (ctx :pointer) (obj :pointer) (mode :int))

(defcfun (%ais-deactivate-selection "ais_deactivate_selection") :void
  (ctx :pointer) (obj :pointer))

(defcfun (%ais-set-tessellation "ais_set_tessellation") :void
  (obj :pointer) (deflection :double) (deviation :double))

;; --- Lighting ---

(defcfun (%make-light-ambient "make_light_ambient") :pointer
  (r :double) (g :double) (b :double) (intensity :double))

(defcfun (%make-light-directional "make_light_directional") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-light-positional "make_light_positional") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (x :double) (y :double) (z :double))

(defcfun (%make-light-spot "make_light_spot") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (x :double) (y :double) (z :double)
  (dx :double) (dy :double) (dz :double)
  (angle :double) (concentration :double))

(defcfun (%light-free "light_free") :void
  (light :pointer))

(defcfun (%v3d-viewer-add-light "v3d_viewer_add_light") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-remove-light "v3d_viewer_remove_light") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-light-on "v3d_viewer_light_on") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-light-off "v3d_viewer_light_off") :void
  (viewer :pointer) (light :pointer))

(defcfun (%light-is-on "light_is_on") :int
  (light :pointer))

(defcfun (%light-set-color "light_set_color") :void
  (light :pointer) (r :double) (g :double) (b :double))

(defcfun (%light-set-intensity "light_set_intensity") :void
  (light :pointer) (v :double))

(defcfun (%light-set-direction "light_set_direction") :void
  (light :pointer) (dx :double) (dy :double) (dz :double))

(defcfun (%light-set-position "light_set_position") :void
  (light :pointer) (x :double) (y :double) (z :double))

(defcfun (%light-set-angle "light_set_angle") :void
  (light :pointer) (angle :double))

(defcfun (%light-set-concentration "light_set_concentration") :void
  (light :pointer) (v :double))

(defcfun (%light-set-headlight "light_set_headlight") :void
  (light :pointer) (on :int))

(defcfun (%light-set-shadows "light_set_shadows") :void
  (light :pointer) (on :int))

(defcfun (%v3d-viewer-default-lights "v3d_viewer_default_lights") :void
  (viewer :pointer))

;; --- Grid Extensions ---

(defcfun (%v3d-viewer-grid-active "v3d_viewer_grid_active") :int
  (viewer :pointer))

(defcfun (%v3d-view-set-grid-echo "v3d_view_set_grid_echo") :void
  (view :pointer) (on :int))

;; --- Background ---

(defcfun (%v3d-view-set-bg-image "v3d_view_set_bg_image") :void
  (view :pointer) (path :string))

(defcfun (%make-cubemap-separate "make_cubemap_separate") :pointer
  (paths :pointer) (count :int))

(defcfun (%free-cubemap "free_cubemap") :void
  (cubemap :pointer))

(defcfun (%v3d-view-set-bg-cubemap "v3d_view_set_bg_cubemap") :void
  (view :pointer) (cubemap :pointer))

(defcfun (%v3d-view-set-bg-gradient "v3d_view_set_bg_gradient") :void
  (view :pointer)
  (r1 :double) (g1 :double) (b1 :double)
  (r2 :double) (g2 :double) (b2 :double)
  (style :int))

(defcfun (%v3d-view-reset-background "v3d_view_reset_background") :void
  (view :pointer))

;; --- Rendering ---

(defcfun (%v3d-view-set-computed-mode "v3d_view_set_computed_mode") :void
  (view :pointer) (on :int))

(defcfun (%v3d-view-computed-mode "v3d_view_computed_mode") :int
  (view :pointer))

(defcfun (%v3d-view-set-back-face-model "v3d_view_set_back_face_model") :void
  (view :pointer) (mode :int))

(defcfun (%v3d-view-get-camera-handle "v3d_view_get_camera_handle") :void
  (view :pointer) (out-camera :pointer))

(defcfun (%v3d-view-set-camera "v3d_view_set_camera") :void
  (view :pointer) (camera :pointer))

(defcfun (%v3d-view-set-transparency-method "v3d_view_set_transparency_method") :void
  (view :pointer) (method :int))

(defcfun (%v3d-viewer-set-default-bg-gradient "v3d_viewer_set_default_bg_gradient") :void
  (viewer :pointer)
  (r1 :double) (g1 :double) (b1 :double)
  (r2 :double) (g2 :double) (b2 :double)
  (style :int))

(defcfun (%ais-text-label-set-hjustification "ais_text_label_set_hjustification") :void
  (label :pointer) (align :int))

(defcfun (%ais-text-label-set-vjustification "ais_text_label_set_vjustification") :void
  (label :pointer) (align :int))

(defcfun (%ais-text-label-set-color-sub-title "ais_text_label_set_color_sub_title") :void
  (label :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-text-label-set-display-type "ais_text_label_set_display_type") :void
  (label :pointer) (type :int))

(defcfun (%v3d-viewer-set-rectangular-grid-values "v3d_viewer_set_rectangular_grid_values") :void
  (viewer :pointer) (x-origin :double) (y-origin :double)
  (x-step :double) (y-step :double) (rotation-angle :double))

(defcfun (%v3d-view-grid-display "v3d_view_grid_display") :void
  (view :pointer) (r :double) (g :double) (b :double)
  (size-x :double) (size-y :double))

(defcfun (%ais-context-default-drawer "ais_context_default_drawer") :pointer
  (ctx :pointer))

(defcfun (%prsdim-set-measured-edge "prsdim_set_measured_edge") :void
  (dim :pointer) (shape :pointer)
  (px :double) (py :double) (pz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%prsdim-set-custom-value "prsdim_set_custom_value") :void
  (dim :pointer) (value :string))

(defcfun (%prsdim-set-angle-edges "prsdim_set_angle_edges") :void
  (dim :pointer) (edge1 :pointer) (edge2 :pointer))

(defcfun (%prsdim-set-arrow-length "prsdim_set_arrow_length") :void
  (dim :pointer) (v :double))

(defcfun (%prsdim-set-extension-size "prsdim_set_extension_size") :void
  (dim :pointer) (v :double))

(defcfun (%v3d-view-set-frustum-culling "v3d_view_set_frustum_culling") :void
  (view :pointer) (on :int))

(defcfun (%v3d-view-redraw "v3d_view_redraw") :void
  (view :pointer))

(defcfun (%v3d-view-set-immediate-update "v3d_view_set_immediate_update") :void
  (view :pointer) (on :int))

;; --- Text Label Enhancements ---

(defcfun (%ais-text-label-set-angle "ais_text_label_set_angle") :void
  (label :pointer) (rad :double))

;; --- Viewer Defaults ---

(defcfun (%v3d-viewer-set-default-lights "v3d_viewer_set_default_lights") :void
  (viewer :pointer) (on :int))

(defcfun (%v3d-viewer-set-default-bg-color "v3d_viewer_set_default_bg_color") :void
  (viewer :pointer) (r :double) (g :double) (b :double))

(defcfun (%v3d-viewer-set-default-view-proj "v3d_viewer_set_default_view_proj") :void
  (viewer :pointer) (orientation :int))

(defcfun (%v3d-viewer-set-default-view-size "v3d_viewer_set_default_view_size") :void
  (viewer :pointer) (size :double))

(defcfun (%v3d-viewer-set-default-view-type "v3d_viewer_set_default_view_type") :void
  (viewer :pointer) (is-perspective :int))

;; --- Drawer ---

(defcfun (%ais-object-attributes "ais_object_attributes") :pointer
  (obj :pointer))

(defcfun (%drawer-shading-aspect "drawer_shading_aspect") :pointer
  (drawer :pointer))

(defcfun (%drawer-line-aspect "drawer_line_aspect") :pointer
  (drawer :pointer))

(defcfun (%line-aspect-set-color "line_aspect_set_color") :void
  (aspect :pointer) (r :double) (g :double) (b :double))

(defcfun (%line-aspect-set-width "line_aspect_set_width") :void
  (aspect :pointer) (w :double))

(defcfun (%line-aspect-set-type "line_aspect_set_type") :void
  (aspect :pointer) (type :int))

(defcfun (%shading-aspect-set-color "shading_aspect_set_color") :void
  (aspect :pointer) (r :double) (g :double) (b :double))

(defcfun (%shading-aspect-set-material "shading_aspect_set_material") :void
  (aspect :pointer)
  (ar :double) (ag :double) (ab :double)
  (dr :double) (dg :double) (db :double)
  (sr :double) (sg :double) (sb :double)
  (shininess :double) (transparency :double))

(defcfun (%ais-object-set-line-color "ais_object_set_line_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-object-set-line-width "ais_object_set_line_width") :void
  (obj :pointer) (w :double))

(defcfun (%ais-object-set-line-type "ais_object_set_line_type") :void
  (obj :pointer) (type :int))

(defcfun (%ais-object-set-point-color "ais_object_set_point_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-object-set-point-type "ais_object_set_point_type") :void
  (obj :pointer) (type :int))

(defcfun (%ais-object-set-point-scale "ais_object_set_point_scale") :void
  (obj :pointer) (scale :double))

(defcfun (%ais-object-set-text-color "ais_object_set_text_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-object-set-text-font "ais_object_set_text_font") :void
  (obj :pointer) (font :string))

(defcfun (%ais-object-set-text-height "ais_object_set_text_height") :void
  (obj :pointer) (h :double))

(defcfun (%ais-object-set-iso-display "ais_object_set_iso_display") :void
  (obj :pointer) (u-on :int) (v-on :int))

(defcfun (%ais-object-set-wire-color "ais_object_set_wire_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-object-set-shading-color "ais_object_set_shading_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-object-set-face-boundary-draw "ais_object_set_face_boundary_draw") :void
  (obj :pointer) (on :int))

(defcfun (%ais-object-set-free-boundary-draw "ais_object_set_free_boundary_draw") :void
  (obj :pointer) (on :int))

;; --- Dimensions ---

(defcfun (%prsdim-make-length-2p "prsdim_make_length_2p") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%prsdim-make-angle-3p "prsdim_make_angle_3p") :pointer
  (vx :double) (vy :double) (vz :double)
  (p1x :double) (p1y :double) (p1z :double)
  (p2x :double) (p2y :double) (p2z :double))

(defcfun (%prsdim-make-diameter "prsdim_make_diameter") :pointer
  (shape :pointer))

(defcfun (%prsdim-make-radius "prsdim_make_radius") :pointer
  (shape :pointer))

(defcfun (%prsdim-set-text-position "prsdim_set_text_position") :void
  (dim :pointer) (x :double) (y :double) (z :double))

(defcfun (%prsdim-set-display-units "prsdim_set_display_units") :void
  (dim :pointer) (units :string))

(defcfun (%prsdim-set-flyout "prsdim_set_flyout") :void
  (dim :pointer) (v :double))

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

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

;; --- IGES I/O ---

(defcfun (%write-iges "write_iges") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-iges "read_iges") :pointer
  (filename :string))

;; --- IGES Assembly (XDE) I/O ---

(defcfun (%xde-read-iges "xde_read_iges") :pointer
  (filename :string))

(defcfun (%xde-write-iges "xde_write_iges") :int
  (doc :pointer)
  (filename :string))

;; --- OBJ Mesh I/O ---

(defcfun (%write-obj "write_obj") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (name-format :int)
  (per-vertex-colors :int))

(defcfun (%read-obj "read_obj") :pointer
  (filename :string)
  (coordinate-system :int))

;; --- VRML Export ---

(defcfun (%write-vrml "write_vrml") :int
  (shape :pointer)
  (filename :string)
  (deflection :double))

;; --- glTF I/O ---

(defcfun (%write-gltf "write_gltf") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (per-vertex-colors :int))

(defcfun (%read-gltf "read_gltf") :pointer
  (filename :string)
  (coordinate-system :int))

;; --- PLY Export ---

(defcfun (%write-ply "write_ply") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (per-vertex-colors :int))

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

(defcfun (%v3d-view-get-eye-x "v3d_view_get_eye_x") :double
  (view :pointer))

(defcfun (%v3d-view-get-eye-y "v3d_view_get_eye_y") :double
  (view :pointer))

(defcfun (%v3d-view-get-eye-z "v3d_view_get_eye_z") :double
  (view :pointer))

(defcfun (%v3d-view-set-target "v3d_view_set_target") :void
  (view :pointer) (x :double) (y :double) (z :double))

(defcfun (%v3d-view-get-target-x "v3d_view_get_target_x") :double
  (view :pointer))

(defcfun (%v3d-view-get-target-y "v3d_view_get_target_y") :double
  (view :pointer))

(defcfun (%v3d-view-get-target-z "v3d_view_get_target_z") :double
  (view :pointer))

(defcfun (%v3d-view-set-up "v3d_view_set_up") :void
  (view :pointer) (x :double) (y :double) (z :double))

(defcfun (%v3d-view-get-up-x "v3d_view_get_up_x") :double
  (view :pointer))

(defcfun (%v3d-view-get-up-y "v3d_view_get_up_y") :double
  (view :pointer))

(defcfun (%v3d-view-get-up-z "v3d_view_get_up_z") :double
  (view :pointer))

(defcfun (%v3d-view-set-projection-type "v3d_view_set_projection_type") :void
  (view :pointer) (is-perspective :int))

(defcfun (%v3d-view-get-projection-type "v3d_view_get_projection_type") :int
  (view :pointer))

(defcfun (%v3d-view-set-fov "v3d_view_set_fov") :void
  (view :pointer) (fov-rad :double))

(defcfun (%v3d-view-get-fov "v3d_view_get_fov") :double
  (view :pointer))

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

(defcfun (%ais-trihedron-set-wireframe-color "ais_trihedron_set_wireframe_color") :void
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

;; --- 3D Curves ---

(defcfun (%make-line-3d "make_line_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-circle-3d "make_circle_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (radius :double))

(defcfun (%make-ellipse-3d "make_ellipse_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-hyperbola "make_hyperbola") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-parabola "make_parabola") :pointer
  (ox :double) (oy :double) (oz :double)
  (focal :double))

(defcfun (%make-bezier-curve "make_bezier_curve") :pointer
  (points :pointer) (num-points :int))

(defcfun (%make-bspline-curve "make_bspline_curve") :pointer
  (poles :pointer) (num-poles :int)
  (knots :pointer) (mults :pointer) (num-knots :int)
  (degree :int))

(defcfun (%free-curve "free_curve") :void
  (curve :pointer))

(defcfun (%curve-type "curve_type") :int
  (curve :pointer))

(defcfun (%make-gc-line "make_gc_line") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%make-gc-arc-of-circle "make_gc_arc_of_circle") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double)
  (x3 :double) (y3 :double) (z3 :double))

(defcfun (%convert-curve-to-bspline "convert_curve_to_bspline") :pointer
  (curve :pointer))

(defcfun (%curve-bounding-box "curve_bounding_box") :int
  (curve :pointer)
  (xmin :pointer) (ymin :pointer) (zmin :pointer)
  (xmax :pointer) (ymax :pointer) (zmax :pointer))

;; --- 3D Surfaces ---

(defcfun (%make-plane "make_plane") :pointer
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%make-cylindrical-surface "make_cylindrical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (radius :double))

(defcfun (%make-conical-surface "make_conical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (radius :double) (semi-angle :double))

(defcfun (%make-spherical-surface "make_spherical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (radius :double))

(defcfun (%make-toroidal-surface "make_toroidal_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-bezier-surface "make_bezier_surface") :pointer
  (poles :pointer) (num-u :int) (num-v :int))

(defcfun (%make-bspline-surface "make_bspline_surface") :pointer
  (poles :pointer)
  (num-u-poles :int) (num-v-poles :int)
  (uknots :pointer) (umults :pointer) (num-uknots :int)
  (vknots :pointer) (vmults :pointer) (num-vknots :int)
  (udeg :int) (vdeg :int))

(defcfun (%free-surface "free_surface") :void
  (surface :pointer))

(defcfun (%surface-type "surface_type") :int
  (surface :pointer))

(defcfun (%convert-surface-to-bspline "convert_surface_to_bspline") :pointer
  (surface :pointer))

(defcfun (%surface-bounding-box "surface_bounding_box") :int
  (surface :pointer)
  (xmin :pointer) (ymin :pointer) (zmin :pointer)
  (xmax :pointer) (ymax :pointer) (zmax :pointer))

;; --- Geometric Algorithms ---

(defcfun (%project-point-on-curve "project_point_on_curve") :int
  (curve :pointer)
  (px :double) (py :double) (pz :double)
  (out-x :pointer) (out-y :pointer) (out-z :pointer)
  (out-dist :pointer) (out-param :pointer))

(defcfun (%project-point-on-surface "project_point_on_surface") :int
  (surface :pointer)
  (px :double) (py :double) (pz :double)
  (out-x :pointer) (out-y :pointer) (out-z :pointer)
  (out-u :pointer) (out-v :pointer) (out-dist :pointer))

(defcfun (%intersect-curves "intersect_curves") :int
  (c1 :pointer) (c2 :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%intersect-curve-surface "intersect_curve_surface") :int
  (curve :pointer) (surface :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%intersect-surfaces "intersect_surfaces") :int
  (s1 :pointer) (s2 :pointer)
  (out-curves :pointer) (max-curves :int))

(defcfun (%extrema-curve-curve "extrema_curve_curve") :int
  (c1 :pointer) (c2 :pointer)
  (out-dist :pointer)
  (out-p1x :pointer) (out-p1y :pointer) (out-p1z :pointer)
  (out-p2x :pointer) (out-p2y :pointer) (out-p2z :pointer))

(defcfun (%extrema-curve-surface "extrema_curve_surface") :int
  (curve :pointer) (surface :pointer)
  (out-dist :pointer)
  (out-px :pointer) (out-py :pointer) (out-pz :pointer)
  (out-u :pointer) (out-v :pointer))

(defcfun (%intersect-curves-2d "intersect_curves_2d") :int
  (c1 :pointer) (c2 :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%project-point-on-curve-2d "project_point_on_curve_2d") :int
  (curve :pointer)
  (px :double) (py :double)
  (out-x :pointer) (out-y :pointer)
  (out-dist :pointer) (out-param :pointer))

(defcfun (%points-to-bspline "points_to_bspline") :pointer
  (points :pointer) (num-points :int) (degree :int))

(defcfun (%interpolate-points "interpolate_points") :pointer
  (points :pointer) (num-points :int)
  (init-tangent :pointer) (final-tangent :pointer))

;; --- Helix ---

(defcfun (%make-helix-curve "make_helix_curve") :pointer
  (radius :double) (pitch :double) (height :double)
  (left-handed :int) (angle :double))

(defcfun (%make-helix-edge "make_helix_edge") :pointer
  (radius :double) (pitch :double) (height :double)
  (left-handed :int) (angle :double)
  (on-surface :pointer))

;; --- Mass Properties (BRepGProp) ---

(defcfun (%shape-volume "shape_volume") :double
  (shape :pointer))

(defcfun (%shape-area "shape_area") :double
  (shape :pointer))

(defcfun (%shape-center-of-mass "shape_center_of_mass") :int
  (shape :pointer)
  (out-x :pointer)
  (out-y :pointer)
  (out-z :pointer))

(defcfun (%shape-inertia "shape_inertia") :int
  (shape :pointer)
  (out-inertia :pointer)
  (inertia-size :int)
  (out-principal-moments :pointer)
  (pm-size :int)
  (out-principal-axes :pointer)
  (pa-size :int))

;; --- Shape Analysis Queries ---

(defcfun (%shape-distance "shape_distance") :double
  (shape1 :pointer)
  (shape2 :pointer))

(defcfun (%shape-distance-extrema "shape_distance_extrema") :int
  (shape1 :pointer)
  (shape2 :pointer)
  (out-dist :pointer)
  (out-p1x :pointer) (out-p1y :pointer) (out-p1z :pointer)
  (out-p2x :pointer) (out-p2y :pointer) (out-p2z :pointer))

(defcfun (%classify-point-in-solid "classify_point_in_solid") :int
  (shape :pointer)
  (px :double) (py :double) (pz :double)
  (out-state :pointer)
  (out-face :pointer))

(defcfun (%shape-is-valid "shape_is_valid") :int
  (shape :pointer))

(defcfun (%shape-analysis-report "shape_analysis_report") :string
  (shape :pointer))

(defcfun (%intersect-curve-shape "intersect_curve_shape") :int
  (curve :pointer)
  (shape :pointer)
  (out-points :pointer)
  (out-params :pointer)
  (out-faces :pointer)
  (max-results :int))

;; --- Topology Navigation ---

(defcfun (%map-subshapes "map_subshapes") :int
  (shape :pointer)
  (shape-type :int)
  (stop-at-type :int)
  (out-shapes :pointer)
  (max-shapes :int))

(defcfun (%count-subshapes "count_subshapes") :int
  (shape :pointer)
  (shape-type :int)
  (stop-at-type :int))

(defcfun (%dump-shape "dump_shape") :string
  (shape :pointer))

(defcfun (%shape-triangle-count "shape_triangle_count") :int
  (shape :pointer))

(defcfun (%wire-order-check "wire_order_check") :int
  (wire :pointer)
  (face :pointer))

(defcfun (%edge-to-curve "edge_to_curve") :pointer
  (edge :pointer))

(defcfun (%face-to-surface "face_to_surface") :pointer
  (face :pointer))

(defcfun (%make-vertex "make_vertex") :pointer
  (x :double) (y :double) (z :double))

(defcfun (%make-polygon "make_polygon") :pointer
  (points :pointer)
  (num-points :int)
  (closed :int))

;; --- Fillet / Chamfer / Blend ---

(defcfun (%fillet-edge-constant "fillet_edge_constant") :pointer
  (shape :pointer)
  (edge :pointer)
  (radius :double))

(defcfun (%fillet-edges-constant "fillet_edges_constant") :pointer
  (shape :pointer)
  (edges :pointer)
  (num-edges :int)
  (radius :double))

(defcfun (%fillet-edge-variable "fillet_edge_variable") :pointer
  (shape :pointer)
  (edge :pointer)
  (params-and-radii :pointer)
  (num-pairs :int))

(defcfun (%fillet-wire-corner "fillet_wire_corner") :pointer
  (wire :pointer)
  (radius :double))

(defcfun (%fillet-wire-all-corners "fillet_wire_all_corners") :pointer
  (wire :pointer)
  (radius :double))

(defcfun (%chamfer-edge-equal "chamfer_edge_equal") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance :double))

(defcfun (%chamfer-edges-equal "chamfer_edges_equal") :pointer
  (shape :pointer)
  (edges :pointer)
  (num-edges :int)
  (distance :double))

(defcfun (%chamfer-edge-asym "chamfer_edge_asym") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance1 :double)
  (distance2 :double))

(defcfun (%chamfer-edge-on-face "chamfer_edge_on_face") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance :double)
  (face :pointer))

(defcfun (%blend-faces-constant "blend_faces_constant") :pointer
  (face1 :pointer)
  (face2 :pointer)
  (radius :double))

(defcfun (%blend-make-constant "blend_make_constant") :pointer
  (face1 :pointer)
  (face2 :pointer)
  (radius :double))

;; --- Sweep / Pipe ---

(defcfun (%sweep-pipe "sweep_pipe") :pointer
  (profile :pointer)
  (spine :pointer))

(defcfun (%sweep-pipe-fixed "sweep_pipe_fixed") :pointer
  (profile :pointer)
  (spine :pointer))

(defcfun (%sweep-pipe-shell "sweep_pipe_shell") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-sliding "sweep_pipe_shell_sliding") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-fixed "sweep_pipe_shell_fixed") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-aux "sweep_pipe_shell_aux") :pointer
  (profile :pointer)
  (main-spine :pointer)
  (aux-spine :pointer))

;; --- Loft ---

(defcfun (%loft-sections "loft_sections") :pointer
  (wires :pointer)
  (count :int)
  (solid :int))

(defcfun (%loft-sections-ruled "loft_sections_ruled") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (ruled :int))

(defcfun (%loft-sections-smooth "loft_sections_smooth") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (smooth :int))

(defcfun (%loft-sections-tangency "loft_sections_tangency") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (init-face :pointer)
  (final-face :pointer))

;; --- Face Filling ---

(defcfun (%fill-face "fill_face") :pointer
  (wire :pointer))

(defcfun (%fill-face-constrained "fill_face_constrained") :pointer
  (wire :pointer)
  (support-faces :pointer)
  (continuities :pointer)
  (count :int))

(defcfun (%fill-n-sided-face "fill_n_sided_face") :pointer
  (edges :pointer)
  (count :int)
  (continuity :int))

;; --- Shell / Thicken ---

(defcfun (%shell-shape "shell_shape") :pointer
  (shape :pointer)
  (faces :pointer)
  (num-faces :int)
  (thickness :double))

;; --- Offset ---

(defcfun (%offset-shape-3d "offset_shape_3d") :pointer
  (shape :pointer)
  (offset :double)
  (join :int))

(defcfun (%offset-wire-2d "offset_wire_2d") :pointer
  (wire :pointer)
  (offset :double))

;; --- Draft ---

(defcfun (%draft-face "draft_face") :pointer
  (shape :pointer)
  (face :pointer)
  (angle :double)
  (dx :double) (dy :double) (dz :double)
  (px :double) (py :double) (pz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%make-evolved "make_evolved") :pointer
  (profile :pointer)
  (spine :pointer)
  (offset :double)
  (join :int))

;; --- Mechanical Features (BRepFeat) ---

(defcfun (%make-cylindrical-hole "make_cylindrical_hole") :pointer
  (shape :pointer)
  (face :pointer)
  (radius :double)
  (depth :double)
  (through :int))

(defcfun (%make-prism-feature "make_prism_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (height :double)
  (dx :double) (dy :double) (dz :double)
  (operation :int))

(defcfun (%make-revol-feature "make_revol_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (ax :double) (ay :double) (az :double)
  (angle :double)
  (operation :int))

(defcfun (%make-pipe-feature "make_pipe_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (path :pointer)
  (operation :int))

;; --- Local Operations (LocOpe) ---

(defcfun (%local-extrude "local_extrude") :pointer
  (face :pointer)
  (height :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-groove "make_groove") :pointer
  (shape :pointer)
  (face :pointer)
  (ax :double) (ay :double) (az :double)
  (angle :double))

(defcfun (%make-rib "make_rib") :pointer
  (shape :pointer)
  (profile :pointer)
  (thickness :double)
  (dx :double) (dy :double) (dz :double))

;; --- Shape Fix ---

(defcfun (%fix-shape "fix_shape") :pointer
  (shape :pointer))

(defcfun (%fix-wire "fix_wire") :pointer
  (wire :pointer)
  (face :pointer)
  (tolerance :double))

(defcfun (%fix-solid "fix_solid") :pointer
  (shape :pointer))

(defcfun (%fix-edge "fix_edge") :pointer
  (edge :pointer))

(defcfun (%fix-face "fix_face") :pointer
  (face :pointer))

(defcfun (%shape-analysis-free-edges "shape_analysis_free_edges") :pointer
  (shape :pointer))

(defcfun (%shape-analysis-check-intersections "shape_analysis_check_intersections") :int
  (shape :pointer))

(defcfun (%shape-analysis-wire-contains "shape_analysis_wire_contains") :int
  (wire :pointer)
  (x :double)
  (y :double))

(defcfun (%shape-analysis-contents "shape_analysis_contents") :string
  (shape :pointer))

;; --- Shape Rebuild ---

(defcfun (%substitute-single "substitute_single") :pointer
  (shape :pointer)
  (old-sub :pointer)
  (new-sub :pointer))

(defcfun (%substitute-batch "substitute_batch") :pointer
  (shape :pointer)
  (old-shapes :pointer)
  (new-shapes :pointer)
  (count :int))

(defcfun (%shape-to-nurbs "shape_to_nurbs") :pointer
  (shape :pointer))

(defcfun (%shape-reduce-degree "shape_reduce_degree") :pointer
  (shape :pointer)
  (max-degree :int))

(defcfun (%shape-to-rational-bspline "shape_to_rational_bspline") :pointer
  (shape :pointer))

(defcfun (%shape-split-u "shape_split_u") :pointer
  (shape :pointer)
  (num-splits :int))

(defcfun (%shape-upgrade-continuity "shape_upgrade_continuity") :pointer
  (shape :pointer)
  (continuity :int))

;; --- Shape Process Pipeline ---

(defcfun (%apply-shape-process "apply_shape_process") :pointer
  (shape :pointer)
  (operator-name :string))

(defcfun (%apply-operator-sequence "apply_operator_sequence") :pointer
  (shape :pointer)
  (operators :pointer)
  (count :int))

(defcfun (%apply-healing-pipeline "apply_healing_pipeline") :pointer
  (shape :pointer)
  (pipeline-name :string)
  (resource :string))

(defcfun (%heal-shape-default "heal_shape_default") :pointer
  (shape :pointer))

;; --- Sewing ---

(defcfun (%sew-shapes "sew_shapes") :pointer
  (shapes :pointer)
  (num-shapes :int)
  (tolerance :double)
  (allow-non-manifold :int))

;; --- Defeaturing ---

(defcfun (%defeature-shape "defeature_shape") :pointer
  (shape :pointer)
  (faces :pointer)
  (num-faces :int))

;; --- Shape Check & Builder ---

(defcfun (%check-shape-validity "check_shape_validity") :string
  (shape :pointer))

(defcfun (%boolean-builder "boolean_builder") :pointer
  (shape1 :pointer)
  (shape2 :pointer)
  (operation :int))

;; --- HLR ---

(defcfun (%hlr-project "hlr_project") :pointer
  (shape :pointer)
  (proj-dx :double) (proj-dy :double) (proj-dz :double)
  (px :double) (py :double) (pz :double))

;; --- Shape Conversion ---

(defcfun (%convert-to-revolution "convert_to_revolution") :pointer
  (shape :pointer))

(defcfun (%convert-swept-to-elementary "convert_swept_to_elementary") :pointer
  (shape :pointer))

(in-package :cl-occt.impl)

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

(defcfun (%v3d-viewer-set-rectangular-grid-values "v3d_viewer_set_rectangular_grid_values") :void
  (viewer :pointer) (x-origin :double) (y-origin :double)
  (x-step :double) (y-step :double) (rotation-angle :double))

(defcfun (%v3d-view-grid-display "v3d_view_grid_display") :void
  (view :pointer) (r :double) (g :double) (b :double)
  (size-x :double) (size-y :double))

(defcfun (%ais-context-default-drawer "ais_context_default_drawer") :pointer
  (ctx :pointer))

(defcfun (%v3d-view-set-frustum-culling "v3d_view_set_frustum_culling") :void
  (view :pointer) (on :int))

(defcfun (%v3d-view-redraw "v3d_view_redraw") :void
  (view :pointer))

(defcfun (%v3d-view-set-immediate-update "v3d_view_set_immediate_update") :void
  (view :pointer) (on :int))

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

(in-package :cl-occt.impl)

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

;; --- AIS Interactive Types ---

(defcfun (%ais-create-colored-shape "ais_create_colored_shape") :pointer
  (shape :pointer))

(defcfun (%ais-colored-shape-set-color "ais_colored_shape_set_color") :int
  (obj :pointer) (sub :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-create-manipulator "ais_create_manipulator") :pointer)

(defcfun (%ais-manipulator-attach "ais_manipulator_attach") :void
  (obj :pointer) (ais-obj :pointer))

(defcfun (%ais-manipulator-set-position "ais_manipulator_set_position") :void
  (obj :pointer) (x :double) (y :double) (z :double))

(defcfun (%ais-manipulator-set-size "ais_manipulator_set_size") :void
  (obj :pointer) (size :double))

(defcfun (%ais-manipulator-set-active-axes "ais_manipulator_set_active_axes") :void
  (obj :pointer) (translate :int) (rotate :int) (scale :int))

(defcfun (%ais-create-connected "ais_create_connected") :pointer
  (src :pointer))

(defcfun (%ais-create-multiple-connected "ais_create_multiple_connected") :pointer)

(defcfun (%ais-multiple-connected-connect "ais_multiple_connected_connect") :void
  (obj :pointer) (src :pointer))

(defcfun (%ais-create-point-cloud "ais_create_point_cloud") :pointer
  (verts :pointer) (count :int))

(defcfun (%ais-point-cloud-set-colors "ais_point_cloud_set_colors") :void
  (obj :pointer) (colors :pointer) (count :int))

(defcfun (%ais-point-cloud-set-size "ais_point_cloud_set_size") :void
  (obj :pointer) (size :double))

(defcfun (%ais-create-triangulation "ais_create_triangulation") :pointer
  (verts :pointer) (vcount :int) (tris :pointer) (tcount :int) (colors :pointer))

(defcfun (%ais-create-plane "ais_create_plane") :pointer
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double) (size :double))

(defcfun (%ais-create-axis "ais_create_axis") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%ais-create-line "ais_create_line") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%ais-create-circle "ais_create_circle") :pointer
  (cx :double) (cy :double) (cz :double)
  (nx :double) (ny :double) (nz :double) (radius :double))

(defcfun (%ais-create-textured-shape "ais_create_textured_shape") :pointer
  (shape :pointer) (filename :string))

(defcfun (%ais-textured-shape-set-repeat "ais_textured_shape_set_repeat") :void
  (obj :pointer) (u :double) (v :double))

(defcfun (%ais-textured-shape-set-origin "ais_textured_shape_set_origin") :void
  (obj :pointer) (u :double) (v :double))

(defcfun (%ais-create-view-cube "ais_create_view_cube") :pointer)

(defcfun (%ais-view-cube-set-size "ais_view_cube_set_size") :void
  (obj :pointer) (size :double))

(defcfun (%ais-view-cube-set-box-color "ais_view_cube_set_box_color") :void
  (obj :pointer) (r :double) (g :double) (b :double))

(defcfun (%ais-view-cube-set-corner "ais_view_cube_set_corner") :void
  (obj :pointer) (corner :int))

(defcfun (%ais-create-color-scale "ais_create_color_scale") :pointer)

(defcfun (%ais-color-scale-set-range "ais_color_scale_set_range") :void
  (obj :pointer) (min :double) (max :double))

(defcfun (%ais-color-scale-set-size "ais_color_scale_set_size") :void
  (obj :pointer) (w :double) (h :double))

(defcfun (%ais-color-scale-set-title "ais_color_scale_set_title") :void
  (obj :pointer) (title :string))

(defcfun (%ais-color-scale-set-intervals "ais_color_scale_set_intervals") :void
  (obj :pointer) (n :int))

(defcfun (%ais-create-light-source "ais_create_light_source") :pointer
  (light :pointer))

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

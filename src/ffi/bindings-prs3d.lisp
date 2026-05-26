(in-package :cl-occt.impl)

;; --- Prs3d_Tool* (Parametric Triangulation Generators) ---

(defcfun (%prs3d-tool-cylinder "prs3d_tool_cylinder") :pointer
  (radius :double) (height :double) (n-slices :int) (n-stacks :int))

(defcfun (%prs3d-tool-sphere "prs3d_tool_sphere") :pointer
  (radius :double) (n-slices :int) (n-stacks :int))

(defcfun (%prs3d-tool-torus "prs3d_tool_torus") :pointer
  (major-radius :double) (minor-radius :double) (n-slices :int) (n-stacks :int))

(defcfun (%prs3d-tool-disk "prs3d_tool_disk") :pointer
  (inner-radius :double) (outer-radius :double) (n-slices :int) (n-stacks :int))

(defcfun (%prs3d-triangulation-free "prs3d_triangulation_free") :void
  (handle :pointer))

(defcfun (%prs3d-triangulation-vertex-count "prs3d_triangulation_vertex_count") :int
  (handle :pointer))

(defcfun (%prs3d-triangulation-triangle-count "prs3d_triangulation_triangle_count") :int
  (handle :pointer))

(defcfun (%prs3d-triangulation-has-normals "prs3d_triangulation_has_normals") :int
  (handle :pointer))

(defcfun (%prs3d-triangulation-get-vertices "prs3d_triangulation_get_vertices") :void
  (handle :pointer) (out :pointer) (max-count :int))

(defcfun (%prs3d-triangulation-get-normals "prs3d_triangulation_get_normals") :void
  (handle :pointer) (out :pointer) (max-count :int))

(defcfun (%prs3d-triangulation-get-triangles "prs3d_triangulation_get_triangles") :void
  (handle :pointer) (out :pointer) (max-count :int))

;; --- Prs3d_Arrow, Prs3d_Text, Prs3d_BndBox ---

(defcfun (%prs3d-arrow "prs3d_arrow") :pointer
  (sx :double) (sy :double) (sz :double)
  (ex :double) (ey :double) (ez :double)
  (shaft-radius :double) (cone-length :double) (cone-radius :double)
  (n-facets :int))

(defcfun (%prs3d-bndbox "prs3d_bndbox") :pointer
  (xmin :double) (ymin :double) (zmin :double)
  (xmax :double) (ymax :double) (zmax :double))

(defcfun (%prs3d-segments-vertex-count "prs3d_segments_vertex_count") :int
  (handle :pointer))

(defcfun (%prs3d-segments-edge-count "prs3d_segments_edge_count") :int
  (handle :pointer))

(defcfun (%prs3d-segments-free "prs3d_segments_free") :void
  (handle :pointer))

(defcfun (%prs3d-segments-get-vertices "prs3d_segments_get_vertices") :void
  (handle :pointer) (out :pointer) (max-count :int))

(defcfun (%prs3d-segments-get-edges "prs3d_segments_get_edges") :void
  (handle :pointer) (out :pointer) (max-count :int))

(defcfun (%shape-bounding-box "shape_bounding_box") :int
  (shape :pointer)
  (xmin :pointer) (ymin :pointer) (zmin :pointer)
  (xmax :pointer) (ymax :pointer) (zmax :pointer))

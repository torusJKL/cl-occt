(in-package :cl-occt.impl)

;; --- Mesh Operations ---

(defcfun (%mesh-shape "mesh_shape") :pointer
  (shape :pointer)
  (deflection :double)
  (angle :double)
  (relative :int))

(defcfun (%mesh-get-vertices "mesh_get_vertices") :int
  (shape :pointer)
  (out-verts :pointer)
  (max-count :int))

(defcfun (%mesh-get-triangles "mesh_get_triangles") :int
  (shape :pointer)
  (out-tris :pointer)
  (max-count :int))

(defcfun (%mesh-get-normals "mesh_get_normals") :int
  (shape :pointer)
  (out-normals :pointer)
  (max-count :int))

(defcfun (%mesh-get-triangle-count "mesh_get_triangle_count") :int
  (shape :pointer))

;; --- Poly_Connect ---

(defcfun (%mesh-triangle-adjacent "mesh_triangle_adjacent") :int
  (shape :pointer)
  (tri-index :int)
  (edge-index :int))

(defcfun (%mesh-triangle-elements "mesh_triangle_elements") :int
  (shape :pointer)
  (tri-index :int)
  (out-n1 :pointer)
  (out-n2 :pointer)
  (out-n3 :pointer))

;; --- MeshVS ---

(defcfun (%meshvs-create-mesh "meshvs_create_mesh") :pointer)

(defcfun (%meshvs-free-mesh "meshvs_free_mesh") :void
  (mesh :pointer))

(defcfun (%meshvs-set-data "meshvs_set_data") :int
  (mesh :pointer)
  (verts :pointer)
  (vcount :int)
  (tris :pointer)
  (tcount :int)
  (colors :pointer))

(defcfun (%meshvs-display "meshvs_display") :void
  (ctx :pointer)
  (mesh :pointer))

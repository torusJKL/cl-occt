(in-package :cl-occt.impl)

(defcfun (%write-step "write_step") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-step "read_step") :pointer
  (filename :string))

(defcfun (%write-stl "write_stl") :int
  (shape :pointer)
  (filename :string)
  (deflection :double)
  (angle :double)
  (relative :int))

(defcfun (%read-stl "read_stl") :pointer
  (filename :string))

(defcfun (%write-iges "write_iges") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-iges "read_iges") :pointer
  (filename :string))

(defcfun (%xde-read-iges "xde_read_iges") :pointer
  (filename :string))

(defcfun (%xde-write-iges "xde_write_iges") :int
  (doc :pointer)
  (filename :string))

(defcfun (%write-obj "write_obj") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (name-format :int)
  (per-vertex-colors :int))

(defcfun (%read-obj "read_obj") :pointer
  (filename :string)
  (coordinate-system :int))

(defcfun (%write-vrml "write_vrml") :int
  (shape :pointer)
  (filename :string)
  (deflection :double))

(defcfun (%write-gltf "write_gltf") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (per-vertex-colors :int))

(defcfun (%read-gltf "read_gltf") :pointer
  (filename :string)
  (coordinate-system :int))

(defcfun (%write-ply "write_ply") :int
  (shape :pointer)
  (filename :string)
  (coordinate-system :int)
  (per-vertex-colors :int))

(defcfun (%rwmesh-coordinate-system-zup "rwmesh_coordinate_system_zup") :int)

(defcfun (%rwmesh-coordinate-system-yup "rwmesh_coordinate_system_yup") :int)

(defcfun (%rwmesh-name-format-auto "rwmesh_name_format_auto") :int)

(defcfun (%rwmesh-name-format-short "rwmesh_name_format_short") :int)

(defcfun (%rwmesh-name-format-full "rwmesh_name_format_full") :int)

(in-package :cl-occt.impl)

(defcfun (%find-edges-by-type "find_edges_by_type") :pointer
  (shape :pointer)
  (curve-type :int)
  (out-count :pointer))

(defcfun (%find-edges-by-radius "find_edges_by_radius") :pointer
  (shape :pointer)
  (radius :double)
  (out-count :pointer))

(defcfun (%free-shape-array "free_shape_array") :void
  (arr :pointer))

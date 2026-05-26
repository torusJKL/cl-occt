(in-package :cl-occt.impl)

(defcfun (%shape-proximity "shape_proximity") :int
  (shape1 :pointer)
  (shape2 :pointer)
  (tolerance :double)
  (out-value :pointer)
  (out-subshapes1 :pointer)
  (out-subshapes2 :pointer)
  (max-results :int))

(defcfun (%shape-overlap-p "shape_overlap_p") :int
  (shape1 :pointer)
  (shape2 :pointer)
  (tolerance :double))

(defcfun (%shape-overlap-detail "shape_overlap_detail") :int
  (shape1 :pointer)
  (shape2 :pointer)
  (tolerance :double)
  (out-subshapes1 :pointer)
  (out-subshapes2 :pointer)
  (max-results :int))

(defcfun (%shape-self-intersect "shape_self_intersect") :int
  (shape :pointer)
  (tolerance :double)
  (out-faces :pointer)
  (max-results :int))

(defcfun (%face-distance "face_distance") :int
  (face1 :pointer)
  (face2 :pointer)
  (out-min :pointer)
  (out-max :pointer))

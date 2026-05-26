(in-package :cl-occt.impl)

(defcfun (%vertex-point "vertex_point") :int
  (vertex :pointer)
  (out-x :pointer)
  (out-y :pointer)
  (out-z :pointer))

(defcfun (%edge-get-curve "edge_get_curve") :pointer
  (edge :pointer)
  (out-first :pointer)
  (out-last :pointer))

(defcfun (%face-get-surface "face_get_surface") :pointer
  (face :pointer)
  (out-umin :pointer)
  (out-umax :pointer)
  (out-vmin :pointer)
  (out-vmax :pointer))

(defcfun (%shape-tolerance "shape_tolerance") :int
  (shape :pointer)
  (out-tol :pointer))

(defcfun (%face-natural-restriction "face_natural_restriction") :int
  (face :pointer))

(defcfun (%shape-reversed "shape_reversed") :pointer
  (shape :pointer))

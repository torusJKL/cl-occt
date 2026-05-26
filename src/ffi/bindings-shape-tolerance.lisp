(in-package :cl-occt.impl)

(defcfun (%set-shape-tolerance "set_shape_tolerance") :int
  (shape :pointer)
  (tolerance :double)
  (shape-type :int))

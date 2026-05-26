(in-package :cl-occt.impl)

(defcfun (%shape-copy "shape_copy") :pointer
  (shape :pointer))

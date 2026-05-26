(in-package :cl-occt.impl)

(defcfun (%fix-small-faces "fix_small_faces") :pointer
  (shape :pointer))

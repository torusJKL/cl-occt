(in-package :cl-occt.impl)

(defcfun (%normal-project "normal_project") :pointer
  (shape-to-project :pointer)
  (face :pointer))

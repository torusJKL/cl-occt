(in-package :cl-occt.impl)

(defcfun (%remove-features "remove_features") :pointer
  (shape :pointer)
  (faces :pointer)
  (num-faces :int))

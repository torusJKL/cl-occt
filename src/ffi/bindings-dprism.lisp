(in-package :cl-occt.impl)

(defcfun (%make-drafted-prism "make_drafted_prism") :pointer
  (shape :pointer)
  (face :pointer)
  (profile :pointer)
  (height :double)
  (angle :double)
  (operation :int))

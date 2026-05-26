(in-package :cl-occt.impl)

(defcfun (%translate "translate") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%rotate "rotate") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

(in-package :cl-occt.impl)

(defcfun (%curve-value "curve_value") :int
  (curve :pointer)
  (t-param :double)
  (out-x :pointer)
  (out-y :pointer)
  (out-z :pointer))

(defcfun (%surface-value "surface_value") :int
  (surface :pointer)
  (u :double)
  (v :double)
  (out-x :pointer)
  (out-y :pointer)
  (out-z :pointer))

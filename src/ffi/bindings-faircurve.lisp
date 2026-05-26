(in-package :cl-occt.impl)

(defcfun (%fair-curve-batten "fair_curve_batten") :pointer
  (points :pointer)
  (num-points :int)
  (free-end :int)
  (free-slide :int)
  (init-tangent :pointer)
  (final-tangent :pointer))

(defcfun (%fair-curve-minvar "fair_curve_minvar") :pointer
  (points :pointer)
  (num-points :int)
  (free-end :int)
  (free-slide :int)
  (init-slope :pointer)
  (final-slope :pointer))

(in-package :cl-occt.impl)

(defcfun (%fill-surface-from-curves "fill_surface_from_curves") :pointer
  (curves :pointer)
  (num-curves :int)
  (continuity :int)
  (support-faces :pointer)
  (num-support-faces :int))

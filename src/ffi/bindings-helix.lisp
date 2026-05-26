(in-package :cl-occt.impl)

(defcfun (%make-helix-curve "make_helix_curve") :pointer
  (radius :double) (pitch :double) (height :double)
  (left-handed :int) (angle :double))

(defcfun (%make-helix-edge "make_helix_edge") :pointer
  (radius :double) (pitch :double) (height :double)
  (left-handed :int) (angle :double)
  (on-surface :pointer))

(in-package :cl-occt.impl)

(defcfun (%uniform-abscissa-points "uniform_abscissa_points") :int
  (curve :pointer)
  (first :double)
  (last :double)
  (num-points :int)
  (out-coords :pointer))

(defcfun (%uniform-deflection-points "uniform_deflection_points") :int
  (curve :pointer)
  (first :double)
  (last :double)
  (deflection :double)
  (out-coords :pointer))

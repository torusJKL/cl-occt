(in-package :cl-occt.impl)

(defcfun (%gccana-circle-tangent-two-lines "gccana_circle_tangent_two_lines") :int
  (x1 :double) (y1 :double) (dx1 :double) (dy1 :double)
  (x2 :double) (y2 :double) (dx2 :double) (dy2 :double)
  (radius :double)
  (out-circles :pointer) (max-circles :int) (out-count :pointer))

(defcfun (%gccana-line-through-two-points "gccana_line_through_two_points") :int
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double)
  (out-params :pointer))

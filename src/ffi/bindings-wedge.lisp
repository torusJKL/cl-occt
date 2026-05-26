(in-package :cl-occt.impl)

(defcfun (%make-wedge-full "make_wedge_full") :pointer
  (dx :double)
  (dy :double)
  (dz :double)
  (ltx :double))

(defcfun (%make-wedge-corner "make_wedge_corner") :pointer
  (dx :double)
  (dy :double)
  (dz :double)
  (xmin :double)
  (zmin :double)
  (xmax :double)
  (zmax :double))

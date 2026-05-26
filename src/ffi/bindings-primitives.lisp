(in-package :cl-occt.impl)

(defcfun (%make-box "make_box") :pointer
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-cylinder "make_cylinder") :pointer
  (radius :double)
  (height :double))

(defcfun (%make-sphere "make_sphere") :pointer
  (radius :double))

(defcfun (%make-cone "make_cone") :pointer
  (r1 :double)
  (r2 :double)
  (height :double))

(defcfun (%make-torus "make_torus") :pointer
  (major-radius :double)
  (minor-radius :double))

(defcfun (%make-prism "make_prism") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-revol "make_revol") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

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

(defcfun (%boolean-cut "boolean_cut") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-fuse "boolean_fuse") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-common "boolean_common") :pointer
  (a :pointer)
  (b :pointer))

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

(defcfun (%write-step "write_step") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-step "read_step") :pointer
  (filename :string))

(defcfun (%free-shape "free_shape") :void
  (shape :pointer))

(defcfun (%get-error-code "get_error_code") :int)

(defcfun (%get-error-message "get_error_message") :string)

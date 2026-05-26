(in-package :cl-occt.impl)

(defcfun (%boolean-cut "boolean_cut") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-fuse "boolean_fuse") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-common "boolean_common") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-section "boolean_section") :pointer
  (a :pointer)
  (b :pointer))

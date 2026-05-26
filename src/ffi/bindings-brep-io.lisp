(in-package :cl-occt.impl)

(defcfun (%brep-write-shape "brep_write_shape") :int
  (shape :pointer)
  (filename :string))

(defcfun (%brep-read-shape "brep_read_shape") :pointer
  (filename :string))

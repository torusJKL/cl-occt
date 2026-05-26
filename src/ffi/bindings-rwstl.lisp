(in-package :cl-occt.impl)

(defcfun (%rwstl-read-file "rwstl_read_file") :pointer
  (filename :string))

(defcfun (%rwstl-write-file "rwstl_write_file") :int
  (tri :pointer)
  (filename :string))

(defcfun (%rwstl-free-triangulation "rwstl_free_triangulation") :void
  (tri :pointer))

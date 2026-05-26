(in-package :cl-occt.impl)

;; --- Topological Naming ---

(defcfun (%ocaf-name-shape "ocaf_name_shape") :void
  (label :pointer)
  (shape :pointer)
  (evolution :int))

(defcfun (%ocaf-get-named-shape "ocaf_get_named_shape") :pointer
  (label :pointer)
  (evolution :int))

(defcfun (%ocaf-named-shape-is-deleted "ocaf_named_shape_is_deleted") :int
  (label :pointer))

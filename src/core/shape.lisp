(in-package :cl-occt)

(defclass shape ()
  ((%ptr :initarg :ptr :reader %ptr))
  (:documentation "Wraps a TopoDS_Shape handle from OCCT with GC via tg:finalize."))

(defun shape-p (obj)
  "**Returns:** `t` if `obj` is a `shape` object, `nil` otherwise."
  (typep obj 'shape))

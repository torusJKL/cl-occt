(in-package :cl-occt)

(defclass shape ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun shape-p (obj)
  "Return T if OBJ is a shape object, NIL otherwise."
  (typep obj 'shape))

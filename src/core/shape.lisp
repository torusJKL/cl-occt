(in-package :cl-occt)

(defclass shape ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun shape-p (obj)
  (typep obj 'shape))

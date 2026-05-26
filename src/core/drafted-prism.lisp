(in-package :cl-occt)

(defun make-drafted-prism (shape face profile height angle operation)
  (if (or (null shape) (null face) (null profile))
      nil
      (make-shape (%make-drafted-prism (%ptr shape) (%ptr face) (%ptr profile)
                                       (coerce height 'double-float)
                                       (coerce angle 'double-float)
                                       operation))))

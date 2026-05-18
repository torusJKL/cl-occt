(in-package :cl-occt)

(defun translate (shape dx dy dz)
  (if (null shape)
      nil
      (make-shape (%translate (%ptr shape)
                              (coerce dx 'double-float)
                              (coerce dy 'double-float)
                              (coerce dz 'double-float)))))

(defun rotate (shape ax ay az angle-deg)
  (if (null shape)
      nil
      (make-shape (%rotate (%ptr shape)
                           (coerce ax 'double-float)
                           (coerce ay 'double-float)
                           (coerce az 'double-float)
                           (coerce angle-deg 'double-float)))))

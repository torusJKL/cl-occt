(in-package :cl-occt)

(defun translate (shape dx dy dz)
  "Translate (move) SHAPE by the vector (DX DY DZ).

  Returns a new translated copy of SHAPE. The original is not modified.

  Example:
    (translate (make-box 10 10 10) 20 0 0)"
  (if (null shape)
      nil
      (make-shape (%translate (%ptr shape)
                              (coerce dx 'double-float)
                              (coerce dy 'double-float)
                              (coerce dz 'double-float)))))

(defun rotate (shape ax ay az angle-deg)
  "Rotate SHAPE by ANGLE-DEG around the axis (AX AY AZ).

  The axis passes through the origin. Returns a new rotated copy of
  SHAPE. The original is not modified.

  Example:
    (rotate (make-box 10 20 30) 0 0 1 45)"
  (if (null shape)
      nil
      (make-shape (%rotate (%ptr shape)
                           (coerce ax 'double-float)
                           (coerce ay 'double-float)
                           (coerce az 'double-float)
                           (coerce angle-deg 'double-float)))))

(in-package :cl-occt)

(defun local-extrude (face height &key direction)
  (declare (ignore direction))
  (if (null face)
      nil
      (make-shape (%local-extrude
                    (%ptr face)
                    (coerce height 'double-float)
                    (coerce 0 'double-float)
                    (coerce 0 'double-float)
                    (coerce 0 'double-float)))))

(defun make-groove (shape face axis angle)
  (if (or (null shape) (null face) (null axis))
      nil
      (make-shape (%make-groove
                    (%ptr shape) (%ptr face)
                    (coerce (first axis) 'double-float)
                    (coerce (second axis) 'double-float)
                    (coerce (third axis) 'double-float)
                    (coerce angle 'double-float)))))

(defun make-rib (shape profile thickness &key (direction '(0 1 0)))
  (if (or (null shape) (null profile))
      nil
      (make-shape (%make-rib
                    (%ptr shape) (%ptr profile)
                    (coerce thickness 'double-float)
                    (coerce (first direction) 'double-float)
                    (coerce (second direction) 'double-float)
                    (coerce (third direction) 'double-float)))))

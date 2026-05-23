(in-package :cl-occt)

(defun make-cylindrical-hole (shape face radius depth &key through)
  (if (or (null shape) (null face))
      nil
      (make-shape (%make-cylindrical-hole (%ptr shape) (%ptr face)
                                           (coerce radius 'double-float)
                                           (coerce depth 'double-float)
                                           (if through 1 0)))))

(defun make-prism-feature (shape base-face profile height
                           &key (operation :cut) (direction nil))
  (if (or (null shape) (null base-face) (null profile))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1))
            (dir (or direction '(0 0 1))))
        (make-shape (%make-prism-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (coerce height 'double-float)
                      (coerce (first dir) 'double-float)
                      (coerce (second dir) 'double-float)
                      (coerce (third dir) 'double-float)
                      op-flag)))))

(defun make-revol-feature (shape base-face profile axis angle
                           &key (operation :cut))
  (if (or (null shape) (null base-face) (null profile) (null axis))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1)))
        (make-shape (%make-revol-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (coerce (first axis) 'double-float)
                      (coerce (second axis) 'double-float)
                      (coerce (third axis) 'double-float)
                      (coerce angle 'double-float)
                      op-flag)))))

(in-package :cl-occt)

(defun make-location (dx dy dz)
  (let ((ptr (%location-from-translation (coerce dx 'double-float)
                                         (coerce dy 'double-float)
                                         (coerce dz 'double-float))))
    (if (cffi:null-pointer-p ptr)
        nil
        ptr)))

(defun compose-locations (loc1 loc2)
  (if (or (null loc1) (null loc2))
      nil
      (%location-multiply loc1 loc2)))

(defun invert-location (loc)
  (if (null loc)
      nil
      (%location-inverted loc)))

(defun shape-location (shape)
  (if (null shape)
      nil
      (%shape-get-location (%ptr shape))))

(defun move-shape (shape location)
  (if (or (null shape) (null location))
      nil
      (make-shape (%shape-moved (%ptr shape) location))))

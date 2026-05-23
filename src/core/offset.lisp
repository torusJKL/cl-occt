(in-package :cl-occt)

(defun offset-shape (shape offset-distance &key (join :arc))
  (if (null shape)
      nil
      (let ((join-val (ecase join
                        (:arc 0)
                        (:tangent 1)
                        (:intersection 2))))
        (make-shape (%offset-shape-3d (%ptr shape)
                                       (coerce offset-distance 'double-float)
                                       join-val)))))

(defun offset-wire (wire offset-distance)
  (if (null wire)
      nil
      (make-shape (%offset-wire-2d (%ptr wire)
                                    (coerce offset-distance 'double-float)))))

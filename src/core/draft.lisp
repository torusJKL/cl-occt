(in-package :cl-occt)

(defun draft-face (shape face angle pull-direction neutral-plane)
  (if (or (null shape) (null face) (null pull-direction) (null neutral-plane))
      nil
      (let* ((pd (mapcar (lambda (v) (coerce v 'double-float)) pull-direction))
             (dx (first pd)) (dy (second pd)) (dz (third pd))
             (np (mapcar (lambda (v) (coerce v 'double-float))
                         (if (= (length neutral-plane) 3)
                             neutral-plane
                             (subseq neutral-plane 0 3))))
             (px (first np)) (py (second np)) (pz (third np)))
        (make-shape (%draft-face (%ptr shape) (%ptr face)
                                  (coerce angle 'double-float)
                                  dx dy dz
                                  px py pz
                                  dx dy dz)))))

(defun make-evolved (profile spine &key (offset 0.0) (join :arc))
  (if (or (null profile) (null spine))
      nil
      (let ((join-val (ecase join
                        (:arc 0)
                        (:tangent 1)
                        (:intersection 2))))
        (make-shape (%make-evolved (%ptr profile) (%ptr spine)
                                    (coerce offset 'double-float)
                                    join-val)))))

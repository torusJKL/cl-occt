(in-package :cl-occt.impl)

(in-package :cl-occt)

(defun fair-curve-batten (points &key (free-end nil) (free-slide nil)
                                   initial-tangent final-tangent)
  "Create a FairCurve batten (physical spline) through the given 3D `points`.
  ...
  **See also:** `fair-curve-minvar`"
  (unless (and points (listp points) (>= (length points) 2))
    (return-from fair-curve-batten nil))
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n)))
         (init-tg (if initial-tangent
                      (let ((p (cffi:foreign-alloc :double :count 3)))
                        (setf (cffi:mem-aref p :double 0) (coerce (first initial-tangent) 'double-float)
                              (cffi:mem-aref p :double 1) (coerce (second initial-tangent) 'double-float)
                              (cffi:mem-aref p :double 2) (coerce (third initial-tangent) 'double-float))
                        p)
                      (cffi:null-pointer)))
         (fin-tg (if final-tangent
                     (let ((p (cffi:foreign-alloc :double :count 3)))
                       (setf (cffi:mem-aref p :double 0) (coerce (first final-tangent) 'double-float)
                             (cffi:mem-aref p :double 1) (coerce (second final-tangent) 'double-float)
                             (cffi:mem-aref p :double 2) (coerce (third final-tangent) 'double-float))
                       p)
                     (cffi:null-pointer))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-curve (%fair-curve-batten arr n
                                            (if free-end 1 0)
                                            (if free-slide 1 0)
                                            init-tg fin-tg)))
      (cffi:foreign-free arr)
      (unless (cffi:null-pointer-p init-tg) (cffi:foreign-free init-tg))
      (unless (cffi:null-pointer-p fin-tg) (cffi:foreign-free fin-tg)))))

(defun fair-curve-minvar (points &key (free-end nil) (free-slide nil)
                                   initial-slope final-slope)
  "Create a FairCurve with minimal curvature variation through the given 3D `points`.
  ...
  **See also:** `fair-curve-batten`"
  (unless (and points (listp points) (>= (length points) 2))
    (return-from fair-curve-minvar nil))
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n)))
         (init-sl (if initial-slope
                      (let ((p (cffi:foreign-alloc :double :count 3)))
                        (setf (cffi:mem-aref p :double 0) (coerce (first initial-slope) 'double-float)
                              (cffi:mem-aref p :double 1) (coerce (second initial-slope) 'double-float)
                              (cffi:mem-aref p :double 2) (coerce (third initial-slope) 'double-float))
                        p)
                      (cffi:null-pointer)))
         (fin-sl (if final-slope
                     (let ((p (cffi:foreign-alloc :double :count 3)))
                       (setf (cffi:mem-aref p :double 0) (coerce (first final-slope) 'double-float)
                             (cffi:mem-aref p :double 1) (coerce (second final-slope) 'double-float)
                             (cffi:mem-aref p :double 2) (coerce (third final-slope) 'double-float))
                       p)
                     (cffi:null-pointer))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-curve (%fair-curve-minvar arr n
                                             (if free-end 1 0)
                                             (if free-slide 1 0)
                                             init-sl fin-sl)))
      (cffi:foreign-free arr)
      (unless (cffi:null-pointer-p init-sl) (cffi:foreign-free init-sl))
      (unless (cffi:null-pointer-p fin-sl) (cffi:foreign-free fin-sl)))))

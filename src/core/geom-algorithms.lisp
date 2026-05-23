(in-package :cl-occt)

(defun project-point-on-curve (curve x y z)
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from project-point-on-curve nil))
    (cffi:with-foreign-objects ((ox :double) (oy :double) (oz :double)
                                 (dist :double) (param :double))
      (let ((result (%project-point-on-curve ptr
                    (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                    ox oy oz dist param)))
        (when (zerop result) (return-from project-point-on-curve nil))
        (values (cffi:mem-ref ox :double)
                (cffi:mem-ref oy :double)
                (cffi:mem-ref oz :double)
                (cffi:mem-ref dist :double)
                (cffi:mem-ref param :double))))))

(defun project-point-on-surface (surface x y z)
  (let ((ptr (%ptr surface)))
    (when (cffi:null-pointer-p ptr)
      (return-from project-point-on-surface nil))
    (cffi:with-foreign-objects ((ox :double) (oy :double) (oz :double)
                                 (u :double) (v :double) (dist :double))
      (let ((result (%project-point-on-surface ptr
                    (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                    ox oy oz u v dist)))
        (when (zerop result) (return-from project-point-on-surface nil))
        (values (cffi:mem-ref ox :double)
                (cffi:mem-ref oy :double)
                (cffi:mem-ref oz :double)
                (cffi:mem-ref u :double)
                (cffi:mem-ref v :double)
                (cffi:mem-ref dist :double))))))

(defun intersect-curves (curve1 curve2)
  (let ((p1 (%ptr curve1))
        (p2 (%ptr curve2)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from intersect-curves nil))
    (let ((count (%intersect-curves p1 p2 (cffi:null-pointer) 0)))
      (when (zerop count) (return-from intersect-curves nil))
      (let ((arr (cffi:foreign-alloc :double :count (* 3 count))))
        (unwind-protect
             (progn
               (%intersect-curves p1 p2 arr count)
               (loop for i from 0 below count
                     collect (list (cffi:mem-aref arr :double (+ (* i 3) 0))
                                   (cffi:mem-aref arr :double (+ (* i 3) 1))
                                   (cffi:mem-aref arr :double (+ (* i 3) 2)))))
          (cffi:foreign-free arr))))))

(defun intersect-curve-surface (curve surface)
  (let ((p1 (%ptr curve))
        (p2 (%ptr surface)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from intersect-curve-surface nil))
    (let ((count (%intersect-curve-surface p1 p2 (cffi:null-pointer) 0)))
      (when (zerop count) (return-from intersect-curve-surface nil))
      (let ((arr (cffi:foreign-alloc :double :count (* 3 count))))
        (unwind-protect
             (progn
               (%intersect-curve-surface p1 p2 arr count)
               (loop for i from 0 below count
                     collect (list (cffi:mem-aref arr :double (+ (* i 3) 0))
                                   (cffi:mem-aref arr :double (+ (* i 3) 1))
                                   (cffi:mem-aref arr :double (+ (* i 3) 2)))))
          (cffi:foreign-free arr))))))

(defun intersect-surfaces (surface1 surface2)
  (let ((p1 (%ptr surface1))
        (p2 (%ptr surface2)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from intersect-surfaces nil))
    (let ((count (%intersect-surfaces p1 p2 (cffi:null-pointer) 0)))
      (when (zerop count) (return-from intersect-surfaces nil))
      (let ((arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (%intersect-surfaces p1 p2 arr count)
               (loop for i from 0 below count
                     collect (make-curve (cffi:mem-aref arr :pointer i))))
          (cffi:foreign-free arr))))))

(defun extrema-curve-curve (curve1 curve2)
  (let ((p1 (%ptr curve1))
        (p2 (%ptr curve2)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from extrema-curve-curve nil))
    (cffi:with-foreign-objects ((dist :double)
                                 (p1x :double) (p1y :double) (p1z :double)
                                 (p2x :double) (p2y :double) (p2z :double))
      (let ((result (%extrema-curve-curve p1 p2 dist p1x p1y p1z p2x p2y p2z)))
        (when (zerop result) (return-from extrema-curve-curve nil))
        (values (cffi:mem-ref dist :double)
                (list (cffi:mem-ref p1x :double)
                      (cffi:mem-ref p1y :double)
                      (cffi:mem-ref p1z :double))
                (list (cffi:mem-ref p2x :double)
                      (cffi:mem-ref p2y :double)
                      (cffi:mem-ref p2z :double)))))))

(defun extrema-curve-surface (curve surface)
  (let ((p1 (%ptr curve))
        (p2 (%ptr surface)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from extrema-curve-surface nil))
    (cffi:with-foreign-objects ((dist :double)
                                 (px :double) (py :double) (pz :double)
                                 (u :double) (v :double))
      (let ((result (%extrema-curve-surface p1 p2 dist px py pz u v)))
        (when (zerop result) (return-from extrema-curve-surface nil))
        (values (cffi:mem-ref dist :double)
                (list (cffi:mem-ref px :double)
                      (cffi:mem-ref py :double)
                      (cffi:mem-ref pz :double))
                (cffi:mem-ref u :double)
                (cffi:mem-ref v :double))))))

(defun intersect-curves-2d (curve1 curve2)
  (let ((p1 (%ptr curve1))
        (p2 (%ptr curve2)))
    (when (or (cffi:null-pointer-p p1) (cffi:null-pointer-p p2))
      (return-from intersect-curves-2d nil))
    (let ((count (%intersect-curves-2d p1 p2 (cffi:null-pointer) 0)))
      (when (zerop count) (return-from intersect-curves-2d nil))
      (let ((arr (cffi:foreign-alloc :double :count (* 2 count))))
        (unwind-protect
             (progn
               (%intersect-curves-2d p1 p2 arr count)
               (loop for i from 0 below count
                     collect (list (cffi:mem-aref arr :double (+ (* i 2) 0))
                                   (cffi:mem-aref arr :double (+ (* i 2) 1)))))
          (cffi:foreign-free arr))))))

(defun project-point-on-curve-2d (curve x y)
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from project-point-on-curve-2d nil))
    (cffi:with-foreign-objects ((ox :double) (oy :double)
                                 (dist :double) (param :double))
      (let ((result (%project-point-on-curve-2d ptr
                    (coerce x 'double-float) (coerce y 'double-float)
                    ox oy dist param)))
        (when (zerop result) (return-from project-point-on-curve-2d nil))
        (values (cffi:mem-ref ox :double)
                (cffi:mem-ref oy :double)
                (cffi:mem-ref dist :double)
                (cffi:mem-ref param :double))))))

(defun points-to-bspline (points &key (degree 3))
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-curve (%points-to-bspline arr n degree)))
      (cffi:foreign-free arr))))

(defun interpolate-points (points &key initial-tangent final-tangent)
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n)))
         (init-arr (if initial-tangent
                       (cffi:foreign-alloc :double :count 3)
                       (cffi:null-pointer)))
         (final-arr (if final-tangent
                        (cffi:foreign-alloc :double :count 3)
                        (cffi:null-pointer))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (when initial-tangent
             (setf (cffi:mem-aref init-arr :double 0) (coerce (first initial-tangent) 'double-float)
                   (cffi:mem-aref init-arr :double 1) (coerce (second initial-tangent) 'double-float)
                   (cffi:mem-aref init-arr :double 2) (coerce (third initial-tangent) 'double-float)))
           (when final-tangent
             (setf (cffi:mem-aref final-arr :double 0) (coerce (first final-tangent) 'double-float)
                   (cffi:mem-aref final-arr :double 1) (coerce (second final-tangent) 'double-float)
                   (cffi:mem-aref final-arr :double 2) (coerce (third final-tangent) 'double-float)))
           (make-curve (%interpolate-points arr n init-arr final-arr)))
      (cffi:foreign-free arr)
      (unless (cffi:null-pointer-p init-arr) (cffi:foreign-free init-arr))
      (unless (cffi:null-pointer-p final-arr) (cffi:foreign-free final-arr)))))

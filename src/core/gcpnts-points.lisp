(in-package :cl-occt)

(defun uniform-abscissa-points (curve first last num-points)
  (if (null curve)
      nil
      (cffi:with-foreign-object (out-coords :double (* num-points 3))
        (let ((count (%uniform-abscissa-points (%ptr curve)
                                                (coerce first 'double-float)
                                                (coerce last 'double-float)
                                                num-points
                                                out-coords)))
          (when (plusp count)
            (loop for i below count
                  collect (list (cffi:mem-aref out-coords :double (+ (* i 3) 0))
                                (cffi:mem-aref out-coords :double (+ (* i 3) 1))
                                (cffi:mem-aref out-coords :double (+ (* i 3) 2)))))))))

(defun uniform-deflection-points (curve first last deflection)
  (if (null curve)
      nil
      (let ((max-pts 10000))
        (cffi:with-foreign-object (out-coords :double (* max-pts 3))
          (let ((count (%uniform-deflection-points (%ptr curve)
                                                    (coerce first 'double-float)
                                                    (coerce last 'double-float)
                                                    (coerce deflection 'double-float)
                                                    out-coords)))
            (when (plusp count)
              (loop for i below count
                    collect (list (cffi:mem-aref out-coords :double (+ (* i 3) 0))
                                  (cffi:mem-aref out-coords :double (+ (* i 3) 1))
                                  (cffi:mem-aref out-coords :double (+ (* i 3) 2))))))))))

(in-package :cl-occt)

(defun uniform-abscissa-points (curve first last num-points)
  "Generate uniformly spaced points along a **curve** by abscissa.

  - **curve** a curve object
  - **first** start parameter on the curve
  - **last** end parameter on the curve
  - **num-points** number of points to generate

  Returns a list of (x y z) point triples, or nil.

  **See also:** `uniform-deflection-points`"
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
  "Generate points along a **curve** within a given **deflection** tolerance.

  - **curve** a curve object
  - **first** start parameter on the curve
  - **last** end parameter on the curve
  - **deflection** maximum allowed deviation between curve and chord

  Returns a list of (x y z) point triples, or nil.

  **See also:** `uniform-abscissa-points`"
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

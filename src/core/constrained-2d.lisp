(in-package :cl-occt)

(defun circle-tangent-two-lines (line1-pt line1-dir line2-pt line2-dir radius)
  "Compute circles of RADIUS tangent to two 2D lines.
  Each line is specified as a point (x y) and direction (dx dy).
  Returns a list of (center-x center-y radius) plists, or nil."
  (check-type line1-pt list) (check-type line1-dir list)
  (check-type line2-pt list) (check-type line2-dir list)
  (when (and (= 2 (length line1-pt)) (= 2 (length line1-dir))
             (= 2 (length line2-pt)) (= 2 (length line2-dir))
             (numberp radius) (> radius 0))
    (cffi:with-foreign-object (out-circles :double (* 3 8))
      (cffi:with-foreign-object (out-count :int)
        (let ((x1 (coerce (first line1-pt) 'double-float))
              (y1 (coerce (second line1-pt) 'double-float))
              (dx1 (coerce (first line1-dir) 'double-float))
              (dy1 (coerce (second line1-dir) 'double-float))
              (x2 (coerce (first line2-pt) 'double-float))
              (y2 (coerce (second line2-pt) 'double-float))
              (dx2 (coerce (first line2-dir) 'double-float))
              (dy2 (coerce (second line2-dir) 'double-float))
              (r (coerce radius 'double-float)))
          (when (= 1 (%gccana-circle-tangent-two-lines
                      x1 y1 dx1 dy1 x2 y2 dx2 dy2 r
                      out-circles 8 out-count))
            (let ((n (cffi:mem-aref out-count :int)))
              (when (plusp n)
                (loop for i from 0 below n
                      collect (list :center-x (cffi:mem-aref out-circles :double (+ (* i 3) 0))
                                    :center-y (cffi:mem-aref out-circles :double (+ (* i 3) 1))
                                    :radius (cffi:mem-aref out-circles :double (+ (* i 3) 2))))))))))))

(defun line-through-two-points (p1 p2)
  "Compute a 2D line passing through two points.
  Each point is (x y). Returns (point-x point-y dir-x dir-y) or nil."
  (check-type p1 list) (check-type p2 list)
  (when (and (= 2 (length p1)) (= 2 (length p2)))
    (cffi:with-foreign-object (out-params :double 4)
      (let ((x1 (coerce (first p1) 'double-float))
            (y1 (coerce (second p1) 'double-float))
            (x2 (coerce (first p2) 'double-float))
            (y2 (coerce (second p2) 'double-float)))
        (when (= 1 (%gccana-line-through-two-points x1 y1 x2 y2 out-params))
          (list (cffi:mem-aref out-params :double 0)
                (cffi:mem-aref out-params :double 1)
                (cffi:mem-aref out-params :double 2)
                (cffi:mem-aref out-params :double 3)))))))

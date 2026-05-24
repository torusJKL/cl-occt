(in-package :cl-occt)

(defun project-point-on-curve (curve x y z)
  "Project a 3D point onto a curve, returning the closest point on the curve.

  CURVE -- a curve object
  X Y Z -- coordinates of the point to project (double-float)

  Returns five values: projected point (X Y Z), distance, and curve parameter.
  Returns NIL if the curve is null or projection fails.

  Example:
    (let ((c (make-bezier-curve '((0 0 0) (5 10 0) (10 0 0)))))
      (project-point-on-curve c 2 5 0))
    => multiple values: projected X, Y, Z, distance, parameter"
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
  "Project a 3D point onto a surface, returning the closest point and UV parameters.

  SURFACE -- a surface object
  X Y Z -- coordinates of the point to project (double-float)

  Returns six values: projected point (X Y Z), UV parameters (U V), and distance.
  Returns NIL if the surface is null or projection fails.

  Example:
    (let ((s (make-plane)))
      (project-point-on-surface s 5 5 10))
    => multiple values: 5.0d0 5.0d0 0.0d0 5.0d0 5.0d0 10.0d0"
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
  "Compute intersection points between two 3D curves.

  CURVE1 CURVE2 -- curve objects to intersect

  Returns a list of intersection points, each as (X Y Z).
  Returns NIL if curves are null or no intersections exist.

  Example:
    (let ((a (make-bezier-curve '((0 0 0) (5 5 0) (10 0 0))))
          (b (make-bezier-curve '((0 5 0) (5 0 0) (10 5 0)))))
      (intersect-curves a b))
    => list of intersection points

  See also: intersect-curves-2d, intersect-curve-surface, intersect-surfaces"
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
  "Compute intersection points between a curve and a surface.

  CURVE -- a curve object
  SURFACE -- a surface object

  Returns a list of intersection points, each as (X Y Z).
  Returns NIL if inputs are null or no intersections exist.

  Example:
    (let ((c (make-bezier-curve '((-10 0 0) (0 0 10) (10 0 0))))
          (s (make-plane)))
      (intersect-curve-surface c s))
    => intersection point(s)

  See also: intersect-curves, intersect-surfaces"
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
  "Compute intersection curves between two surfaces.

  SURFACE1 SURFACE2 -- surface objects to intersect

  Returns a list of intersection curves.
  Returns NIL if inputs are null or no intersections exist.

  Example:
    (let ((s1 (make-plane 0 0 0 1 0 0))
          (s2 (make-plane 0 0 0 0 1 0)))
      (intersect-surfaces s1 s2))
    => list of intersection curves (one straight line)

  See also: intersect-curves, intersect-curve-surface"
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
  "Find minimum distance and closest points between two 3D curves.

  CURVE1 CURVE2 -- curve objects

  Returns three values: minimum distance, point on CURVE1 (X Y Z),
  and point on CURVE2 (X Y Z).  Returns NIL on error.

  Example:
    (let ((a (make-bezier-curve '((0 0 0) (1 0 0) (2 0 0))))
          (b (make-bezier-curve '((0 2 0) (1 2 0) (2 2 0)))))
      (extrema-curve-curve a b))
    => multiple values: 2.0d0 (2 0 0) (2 2 0)

  See also: extrema-curve-surface, shape-distance-extrema"
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
  "Find minimum distance and closest point between a curve and a surface.

  CURVE -- a curve object
  SURFACE -- a surface object

  Returns four values: distance, closest point (X Y Z), and UV parameters (U V).
  Returns NIL on error.

  Example:
    (let ((c (make-bezier-curve '((0 0 -5) (0 0 5))))
          (s (make-plane)))
      (extrema-curve-surface c s))
    => multiple values: 5.0d0 (0 0 0) 0.0d0 0.0d0

  See also: extrema-curve-curve, shape-distance-extrema"
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
  "Compute intersection points between two 2D curves.

  CURVE1 CURVE2 -- 2D curve objects

  Returns a list of intersection points, each as (X Y).
  Returns NIL if curves are null or no intersections exist.

  Example:
    (let ((c1 (make-line2d 0 0 1 1))
          (c2 (make-line2d 2 0 -1 1)))
      (intersect-curves-2d c1 c2))
    => list of 2D intersection points

  See also: intersect-curves, intersect-curve-surface"
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
  "Project a 2D point onto a 2D curve.

  CURVE -- a 2D curve object (geom2d)
  X Y -- coordinates of the point to project (double-float)

  Returns four values: projected point (X Y), distance, and curve parameter.
  Returns NIL if curve is null or projection fails.

  Example:
    (let ((c (make-line2d 0 0 1 0)))
      (project-point-on-curve-2d c 3 5))
    => multiple values: 3.0d0 0.0d0 5.0d0 3.0d0

  See also: project-point-on-curve, intersect-curves-2d"
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
  "Create a B-spline curve interpolating a list of 3D points.

  POINTS -- list of 3D points, each as (X Y Z)
  DEGREE -- polynomial degree of the B-spline (default 3, must be >= 1)

  Returns a curve object, or NIL on error.

  Example:
    (points-to-bspline '((0 0 0) (5 10 0) (10 0 0)) :degree 2)

  See also: interpolate-points"
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
  "Interpolate a B-spline curve through a list of 3D points with optional tangents.

  POINTS -- list of 3D points, each as (X Y Z)
  INITIAL-TANGENT -- tangent vector (X Y Z) at the start of the curve (optional)
  FINAL-TANGENT -- tangent vector (X Y Z) at the end of the curve (optional)

  The curve passes through all points exactly.  Providing tangents gives
  control over the shape at the endpoints.

  Returns a curve object, or NIL on error.

  Example:
    (interpolate-points '((0 0 0) (5 10 0) (10 0 0))
                        :initial-tangent '(1 0 0)
                        :final-tangent '(-1 0 0))

  See also: points-to-bspline"
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

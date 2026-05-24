(in-package :cl-occt)

(defclass curve ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun curve-p (obj)
  "**Returns:** `t` if `obj` is a `curve` object, `nil` otherwise."
  (typep obj 'curve))

(in-package :cl-occt.impl)

(defun %curve-kind->keyword (kind)
  (ecase kind
    (0 :line)
    (1 :circle)
    (2 :ellipse)
    (3 :hyperbola)
    (4 :parabola)
    (5 :bezier-curve)
    (6 :bspline-curve)
    (7 :gc-line)
    (8 :gc-arc-of-circle)
    (9 :helix)))

(defun make-curve (ptr)
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((c (make-instance 'cl-occt:curve :ptr ptr)))
        (tg:finalize c (lambda () (%free-curve ptr)))
        c)))

(in-package :cl-occt)

(defun curve-type (curve)
  "Return the type keyword of `curve`.

  Returns one of `:line`, `:circle`, `:ellipse`, `:hyperbola`, `:parabola`,
  `:bezier-curve`, `:bspline-curve`, `:gc-line`, `:gc-arc-of-circle`, or `nil`.

  **Example:**

      (curve-type (make-line-3d 0 0 0 1 0 0))
      ;; => :LINE"
  (unless (typep curve 'curve)
    (return-from curve-type nil))
  (let ((ptr (%ptr curve)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from curve-type nil))
    (%curve-kind->keyword (%curve-type ptr))))

(defun make-line-3d (x y z dx dy dz)
  "Create a 3D line from point (`x`, `y`, `z`) in direction (`dx`, `dy`, `dz`).

  **Example:**

      (make-line-3d 0 0 0 1 0 0)

  **See also:** `make-gc-line`"
  (make-curve (%make-line-3d (coerce x 'double-float)
                              (coerce y 'double-float)
                              (coerce z 'double-float)
                              (coerce dx 'double-float)
                              (coerce dy 'double-float)
                              (coerce dz 'double-float))))

(defun make-circle-3d (x y z radius)
  "Create a circle centered at (`x`, `y`, `z`) with the given `radius`.

  The circle lies in the XY plane (normal along Z).

  **Example:**

      (make-circle-3d 0 0 0 5)

  **See also:** `make-ellipse`, `make-gc-arc-of-circle`"
  (make-curve (%make-circle-3d (coerce x 'double-float)
                                (coerce y 'double-float)
                                (coerce z 'double-float)
                                (coerce radius 'double-float))))

(defun make-ellipse (x y z major-r minor-r)
  "Create an ellipse centered at (`x`, `y`, `z`) with the given radii.

  - **major-r** semi-major axis length
  - **minor-r** semi-minor axis length

  The ellipse lies in the XY plane with the major axis along X.

  **Example:**

      (make-ellipse 0 0 0 10 5)

  **See also:** `make-circle-3d`"
  (make-curve (%make-ellipse-3d (coerce x 'double-float)
                                 (coerce y 'double-float)
                                 (coerce z 'double-float)
                                 (coerce major-r 'double-float)
                                 (coerce minor-r 'double-float))))

(defun make-hyperbola (x y z major-r minor-r)
  "Create a hyperbola centered at (`x`, `y`, `z`) with the given radii.

  - **major-r** transverse axis length
  - **minor-r** conjugate axis length

  The hyperbola lies in the XY plane.

  **Example:**

      (make-hyperbola 0 0 0 10 5)

  **See also:** `make-parabola`"
  (make-curve (%make-hyperbola (coerce x 'double-float)
                                (coerce y 'double-float)
                                (coerce z 'double-float)
                                (coerce major-r 'double-float)
                                (coerce minor-r 'double-float))))

(defun make-parabola (x y z focal)
  "Create a parabola at (`x`, `y`, `z`) with the given `focal` parameter.

  The parabola opens along the positive X axis in the XY plane.

  **Example:**

      (make-parabola 0 0 0 5)

  **See also:** `make-hyperbola`"
  (make-curve (%make-parabola (coerce x 'double-float)
                               (coerce y 'double-float)
                               (coerce z 'double-float)
                               (coerce focal 'double-float))))

(defun make-bezier-curve (points)
  "Create a Bezier curve through the given list of 3D control `points`.

  Each point is a list of three doubles (x y z).  The curve passes
  through the first and last points and is shaped by the intermediate
  control points.

  **Example:**

      (make-bezier-curve '((0 0 0) (5 10 0) (10 0 0)))

  **See also:** `make-bspline-curve`, `convert-curve-to-bspline`"
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-curve (%make-bezier-curve arr n)))
      (cffi:foreign-free arr))))

(defun make-bspline-curve (poles knots mults degree)
  "Create a B-spline curve from `poles`, `knots`, `mults`, and `degree`.

  - **poles** list of (x y z) control points
  - **knots** list of knot values
  - **mults** list of knot multiplicities (same length as `knots`)
  - **degree** polynomial degree of the spline

  **Example:**

      (make-bspline-curve
        '((0 0 0) (5 10 0) (10 0 0))
        '(0 1)
        '(2 2)
        2)

  **See also:** `make-bezier-curve`, `convert-curve-to-bspline`"
  (let* ((num-poles (length poles))
         (num-knots (length knots))
         (pole-arr (cffi:foreign-alloc :double :count (* 3 num-poles)))
         (knot-arr (cffi:foreign-alloc :double :count num-knots))
         (mult-arr (cffi:foreign-alloc :int :count num-knots)))
    (unwind-protect
         (progn
           (loop for i from 0 below num-poles
                 for p in poles
                 do (setf (cffi:mem-aref pole-arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref pole-arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref pole-arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (loop for i from 0 below num-knots
                 do (setf (cffi:mem-aref knot-arr :double i) (coerce (nth i knots) 'double-float)
                          (cffi:mem-aref mult-arr :int i) (nth i mults)))
           (make-curve (%make-bspline-curve pole-arr num-poles knot-arr mult-arr num-knots degree)))
      (cffi:foreign-free pole-arr)
      (cffi:foreign-free knot-arr)
      (cffi:foreign-free mult-arr))))

(defun make-gc-line (x1 y1 z1 x2 y2 z2)
  "Create a line segment from (`x1`, `y1`, `z1`) to (`x2`, `y2`, `z2`).

  This is a two-point constructor (GC = geometric construction).
  The resulting curve is a trimmed line between the two points.

  **Example:**

      (make-gc-line 0 0 0 10 0 0)

  **See also:** `make-line-3d`, `make-gc-arc-of-circle`"
  (make-curve (%make-gc-line (coerce x1 'double-float)
                              (coerce y1 'double-float)
                              (coerce z1 'double-float)
                              (coerce x2 'double-float)
                              (coerce y2 'double-float)
                              (coerce z2 'double-float))))

(defun make-gc-arc-of-circle (x1 y1 z1 x2 y2 z2 x3 y3 z3)
  "Create a circular arc through three 3D points.

  The arc passes from (`x1`, `y1`, `z1`) through (`x2`, `y2`, `z2`) to (`x3`, `y3`, `z3`).
  All three points must be distinct and not collinear.

  **Example:**

      (make-gc-arc-of-circle 0 0 0 5 5 0 10 0 0)

  **See also:** `make-gc-line`, `make-circle-3d`"
  (make-curve (%make-gc-arc-of-circle
               (coerce x1 'double-float) (coerce y1 'double-float) (coerce z1 'double-float)
               (coerce x2 'double-float) (coerce y2 'double-float) (coerce z2 'double-float)
               (coerce x3 'double-float) (coerce y3 'double-float) (coerce z3 'double-float))))

(defun convert-curve-to-bspline (curve)
  "Convert `curve` to a B-spline representation.

  Any curve type (line, circle, bezier, etc.) can be converted to an
  equivalent B-spline.  Returns the B-spline curve, or `nil` on error.

  **Example:**

      (let* ((c (make-circle-3d 0 0 0 5))
             (bs (convert-curve-to-bspline c)))
        (curve-type bs))
      ;; => :BSPLINE-CURVE

  **See also:** `make-bspline-curve`, `convert-surface-to-bspline`"
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from convert-curve-to-bspline nil))
    (make-curve (%convert-curve-to-bspline ptr))))

(defun curve-bounding-box (curve)
  "Return the bounding box of `curve` as six values (`xmin` `ymin` `zmin` `xmax` `ymax` `zmax`).

  Returns `nil` if the curve has no geometry or on error.

  **Example:**

      (let* ((c (make-bezier-curve '((0 0 0) (5 10 0) (10 0 0))))
             (bx (curve-bounding-box c)))
        (format t \"~A~%\" bx))
      ;; => multiple values: 0.0d0 0.0d0 0.0d0 10.0d0 10.0d0 0.0d0

  **See also:** `surface-bounding-box`"
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from curve-bounding-box nil))
    (cffi:with-foreign-objects ((xmin :double) (ymin :double) (zmin :double)
                                 (xmax :double) (ymax :double) (zmax :double))
      (let ((result (%curve-bounding-box ptr xmin ymin zmin xmax ymax zmax)))
        (when (zerop result) (return-from curve-bounding-box nil))
        (values (cffi:mem-ref xmin :double)
                (cffi:mem-ref ymin :double)
                (cffi:mem-ref zmin :double)
                (cffi:mem-ref xmax :double)
                (cffi:mem-ref ymax :double)
                (cffi:mem-ref zmax :double))))))

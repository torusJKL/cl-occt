(in-package :cl-occt)

(defclass surface ()
  ((%ptr :initarg :ptr :reader %ptr))
  (:documentation "Wraps a Geom_Surface handle from OCCT with GC via tg:finalize."))

(defun surface-p (obj)
  "**Returns:** `t` if `obj` is a `surface` object, `nil` otherwise."
  (typep obj 'surface))

(in-package :cl-occt.impl)

(defun %surface-kind->keyword (kind)
  (ecase kind
    (0 :plane)
    (1 :cylindrical-surface)
    (2 :conical-surface)
    (3 :spherical-surface)
    (4 :toroidal-surface)
    (5 :bezier-surface)
    (6 :bspline-surface)))

(defun make-surface (ptr)
  "Wrap a raw Geom_Surface C pointer in a `surface` CLOS instance with finalization.

  Returns a `surface` object, or nil if **ptr** is null."
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((s (make-instance 'cl-occt:surface :ptr ptr)))
        (tg:finalize s (lambda () (%free-surface ptr)))
        s)))

(in-package :cl-occt)

(defun surface-type (surface)
  "Return the type keyword of `surface`.

  **Returns:** one of `:plane`, `:cylindrical-surface`, `:conical-surface`,
  `:spherical-surface`, `:toroidal-surface`, `:bezier-surface`,
  `:bspline-surface`, or `nil`.

  **Example:**

      (surface-type (make-plane 0 0 0 0 0 1))
      ;; => :PLANE"
  (unless (typep surface 'surface)
    (return-from surface-type nil))
  (let ((ptr (%ptr surface)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from surface-type nil))
    (%surface-kind->keyword (%surface-type ptr))))

(defun make-plane (x y z nx ny nz)
  "Create a plane through point (`x`, `y`, `z`) with normal (`nx`, `ny`, `nz`).

  **Example:**

      (make-plane 0 0 0 0 0 1)

  **See also:** `make-cylindrical-surface`, `make-spherical-surface`"
  (make-surface (%make-plane (coerce x 'double-float)
                              (coerce y 'double-float)
                              (coerce z 'double-float)
                              (coerce nx 'double-float)
                              (coerce ny 'double-float)
                              (coerce nz 'double-float))))

(defun make-cylindrical-surface (x y z dx dy dz radius)
  "Create a cylindrical surface through (`x`, `y`, `z`) with axis (`dx`, `dy`, `dz`) and `radius`.

  **Example:**

      (make-cylindrical-surface 0 0 0 0 0 1 5)

  **See also:** `make-conical-surface`, `make-spherical-surface`"
  (make-surface (%make-cylindrical-surface
                  (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                  (coerce dx 'double-float) (coerce dy 'double-float) (coerce dz 'double-float)
                  (coerce radius 'double-float))))

(defun make-conical-surface (x y z dx dy dz radius semi-angle)
  "Create a conical surface through (`x`, `y`, `z`) with axis (`dx`, `dy`, `dz`),
  base `radius` and `semi-angle` (in degrees).

  **Example:**

      (make-conical-surface 0 0 0 0 0 1 5 30)

  **See also:** `make-cylindrical-surface`, `make-spherical-surface`"
  (make-surface (%make-conical-surface
                  (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                  (coerce dx 'double-float) (coerce dy 'double-float) (coerce dz 'double-float)
                  (coerce radius 'double-float) (coerce semi-angle 'double-float))))

(defun make-spherical-surface (x y z radius)
  "Create a sphere centered at (`x`, `y`, `z`) with the given `radius`.

  **Example:**

      (make-spherical-surface 0 0 0 10)

  **See also:** `make-toroidal-surface`, `make-cylindrical-surface`"
  (make-surface (%make-spherical-surface (coerce x 'double-float)
                                          (coerce y 'double-float)
                                          (coerce z 'double-float)
                                          (coerce radius 'double-float))))

(defun make-toroidal-surface (x y z major-r minor-r)
  "Create a torus centered at (`x`, `y`, `z`) with the given radii.

  - **major-r** distance from center to tube center
  - **minor-r** radius of the tube

  **Example:**

      (make-toroidal-surface 0 0 0 20 5)

  **See also:** `make-spherical-surface`"
  (make-surface (%make-toroidal-surface (coerce x 'double-float)
                                        (coerce y 'double-float)
                                        (coerce z 'double-float)
                                        (coerce major-r 'double-float)
                                        (coerce minor-r 'double-float))))

(defun make-bezier-surface (poles num-u num-v)
  "Create a Bezier surface with `num-u` x `num-v` control `poles`.

  `poles` is a flat list of (x y z) control points, ordered by U then V.
  Each point is a list of three doubles.  The total must equal `num-u` * `num-v`.

  **Example:**

      (make-bezier-surface
        '((0 0 0) (10 0 0)
          (0 10 0) (10 10 0))
        2 2)

  **See also:** `make-bspline-surface`"
  (let* ((count (* num-u num-v))
         (arr (cffi:foreign-alloc :double :count (* 3 count))))
    (unwind-protect
         (progn
           (loop for i from 0 below count
                 for p in poles
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-surface (%make-bezier-surface arr num-u num-v)))
      (cffi:foreign-free arr))))

(defun make-bspline-surface (poles num-u-poles num-v-poles
                              uknots umults vknots vmults udeg vdeg)
  "Create a B-spline surface with control `poles`, knots, and degrees.

  - **num-u-poles**, **num-v-poles** number of control poles in each direction
  - **poles** flat list of (x y z) poles ordered by U then V
  - **uknots**, **vknots** knot value lists for U and V directions
  - **umults**, **vmults** knot multiplicity lists for U and V directions
  - **udeg**, **vdeg** polynomial degree in U and V directions

  **Example:**

      (make-bspline-surface
        '((0 0 0) (10 0 5) (20 0 0)
          (0 10 0) (10 10 5) (20 10 0))
        3 2
        '(0 1) '(2 2)
        '(0 1) '(2 2)
        1 1)

  **See also:** `make-bezier-surface`, `convert-surface-to-bspline`"
  (let* ((num-poles (* num-u-poles num-v-poles))
         (num-uknots (length uknots))
         (num-vknots (length vknots))
         (pole-arr (cffi:foreign-alloc :double :count (* 3 num-poles)))
         (uknot-arr (cffi:foreign-alloc :double :count num-uknots))
         (umult-arr (cffi:foreign-alloc :int :count num-uknots))
         (vknot-arr (cffi:foreign-alloc :double :count num-vknots))
         (vmult-arr (cffi:foreign-alloc :int :count num-vknots)))
    (unwind-protect
         (progn
           (loop for i from 0 below num-poles
                 for p in poles
                 do (setf (cffi:mem-aref pole-arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref pole-arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref pole-arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (loop for i from 0 below num-uknots
                 do (setf (cffi:mem-aref uknot-arr :double i) (coerce (nth i uknots) 'double-float)
                          (cffi:mem-aref umult-arr :int i) (nth i umults)))
           (loop for i from 0 below num-vknots
                 do (setf (cffi:mem-aref vknot-arr :double i) (coerce (nth i vknots) 'double-float)
                          (cffi:mem-aref vmult-arr :int i) (nth i vmults)))
           (make-surface (%make-bspline-surface pole-arr num-u-poles num-v-poles
                                                 uknot-arr umult-arr num-uknots
                                                 vknot-arr vmult-arr num-vknots
                                                 udeg vdeg)))
      (cffi:foreign-free pole-arr)
      (cffi:foreign-free uknot-arr)
      (cffi:foreign-free umult-arr)
      (cffi:foreign-free vknot-arr)
      (cffi:foreign-free vmult-arr))))

(defun convert-surface-to-bspline (surface)
  "Convert `surface` to a B-spline representation.

  Any surface type (`plane`, `sphere`, `bezier`, etc.) can be converted to
  an equivalent B-spline.  **Returns:** the B-spline surface, or `nil` on error.

  **Example:**

      (let* ((s (make-spherical-surface 0 0 0 10))
             (bs (convert-surface-to-bspline s)))
        (surface-type bs))
      ;; => :BSPLINE-SURFACE

  **See also:** `make-bspline-surface`, `convert-curve-to-bspline`"
  (let ((ptr (%ptr surface)))
    (when (cffi:null-pointer-p ptr)
      (return-from convert-surface-to-bspline nil))
    (make-surface (%convert-surface-to-bspline ptr))))

(defun surface-bounding-box (surface)
  "Return the bounding box of `surface` as six values (`xmin` `ymin` `zmin` `xmax` `ymax` `zmax`).

  **Returns:** `nil` if the surface has no geometry or on error.

  **Example:**

      (let* ((s (make-plane 0 0 0 0 0 1))
             (bx (surface-bounding-box s)))
        (format t \"~A~%\" bx))
      ;; => multiple values: 0.0d0 0.0d0 0.0d0 ... (infinite plane has large bounds)

  **See also:** `curve-bounding-box`"
  (let ((ptr (%ptr surface)))
    (when (cffi:null-pointer-p ptr)
      (return-from surface-bounding-box nil))
    (cffi:with-foreign-objects ((xmin :double) (ymin :double) (zmin :double)
                                 (xmax :double) (ymax :double) (zmax :double))
      (let ((result (%surface-bounding-box ptr xmin ymin zmin xmax ymax zmax)))
        (when (zerop result) (return-from surface-bounding-box nil))
        (values (cffi:mem-ref xmin :double)
                (cffi:mem-ref ymin :double)
                (cffi:mem-ref zmin :double)
                (cffi:mem-ref xmax :double)
                (cffi:mem-ref ymax :double)
                (cffi:mem-ref zmax :double))))))

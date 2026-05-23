(in-package :cl-occt)

(defclass curve ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun curve-p (obj)
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
  (unless (typep curve 'curve)
    (return-from curve-type nil))
  (let ((ptr (%ptr curve)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from curve-type nil))
    (%curve-kind->keyword (%curve-type ptr))))

(defun make-line-3d (x y z dx dy dz)
  (make-curve (%make-line-3d (coerce x 'double-float)
                              (coerce y 'double-float)
                              (coerce z 'double-float)
                              (coerce dx 'double-float)
                              (coerce dy 'double-float)
                              (coerce dz 'double-float))))

(defun make-circle-3d (x y z radius)
  (make-curve (%make-circle-3d (coerce x 'double-float)
                                (coerce y 'double-float)
                                (coerce z 'double-float)
                                (coerce radius 'double-float))))

(defun make-ellipse (x y z major-r minor-r)
  (make-curve (%make-ellipse-3d (coerce x 'double-float)
                                 (coerce y 'double-float)
                                 (coerce z 'double-float)
                                 (coerce major-r 'double-float)
                                 (coerce minor-r 'double-float))))

(defun make-hyperbola (x y z major-r minor-r)
  (make-curve (%make-hyperbola (coerce x 'double-float)
                                (coerce y 'double-float)
                                (coerce z 'double-float)
                                (coerce major-r 'double-float)
                                (coerce minor-r 'double-float))))

(defun make-parabola (x y z focal)
  (make-curve (%make-parabola (coerce x 'double-float)
                               (coerce y 'double-float)
                               (coerce z 'double-float)
                               (coerce focal 'double-float))))

(defun make-bezier-curve (points)
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
  (make-curve (%make-gc-line (coerce x1 'double-float)
                              (coerce y1 'double-float)
                              (coerce z1 'double-float)
                              (coerce x2 'double-float)
                              (coerce y2 'double-float)
                              (coerce z2 'double-float))))

(defun make-gc-arc-of-circle (x1 y1 z1 x2 y2 z2 x3 y3 z3)
  (make-curve (%make-gc-arc-of-circle
               (coerce x1 'double-float) (coerce y1 'double-float) (coerce z1 'double-float)
               (coerce x2 'double-float) (coerce y2 'double-float) (coerce z2 'double-float)
               (coerce x3 'double-float) (coerce y3 'double-float) (coerce z3 'double-float))))

(defun convert-curve-to-bspline (curve)
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from convert-curve-to-bspline nil))
    (make-curve (%convert-curve-to-bspline ptr))))

(defun curve-bounding-box (curve)
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

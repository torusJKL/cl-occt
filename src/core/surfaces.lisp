(in-package :cl-occt)

(defclass surface ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun surface-p (obj)
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
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((s (make-instance 'cl-occt:surface :ptr ptr)))
        (tg:finalize s (lambda () (%free-surface ptr)))
        s)))

(in-package :cl-occt)

(defun surface-type (surface)
  (unless (typep surface 'surface)
    (return-from surface-type nil))
  (let ((ptr (%ptr surface)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from surface-type nil))
    (%surface-kind->keyword (%surface-type ptr))))

(defun make-plane (x y z nx ny nz)
  (make-surface (%make-plane (coerce x 'double-float)
                              (coerce y 'double-float)
                              (coerce z 'double-float)
                              (coerce nx 'double-float)
                              (coerce ny 'double-float)
                              (coerce nz 'double-float))))

(defun make-cylindrical-surface (x y z dx dy dz radius)
  (make-surface (%make-cylindrical-surface
                  (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                  (coerce dx 'double-float) (coerce dy 'double-float) (coerce dz 'double-float)
                  (coerce radius 'double-float))))

(defun make-conical-surface (x y z dx dy dz radius semi-angle)
  (make-surface (%make-conical-surface
                  (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)
                  (coerce dx 'double-float) (coerce dy 'double-float) (coerce dz 'double-float)
                  (coerce radius 'double-float) (coerce semi-angle 'double-float))))

(defun make-spherical-surface (x y z radius)
  (make-surface (%make-spherical-surface (coerce x 'double-float)
                                          (coerce y 'double-float)
                                          (coerce z 'double-float)
                                          (coerce radius 'double-float))))

(defun make-toroidal-surface (x y z major-r minor-r)
  (make-surface (%make-toroidal-surface (coerce x 'double-float)
                                        (coerce y 'double-float)
                                        (coerce z 'double-float)
                                        (coerce major-r 'double-float)
                                        (coerce minor-r 'double-float))))

(defun make-bezier-surface (poles num-u num-v)
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
  (let ((ptr (%ptr surface)))
    (when (cffi:null-pointer-p ptr)
      (return-from convert-surface-to-bspline nil))
    (make-surface (%convert-surface-to-bspline ptr))))

(defun surface-bounding-box (surface)
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

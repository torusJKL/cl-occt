(in-package :cl-occt)

(defclass geom2d ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun geom2d-p (obj)
  (typep obj 'geom2d))

(in-package :cl-occt.impl)

(defun make-geom2d (ptr)
  (if (cffi:null-pointer-p ptr)
      nil
      (let ((g (make-instance 'cl-occt:geom2d :ptr ptr)))
        (tg:finalize g (lambda () (%free-geom2d ptr)))
        g)))

(in-package :cl-occt)

(defun make-pnt2d (x y)
  (make-geom2d (%make-pnt2d (coerce x 'double-float)
                             (coerce y 'double-float))))

(defun make-vec2d (x y)
  (make-geom2d (%make-vec2d (coerce x 'double-float)
                             (coerce y 'double-float))))

(defun make-dir2d (x y)
  (make-geom2d (%make-dir2d (coerce x 'double-float)
                             (coerce y 'double-float))))

(defun make-line2d (x y dx dy)
  (make-geom2d (%make-line-2d (coerce x 'double-float)
                               (coerce y 'double-float)
                               (coerce dx 'double-float)
                               (coerce dy 'double-float))))

(defun make-circle2d (x y radius)
  (make-geom2d (%make-circle-2d (coerce x 'double-float)
                                 (coerce y 'double-float)
                                 (coerce radius 'double-float))))

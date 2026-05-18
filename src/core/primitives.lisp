(in-package :cl-occt.impl)

(defun make-shape (ptr)
  (if (cffi:null-pointer-p ptr)
      nil
      (let ((s (make-instance 'cl-occt:shape :ptr ptr)))
        (tg:finalize s (lambda () (%free-shape ptr)))
        s)))

(in-package :cl-occt)

(defun make-box (dx dy dz)
  (make-shape (%make-box (coerce dx 'double-float)
                         (coerce dy 'double-float)
                         (coerce dz 'double-float))))

(defun make-cylinder (radius height)
  (make-shape (%make-cylinder (coerce radius 'double-float)
                              (coerce height 'double-float))))

(defun make-sphere (radius)
  (make-shape (%make-sphere (coerce radius 'double-float))))

(defun make-cone (r1 r2 height)
  (make-shape (%make-cone (coerce r1 'double-float)
                          (coerce r2 'double-float)
                          (coerce height 'double-float))))

(in-package :cl-occt.impl)

(defun make-shape (ptr)
  (if (or (null ptr) (cffi:null-pointer-p ptr))
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

(defun make-torus (major-radius minor-radius)
  (make-shape (%make-torus (coerce major-radius 'double-float)
                           (coerce minor-radius 'double-float))))

(defun make-prism (shape dx dy dz)
  (if (null shape)
      nil
      (make-shape (%make-prism (%ptr shape)
                               (coerce dx 'double-float)
                               (coerce dy 'double-float)
                               (coerce dz 'double-float)))))

(defun make-revol (shape ax ay az angle-deg)
  (if (null shape)
      nil
      (make-shape (%make-revol (%ptr shape)
                               (coerce ax 'double-float)
                               (coerce ay 'double-float)
                               (coerce az 'double-float)
                               (coerce angle-deg 'double-float)))))

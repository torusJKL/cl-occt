(in-package :cl-occt)

(defparameter *gradient-style-map*
  '((:x-pos . 0) (:x-neg . 1) (:y-pos . 2) (:y-neg . 3) (:z-pos . 4) (:z-neg . 5)))

(defun set-gradient-background (view &key color1 color2 (style :y-pos))
  (when (viewer-p view)
    (let* ((rgb1 (normalize-color (or color1 '(0.1 0.1 0.3))))
           (rgb2 (normalize-color (or color2 '(0.8 0.8 0.9))))
           (style-int (or (cdr (assoc style *gradient-style-map*)) 2))
           (view-ptr (%view view)))
      (when (and rgb1 rgb2 view-ptr (not (cffi:null-pointer-p view-ptr)))
        (destructuring-bind (r1 g1 b1) rgb1
          (destructuring-bind (r2 g2 b2) rgb2
            (%v3d-view-set-bg-gradient view-ptr
              (coerce r1 'double-float) (coerce g1 'double-float) (coerce b1 'double-float)
              (coerce r2 'double-float) (coerce g2 'double-float) (coerce b2 'double-float)
              style-int)))
        view))))

(defun set-background-cubemap (view &key pos-x neg-x pos-y neg-y pos-z neg-z)
  (when (viewer-p view)
    (let* ((cffi-vec (cffi:foreign-alloc :string :initial-contents
                      (list pos-x neg-x pos-y neg-y pos-z neg-z)))
           (ptr (%make-cubemap-separate cffi-vec 6)))
      (cffi:foreign-free cffi-vec)
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((view-ptr (%view view)))
          (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
            (%v3d-view-set-bg-cubemap view-ptr ptr))
          (tg:finalize ptr (lambda () (%free-cubemap ptr)))
          view)))))

;; (defun set-background-cubemap () already returns view)

(defun set-image-background (view path)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-bg-image view-ptr path)
        view))))

(defun reset-background (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-reset-background view-ptr)
        view))))

(in-package :cl-occt)

(defun grid-active-p (viewer)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (not (zerop (%v3d-viewer-grid-active v-ptr)))))))

(defun set-grid-xy-size (viewer x-step y-step)
  (set-rectangular-grid-values viewer :x-step x-step :y-step y-step))

(defun set-grid-offset (viewer x-offset y-offset)
  (set-rectangular-grid-values viewer :x-origin x-offset :y-origin y-offset))

(defun set-rectangular-grid-values (viewer &key (x-origin 0.0) (y-origin 0.0) (x-step 10.0) (y-step 10.0) (rotation-angle 0.0))
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-rectangular-grid-values v-ptr
          (coerce x-origin 'double-float)
          (coerce y-origin 'double-float)
          (coerce x-step 'double-float)
          (coerce y-step 'double-float)
          (coerce rotation-angle 'double-float))
        viewer))))

(defun grid-display (view &key (color '(0.5 0.5 0.5)) (size-x 10.0) (size-y 10.0))
  (when (viewer-p view)
    (let ((rgb (normalize-color color))
          (view-ptr (%view view)))
      (when (and rgb view-ptr (not (cffi:null-pointer-p view-ptr)))
        (destructuring-bind (r g b) rgb
          (%v3d-view-grid-display view-ptr
            (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
            (coerce size-x 'double-float) (coerce size-y 'double-float)))
        view))))

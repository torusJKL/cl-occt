(in-package :cl-occt)

;; --- Camera convenience functions ---

(defun set-camera (view &key eye target up)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (when eye
          (destructuring-bind (x y z) eye
            (%v3d-view-set-eye view-ptr
                               (coerce x 'double-float)
                               (coerce y 'double-float)
                               (coerce z 'double-float))))
        (when target
          (destructuring-bind (x y z) target
            (%v3d-view-set-target view-ptr
                                  (coerce x 'double-float)
                                  (coerce y 'double-float)
                                  (coerce z 'double-float))))
        (when up
          (destructuring-bind (x y z) up
            (%v3d-view-set-up view-ptr
                              (coerce x 'double-float)
                              (coerce y 'double-float)
                              (coerce z 'double-float))))
        view))))

(defun set-perspective (view on)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-projection-type view-ptr (if on 1 0))
        view))))

(defun perspective-p (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (not (zerop (%v3d-view-get-projection-type view-ptr)))))))

(defun set-fov (view fov-degrees)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-fov view-ptr
                           (coerce (* fov-degrees (/ pi 180)) 'double-float))
        view))))

(defun set-clip-planes (view &key near far)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-clip-planes view-ptr
                                   (coerce near 'double-float)
                                   (coerce far 'double-float))
        view))))

(defun pan-camera (view dx dy)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-pan view-ptr
                       (coerce dx 'double-float)
                       (coerce dy 'double-float))
        view))))

(defun zoom-camera (view factor)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-zoom view-ptr (coerce factor 'double-float))
        view))))

(defun rotate-camera (view ax ay az)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-rotate view-ptr
                          (coerce ax 'double-float)
                          (coerce ay 'double-float)
                          (coerce az 'double-float))
        view))))

(defun reset-view (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-reset view-ptr)
        view))))

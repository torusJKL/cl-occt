(in-package :cl-occt)

;; --- Viewer camera CLOS class ---

(defclass viewer-camera ()
  ((%eye :initarg :eye :reader %eye)
   (%target :initarg :target :reader %target)
   (%up :initarg :up :reader %up)
   (%projection-type :initarg :projection-type :reader %projection-type)
   (%fov :initarg :fov :reader %fov)))

(defun viewer-camera-p (obj)
  (typep obj 'viewer-camera))

(defun viewer-camera (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (make-instance 'viewer-camera
          :eye (list (%v3d-view-get-eye-x view-ptr)
                     (%v3d-view-get-eye-y view-ptr)
                     (%v3d-view-get-eye-z view-ptr))
          :target (list (%v3d-view-get-target-x view-ptr)
                        (%v3d-view-get-target-y view-ptr)
                        (%v3d-view-get-target-z view-ptr))
          :up (list (%v3d-view-get-up-x view-ptr)
                    (%v3d-view-get-up-y view-ptr)
                    (%v3d-view-get-up-z view-ptr))
          :projection-type (if (zerop (%v3d-view-get-projection-type view-ptr))
                               :orthographic
                               :perspective)
          :fov (%v3d-view-get-fov view-ptr))))))

(defun set-viewer-camera (view cam)
  (when (and (viewer-p view) (viewer-camera-p cam))
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (destructuring-bind (x y z) (%eye cam)
          (%v3d-view-set-eye view-ptr
            (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)))
        (destructuring-bind (x y z) (%target cam)
          (%v3d-view-set-target view-ptr
            (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)))
        (destructuring-bind (x y z) (%up cam)
          (%v3d-view-set-up view-ptr
            (coerce x 'double-float) (coerce y 'double-float) (coerce z 'double-float)))
        (%v3d-view-set-projection-type view-ptr
          (if (eq (%projection-type cam) :perspective) 1 0))
        (%v3d-view-set-fov view-ptr
          (coerce (%fov cam) 'double-float))
        view))))

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

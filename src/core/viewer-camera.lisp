(in-package :cl-occt)

;; --- Viewer camera CLOS class ---

(defclass viewer-camera ()
  ((%eye :initarg :eye :reader %eye)
   (%target :initarg :target :reader %target)
   (%up :initarg :up :reader %up)
   (%projection-type :initarg :projection-type :reader %projection-type)
   (%fov :initarg :fov :reader %fov))
  (:documentation "Snapshot of a V3d_View camera state (eye, target, up, projection, FOV)."))

(defun viewer-camera-p (obj)
  "Returns `t` if **obj** is a `viewer-camera` object.

  **See also:** `viewer-camera`, `set-viewer-camera`"
  (typep obj 'viewer-camera))

(defun viewer-camera (view)
  "Returns a `viewer-camera` snapshot from **view**'s current state.

  The returned object contains eye, target, up, projection type,
  and field of view.

  **Example:**
    (with-viewer (v)
      (viewer-camera v))"
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
  "Applies a `viewer-camera` object to **view**.

  Restores eye, target, up, projection type, and FOV from **cam**.

  **Example:**
    (with-viewer (v)
      (let ((cam (viewer-camera v)))
        (set-viewer-camera v cam)))"
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
  "Sets camera position, target, and up vector directly.

  Each argument is a 3-element coordinate list (x y z).

  **Example:**
    (with-viewer (v)
      (set-camera v
        :eye '(0 0 100)
        :target '(0 0 0)
        :up '(0 1 0)))"
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
  "Enables or disables perspective projection.

  When **on** is `nil`, uses orthographic projection.

  **Example:**
    (with-viewer (v)
      (set-perspective v t))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-projection-type view-ptr (if on 1 0))
        view))))

(defun perspective-p (view)
  "Returns `t` if **view** is using perspective projection.

  **Example:**
    (with-viewer (v)
      (set-perspective v t)
      (perspective-p v))
    => `t`"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (not (zerop (%v3d-view-get-projection-type view-ptr)))))))

(defun set-fov (view fov-degrees)
  "Sets the camera field of view in degrees.

  **Example:**
    (with-viewer (v)
      (set-fov v 45.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-fov view-ptr
                           (coerce (* fov-degrees (/ pi 180)) 'double-float))
        view))))

(defun set-clip-planes (view &key near far)
  "Sets the near and far clipping plane distances.

  **Example:**
    (with-viewer (v)
      (set-clip-planes v :near 0.1 :far 1000.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-clip-planes view-ptr
                                   (coerce near 'double-float)
                                   (coerce far 'double-float))
        view))))

(defun pan-camera (view dx dy)
  "Pans the camera by **dx** and **dy** in screen coordinates.

  **Example:**
    (with-viewer (v)
      (pan-camera v 10.0 -5.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-pan view-ptr
                       (coerce dx 'double-float)
                       (coerce dy 'double-float))
        view))))

(defun zoom-camera (view factor)
  "Zooms the camera by a scale **factor**.

  Values greater than 1.0 zoom in, less than 1.0 zoom out.

  **Example:**
    (with-viewer (v)
      (zoom-camera v 2.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-zoom view-ptr (coerce factor 'double-float))
        view))))

(defun rotate-camera (view ax ay az)
  "Rotates the camera by the given Euler angles (**ax**, **ay**, **az**).

  Angles are in radians.

  **Example:**
    (with-viewer (v)
      (rotate-camera v 0.5 0.0 0.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-rotate view-ptr
                          (coerce ax 'double-float)
                          (coerce ay 'double-float)
                          (coerce az 'double-float))
        view))))

(defun reset-view (view)
  "Resets the camera to the default view position.

  **Example:**
    (with-viewer (v)
      (pan-camera v 10.0 10.0)
      (reset-view v))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-reset view-ptr)
        view))))

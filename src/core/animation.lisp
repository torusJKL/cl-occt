(in-package :cl-occt)

;; --- AIS_Animation base class ---

(defclass ais-animation ()
  ((%ptr :initarg :ptr :reader %ptr))
  (:documentation "Wraps a Handle(AIS_Animation)* from OCCT."))

(defun ais-animation-p (obj)
  "**Returns:** `t` if **obj** is an `ais-animation` object."
  (typep obj 'ais-animation))

(defun make-animation (name)
  "Create an AIS_Animation with the given **name** (string).

  Returns an `ais-animation` object, or nil on failure.

  **See also:** `ais-animation-free`, `ais-animation-start`, `add-animation`"
  (when (and name (stringp name))
    (let* ((ptr (%ais-animation-create name))
           (anim (when (and ptr (not (cffi:null-pointer-p ptr)))
                   (make-instance 'ais-animation :ptr ptr))))
      (when anim
        (tg:finalize anim (lambda () (ais-animation-free anim))))
      anim)))

(defun ais-animation-free (anim)
  "Explicitly free an ais-animation's C handle. Safe to call on nil."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-free ptr)
        (setf (slot-value anim '%ptr) (cffi:null-pointer))))))

(defun ais-animation-start (anim)
  "Start playing the animation."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-start ptr)))))

(defun ais-animation-stop (anim)
  "Stop playing the animation."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-stop ptr)))))

(defun ais-animation-playing-p (anim)
  "**Returns:** `t` if the animation is currently playing."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%ais-animation-is-playing ptr)))))))

(defun ais-animation-duration (anim)
  "Return the duration of the animation in seconds."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-duration ptr)))))

(defun (setf ais-animation-duration) (seconds anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-set-duration ptr (coerce seconds 'double-float))
        seconds))))

(defun ais-animation-progress (anim)
  "Return the current progress of the animation (0.0 to 1.0)."
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-progress ptr)))))

(defun (setf ais-animation-progress) (progress anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-set-progress ptr (coerce progress 'double-float))
        progress))))

(defun (setf ais-animation-start-pause) (seconds anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-set-start-pause ptr (coerce seconds 'double-float))
        seconds))))

(defun add-animation (parent child)
  "Add a **child** animation to a **parent** animation.

  **See also:** `remove-animation`, `make-animation`"
  (when (and (ais-animation-p parent) (ais-animation-p child))
    (let ((p-ptr (%ptr parent))
          (c-ptr (%ptr child)))
      (when (and p-ptr c-ptr
                 (not (cffi:null-pointer-p p-ptr))
                 (not (cffi:null-pointer-p c-ptr)))
        (%ais-animation-add p-ptr c-ptr)))))

(defun remove-animation (parent child)
  "Remove a **child** animation from a **parent** animation.

  **See also:** `add-animation`"
  (when (and (ais-animation-p parent) (ais-animation-p child))
    (let ((p-ptr (%ptr parent))
          (c-ptr (%ptr child)))
      (when (and p-ptr c-ptr
                 (not (cffi:null-pointer-p p-ptr))
                 (not (cffi:null-pointer-p c-ptr)))
        (%ais-animation-remove p-ptr c-ptr)))))

;; --- AIS_AnimationObject ---

(defclass ais-animation-object (ais-animation)
  ()
  (:documentation "Wraps a Handle(AIS_AnimationObject)* from OCCT."))

(defun ais-animation-object-p (obj)
  "**Returns:** `t` if **obj** is an `ais-animation-object`."
  (typep obj 'ais-animation-object))

(defun make-animation-object (name ctx ais-obj
                               &key translation rotation-angle rotation-axis)
  "Create an animation object that moves an AIS object over time.

  - **name** animation name (string)
  - **ctx** AIS context
  - **ais-obj** the AIS object to animate
  - **translation** (tx ty tz) translation vector (default (0 0 0))
  - **rotation-angle** rotation angle in degrees
  - **rotation-axis** (rx ry rz) rotation axis (default (0 0 1))

  Returns an `ais-animation-object`, or nil on failure.

  **See also:** `make-animation`, `add-animation`"
  (let* ((tx (coerce (if translation (first translation) 0.0) 'double-float))
         (ty (coerce (if translation (second translation) 0.0) 'double-float))
         (tz (coerce (if translation (third translation) 0.0) 'double-float))
         (ra rotation-axis)
         (rx (coerce (if ra (first ra) 0.0) 'double-float))
         (ry (coerce (if ra (second ra) 0.0) 'double-float))
         (rz (coerce (if ra (third ra) 1.0) 'double-float))
         (ang (coerce (or rotation-angle 0.0) 'double-float)))
    (when (and name (stringp name) (ais-context-p ctx) (ais-object-p ais-obj))
      (let* ((ptr (%ais-animation-object-create name (%ptr ctx) (%ptr ais-obj)
                                                  tx ty tz rx ry rz ang))
             (anim (when (and ptr (not (cffi:null-pointer-p ptr)))
                     (make-instance 'ais-animation-object :ptr ptr))))
        (when anim
          (tg:finalize anim (lambda () (ais-animation-free anim))))
        anim))))

(defun animation-object (anim-obj)
  "Get the AIS object associated with an **animation-object**.
  Returns an `ais-object` or nil."
  (when (ais-animation-object-p anim-obj)
    (let ((ptr (%ptr anim-obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj-ptr (%ais-animation-object-get-object ptr)))
          (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
            (make-instance 'ais-object :ptr obj-ptr)))))))

;; --- AIS_AnimationCamera ---

(defclass ais-animation-camera (ais-animation)
  ()
  (:documentation "Wraps a Handle(AIS_AnimationCamera)* from OCCT."))

(defun ais-animation-camera-p (obj)
  "**Returns:** `t` if **obj** is an `ais-animation-camera`."
  (typep obj 'ais-animation-camera))

(defun make-animation-camera (name view start-cam end-cam)
  "Create a camera animation from **start-cam** to **end-cam** in the given **view**.

  - **name** animation name (string)
  - **view** a viewer view
  - **start-cam** starting camera
  - **end-cam** ending camera

  Returns an `ais-animation-camera`, or nil on failure.

  **See also:** `make-animation`, `add-animation`"
  (when (and name (stringp name) (viewer-p view)
             (viewer-camera-p start-cam) (viewer-camera-p end-cam))
    (destructuring-bind (sex sey sez) (%eye start-cam)
      (destructuring-bind (stx sty stz) (%target start-cam)
        (destructuring-bind (sux suy suz) (%up start-cam)
          (destructuring-bind (eex eey eez) (%eye end-cam)
            (destructuring-bind (etx ety etz) (%target end-cam)
              (destructuring-bind (eux euy euz) (%up end-cam)
                (let* ((ptr (%ais-animation-camera-create name (%view view)
                                                           (coerce sex 'double-float)
                                                           (coerce sey 'double-float)
                                                           (coerce sez 'double-float)
                                                           (coerce stx 'double-float)
                                                           (coerce sty 'double-float)
                                                           (coerce stz 'double-float)
                                                           (coerce sux 'double-float)
                                                           (coerce suy 'double-float)
                                                           (coerce suz 'double-float)
                                                           (coerce eex 'double-float)
                                                           (coerce eey 'double-float)
                                                           (coerce eez 'double-float)
                                                           (coerce etx 'double-float)
                                                           (coerce ety 'double-float)
                                                           (coerce etz 'double-float)
                                                           (coerce eux 'double-float)
                                                           (coerce euy 'double-float)
                                                           (coerce euz 'double-float)))
                       (anim (when (and ptr (not (cffi:null-pointer-p ptr)))
                               (make-instance 'ais-animation-camera :ptr ptr))))
                  (when anim
                    (tg:finalize anim (lambda () (ais-animation-free anim))))
                  anim)))))))))

;; --- AIS_AnimationAxisRotation ---

(defclass ais-animation-axis-rotation (ais-animation)
  ()
  (:documentation "Wraps a Handle(AIS_AnimationAxisRotation)* from OCCT."))

(defun ais-animation-axis-rotation-p (obj)
  "**Returns:** `t` if **obj** is an `ais-animation-axis-rotation`."
  (typep obj 'ais-animation-axis-rotation))

(defun make-animation-axis-rotation (name ctx ais-obj origin direction
                                      &key (angle-start 0.0) (angle-end 360.0))
  "Create an axis rotation animation for an AIS object.

  - **name** animation name (string)
  - **ctx** AIS context
  - **ais-obj** the AIS object to animate
  - **origin** (ox oy oz) origin of rotation axis
  - **direction** (dx dy dz) direction of rotation axis
  - **angle-start** start angle in degrees (default 0.0)
  - **angle-end** end angle in degrees (default 360.0)

  Returns an `ais-animation-axis-rotation`, or nil on failure.

  **See also:** `make-animation`, `add-animation`"
  (when (and name (stringp name) (ais-context-p ctx) (ais-object-p ais-obj))
    (destructuring-bind (ox oy oz) origin
      (destructuring-bind (dx dy dz) direction
        (let* ((ptr (%ais-animation-axis-rotation-create name (%ptr ctx) (%ptr ais-obj)
                                                          (coerce ox 'double-float)
                                                          (coerce oy 'double-float)
                                                          (coerce oz 'double-float)
                                                          (coerce dx 'double-float)
                                                          (coerce dy 'double-float)
                                                          (coerce dz 'double-float)
                                                          (coerce angle-start 'double-float)
                                                          (coerce angle-end 'double-float)))
               (anim (when (and ptr (not (cffi:null-pointer-p ptr)))
                       (make-instance 'ais-animation-axis-rotation :ptr ptr))))
          (when anim
            (tg:finalize anim (lambda () (ais-animation-free anim))))
          anim)))))

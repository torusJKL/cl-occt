(in-package :cl-occt)

;; --- AIS_Animation base class ---

(defclass ais-animation ()
  ((%ptr :initarg :ptr :reader %ptr))
  (:documentation "Wraps a Handle(AIS_Animation)* from OCCT."))

(defun ais-animation-p (obj)
  (typep obj 'ais-animation))

(defun make-animation (name)
  (when (and name (stringp name))
    (let* ((ptr (%ais-animation-create name))
           (anim (when (and ptr (not (cffi:null-pointer-p ptr)))
                   (make-instance 'ais-animation :ptr ptr))))
      (when anim
        (tg:finalize anim (lambda () (ais-animation-free anim))))
      anim)))

(defun ais-animation-free (anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-free ptr)
        (setf (slot-value anim '%ptr) (cffi:null-pointer))))))

(defun ais-animation-start (anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-start ptr)))))

(defun ais-animation-stop (anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-animation-stop ptr)))))

(defun ais-animation-playing-p (anim)
  (when (ais-animation-p anim)
    (let ((ptr (%ptr anim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%ais-animation-is-playing ptr)))))))

(defun ais-animation-duration (anim)
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
  (when (and (ais-animation-p parent) (ais-animation-p child))
    (let ((p-ptr (%ptr parent))
          (c-ptr (%ptr child)))
      (when (and p-ptr c-ptr
                 (not (cffi:null-pointer-p p-ptr))
                 (not (cffi:null-pointer-p c-ptr)))
        (%ais-animation-add p-ptr c-ptr)))))

(defun remove-animation (parent child)
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
  (typep obj 'ais-animation-object))

(defun make-animation-object (name ctx ais-obj
                               &key translation rotation-angle rotation-axis)
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
  (typep obj 'ais-animation-camera))

(defun make-animation-camera (name view start-cam end-cam)
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
  (typep obj 'ais-animation-axis-rotation))

(defun make-animation-axis-rotation (name ctx ais-obj origin direction
                                      &key (angle-start 0.0) (angle-end 360.0))
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

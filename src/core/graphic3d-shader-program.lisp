(in-package :cl-occt)

(defclass shader-program ()
  ((%handle :initarg :handle :reader %handle)))

(defun shader-program-p (obj)
  (typep obj 'shader-program))

(defun make-shader-program ()
  (let* ((ptr (%graphic3d-shader-program-new))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'shader-program :handle ptr))))
    (when obj
      (tg:finalize obj (lambda () (%graphic3d-shader-program-free (%handle obj)))))
    obj))

(defun free-shader-program (prog)
  (when (shader-program-p prog)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-free ptr)
        (setf (slot-value prog '%handle) (cffi:null-pointer))))))

(defun set-shader-vertex-source (prog source)
  (when (and (shader-program-p prog) source)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-vertex-source ptr source)
        prog))))

(defun set-shader-fragment-source (prog source)
  (when (and (shader-program-p prog) source)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-fragment-source ptr source)
        prog))))

(defun set-shader-header (prog header)
  (when (and (shader-program-p prog) header)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-header ptr header)
        prog))))

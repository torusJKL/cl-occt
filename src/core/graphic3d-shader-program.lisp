(in-package :cl-occt)

(defclass shader-program ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_ShaderProgram handle with GC via tg:finalize."))

(defun shader-program-p (obj)
  "**Returns:** `t` if **obj** is a `shader-program` object."
  (typep obj 'shader-program))

(defun make-shader-program ()
  "Create a Graphic3d_ShaderProgram for custom vertex/fragment shaders.

  Returns a `shader-program` object, or nil on failure.

  **See also:** `set-shader-vertex-source`, `set-shader-fragment-source`"
  (let* ((ptr (%graphic3d-shader-program-new))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'shader-program :handle ptr))))
    (when obj
      (tg:finalize obj (lambda () (%graphic3d-shader-program-free (%handle obj)))))
    obj))

(defun free-shader-program (prog)
  "Explicitly free a shader-program's C handle. Safe to call on nil."
  (when (shader-program-p prog)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-free ptr)
        (setf (slot-value prog '%handle) (cffi:null-pointer))))))

(defun set-shader-vertex-source (prog source)
  "Set the vertex shader **source** string for **prog**. Returns the program."
  (when (and (shader-program-p prog) source)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-vertex-source ptr source)
        prog))))

(defun set-shader-fragment-source (prog source)
  "Set the fragment shader **source** string for **prog**. Returns the program."
  (when (and (shader-program-p prog) source)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-fragment-source ptr source)
        prog))))

(defun set-shader-header (prog header)
  "Set the shader **header** string (common definitions) for **prog**. Returns the program."
  (when (and (shader-program-p prog) header)
    (let ((ptr (%handle prog)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-shader-program-set-header ptr header)
        prog))))

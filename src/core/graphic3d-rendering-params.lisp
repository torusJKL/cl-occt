(in-package :cl-occt)

(defparameter *rendering-method-map*
  '((:rasterization . 0) (:ray-tracing . 1))
  "Maps rendering method keywords to Graphic3d_RenderingParams integer codes.")

(defparameter *rendering-method-rev-map*
  '((0 . :rasterization) (1 . :ray-tracing)))

(defclass rendering-params ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_RenderingParams handle (not owned, no finalization)."))

(defun rendering-params-p (obj)
  "**Returns:** `t` if **obj** is a `rendering-params` object."
  (typep obj 'rendering-params))

(defun viewer-rendering-params (view)
  "Get the rendering parameters for a **view**.
  Returns a `rendering-params` object, or nil."
  (when (viewer-p view)
    (let* ((view-ptr (%view view))
           (ptr (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
                  (%graphic3d-view-rendering-params view-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'rendering-params :handle ptr))))
      obj)))

(defun set-rendering-method (params method)
  "Set rendering **method** keyword (:rasterization or :ray-tracing). Returns params."
  (when (rendering-params-p params)
    (let ((ptr (%handle params))
          (method-int (cdr (assoc method *rendering-method-map*))))
      (when (and ptr (not (cffi:null-pointer-p ptr)) method-int)
        (%graphic3d-rendering-params-set-method ptr method-int)
        params))))

(defun rendering-method (params)
  "Return the rendering method keyword (:rasterization or :ray-tracing)."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-rendering-params-get-method ptr)))
          (cdr (assoc val *rendering-method-rev-map*)))))))

(defun set-ray-tracing-depth (params depth)
  "Set the maximum ray-tracing recursion **depth**. Returns params."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-raytracing-depth ptr depth)
        params))))

(defun ray-tracing-depth (params)
  "Return the current ray-tracing recursion depth."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-get-raytracing-depth ptr)))))

(defun set-ray-traced-shadows (params on)
  "Enable or disable ray-traced shadows. Returns params."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-shadows ptr (if on 1 0))
        params))))

(defun ray-traced-shadows-p (params)
  "**Returns:** `t` if ray-traced shadows are enabled."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-shadows ptr)))))))

(defun set-ray-traced-reflections (params on)
  "Enable or disable ray-traced reflections. Returns params."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-reflections ptr (if on 1 0))
        params))))

(defun ray-traced-reflections-p (params)
  "**Returns:** `t` if ray-traced reflections are enabled."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-reflections ptr)))))))

(defun set-ray-traced-antialiasing (params on)
  "Enable or disable ray-traced antialiasing. Returns params."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-antialiasing ptr (if on 1 0))
        params))))

(defun ray-traced-antialiasing-p (params)
  "**Returns:** `t` if ray-traced antialiasing is enabled."
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-antialiasing ptr)))))))

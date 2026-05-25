(in-package :cl-occt)

(defparameter *rendering-method-map*
  '((:rasterization . 0) (:ray-tracing . 1)))

(defparameter *rendering-method-rev-map*
  '((0 . :rasterization) (1 . :ray-tracing)))

(defclass rendering-params ()
  ((%handle :initarg :handle :reader %handle)))

(defun rendering-params-p (obj)
  (typep obj 'rendering-params))

(defun viewer-rendering-params (view)
  (when (viewer-p view)
    (let* ((view-ptr (%view view))
           (ptr (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
                  (%graphic3d-view-rendering-params view-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'rendering-params :handle ptr))))
      obj)))

(defun set-rendering-method (params method)
  (when (rendering-params-p params)
    (let ((ptr (%handle params))
          (method-int (cdr (assoc method *rendering-method-map*))))
      (when (and ptr (not (cffi:null-pointer-p ptr)) method-int)
        (%graphic3d-rendering-params-set-method ptr method-int)
        params))))

(defun rendering-method (params)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-rendering-params-get-method ptr)))
          (cdr (assoc val *rendering-method-rev-map*)))))))

(defun set-ray-tracing-depth (params depth)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-raytracing-depth ptr depth)
        params))))

(defun ray-tracing-depth (params)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-get-raytracing-depth ptr)))))

(defun set-ray-traced-shadows (params on)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-shadows ptr (if on 1 0))
        params))))

(defun ray-traced-shadows-p (params)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-shadows ptr)))))))

(defun set-ray-traced-reflections (params on)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-reflections ptr (if on 1 0))
        params))))

(defun ray-traced-reflections-p (params)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-reflections ptr)))))))

(defun set-ray-traced-antialiasing (params on)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-rendering-params-set-antialiasing ptr (if on 1 0))
        params))))

(defun ray-traced-antialiasing-p (params)
  (when (rendering-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-rendering-params-get-antialiasing ptr)))))))

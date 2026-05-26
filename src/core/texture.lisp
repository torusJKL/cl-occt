(in-package :cl-occt)

(defclass image ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps an Image_PixMap handle with GC via tg:finalize."))

(defun image-p (obj)
  "Returns `t` if **obj** is an `image` instance."
  (typep obj 'image))

(defun image-from-file (path)
  "Load an image file from disk into a pixel map using `Image_AlienPixMap`.
Supported formats include PNG, JPEG, BMP, TGA, and any format supported by OCCT.
Returns an `image` instance or nil on failure.

**Example:**
    (image-from-file \"/path/to/texture.png\")"
  (when (and path (stringp path) (plusp (length path)))
    (let* ((ptr (%image-from-file path))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'image :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%free-image (%handle obj)))))
      obj)))

(defun image-save (img path)
  "Save an `image` pixel map to a file. The output format is inferred from the file extension.
Returns t on success, nil otherwise.

**Example:**
    (image-save img \"/path/to/output.png\")"
  (when (image-p img)
    (let ((ptr (%handle img)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%image-save ptr path)))))))

(defun image-width (img)
  "Return the pixel width of an `image`, or nil on invalid input.
**Example:**
    (image-width img)"
  (when (image-p img)
    (let ((ptr (%handle img)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%image-width ptr)))))

(defun image-height (img)
  "Return the pixel height of an `image`, or nil on invalid input.
**Example:**
    (image-height img)"
  (when (image-p img)
    (let ((ptr (%handle img)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%image-height ptr)))))

;; --- Texture 2D ---

(defclass texture-2d ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_Texture2D handle with GC via tg:finalize."))

(defun texture-2d-p (obj)
  "Returns `t` if **obj** is a `texture-2d` instance (including `texture-2dplane`)."
  (typep obj 'texture-2d))

(defun texture-2d-from-file (path)
  "Create a `Graphic3d_Texture2D` from an image file path.
Returns a `texture-2d` instance or nil on failure.

**Example:**
    (texture-2d-from-file \"/path/to/texture.png\")"
  (when (and path (stringp path) (plusp (length path)))
    (let* ((ptr (%texture-2d-from-file path))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'texture-2d :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%free-texture (%handle obj)))))
      obj)))

(defun texture-2d-from-image (img)
  "Create a `Graphic3d_Texture2D` from an existing `image` instance.
Returns a `texture-2d` instance or nil on failure.

**Example:**
    (let ((img (image-from-file \"/path/to/texture.png\")))
      (texture-2d-from-image img))"
  (when (image-p img)
    (let* ((img-ptr (%handle img))
           (ptr (when (and img-ptr (not (cffi:null-pointer-p img-ptr)))
                  (%texture-2d-from-image img-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'texture-2d :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%free-texture (%handle obj)))))
      obj)))

;; --- Texture 2D Plane ---

(defclass texture-2dplane (texture-2d)
  ()
  (:documentation "Wraps a Graphic3d_Texture2Dplane handle with GC via tg:finalize."))

(defun texture-2dplane-p (obj)
  "Returns `t` if **obj** is a `texture-2dplane` instance."
  (typep obj 'texture-2dplane))

(defun texture-2dplane-from-file (path)
  "Create a `Graphic3d_Texture2Dplane` from an image file path.
Returns a `texture-2dplane` instance or nil on failure.

**Example:**
    (texture-2dplane-from-file \"/path/to/texture.png\")"
  (when (and path (stringp path) (plusp (length path)))
    (let* ((ptr (%texture-2dplane-from-file path))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'texture-2dplane :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%free-texture (%handle obj)))))
      obj)))

(defun set-texture-plane-repeat (tex u-repeat v-repeat)
  "Set UV repeat on a `texture-2dplane`. **u-repeat** and **v-repeat** are booleans.

**Example:**
    (set-texture-plane-repeat tex t t)"
  (when (texture-2dplane-p tex)
    (let ((ptr (%handle tex)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-2dplane-set-repeat ptr (if u-repeat 1 0) (if v-repeat 1 0))))))

(defun set-texture-plane-origin (tex u v)
  "Set UV origin offset on a `texture-2dplane`.

**Example:**
    (set-texture-plane-origin tex 0.5 0.5)"
  (when (texture-2dplane-p tex)
    (let ((ptr (%handle tex)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-2dplane-set-origin ptr
          (coerce u 'double-float)
          (coerce v 'double-float))))))

(defun set-texture-plane-scale (tex u v)
  "Set UV scale on a `texture-2dplane`.

**Example:**
    (set-texture-plane-scale tex 2.0 1.0)"
  (when (texture-2dplane-p tex)
    (let ((ptr (%handle tex)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-2dplane-set-scale ptr
          (coerce u 'double-float)
          (coerce v 'double-float))))))

(defun set-texture-plane-rotation (tex angle-deg)
  "Set rotation angle in degrees on a `texture-2dplane`.

**Example:**
    (set-texture-plane-rotation tex 45.0)"
  (when (texture-2dplane-p tex)
    (let ((ptr (%handle tex)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-2dplane-set-rotation ptr
          (coerce angle-deg 'double-float))))))

;; --- Texture Params ---

(defclass texture-params ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_TextureParams handle with GC via tg:finalize."))

(defun texture-params-p (obj)
  "Returns `t` if **obj** is a `texture-params` instance."
  (typep obj 'texture-params))

(defun make-texture-params ()
  "Create a `Graphic3d_TextureParams` object with default settings.
Returns a `texture-params` instance or nil.

**Example:**
    (make-texture-params)"
  (let* ((ptr (%make-texture-params))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'texture-params :handle ptr))))
    (when obj
      (tg:finalize obj (lambda () (%free-texture-params (%handle obj)))))
    obj))

(defun set-texture-params-filter (params filter)
  "Set texture filter mode. **filter** is `:nearest`, `:bilinear`, or `:trilinear`.

**Example:**
    (set-texture-params-filter params :trilinear)"
  (when (texture-params-p params)
    (let ((ptr (%handle params))
          (filter-val (cdr (assoc filter '((:nearest . 0) (:bilinear . 1) (:trilinear . 2))))))
      (when (and ptr (not (cffi:null-pointer-p ptr)) filter-val)
        (%texture-params-set-filter ptr filter-val)))))

(defun set-texture-params-repeat (params on)
  "Set texture repeat mode. **on** is a boolean (t = repeat, nil = clamp).

**Example:**
    (set-texture-params-repeat params t)"
  (when (texture-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-params-set-repeat ptr (if on 1 0))))))

(defun set-texture-params-aniso (params level)
  "Set anisotropic filtering level. **level** is a non-negative integer (0 disables).

**Example:**
    (set-texture-params-aniso params 4)"
  (when (texture-params-p params)
    (let ((ptr (%handle params)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%texture-params-set-aniso ptr level)))))

;; --- Texture-2d accessor for params ---

(defun texture-params (tex)
  "Return the `texture-params` associated with a `texture-2d`.
Modifying the returned params affects the texture directly.
Returns nil if the texture has no params or on error.

**Example:**
    (let ((params (texture-params tex)))
      (set-texture-params-filter params :trilinear))"
  (when (texture-2d-p tex)
    (let* ((tex-ptr (%handle tex))
           (ptr (when (and tex-ptr (not (cffi:null-pointer-p tex-ptr)))
                  (%texture-get-params tex-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'texture-params :handle ptr)))
          (tg:finalize obj (lambda () (%free-texture-params (%handle obj))))
          obj)))))

(in-package :cl-occt)

(defclass clip-plane ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_ClipPlane handle with GC via tg:finalize."))

(defun clip-plane-p (obj)
  "**Returns:** `t` if **obj** is a `clip-plane` object."
  (typep obj 'clip-plane))

(defun make-clip-plane (&key (equation '(1 0 0 0)))
  "Create a Graphic3d_ClipPlane with the given clipping plane **equation**.

  **equation** is (a b c d) representing the plane ax + by + cz + d = 0.
  Points with positive distance to the plane are clipped.

  **Example:**

      (make-clip-plane :equation '(0 0 1 -5))  ; clip below z=5

  **See also:** `clip-plane-p`, `free-clip-plane`, `set-clip-plane-equation`"
  (destructuring-bind (a b c d) equation
    (let* ((ptr (%graphic3d-clip-plane-new
                 (coerce a 'double-float)
                 (coerce b 'double-float)
                 (coerce c 'double-float)
                 (coerce d 'double-float)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'clip-plane :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%graphic3d-clip-plane-free (%handle obj)))))
      obj)))

(defun free-clip-plane (cp)
  "Explicitly free a clip-plane's C handle. Safe to call on nil."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-clip-plane-free ptr)
        (setf (slot-value cp '%handle) (cffi:null-pointer))))))

(defun set-clip-plane-equation (cp equation)
  "Set the clipping plane **equation** (a b c d) for **cp**.
  Returns the clip-plane object."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (a b c d) equation
          (%graphic3d-clip-plane-set-equation ptr
            (coerce a 'double-float)
            (coerce b 'double-float)
            (coerce c 'double-float)
            (coerce d 'double-float)))
        cp))))

(defun clip-plane-equation (cp)
  "Return the clipping plane equation (a b c d) of **cp**."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((a :double) (b :double) (c :double) (d :double))
          (%graphic3d-clip-plane-get-equation ptr a b c d)
          (list (cffi:mem-ref a :double)
                (cffi:mem-ref b :double)
                (cffi:mem-ref c :double)
                (cffi:mem-ref d :double)))))))

(defun set-clip-plane-on (cp on)
  "Enable or disable clipping for **cp**. Returns the clip-plane object."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-clip-plane-set-on ptr (if on 1 0))
        cp))))

(defun clip-plane-on-p (cp)
  "**Returns:** `t` if clipping plane **cp** is enabled."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (not (zerop (%graphic3d-clip-plane-is-on ptr)))))))

(defun set-clip-plane-capping (cp on)
  "Enable or disable capping (filled intersection surface) for **cp**.
  Returns the clip-plane object."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-clip-plane-set-capping ptr (if on 1 0))
        cp))))

(defun set-clip-plane-cap-color (cp color)
  "Set the cap color for **cp** as an (r g b) list.
  Returns the clip-plane object."
  (when (clip-plane-p cp)
    (let ((ptr (%handle cp)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) (normalize-color color)
          (%graphic3d-clip-plane-set-cap-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        cp))))

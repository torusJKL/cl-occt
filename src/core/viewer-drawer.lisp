(in-package :cl-occt)

(defparameter *line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3)))

(defun ais-set-drawer-line-color (obj color)
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-line-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-line-width (obj width)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-line-width ptr (coerce width 'double-float))
        obj))))

(defun ais-set-drawer-line-type (obj type)
  (when (ais-object-p obj)
    (let ((type-int (cdr (assoc type *line-type-map*)))
          (ptr (%ptr obj)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-line-type ptr type-int)
        obj))))

(defun ais-set-drawer-shading-color (obj color)
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-shading-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-face-boundaries (obj on)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-face-boundary-draw ptr (if on 1 0))
        obj))))

(defun ais-set-drawer-free-boundaries (obj on)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-free-boundary-draw ptr (if on 1 0))
        obj))))

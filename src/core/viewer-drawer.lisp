(in-package :cl-occt)

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

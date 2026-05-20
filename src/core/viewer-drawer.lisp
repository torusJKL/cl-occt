(in-package :cl-occt)

(defclass drawer ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun drawer-p (obj) (typep obj 'drawer))

(defun ais-drawer (obj)
  (when (ais-object-p obj)
    (let ((ptr (%ais-object-attributes (%ptr obj))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((d (make-instance 'drawer :ptr ptr)))
          (tg:finalize d (lambda () (declare (ignore d)) nil))
          d)))))

(defclass line-aspect ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun drawer-line-aspect (d)
  (when (drawer-p d)
    (let ((ptr (%drawer-line-aspect (%ptr d))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (make-instance 'line-aspect :ptr ptr)))))

(defun (setf line-aspect-color) (color aspect)
  (when (typep aspect 'line-aspect)
    (let ((rgb (normalize-color color))
          (ptr (%ptr aspect)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%line-aspect-set-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        color))))

(defun line-aspect-color (aspect)
  (declare (ignore aspect))
  nil)

(defun (setf line-aspect-width) (width aspect)
  (when (typep aspect 'line-aspect)
    (let ((ptr (%ptr aspect)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%line-aspect-set-width ptr (coerce width 'double-float))
        width))))

(defun line-aspect-width (aspect)
  (declare (ignore aspect))
  nil)

(defparameter *line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3)))

(defun (setf line-aspect-type) (type aspect)
  (when (typep aspect 'line-aspect)
    (let ((type-int (cdr (assoc type *line-type-map*)))
          (ptr (%ptr aspect)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%line-aspect-set-type ptr type-int)
        type))))

(defun line-aspect-type (aspect)
  (declare (ignore aspect))
  nil)

(defclass shading-aspect ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun drawer-shading-aspect (d)
  (when (drawer-p d)
    (let ((ptr (%drawer-shading-aspect (%ptr d))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (make-instance 'shading-aspect :ptr ptr)))))

(defun (setf shading-aspect-color) (color aspect)
  (when (typep aspect 'shading-aspect)
    (let ((rgb (normalize-color color))
          (ptr (%ptr aspect)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%shading-aspect-set-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        color))))

(defun shading-aspect-color (aspect)
  (declare (ignore aspect))
  nil)

;; --- Convenience functions (direct C bridge accessors) ---

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

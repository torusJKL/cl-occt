(in-package :cl-occt)

(defparameter *line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3)))

(defparameter *marker-type-map*
  '((:point . 0) (:plus . 1) (:star . 2) (:o . 3) (:x . 4) (:ball . 5) (:ring . 6)))

;; --- Line aspect convenience ---

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

;; --- Shading aspect convenience ---

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

;; --- Point aspect convenience ---

(defun ais-set-drawer-point-color (obj color)
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-point-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-point-type (obj type)
  (when (ais-object-p obj)
    (let ((type-int (cdr (assoc type *marker-type-map*)))
          (ptr (%ptr obj)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-point-type ptr type-int)
        obj))))

(defun ais-set-drawer-point-scale (obj scale)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-point-scale ptr (coerce scale 'double-float))
        obj))))

;; --- Text aspect convenience ---

(defun ais-set-drawer-text-color (obj color)
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-text-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-text-font (obj font)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-text-font ptr font)
        obj))))

(defun ais-set-drawer-text-height (obj height)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-text-height ptr (coerce height 'double-float))
        obj))))

;; --- Iso-line display ---

(defun ais-set-drawer-iso-display (obj &key (u-on t) (v-on t))
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-iso-display ptr (if u-on 1 0) (if v-on 1 0))
        obj))))

;; --- Wire aspect convenience ---

(defun ais-set-drawer-wire-color (obj color)
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-wire-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

;; --- Boundary toggle convenience ---

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

(in-package :cl-occt)

;; --- Interior style enum map ---

(defparameter *interior-style-map*
  '((:empty . 0) (:hollow . 1) (:solid . 2) (:hatch . 3))
  "Maps interior style keywords to AspectFillArea3d integer codes.")

(defparameter *interior-style-rev-map*
  '((0 . :empty) (1 . :hollow) (2 . :solid) (3 . :hatch)))

;; --- Line type map ---

(defparameter *aspect-line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3))
  "Maps line type keywords to AspectLine3d integer codes.")

(defparameter *aspect-line-type-rev-map*
  '((0 . :solid) (1 . :dash) (2 . :dot) (3 . :dot-dash)))

;; --- Marker type map ---

(defparameter *aspect-marker-type-map*
  '((:point . 1) (:plus . 2) (:star . 3) (:o . 4) (:x . 5) (:ball . 6) (:ring . 7))
  "Maps marker type keywords to AspectMarker3d integer codes.")

(defparameter *aspect-marker-type-rev-map*
  '((1 . :point) (2 . :plus) (3 . :star) (4 . :o) (5 . :x) (6 . :ball) (7 . :ring)))

;; --- Text style enum map ---

(defparameter *text-style-map*
  '((:normal . 0) (:bold . 1) (:italic . 2) (:bold-italic . 3))
  "Maps text style keywords to AspectText3d integer codes.")

(defparameter *text-style-rev-map*
  '((0 . :normal) (1 . :bold) (2 . :italic) (3 . :bold-italic)))

;; --- AspectFillArea3d ---

(defclass aspect-fill-area ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_AspectFillArea3d handle with GC via tg:finalize."))

(defun aspect-fill-area-p (obj)
  "**Returns:** `t` if **obj** is an `aspect-fill-area` object."
  (typep obj 'aspect-fill-area))

(defun make-aspect-fill-area (&key (interior-style :solid) (color '(0.5 0.5 0.5))
                                    (edge-color '(0 0 0)) (edge-line-type :solid)
                                    (edge-width 1.0))
  "Create a Graphic3d_AspectFillArea3d object for controlling fill area display.

  - **interior-style** keyword (:empty, :hollow, :solid, :hatch, default :solid)
  - **color** (r g b) list for interior color (default (0.5 0.5 0.5))
  - **edge-color** (r g b) list for edge color (default (0 0 0))
  - **edge-line-type** keyword for edge lines (:solid, :dash, :dot, :dot-dash)
  - **edge-width** line width for edges (default 1.0)

  **See also:** `aspect-fill-area-p`, `free-aspect-fill-area`"
  (let ((style-int (or (cdr (assoc interior-style *interior-style-map*)) 2))
        (edge-int (or (cdr (assoc edge-line-type *aspect-line-type-map*)) 0)))
    (destructuring-bind (r g b) (normalize-color color)
      (destructuring-bind (er eg eb) (normalize-color edge-color)
        (let* ((ptr (%graphic3d-aspect-fill-area-new
                      style-int
                      (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
                      (coerce er 'double-float) (coerce eg 'double-float) (coerce eb 'double-float)
                      edge-int (coerce edge-width 'double-float)))
               (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                      (make-instance 'aspect-fill-area :handle ptr))))
          (when obj
            (tg:finalize obj (lambda () (%graphic3d-aspect-fill-area-free (%handle obj)))))
          obj)))))

(defun free-aspect-fill-area (a)
  "Explicitly free an aspect-fill-area's C handle. Safe to call on nil."
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-fill-area-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-fill-area-color (a)
  "Return the interior color of an **aspect-fill-area** as (r g b)."
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-fill-area-get-interior-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-fill-area-edge-color (a)
  "Return the edge color of an **aspect-fill-area** as (r g b)."
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-fill-area-get-edge-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-fill-area-interior-style (a)
  "Return the interior style keyword of an **aspect-fill-area** (:empty, :hollow, :solid, :hatch)."
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-fill-area-get-interior-style ptr)))
          (cdr (assoc val *interior-style-rev-map*)))))))

;; --- AspectLine3d ---

(defclass aspect-line ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_AspectLine3d handle with GC via tg:finalize."))

(defun aspect-line-p (obj)
  "**Returns:** `t` if **obj** is an `aspect-line` object."
  (typep obj 'aspect-line))

(defun make-aspect-line (&key (color '(0 0 0)) (type :solid) (width 1.0))
  "Create a Graphic3d_AspectLine3d object for controlling line display.

  - **color** (r g b) list (default (0 0 0))
  - **type** line type keyword (:solid, :dash, :dot, :dot-dash, default :solid)
  - **width** line width (default 1.0)

  **See also:** `aspect-line-p`, `free-aspect-line`"
  (let ((type-int (or (cdr (assoc type *aspect-line-type-map*)) 0)))
    (destructuring-bind (r g b) (normalize-color color)
      (let* ((ptr (%graphic3d-aspect-line-new
                    (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
                    type-int (coerce width 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'aspect-line :handle ptr))))
        (when obj
          (tg:finalize obj (lambda () (%graphic3d-aspect-line-free (%handle obj)))))
        obj))))

(defun free-aspect-line (a)
  "Explicitly free an aspect-line's C handle. Safe to call on nil."
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-line-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-line-color (a)
  "Return the color of an **aspect-line** as (r g b)."
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-line-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-line-type (a)
  "Return the line type keyword of an **aspect-line** (:solid, :dash, :dot, :dot-dash)."
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-line-get-type ptr)))
          (cdr (assoc val *aspect-line-type-rev-map*)))))))

(defun aspect-line-width (a)
  "Return the line width of an **aspect-line** as a double-float."
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-line-get-width ptr)))))

;; --- AspectMarker3d ---

(defclass aspect-marker ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_AspectMarker3d handle with GC via tg:finalize."))

(defun aspect-marker-p (obj)
  "**Returns:** `t` if **obj** is an `aspect-marker` object."
  (typep obj 'aspect-marker))

(defun make-aspect-marker (&key (color '(0 0 0)) (type :ball) (scale 1.0))
  "Create a Graphic3d_AspectMarker3d object for controlling marker display.

  - **color** (r g b) list (default (0 0 0))
  - **type** marker type keyword (:point, :plus, :star, :o, :x, :ball, :ring, default :ball)
  - **scale** marker scale factor (default 1.0)

  **See also:** `aspect-marker-p`, `free-aspect-marker`"
  (let ((type-int (or (cdr (assoc type *aspect-marker-type-map*)) 6)))
    (destructuring-bind (r g b) (normalize-color color)
      (let* ((ptr (%graphic3d-aspect-marker-new
                    type-int
                    (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
                    (coerce scale 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'aspect-marker :handle ptr))))
        (when obj
          (tg:finalize obj (lambda () (%graphic3d-aspect-marker-free (%handle obj)))))
        obj))))

(defun free-aspect-marker (a)
  "Explicitly free an aspect-marker's C handle. Safe to call on nil."
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-marker-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-marker-color (a)
  "Return the color of an **aspect-marker** as (r g b)."
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-marker-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-marker-type (a)
  "Return the marker type keyword of an **aspect-marker** (:point, :plus, :star, :o, :x, :ball, :ring)."
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-marker-get-type ptr)))
          (cdr (assoc val *aspect-marker-type-rev-map*)))))))

(defun aspect-marker-scale (a)
  "Return the marker scale of an **aspect-marker** as a double-float."
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-marker-get-scale ptr)))))

;; --- AspectText3d ---

(defclass aspect-text ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_AspectText3d handle with GC via tg:finalize."))

(defun aspect-text-p (obj)
  "**Returns:** `t` if **obj** is an `aspect-text` object."
  (typep obj 'aspect-text))

(defun make-aspect-text (&key (color '(0 0 0)) (font "Courier") (style :normal))
  "Create a Graphic3d_AspectText3d object for controlling text display.

  - **color** (r g b) list (default (0 0 0))
  - **font** font name string (default \"Courier\")
  - **style** text style keyword (:normal, :bold, :italic, :bold-italic, default :normal)

  **See also:** `aspect-text-p`, `free-aspect-text`"
  (let ((style-int (or (cdr (assoc style *text-style-map*)) 0)))
    (destructuring-bind (r g b) (normalize-color color)
      (let* ((ptr (%graphic3d-aspect-text-new
                    (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
                    font style-int))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'aspect-text :handle ptr))))
        (when obj
          (tg:finalize obj (lambda () (%graphic3d-aspect-text-free (%handle obj)))))
        obj))))

(defun free-aspect-text (a)
  "Explicitly free an aspect-text's C handle. Safe to call on nil."
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-text-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-text-color (a)
  "Return the color of an **aspect-text** as (r g b)."
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-text-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-text-font (a)
  "Return the font name of an **aspect-text** as a string."
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-text-get-font ptr)))))

(defun aspect-text-style (a)
  "Return the text style keyword of an **aspect-text** (:normal, :bold, :italic, :bold-italic)."
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-text-get-style ptr)))
          (cdr (assoc val *text-style-rev-map*)))))))

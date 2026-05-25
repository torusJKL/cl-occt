(in-package :cl-occt)

;; --- Interior style enum map ---

(defparameter *interior-style-map*
  '((:empty . 0) (:hollow . 1) (:solid . 2) (:hatch . 3)))

(defparameter *interior-style-rev-map*
  '((0 . :empty) (1 . :hollow) (2 . :solid) (3 . :hatch)))

;; --- Line type map ---

(defparameter *aspect-line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3)))

(defparameter *aspect-line-type-rev-map*
  '((0 . :solid) (1 . :dash) (2 . :dot) (3 . :dot-dash)))

;; --- Marker type map ---

(defparameter *aspect-marker-type-map*
  '((:point . 1) (:plus . 2) (:star . 3) (:o . 4) (:x . 5) (:ball . 6) (:ring . 7)))

(defparameter *aspect-marker-type-rev-map*
  '((1 . :point) (2 . :plus) (3 . :star) (4 . :o) (5 . :x) (6 . :ball) (7 . :ring)))

;; --- Text style enum map ---

(defparameter *text-style-map*
  '((:normal . 0) (:bold . 1) (:italic . 2) (:bold-italic . 3)))

(defparameter *text-style-rev-map*
  '((0 . :normal) (1 . :bold) (2 . :italic) (3 . :bold-italic)))

;; --- AspectFillArea3d ---

(defclass aspect-fill-area ()
  ((%handle :initarg :handle :reader %handle)))

(defun aspect-fill-area-p (obj)
  (typep obj 'aspect-fill-area))

(defun make-aspect-fill-area (&key (interior-style :solid) (color '(0.5 0.5 0.5))
                                    (edge-color '(0 0 0)) (edge-line-type :solid)
                                    (edge-width 1.0))
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
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-fill-area-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-fill-area-color (a)
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-fill-area-get-interior-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-fill-area-edge-color (a)
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-fill-area-get-edge-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-fill-area-interior-style (a)
  (when (aspect-fill-area-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-fill-area-get-interior-style ptr)))
          (cdr (assoc val *interior-style-rev-map*)))))))

;; --- AspectLine3d ---

(defclass aspect-line ()
  ((%handle :initarg :handle :reader %handle)))

(defun aspect-line-p (obj)
  (typep obj 'aspect-line))

(defun make-aspect-line (&key (color '(0 0 0)) (type :solid) (width 1.0))
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
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-line-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-line-color (a)
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-line-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-line-type (a)
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-line-get-type ptr)))
          (cdr (assoc val *aspect-line-type-rev-map*)))))))

(defun aspect-line-width (a)
  (when (aspect-line-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-line-get-width ptr)))))

;; --- AspectMarker3d ---

(defclass aspect-marker ()
  ((%handle :initarg :handle :reader %handle)))

(defun aspect-marker-p (obj)
  (typep obj 'aspect-marker))

(defun make-aspect-marker (&key (color '(0 0 0)) (type :ball) (scale 1.0))
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
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-marker-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-marker-color (a)
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-marker-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-marker-type (a)
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-marker-get-type ptr)))
          (cdr (assoc val *aspect-marker-type-rev-map*)))))))

(defun aspect-marker-scale (a)
  (when (aspect-marker-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-marker-get-scale ptr)))))

;; --- AspectText3d ---

(defclass aspect-text ()
  ((%handle :initarg :handle :reader %handle)))

(defun aspect-text-p (obj)
  (typep obj 'aspect-text))

(defun make-aspect-text (&key (color '(0 0 0)) (font "Courier") (style :normal))
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
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-text-free ptr)
        (setf (slot-value a '%handle) (cffi:null-pointer))))))

(defun aspect-text-color (a)
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double))
          (%graphic3d-aspect-text-get-color ptr r g b)
          (list (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)))))))

(defun aspect-text-font (a)
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-aspect-text-get-font ptr)))))

(defun aspect-text-style (a)
  (when (aspect-text-p a)
    (let ((ptr (%handle a)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((val (%graphic3d-aspect-text-get-style ptr)))
          (cdr (assoc val *text-style-rev-map*)))))))

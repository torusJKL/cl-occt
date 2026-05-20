(in-package :cl-occt)

(defun set-text-label-angle (label degrees)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-angle ptr
          (coerce (* degrees (/ pi 180)) 'double-float))
        label))))

(defun set-text-label-hjustification (label align)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label))
          (align-int (cdr (assoc align '((:left . 0) (:center . 1) (:right . 2)) :test #'eq))))
      (when (and align-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-hjustification ptr align-int)
        label))))

(defun set-text-label-vjustification (label align)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label))
          (align-int (cdr (assoc align '((:top . 0) (:cap . 1) (:half . 2) (:base . 3) (:bottom . 4)) :test #'eq))))
      (when (and align-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-vjustification ptr align-int)
        label))))

(defparameter *text-display-type-map*
  '((:ordinary . 0) (:subtitle . 1) (:dekale . 2) (:blend . 3) (:dimension . 4)))

(defun set-text-label-display-type (label type)
  (when (ais-text-label-p label)
    (let ((type-int (cdr (assoc type *text-display-type-map*)))
          (ptr (%ptr label)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-display-type ptr type-int)
        label))))

(defun set-text-label-subtitle-color (label color)
  (when (ais-text-label-p label)
    (let ((rgb (normalize-color color))
          (ptr (%ptr label)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-text-label-set-color-sub-title ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        label))))

(defun make-text-label (ctx text position &key color font height angle)
  (let* ((normalized-color (and color (normalize-color color)))
         (label (make-ais-text-label text
                                      :position position
                                      :color normalized-color
                                      :font font
                                      :height height)))
    (when label
      (when angle (set-text-label-angle label angle))
      (ais-display ctx label)
      label)))

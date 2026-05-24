(in-package :cl-occt)

(defun set-text-label-angle (label degrees)
  "Sets the rotation angle of text LABEL in degrees.

  Returns LABEL on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (label (make-text-label ctx \"Rotated\" '(0 0 0))))
      (set-text-label-angle label 45.0))"
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-angle ptr
          (coerce (* degrees (/ pi 180)) 'double-float))
        label))))

(defun set-text-label-hjustification (label align)
  "Sets the horizontal justification of text LABEL.

  ALIGN is :LEFT, :CENTER, or :RIGHT.

  Returns LABEL on success, NIL otherwise.

  Example:
    (set-text-label-hjustification label :center)"
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label))
          (align-int (cdr (assoc align '((:left . 0) (:center . 1) (:right . 2)) :test #'eq))))
      (when (and align-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-hjustification ptr align-int)
        label))))

(defun set-text-label-vjustification (label align)
  "Sets the vertical justification of text LABEL.

  ALIGN is :TOP, :CAP, :HALF, :BASE, or :BOTTOM.

  Returns LABEL on success, NIL otherwise.

  Example:
    (set-text-label-vjustification label :base)"
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label))
          (align-int (cdr (assoc align '((:top . 0) (:cap . 1) (:half . 2) (:base . 3) (:bottom . 4)) :test #'eq))))
      (when (and align-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-vjustification ptr align-int)
        label))))

(defparameter *text-display-type-map*
  '((:ordinary . 0) (:subtitle . 1) (:dekale . 2) (:blend . 3) (:dimension . 4)))

(defun set-text-label-display-type (label type)
  "Sets the display type of text LABEL.

  TYPE is :ORDINARY, :SUBTITLE, :DEKALE, :BLEND, or :DIMENSION.

  Returns LABEL on success, NIL otherwise.

  Example:
    (set-text-label-display-type label :subtitle)"
  (when (ais-text-label-p label)
    (let ((type-int (cdr (assoc type *text-display-type-map*)))
          (ptr (%ptr label)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-display-type ptr type-int)
        label))))

(defun set-text-label-subtitle-color (label color)
  "Sets the subtitle color of text LABEL (when display type is :SUBTITLE).

  Returns LABEL on success, NIL otherwise.

  Example:
    (set-text-label-subtitle-color label :gray)"
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

(defun set-text-label-align (label &key horizontal vertical)
  "Sets both horizontal and vertical alignment of text LABEL.

  See SET-TEXT-LABEL-HJUSTIFICATION and SET-TEXT-LABEL-VJUSTIFICATION.

  Returns LABEL on success, NIL otherwise.

  Example:
    (set-text-label-align label :horizontal :center :vertical :middle)"
  (when (ais-text-label-p label)
    (when horizontal
      (set-text-label-hjustification label horizontal))
    (when vertical
      (set-text-label-vjustification label vertical))
    label))

(defun make-text-label (ctx text position &key color font height angle)
  "Creates a text label AIS object and displays it in CTX.

  TEXT is the string to display. POSITION is an (X Y Z) list.
  COLOR, FONT, HEIGHT, and ANGLE control appearance.

  Returns the label on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (label (make-text-label ctx \"Hello\" '(0 0 0)
                                    :color :white :font \"Arial\" :height 16.0)))"
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

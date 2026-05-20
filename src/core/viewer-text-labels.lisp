(in-package :cl-occt)

(defun set-text-label-angle (label degrees)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-set-angle ptr
          (coerce (* degrees (/ pi 180)) 'double-float))
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

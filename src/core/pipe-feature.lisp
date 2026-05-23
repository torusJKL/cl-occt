(in-package :cl-occt)

(defun make-pipe-feature (shape base-face profile path
                          &key (operation :cut))
  (if (or (null shape) (null base-face) (null profile) (null path))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1)))
        (make-shape (%make-pipe-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (%ptr path) op-flag)))))

(in-package :cl-occt)

(defun fix-small-faces (shape)
  (if (null shape)
      nil
      (make-shape (%fix-small-faces (%ptr shape)))))

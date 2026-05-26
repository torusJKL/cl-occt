(in-package :cl-occt)

(defun normal-project (shape face)
  (if (or (null shape) (null face))
      nil
      (make-shape (%normal-project (%ptr shape) (%ptr face)))))

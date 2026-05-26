(in-package :cl-occt)

(defun normal-project (shape face)
  "Project **shape** onto **face** along the face normal direction.

  Returns a new projected shape, or nil on invalid input.

  **See also:** `fill-face`, `make-face`"
  (if (or (null shape) (null face))
      nil
      (make-shape (%normal-project (%ptr shape) (%ptr face)))))

(in-package :cl-occt)

(defun fix-small-faces (shape)
  "Fix small faces in **shape** by removing or merging them.

  Returns a repaired shape, or nil on invalid input.

  **See also:** `remove-features`, `fix-shape`"
  (if (null shape)
      nil
      (make-shape (%fix-small-faces (%ptr shape)))))

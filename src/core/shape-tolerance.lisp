(in-package :cl-occt)

(defun set-shape-tolerance (shape tolerance shape-type)
  "Set the tolerance on **shape** for a given **shape-type** (:vertex, :edge, :face, :solid, :shell, :wire).

  Returns `t` on success, `nil` on invalid input.

  **Example:**

      (set-shape-tolerance my-shape 0.01 :edge)

  **See also:** `shape-tolerance` (in topology-data-access.lisp)"
  (if (null shape)
      nil
      (let ((ok (%set-shape-tolerance (%ptr shape)
                                      (coerce tolerance 'double-float)
                                      shape-type)))
        (not (= ok 0)))))

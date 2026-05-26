(in-package :cl-occt)

(defun set-shape-tolerance (shape tolerance shape-type)
  (if (null shape)
      nil
      (let ((ok (%set-shape-tolerance (%ptr shape)
                                      (coerce tolerance 'double-float)
                                      shape-type)))
        (not (= ok 0)))))

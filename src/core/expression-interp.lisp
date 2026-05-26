(in-package :cl-occt)

(defun evaluate-expression (expr)
  "Evaluate a mathematical expression string using OCCT's ExprIntrp.
  Returns the numeric result as a double, or nil on error/invalid input."
  (check-type expr string)
  (cffi:with-foreign-object (out-value :double)
    (when (= 1 (%evaluate-expression expr out-value))
      (cffi:mem-aref out-value :double))))

(in-package :cl-occt.impl)

(defcfun (%evaluate-expression "evaluate_expression") :int
  (expr :string)
  (out-value :pointer))

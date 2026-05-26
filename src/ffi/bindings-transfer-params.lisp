(in-package :cl-occt.impl)

(defcfun (%transfer-params "transfer_params") :int
  (source-edge :pointer)
  (target-curve :pointer)
  (param :double)
  (out-param :pointer))

(in-package :cl-occt.impl)

(defcfun (%free-shape "free_shape") :void
  (shape :pointer))

(defcfun (%get-error-code "get_error_code") :int)

(defcfun (%get-error-message "get_error_message") :string)

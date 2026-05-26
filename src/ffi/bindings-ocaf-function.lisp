(in-package :cl-occt.impl)

;; --- Parametric Functions ---

(defcfun (%ocaf-add-function "ocaf_add_function") :int
  (label :pointer)
  (driver-guid :string))

(defcfun (%ocaf-set-function-input "ocaf_set_function_input") :int
  (func-label :pointer)
  (input-label :pointer))

(defcfun (%ocaf-set-function-output "ocaf_set_function_output") :int
  (func-label :pointer)
  (output-label :pointer))

(defcfun (%ocaf-recompute-doc "ocaf_recompute_doc") :int
  (doc :pointer))

(defcfun (%ocaf-recompute-function "ocaf_recompute_function") :int
  (func-label :pointer))

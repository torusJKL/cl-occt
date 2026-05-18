(in-package :cl-occt)

(defvar *local-params*)

(defun param (key)
  (or (and (boundp '*local-params*)
           (getf *local-params* key))
      (getf cl-occt.impl:*params* key)
      (error "Param ~S not found" key)))

(defmacro with-params ((&rest bindings) &body body)
  `(let ((*local-params* (list ,@(loop for (k v) on bindings by #'cddr
                                       append (list k v)))))
     ,@body))

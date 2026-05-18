(in-package :cl-occt.impl)

(defvar *model-registry* (make-hash-table :test 'eq)
  "Map model name (symbol) → model struct.")

(defun register-model (name model)
  (setf (gethash name *model-registry*) model))

(defun find-model (name)
  (gethash name *model-registry*))

(defun unregister-model (name)
  (remhash name *model-registry*))

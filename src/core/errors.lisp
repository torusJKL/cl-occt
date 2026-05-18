(in-package :cl-occt)

(define-condition occt-error (error)
  ((code :initarg :code :reader occt-error-code)
   (message :initarg :message :reader occt-error-message))
  (:report (lambda (c s)
             (format s "OCCT error ~D: ~A"
                     (occt-error-code c)
                     (occt-error-message c)))))

(defun get-error-message ()
  (format nil "~D: ~A" (%get-error-code) (%get-error-message)))

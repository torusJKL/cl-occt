(in-package :cl-occt)

(define-condition occt-error (error)
  ((code :initarg :code :reader occt-error-code)
   (message :initarg :message :reader occt-error-message))
  (:report (lambda (c s)
             (format s "OCCT error ~D: ~A"
                     (occt-error-code c)
                     (occt-error-message c)))))

(defun get-error-message ()
  "Return the last OCCT error as a formatted \"CODE: MESSAGE\" string.

  Retrieves the error code and message from the C layer and formats
  them together.  Use after any operation that may signal an OCCT
  error to understand what went wrong.

  Example:
    (handler-case
        (write-step nil \"/tmp/bad.step\")
      (occt-error (e)
        (format t \"~A\" (get-error-message))))

  See also: occt-error condition"
  (format nil "~D: ~A" (%get-error-code) (%get-error-message)))

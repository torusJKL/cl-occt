(in-package :cl-occt)

(defun write-step (shape filename)
  (if (null shape)
      (progn
        (warn "write-step: nil shape, nothing written")
        nil)
      (let ((result (%write-step (%ptr shape) filename)))
        (if (zerop result)
            (error 'occt-error
                   :code (%get-error-code)
                   :message (%get-error-message))
            t))))

(defun read-step (filename)
  (make-shape (%read-step filename)))

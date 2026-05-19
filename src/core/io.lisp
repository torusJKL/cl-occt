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

(defun write-stl (shape filename &key (deflection 0.1d0))
  (if (null shape)
      (progn
        (warn "write-stl: nil shape, nothing written")
        nil)
      (let ((result (%write-stl (%ptr shape) filename (coerce deflection 'double-float))))
        (if (zerop result)
            (error 'occt-error
                   :code (%get-error-code)
                   :message (%get-error-message))
            t))))

(defun read-stl (filename)
  (make-shape (%read-stl filename)))

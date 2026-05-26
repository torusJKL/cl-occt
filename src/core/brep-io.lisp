(in-package :cl-occt)

(defun write-brep (shape filename)
  (if (null shape)
      nil
      (let ((ok (%brep-write-shape (%ptr shape) filename)))
        (not (= ok 0)))))

(defun read-brep (filename)
  (make-shape (%brep-read-shape filename)))

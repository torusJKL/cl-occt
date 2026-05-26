(in-package :cl-occt)

(defun copy-shape (shape)
  "Create an independent deep copy of a `shape`.
  The copy is fully independent — modification or GC of the original does not affect the copy.
  **Returns:** a new shape object, or nil."
  (unless (shape-p shape)
    (return-from copy-shape nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr)
      (return-from copy-shape nil))
    (let ((result (%shape-copy ptr)))
      (if (and result (not (cffi:null-pointer-p result)))
          (make-shape result)
          nil))))

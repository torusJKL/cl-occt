(in-package :cl-occt)

(defun grid-active-p (viewer)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (not (zerop (%v3d-viewer-grid-active v-ptr)))))))

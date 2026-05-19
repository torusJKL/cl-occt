(in-package :cl-occt)

(defun make-compound (shapes)
  (let ((valid (remove nil shapes)))
    (if valid
        (cffi:with-foreign-object (arr :pointer (length valid))
          (loop for i from 0 for s in valid
                do (setf (cffi:mem-aref arr :pointer i) (%ptr s)))
          (make-shape (%make-compound arr (length valid))))
        nil)))

(defun add-to-compound (compound shape)
  (cond ((null compound) nil)
        ((null shape) compound)
        (t (make-shape (%add-to-compound (%ptr compound) (%ptr shape))))))

(defun compound-shape-p (obj)
  (and (shape-p obj)
       (not (cffi:null-pointer-p (%ptr obj)))
       (/= 0 (%shape-is-compound (%ptr obj)))))

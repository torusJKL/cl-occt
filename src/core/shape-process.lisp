(in-package :cl-occt)

(defun apply-shape-process (shape operator)
  (unless (shape-p shape)
    (return-from apply-shape-process nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from apply-shape-process nil))
    (if (listp operator)
        (let* ((count (length operator))
               (op-vec (cffi:foreign-alloc :pointer :count count)))
          (unwind-protect
               (progn
                 (loop for op in operator
                       for i from 0
                       do (setf (cffi:mem-aref op-vec :pointer i)
                                (cffi:foreign-string-alloc (string op))))
                 (make-shape (%apply-operator-sequence ptr op-vec count)))
            (loop for i from 0 below count
                  do (cffi:foreign-free (cffi:mem-aref op-vec :pointer i)))
            (cffi:foreign-free op-vec)))
        (make-shape (%apply-shape-process ptr (string operator))))))

(defun apply-healing-pipeline (shape pipeline &key resource)
  (unless (shape-p shape)
    (return-from apply-healing-pipeline nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from apply-healing-pipeline nil))
    (make-shape (%apply-healing-pipeline ptr (string pipeline)
                                          (or resource "")))))

(defun heal-shape (shape)
  (unless (shape-p shape)
    (return-from heal-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from heal-shape nil))
    (make-shape (%heal-shape-default ptr))))

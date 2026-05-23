(in-package :cl-occt)

(defun shell-shape (shape faces &key (thickness 1.0) (offset :inward))
  (if (or (null shape) (null faces))
      nil
      (let* ((count (length faces))
             (arr (cffi:foreign-alloc :pointer :count count))
             (signed-thickness (if (eq offset :outward)
                                   (coerce thickness 'double-float)
                                   (- (coerce thickness 'double-float)))))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for f in faces
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if f (%ptr f) (cffi:null-pointer))))
               (make-shape (%shell-shape (%ptr shape) arr count
                                          signed-thickness)))
          (cffi:foreign-free arr)))))

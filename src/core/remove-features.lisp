(in-package :cl-occt)

(defun remove-features (shape faces)
  (if (null shape)
      nil
      (let* ((num-faces (length faces))
             (ptr-array (cffi:foreign-alloc :pointer :count num-faces)))
        (unwind-protect
             (progn
               (loop for i below num-faces
                     for f in faces
                     do (setf (cffi:mem-aref ptr-array :pointer i)
                              (if f (%ptr f) (cffi:null-pointer))))
               (make-shape (%remove-features (%ptr shape) ptr-array num-faces)))
          (cffi:foreign-free ptr-array)))))

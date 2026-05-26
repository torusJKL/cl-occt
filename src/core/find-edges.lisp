(in-package :cl-occt)

(defun find-edges-by-type (shape curve-type)
  (if (null shape)
      nil
      (cffi:with-foreign-object (count :int)
        (let ((arr (%find-edges-by-type (%ptr shape) curve-type count)))
          (if (cffi:null-pointer-p arr)
              nil
              (let ((n (cffi:mem-ref count :int)))
                (unwind-protect
                     (loop for i below n
                           for ptr = (cffi:mem-aref arr :pointer i)
                           collect (make-shape ptr))
                  (when (not (cffi:null-pointer-p arr))
                     (%free-shape-array arr)))))))))

(defun find-edges-by-radius (shape radius)
  (if (null shape)
      nil
      (cffi:with-foreign-object (count :int)
        (let ((arr (%find-edges-by-radius (%ptr shape)
                                          (coerce radius 'double-float)
                                          count)))
          (if (cffi:null-pointer-p arr)
              nil
              (let ((n (cffi:mem-ref count :int)))
                (unwind-protect
                     (loop for i below n
                           for ptr = (cffi:mem-aref arr :pointer i)
                           collect (make-shape ptr))
                  (when (not (cffi:null-pointer-p arr))
                     (%free-shape-array arr)))))))))

(in-package :cl-occt.impl)

(in-package :cl-occt)

(defun fill-surface-from-curves (curves &key (continuity :g0) support-faces)
  "Fill a surface bounded by the given list of `curves` with continuity constraints.
  ...
  **See also:** `fill-face`, `fill-n-sided-face`"
  (unless (and curves (listp curves) (>= (length curves) 3))
    (return-from fill-surface-from-curves nil))
  (let* ((n (length curves))
         (c-arr (cffi:foreign-alloc :pointer :count n))
         (sf-arr (if support-faces
                     (let* ((m (length support-faces))
                            (a (cffi:foreign-alloc :pointer :count m)))
                       (loop for i from 0 below m
                             for f in support-faces
                             do (setf (cffi:mem-aref a :pointer i) (%ptr f)))
                       a)
                     (cffi:null-pointer)))
         (sf-count (if support-faces (length support-faces) 0))
         (cont-code (ecase continuity
                      (:g0 0)
                      (:g1 1)
                      (:g2 2))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for c in curves
                 do (setf (cffi:mem-aref c-arr :pointer i) (%ptr c)))
           (make-surface (%fill-surface-from-curves c-arr n cont-code sf-arr sf-count)))
      (cffi:foreign-free c-arr)
      (unless (cffi:null-pointer-p sf-arr) (cffi:foreign-free sf-arr)))))

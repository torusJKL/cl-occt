(in-package :cl-occt)

(defun loft-sections (wires &key (solid t) (ruled nil) (smooth nil)
                               initial-tangent final-tangent)
  (when (or (null wires) (< (length wires) 2))
    (return-from loft-sections nil))
  (let* ((count (length wires))
         (ptr-vec (map 'vector (lambda (w) (%ptr w)) wires))
         (wires-ff (cffi:foreign-alloc :pointer :initial-contents ptr-vec))
         (solid-int (if solid 1 0))
         result)
    (unwind-protect
         (setf result
               (cond
                 ((or initial-tangent final-tangent)
                  (let ((init-ptr (if initial-tangent (%ptr initial-tangent) (cffi:null-pointer)))
                        (final-ptr (if final-tangent (%ptr final-tangent) (cffi:null-pointer))))
                    (make-shape (%loft-sections-tangency wires-ff count solid-int init-ptr final-ptr))))
                 (smooth
                  (make-shape (%loft-sections-smooth wires-ff count solid-int 1)))
                 (ruled
                  (make-shape (%loft-sections-ruled wires-ff count solid-int 1)))
                 (t
                  (make-shape (%loft-sections wires-ff count solid-int)))))
      (cffi:foreign-free wires-ff))
    result))
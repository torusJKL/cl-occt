(in-package :cl-occt)

(defun loft-sections (wires &key (solid t) (ruled nil) (smooth nil)
                               initial-tangent final-tangent)
  "Create a surface or solid through a sequence of wire sections.

  - **wires** Sequence of wire sections; at least two are required.
  - **solid** When `t` (default), the result is a solid; otherwise it is a face/shell.
  - **ruled** Forces a ruled surface.
  - **smooth** Requests a smooth (approximated) surface.
  - **initial-tangent** Optional 3D direction vector.
  - **final-tangent** Optional 3D direction vector.

  **Returns:** a new shape, or `nil` if fewer than 2 wires provided.

  **Example:**

      (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
             (w2 (make-wire (make-circle-edge 0 0 10))))
        (loft-sections (list w1 w2) :solid t))

  **See also:** `sweep-sections`, `fill-face`"
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
(in-package :cl-occt)

(defun shell-shape (shape faces &key (thickness 1.0) (offset :inward))
  "Create a shell (hollowed solid) by removing specified faces.

  - **shape** a shape to shell
  - **faces** a list of faces to remove from the solid
  - **thickness** wall thickness (default 1.0)
  - **offset** `:inward` (default) or `:outward`, controlling which side of the face to offset from

  **Returns:** a new shape, or `nil` if `shape` or `faces` is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (shell-shape box (list (first faces)) :thickness 2.0))

  **See also:** `offset-shape`"
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

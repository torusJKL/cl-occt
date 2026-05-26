(in-package :cl-occt)

(defun defeature-shape (shape faces)
  "Remove features from a shape by specifying faces to remove.

  - **shape** a shape to remove features from
  - **faces** a list of faces to remove

  **Returns:** a new shape with features removed, or `nil` if `shape` or `faces` is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (defeature-shape box (list (first faces))))

  **See also:** `cut`, `shell-shape`"
  (if (or (null shape) (null faces) (endp faces))
      nil
      (let* ((count (length faces))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for f in faces
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if f (%ptr f) (cffi:null-pointer))))
               (make-shape (%defeature-shape (%ptr shape) arr count)))
          (cffi:foreign-free arr)))))

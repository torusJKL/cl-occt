(in-package :cl-occt)

(defun sew-shapes (shapes &key (tolerance 1.0d-6) (allow-non-manifold nil))
  "Sew adjacent faces/shells into a single watertight shape.

  - **shapes** a list of shapes to sew together
  - **tolerance** sewing tolerance (default 1e-6)
  - **allow-non-manifold** allow non-manifold topology (default nil)

  **Returns:** a new sewn shape, or `nil` if `shapes` is null or empty.

  **Example:**

      (let* ((box1 (make-box 0 0 0 10 10 10))
             (box2 (make-box 10 0 0 10 10 10)))
        (sew-shapes (list box1 box2) :tolerance 0.1))

  **See also:** `make-compound`"
  (if (or (null shapes) (endp shapes))
      nil
      (let* ((count (length shapes))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for s in shapes
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if s (%ptr s) (cffi:null-pointer))))
               (make-shape (%sew-shapes arr count
                                        (coerce tolerance 'double-float)
                                        (if allow-non-manifold 1 0))))
          (cffi:foreign-free arr)))))

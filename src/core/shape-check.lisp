(in-package :cl-occt)

(defun check-shape-validity (shape)
  "Check whether a shape is valid for boolean operations.

  - **shape** a shape to check

  **Returns:** a string describing errors, or `nil` if the shape is valid or `shape` is null.

  **Example:**

      (check-shape-validity (make-box 10 20 30))  ; => nil (valid)

  **See also:** `shape-valid-p`, `shape-check`"
  (if (null shape)
      nil
      (%check-shape-validity (%ptr shape))))

(defun boolean-builder (shape1 shape2 &key (operation :fuse))
  "Perform a boolean operation using the general BuilderAlgo.

  - **shape1** first shape
  - **shape2** second shape
  - **operation** boolean operation: `:fuse` (union), `:cut` (subtract), `:common` (intersect), or `:section` (intersect curves)

  **Returns:** a new shape, or `nil` if any argument is null.

  **Example:**

      (boolean-builder (make-box 10 10 10) (make-cylinder 5 15) :operation :cut)

  **See also:** `fuse`, `cut`, `common`, `section`"
  (if (or (null shape1) (null shape2))
      nil
      (let ((op (case operation
                  (:fuse 0)
                  (:cut 1)
                  (:common 2)
                  (:section 3)
                  (t (error "Unknown boolean operation: ~s (use :fuse, :cut, :common, or :section)"
                            operation)))))
        (make-shape (%boolean-builder (%ptr shape1) (%ptr shape2) op)))))

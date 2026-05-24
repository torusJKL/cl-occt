(in-package :cl-occt)

(defun cut (shape &rest others)
  "Subtract `other` shapes from `shape` (boolean difference).

  **Returns:** a new `shape` representing `shape` minus the volume of all
  `other` shapes.  Accepts one or more shapes as `&rest` arguments.

  **Example:**

      (let ((box (make-box 30 30 30))
            (cyl (make-cylinder 10 40)))
        (cut box cyl (translate cyl 20 0 0)))

  **See also:** `fuse`, `common`, `section`"
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-cut (when a (%ptr a))
                                              (when b (%ptr b))))))
              others
              :initial-value shape)))

(defun fuse (shape &rest others)
  "Merge `shape` with `other` shapes (boolean union).

  **Returns:** a new `shape` that is the union of `shape` and all `other`
  shapes. Accepts one or more shapes as `&rest` arguments.

  **Example:**

      (let ((box (make-box 30 30 30))
            (sph (make-sphere 20)))
        (fuse box (translate sph 15 15 15)))

  **See also:** `cut`, `common`, `section`"
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-fuse (when a (%ptr a))
                                               (when b (%ptr b))))))
              others
              :initial-value shape)))

(defun common (shape &rest others)
  "Compute the intersection of `shape` and `other` shapes (boolean AND).

  **Returns:** a new `shape` representing the volume shared by `shape` and all
  `other` shapes.  Accepts one or more shapes as `&rest` arguments.

  **Example:**

      (let ((box (make-box 30 30 30))
            (sph (make-sphere 20)))
        (common box (translate sph 5 5 5)))

  **See also:** `cut`, `fuse`, `section`"
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-common (when a (%ptr a))
                                                 (when b (%ptr b))))))
              others
              :initial-value shape)))

(defun section (shape &rest others)
  "Compute the intersection curves/edges of `shape` and `other` shapes.

  Unlike `common` which returns a solid, `section` returns the shared
  boundary (edges/curves) between shapes. Accepts one or more shapes
  as `&rest` arguments.

  **Example:**

      (let ((box (make-box 30 30 30))
            (sph (make-sphere 20)))
        (section box (translate sph 5 5 5)))

  **See also:** `cut`, `fuse`, `common`"
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-section (when a (%ptr a))
                                                  (when b (%ptr b))))))
              others
              :initial-value shape)))

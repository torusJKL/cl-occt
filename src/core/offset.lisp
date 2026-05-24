(in-package :cl-occt)

(defun offset-shape (shape offset-distance &key (join :arc))
  "Offset a 3D solid or face by a given distance.

  Positive **offset-distance** offsets outward, negative inward.  **join**
  is one of `:arc` (default), `:tangent`, or `:intersection`, controlling
  how adjacent offset surfaces are joined.

  **Returns:** a new shape, or `nil` if **shape** is null.

  **Example:**

      (offset-shape (make-box 10 10 10) 3.0)
      (offset-shape (make-box 10 10 10) -2.0 :join :tangent)

  **See also:** `offset-wire`, `shell-shape`"
  (if (null shape)
      nil
      (let ((join-val (ecase join
                        (:arc 0)
                        (:tangent 1)
                        (:intersection 2))))
        (make-shape (%offset-shape-3d (%ptr shape)
                                       (coerce offset-distance 'double-float)
                                       join-val)))))

(defun offset-wire (wire offset-distance)
  "Offset a 2D planar wire by a given distance.

  Positive **offset-distance** offsets outward, negative inward.

  **Returns:** a new wire shape, or `nil` if **wire** is null.

  **Example:**

      (let* ((e1 (make-edge 0 0 10 0))
             (e2 (make-edge 10 0 10 10))
             (e3 (make-edge 10 10 0 10))
             (e4 (make-edge 0 10 0 0))
             (wire (make-wire e1 e2 e3 e4)))
        (offset-wire wire 3.0))

  **See also:** `offset-shape`"
  (if (null wire)
      nil
      (make-shape (%offset-wire-2d (%ptr wire)
                                    (coerce offset-distance 'double-float)))))

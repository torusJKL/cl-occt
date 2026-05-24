(in-package :cl-occt)

(defun local-extrude (face height &key direction)
  "Extrude a `face` by a given `height` as a local operation.

  - **direction** currently ignored (the face normal is used).

  **Returns:** a new shape, or `nil` if `face` is null.

  **Example:**

      (let* ((e1 (make-edge 0 0 10 0))
             (e2 (make-edge 10 0 10 10))
             (e3 (make-edge 10 10 0 10))
             (e4 (make-edge 0 10 0 0))
             (face (make-face (make-wire e1 e2 e3 e4))))
        (local-extrude face 20))

  **See also:** `make-prism-feature`"
  (declare (ignore direction))
  (if (null face)
      nil
      (make-shape (%local-extrude
                    (%ptr face)
                    (coerce height 'double-float)
                    (coerce 0 'double-float)
                    (coerce 0 'double-float)
                    (coerce 0 'double-float)))))

(defun make-groove (shape face axis angle)
  "Create a groove feature rotating a `face` around an `axis` by an `angle`.

  - **axis** a 3-element vector (dx dy dz).
  - **angle** in degrees.

  **Returns:** a new shape, or `nil` if `shape`, `face`, or `axis` is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (when faces
          (make-groove box (first faces) '(0 0 1) 45)))

  **See also:** `make-cylindrical-hole`, `make-revol-feature`"
  (if (or (null shape) (null face) (null axis))
      nil
      (make-shape (%make-groove
                    (%ptr shape) (%ptr face)
                    (coerce (first axis) 'double-float)
                    (coerce (second axis) 'double-float)
                    (coerce (third axis) 'double-float)
                    (coerce angle 'double-float)))))

(defun make-rib (shape profile thickness &key (direction '(0 1 0)))
  "Create a rib feature on a `shape` from a `profile` with a given `thickness`.

  - **direction** a 3-element vector (dx dy dz) for the rib direction.

  **Returns:** a new shape, or `nil` if `shape` or `profile` is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (profile (make-wire (make-edge 0 -5 0 0 5 0))))
        (make-rib box profile 2.0 :direction '(0 1 0)))

  **See also:** `make-prism-feature`, `local-extrude`"
  (if (or (null shape) (null profile))
      nil
      (make-shape (%make-rib
                    (%ptr shape) (%ptr profile)
                    (coerce thickness 'double-float)
                    (coerce (first direction) 'double-float)
                    (coerce (second direction) 'double-float)
                    (coerce (third direction) 'double-float)))))

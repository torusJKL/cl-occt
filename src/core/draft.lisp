(in-package :cl-occt)

(defun draft-face (shape face angle pull-direction neutral-plane)
  "Apply a draft angle to a face of a solid.

  - **angle** the draft angle in degrees.
  - **pull-direction** a 3-element vector (dx dy dz) indicating the pull direction.
  - **neutral-plane** a 3-element vector (px py pz) defining a point on the neutral plane (the plane uses `pull-direction` as its normal).

  **Returns:** a new shape, or `nil` if any argument is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (draft-face box (first faces) 10.0 '(0 0 -1) '(0 0 0)))

  **See also:** `make-evolved`"
  (if (or (null shape) (null face) (null pull-direction) (null neutral-plane))
      nil
      (let* ((pd (mapcar (lambda (v) (coerce v 'double-float)) pull-direction))
             (dx (first pd)) (dy (second pd)) (dz (third pd))
             (np (mapcar (lambda (v) (coerce v 'double-float))
                         (if (= (length neutral-plane) 3)
                             neutral-plane
                             (subseq neutral-plane 0 3))))
             (px (first np)) (py (second np)) (pz (third np)))
        (make-shape (%draft-face (%ptr shape) (%ptr face)
                                  (coerce angle 'double-float)
                                  dx dy dz
                                  px py pz
                                  dx dy dz)))))

(defun make-evolved (profile spine &key (offset 0.0) (join :arc))
  "Create an evolved solid by sweeping a `profile` along a closed `spine`.

  - **offset** an optional offset from the spine.
  - **join** one of `:arc`, `:tangent`, or `:intersection` — it controls how pipe sections are joined.

  **Returns:** a new shape, or `nil` if `profile` or `spine` is null.

  **Example:**

      (let* ((circ (make-circle-edge 0 0 5))
             (profile (make-wire circ))
             (spine (make-wire (make-edge-3d 0 0 0 20 0 0)
                                (make-edge-3d 20 0 0 20 20 0)
                                (make-edge-3d 20 20 0 0 20 0)
                                (make-edge-3d 0 20 0 0 0 0))))
        (make-evolved profile spine :offset 2.0))

  **See also:** `draft-face`, `sweep-profile`"
  (if (or (null profile) (null spine))
      nil
      (let ((join-val (ecase join
                        (:arc 0)
                        (:tangent 1)
                        (:intersection 2))))
        (make-shape (%make-evolved (%ptr profile) (%ptr spine)
                                    (coerce offset 'double-float)
                                    join-val)))))

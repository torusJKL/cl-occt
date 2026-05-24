(in-package :cl-occt)

(defun blend-faces (face1 face2 radius)
  "Blend (fill) between two faces with a constant radius.

  **Returns:** a new shape representing the blended transition, or `nil`
  if either face is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (when (>= (length faces) 2)
          (blend-faces (first faces) (second faces) 2.0)))

  **See also:** `make-blend`, `fill-face`"
  (if (or (null face1) (null face2))
      nil
      (make-shape (%blend-faces-constant (%ptr face1) (%ptr face2)
                                          (coerce radius 'double-float)))))

(defun make-blend (face1 face2 type radius-law)
  "Create a blend between two faces with a specified `type` and radius law.

  - **type** one of `:constant` or `:evolving`
  - **radius-law** a numeric radius for `:constant` blends

  **Returns:** a new shape, or `nil` if either face is null.

  **Example:**

      (let* ((box (make-box 30 20 10))
             (faces (map-shape-subshapes box :face)))
        (when (>= (length faces) 2)
          (make-blend (first faces) (second faces) :constant 2.0)))

  **See also:** `blend-faces`, `fill-face`"
  (if (or (null face1) (null face2))
      nil
      (ecase type
        (:constant
         (make-shape (%blend-make-constant (%ptr face1) (%ptr face2)
                                            (coerce radius-law 'double-float))))
        (:evolving
         radius-law
         nil))))

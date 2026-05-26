(in-package :cl-occt)

(defun make-drafted-prism (shape face profile height angle operation)
  "Create a drafted prism by extruding a **profile** along a **face** of **shape**.

  - **shape** the base shape
  - **face** the face to draft from
  - **profile** the profile wire to extrude
  - **height** extrusion height (positive double-float)
  - **angle** draft angle in degrees
  - **operation** boolean operation type keyword

  Returns a new shape, or nil on invalid input.

  **See also:** `make-prism`, `draft-face`"
  (if (or (null shape) (null face) (null profile))
      nil
      (make-shape (%make-drafted-prism (%ptr shape) (%ptr face) (%ptr profile)
                                       (coerce height 'double-float)
                                       (coerce angle 'double-float)
                                       operation))))

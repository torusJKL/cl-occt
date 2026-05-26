(in-package :cl-occt)

(defun make-wedge (dx dy dz &optional ltx xmin zmin xmax zmax)
  "Create a wedge shape with the given dimensions.

  A wedge is a box with one face tapered. With just **dx**, **dy**, **dz** and
  optional **ltx** (taper in X at top), creates a full wedge. With **xmin**,
  **zmin**, **xmax**, **zmax** creates a wedge with a corner cutout.

  - **dx** width along X
  - **dy** depth along Y
  - **dz** height along Z
  - **ltx** taper length at top (default 0)

  **Example:**

      (make-wedge 10 20 30 5)     ; tapered wedge
      (make-wedge 10 20 30 nil 2 0 8 30)  ; corner wedge

  **See also:** `make-box`"
  (if (and xmin zmin xmax zmax)
      (make-shape (%make-wedge-corner (coerce dx 'double-float)
                                      (coerce dy 'double-float)
                                      (coerce dz 'double-float)
                                      (coerce xmin 'double-float)
                                      (coerce zmin 'double-float)
                                      (coerce xmax 'double-float)
                                      (coerce zmax 'double-float)))
      (make-shape (%make-wedge-full (coerce dx 'double-float)
                                    (coerce dy 'double-float)
                                    (coerce dz 'double-float)
                                    (coerce (or ltx 0) 'double-float)))))

(in-package :cl-occt)

(defun make-edge (x1 y1 x2 y2)
  "Create a 2D line edge from (`x1`, `y1`) to (`x2`, `y2`).

  **Returns:** an edge shape representing a straight line segment in the XY
  plane between the two given points.

  **Example:**

    (make-edge 0 0 10 10)"
  (make-shape (%make-edge-line-2d (coerce x1 'double-float)
                                   (coerce y1 'double-float)
                                   (coerce x2 'double-float)
                                   (coerce y2 'double-float))))

(defun make-edge-3d (x1 y1 z1 x2 y2 z2)
  "Create a 3D line edge from (`x1`, `y1`, `z1`) to (`x2`, `y2`, `z2`).

  **Returns:** an edge shape representing a straight line segment in 3D
  space between the two given points.

  **Example:**

    (make-edge-3d 0 0 0 10 10 10)"
  (make-shape (%make-edge-line-3d (coerce x1 'double-float)
                                   (coerce y1 'double-float)
                                   (coerce z1 'double-float)
                                   (coerce x2 'double-float)
                                   (coerce y2 'double-float)
                                   (coerce z2 'double-float))))

(defun make-circle-edge (x y radius)
  "Create a 2D circle edge centered at (`x`, `y`) with the given `radius`.

  **Returns:** an edge shape representing a full circle in the XY plane.

  **Example:**

    (make-circle-edge 0 0 5)"
  (make-shape (%make-edge-circle-2d (coerce x 'double-float)
                                     (coerce y 'double-float)
                                     (coerce radius 'double-float))))

(defun make-circular-arc (x1 y1 x2 y2 x3 y3)
  "Create a 2D circular arc through three points.

  The arc passes from (`x1`, `y1`) through (`x2`, `y2`) to (`x3`, `y3`).

  **Example:**

    (make-circular-arc 0 0 5 5 10 0)"
  (make-shape (%make-edge-arc-2d (coerce x1 'double-float)
                                  (coerce y1 'double-float)
                                  (coerce x2 'double-float)
                                  (coerce y2 'double-float)
                                  (coerce x3 'double-float)
                                  (coerce y3 'double-float))))

(defun make-wire (&rest edges)
  "Join one or more `edges` into a wire (connected edge sequence).

  **Returns:** a wire shape, or `nil` if no edges are provided.  All edges
  should be connected end-to-end to form a valid wire.

  **Example:**

    (let ((e1 (make-edge 0 0 10 0))
          (e2 (make-edge 10 0 10 10)))
      (make-wire e1 e2))"
  (if (null edges)
      nil
      (let ((count (length edges)))
        (cffi:with-foreign-object (arr :pointer count)
          (loop for i from 0 for e in edges
                do (setf (cffi:mem-aref arr :pointer i) (if (null e)
                                                            (cffi:null-pointer)
                                                            (%ptr e))))
          (make-shape (%make-wire arr count))))))

(defun make-face (wire)
  "Create a planar face bounded by the given `wire`.

  The wire must be closed and planar.  **Returns:** a face shape, or `nil` if
  `wire` is `nil`.

  **Example:**

    (def wire (make-wire (make-edge 0 0 10 0)
                         (make-edge 10 0 10 10)
                         (make-edge 10 10 0 10)
                         (make-edge 0 10 0 0)))
    (make-face wire)

  **See also:** `make-face-on-plane`"
  (if (null wire)
      nil
      (make-shape (%make-face (%ptr wire)))))

(defun make-face-on-plane (wire ox oy oz nx ny nz)
  "Create a face from `wire` on a plane defined by origin and normal.

  - **ox**, **oy**, **oz** origin of the plane
  - **nx**, **ny**, **nz** normal vector of the plane

  **Returns:** a face shape, or `nil` if `wire` is `nil`.

  **Example:**

    (def wire (make-wire (make-circle-edge 0 0 5)))
    (make-face-on-plane wire 0 0 0 0 0 1)

  **See also:** `make-face`"
  (if (null wire)
      nil
      (make-shape (%make-face-on-plane (%ptr wire)
                                        (coerce ox 'double-float)
                                        (coerce oy 'double-float)
                                        (coerce oz 'double-float)
                                        (coerce nx 'double-float)
                                        (coerce ny 'double-float)
                                        (coerce nz 'double-float)))))

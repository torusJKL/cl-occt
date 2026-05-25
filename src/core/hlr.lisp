(in-package :cl-occt)

(defun hlr-project (shape &key (direction '(0 0 1)) (position '(0 0 0)))
  "Project a 3D shape onto a plane with hidden line removal.

  - **shape** a shape to project
  - **direction** projection direction `(dx dy dz)` (default `(0 0 1)`, top view)
  - **position** projection plane origin `(px py pz)` (default `(0 0 0)`)

  **Returns:** a compound of visible and hidden edges, or `nil` if `shape` is null.

  HLR returns 2D projected edges. Use `edge->curve` to extract the 2D curve from each edge;
  the 3D curve may not exist for hidden edges.

  **Example:**

      (hlr-project (make-box 30 20 10) :direction '(0 0 -1) :position '(0 0 5))

  **See also:** `hlr-extract-shapes`"
  (if (null shape)
      nil
      (destructuring-bind (dx dy dz) (mapcar (lambda (v) (coerce v 'double-float)) direction)
        (destructuring-bind (px py pz) (mapcar (lambda (v) (coerce v 'double-float)) position)
          (make-shape (%hlr-project (%ptr shape) dx dy dz px py pz))))))

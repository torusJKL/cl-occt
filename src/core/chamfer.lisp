(in-package :cl-occt)

(defun chamfer-edge (shape edge distance)
  "Chamfer a single edge of a solid with an equal distance on both sides.

  **Returns:** a new shape with the edge chamfered, or `nil` if `shape` or
  `edge` is `nil`.

  **Example:**

    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge)))
      (chamfer-edge box (first edges) 3.0))

  **See also:** `chamfer-edges`, `chamfer-edge-asymmetric`, `chamfer-edge-on-face`"
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-equal (%ptr shape) (%ptr edge)
                                        (coerce distance 'double-float)))))

(defun chamfer-edges (shape edges distance)
  "Chamfer multiple edges of a solid with an equal distance on both sides.

  `edges` is a list of edge shapes.

  **Returns:** a new shape, or `nil` if `shape` is `nil`.

  **Example:**

    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge))
           (some-edges (list (first edges) (second edges))))
      (chamfer-edges box some-edges 3.0))

  **See also:** `chamfer-edge`, `chamfer-edge-asymmetric`, `chamfer-edge-on-face`"
  (if (null shape)
      nil
      (let* ((count (length edges))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for e in edges
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if e (%ptr e) (cffi:null-pointer))))
               (make-shape (%chamfer-edges-equal (%ptr shape) arr count
                                                  (coerce distance 'double-float))))
          (cffi:foreign-free arr)))))

(defun chamfer-edge-asymmetric (shape edge distance1 distance2)
  "Chamfer a single edge with different distances on each side.

  `distance1` and `distance2` are the chamfer distances on the two faces
  adjacent to the edge.

  **Returns:** a new shape, or `nil` if `shape` or `edge` is `nil`.

  **Example:**

    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge)))
      (chamfer-edge-asymmetric box (first edges) 4.0 2.0))

  **See also:** `chamfer-edge`, `chamfer-edges`, `chamfer-edge-on-face`"
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-asym (%ptr shape) (%ptr edge)
                                       (coerce distance1 'double-float)
                                       (coerce distance2 'double-float)))))

(defun chamfer-edge-on-face (shape edge distance face)
  "Chamfer a single edge with distance measured from a specific `face`.

  The chamfer distance is measured from the given `face` to the new
  chamfer face.

  **Returns:** a new shape, or `nil` if `shape` or `edge` is `nil`.

  **Example:**

    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge))
           (faces (map-shape-subshapes box :face)))
      (chamfer-edge-on-face box (first edges) 3.0 (first faces)))

  **See also:** `chamfer-edge`, `chamfer-edges`, `chamfer-edge-asymmetric`"
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-on-face (%ptr shape) (%ptr edge)
                                          (coerce distance 'double-float)
                                          (if face (%ptr face) (cffi:null-pointer))))))

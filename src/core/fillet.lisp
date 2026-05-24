(in-package :cl-occt)

(defun fillet-edge (shape edge radius)
  "Round a single edge of a solid with a constant radius.

  Returns a new shape with the edge filleted, or NIL if SHAPE or
  EDGE is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge)))
      (fillet-edge box (first edges) 3.0))

  See also: fillet-edges, fillet-edge-variable, fillet-wire-corner"
  (if (or (null shape) (null edge))
      nil
      (make-shape (%fillet-edge-constant (%ptr shape) (%ptr edge)
                                          (coerce radius 'double-float)))))

(defun fillet-edges (shape edges radius)
  "Round multiple edges of a solid with a constant radius.

  EDGES is a list of edge shapes to fillet.  Returns a new shape
  with all specified edges filleted, or NIL if SHAPE is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge))
           (some-edges (list (first edges) (second edges))))
      (fillet-edges box some-edges 3.0))

  See also: fillet-edge, fillet-edge-variable"
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
               (make-shape (%fillet-edges-constant (%ptr shape) arr count
                                                    (coerce radius 'double-float))))
          (cffi:foreign-free arr)))))

(defun fillet-edge-variable (shape edge param-radius-pairs)
  "Fillet a single edge with a variable radius along its length.

  PARAM-RADIUS-PAIRS is a list of (parameter radius) pairs, where
  parameter ranges from 0.0 to 1.0 along the edge.  Returns a new
  shape, or NIL if any argument is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (edges (map-shape-subshapes box :edge)))
      (fillet-edge-variable box (first edges)
                            '((0.0 3.0) (0.5 5.0) (1.0 3.0))))

  See also: fillet-edge, fillet-edges"
  (if (or (null shape) (null edge) (null param-radius-pairs))
      nil
      (let* ((count (length param-radius-pairs))
             (arr (cffi:foreign-alloc :double :count (* count 2))))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for (param rad) in param-radius-pairs
                     do (setf (cffi:mem-aref arr :double (* i 2)) (coerce param 'double-float)
                              (cffi:mem-aref arr :double (1+ (* i 2))) (coerce rad 'double-float)))
               (make-shape (%fillet-edge-variable (%ptr shape) (%ptr edge) arr count)))
          (cffi:foreign-free arr)))))

(defun fillet-wire-corner (wire radius)
  "Round the first corner of a wire with a given radius.

  Returns a new wire with the corner filleted, or NIL if WIRE
  is null.

  Example:
    (let* ((e1 (make-edge 0 0 10 0))
           (e2 (make-edge 10 0 10 10))
           (e3 (make-edge 10 10 0 10))
           (e4 (make-edge 0 10 0 0))
           (wire (make-wire e1 e2 e3 e4)))
      (fillet-wire-corner wire 2.0))

  See also: fillet-wire-all-corners"
  (if (null wire)
      nil
      (make-shape (%fillet-wire-corner (%ptr wire)
                                        (coerce radius 'double-float)))))

(defun fillet-wire-all-corners (wire radius)
  "Round all corners of a wire with a given radius.

  Returns a new wire with all corners filleted, or NIL if WIRE
  is null.

  Example:
    (let* ((e1 (make-edge 0 0 10 0))
           (e2 (make-edge 10 0 10 10))
           (e3 (make-edge 10 10 0 10))
           (e4 (make-edge 0 10 0 0))
           (wire (make-wire e1 e2 e3 e4)))
      (fillet-wire-all-corners wire 2.0))

  See also: fillet-wire-corner"
  (if (null wire)
      nil
      (make-shape (%fillet-wire-all-corners (%ptr wire)
                                              (coerce radius 'double-float)))))

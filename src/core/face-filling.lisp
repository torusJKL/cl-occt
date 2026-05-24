(in-package :cl-occt)

(defun fill-face (boundary-wire &key support-faces continuity)
  "Fill a planar boundary `wire` to create a face.

  - **boundary-wire** the wire to fill
  - **support-faces** list of adjacent faces for continuity constraint
  - **continuity** list of keywords (`:c0`, `:tangent`, `:curvature`,
    `:g3`) matching `support-faces`

  When `support-faces` and `continuity` are provided, the fill is
  constrained to maintain tangency or curvature with adjacent
  faces.

  **Returns:** a new face shape, or `nil` if `boundary-wire` is null.

  **Example:**

      (let* ((w (make-wire (make-edge-3d 0 0 0 10 0 0)
                           (make-edge-3d 10 0 0 10 10 0)
                           (make-edge-3d 10 10 0 0 10 0)
                           (make-edge-3d 0 10 0 0 0 0))))
        (fill-face w))

  **See also:** `fill-n-sided-face`, `make-face`"
  (when (null boundary-wire)
    (return-from fill-face nil))
  (if (and support-faces continuity)
      (let* ((count (length support-faces))
             (faces-ff (cffi:foreign-alloc :pointer :initial-contents
                                           (map 'vector (lambda (f) (if f (%ptr f) (cffi:null-pointer)))
                                                support-faces)))
             (cont-vec (map 'vector (lambda (c) (ecase c (:c0 0) (:tangent 1) (:curvature 2) (:g3 3)))
                            continuity))
             (cont-ff (cffi:foreign-alloc :int :initial-contents cont-vec))
             result)
        (unwind-protect
             (setf result (make-shape (%fill-face-constrained (%ptr boundary-wire) faces-ff cont-ff count)))
          (cffi:foreign-free faces-ff)
          (cffi:foreign-free cont-ff))
        result)
      (make-shape (%fill-face (%ptr boundary-wire)))))

(defun fill-n-sided-face (edges &key (continuity :c0))
  "Fill an N-sided face bounded by a list of `edges`.

  - **edges** list of edges bounding the face
  - **continuity** one of `:c0` (default), `:tangent`, `:curvature`,
    or `:g3`, controlling surface continuity at the boundary

  At least 3 edges are required.

  **Returns:** a new face shape, or `nil` if fewer than 3
  edges are provided.

  **Example:**

      (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
             (e2 (make-edge-3d 10 0 0 10 10 0))
             (e3 (make-edge-3d 10 10 0 0 10 0))
             (e4 (make-edge-3d 0 10 0 0 0 0)))
        (fill-n-sided-face (list e1 e2 e3 e4) :continuity :tangent))

  **See also:** `fill-face`"
  (when (or (null edges) (< (length edges) 3))
    (return-from fill-n-sided-face nil))
  (let* ((count (length edges))
         (cont-int (ecase continuity (:c0 0) (:tangent 1) (:curvature 2) (:g3 3)))
         (ptr-vec (map 'vector (lambda (e) (%ptr e)) edges))
         (edges-ff (cffi:foreign-alloc :pointer :initial-contents ptr-vec))
         result)
    (unwind-protect
         (setf result (make-shape (%fill-n-sided-face edges-ff count cont-int)))
      (cffi:foreign-free edges-ff))
    result))
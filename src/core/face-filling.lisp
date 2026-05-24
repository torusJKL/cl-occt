(in-package :cl-occt)

(defun fill-face (boundary-wire &key support-faces continuity)
  "Fill a planar boundary WIRE to create a face.

  When SUPPORT-FACES and CONTINUITY are provided, the fill is
  constrained to maintain tangency or curvature with adjacent
  faces.  CONTINUITY is a list of keywords (:C0, :TANGENT,
  :CURVATURE, :G3) matching SUPPORT-FACES.  Returns a new face
  shape, or NIL if BOUNDARY-WIRE is null.

  Example:
    (let* ((w (make-wire (make-edge-3d 0 0 0 10 0 0)
                         (make-edge-3d 10 0 0 10 10 0)
                         (make-edge-3d 10 10 0 0 10 0)
                         (make-edge-3d 0 10 0 0 0 0))))
      (fill-face w))

  See also: fill-n-sided-face, make-face"
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
  "Fill an N-sided face bounded by a list of EDGES.

  At least 3 edges are required.  CONTINUITY is one of :C0 (default),
  :TANGENT, :CURVATURE, or :G3, controlling surface continuity at
  the boundary.  Returns a new face shape, or NIL if fewer than 3
  edges are provided.

  Example:
    (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
           (e2 (make-edge-3d 10 0 0 10 10 0))
           (e3 (make-edge-3d 10 10 0 0 10 0))
           (e4 (make-edge-3d 0 10 0 0 0 0)))
      (fill-n-sided-face (list e1 e2 e3 e4) :continuity :tangent))

  See also: fill-face"
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
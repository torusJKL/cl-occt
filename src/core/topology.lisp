(in-package :cl-occt.impl)

(defvar *shape-type-map*
  '((:compound . 0)
    (:compsolid . 1)
    (:solid . 2)
    (:shell . 3)
    (:face . 4)
    (:wire . 5)
    (:edge . 6)
    (:vertex . 7)
    (:shape . 8)))

(defun %shape-type-to-int (keyword)
  (or (cdr (assoc keyword *shape-type-map*))
      (error "Unknown shape type keyword: ~S" keyword)))

(in-package :cl-occt)

(defun map-shape-subshapes (shape type &key stop-at)
  "Collect all subshapes of SHAPE matching the given TYPE keyword.

  TYPE     -- keyword in (:compound :compsolid :solid :shell :face
               :wire :edge :vertex :shape)
  STOP-AT  -- optional type keyword at which to stop recursion
               (default :shape, meaning recurse to leaves)

  Example:
    (let ((box (make-box 10 20 30)))
      (map-shape-subshapes box :face))

  See also: count-shape-subshapes, dump-shape"
  (unless (shape-p shape)
    (return-from map-shape-subshapes nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from map-shape-subshapes nil))
    (let* ((type-int (%shape-type-to-int type))
           (stop-int (if stop-at (%shape-type-to-int stop-at) 8))
           (max-shapes 65536)
           (shapes (cffi:foreign-alloc :pointer :count max-shapes)))
      (unwind-protect
           (let ((count (%map-subshapes ptr type-int stop-int shapes max-shapes)))
             (loop for i from 0 below count
                   collect (make-shape
                            (cffi:mem-aref shapes :pointer i))))
        (cffi:foreign-free shapes)))))

(defun count-shape-subshapes (shape type &key stop-at)
  "Count subshapes of SHAPE matching the given TYPE keyword.

  TYPE     -- keyword in (:compound :compsolid :solid :shell :face
               :wire :edge :vertex :shape)
  STOP-AT  -- optional type keyword at which to stop recursion

  Example:
    (let ((box (make-box 10 20 30)))
      (count-shape-subshapes box :face))

  See also: map-shape-subshapes, dump-shape"
  (unless (shape-p shape)
    (return-from count-shape-subshapes nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from count-shape-subshapes nil))
    (%count-subshapes ptr
      (%shape-type-to-int type)
      (if stop-at (%shape-type-to-int stop-at) 8))))

(defun dump-shape (shape)
  "Print the topological hierarchy of SHAPE to standard output.

  Example:
    (let ((box (make-box 10 20 30)))
      (dump-shape box))

  See also: map-shape-subshapes, count-shape-subshapes"
  (unless (shape-p shape)
    (return-from dump-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from dump-shape nil))
    (%dump-shape ptr)))

(defun shape-triangle-count (shape)
  "Return the number of triangles in SHAPE's mesh triangulation.

  Example:
    (shape-triangle-count (make-box 10 20 30))"
  (unless (shape-p shape)
    (return-from shape-triangle-count nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-triangle-count nil))
    (%shape-triangle-count ptr)))

(defun wire-order-check-p (wire &optional face)
  "Check if WIRE has its edges in consistent order (non-optional FACE).

  When FACE is provided, check edge ordering relative to that face.
  Returns T if the wire order is correct, NIL otherwise.

  Example:
    (let ((w (make-wire (make-edge 0 0 10 0)
                        (make-edge 10 0 10 10)
                        (make-edge 10 10 0 10)
                        (make-edge 0 10 0 0))))
      (wire-order-check-p w (make-face w)))"
  (unless (shape-p wire)
    (return-from wire-order-check-p nil))
  (let ((wire-ptr (%ptr wire)))
    (when (or (null wire-ptr) (cffi:null-pointer-p wire-ptr))
      (return-from wire-order-check-p nil))
    (let ((face-ptr (if face (%ptr face) (cffi:null-pointer))))
      (not (zerop (%wire-order-check wire-ptr face-ptr))))))

(defun edge->curve (edge)
  "Extract the geometric curve underlying an EDGE.

  Returns a curve object, or NIL if the edge has no curve.

  Example:
    (let* ((e (make-circle-edge 0 0 5))
           (c (edge->curve e)))
      (curve-type c))

  See also: face->surface, curve-type"
  (unless (shape-p edge)
    (return-from edge->curve nil))
  (let ((ptr (%ptr edge)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from edge->curve nil))
    (let ((curve-ptr (%edge-to-curve ptr)))
      (if (and curve-ptr (not (cffi:null-pointer-p curve-ptr)))
          (make-curve curve-ptr)
          nil))))

(defun face->surface (face)
  "Extract the geometric surface underlying a FACE.

  Returns a surface object, or NIL if the face has no surface.

  Example:
    (let* ((f (make-face-on-plane
                (make-wire (make-circle-edge 0 0 5))
                0 0 0 0 0 1))
           (s (face->surface f)))
      (surface-type s))

  See also: edge->curve, surface-type"
  (unless (shape-p face)
    (return-from face->surface nil))
  (let ((ptr (%ptr face)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from face->surface nil))
    (let ((surface-ptr (%face-to-surface ptr)))
      (if (and surface-ptr (not (cffi:null-pointer-p surface-ptr)))
          (make-surface surface-ptr)
          nil))))

(defun make-vertex (x y z)
  "Create a vertex at the 3D point (X, Y, Z).

  Example:
    (make-vertex 1 2 3)"
  (make-shape (%make-vertex
                (coerce x 'double-float)
                (coerce y 'double-float)
                (coerce z 'double-float))))

(defun make-polygon (points &key (closed t))
  "Create a polygonal wire from a list of 3D POINTS.

  POINTS -- list of (x y z) coordinate triples (at least 2)
  CLOSED -- if T (default), the polygon is closed back to the first point

  Returns a wire shape, or NIL if less than 2 points are provided.

  Example:
    (make-polygon '((0 0 0) (10 0 0) (10 10 0) (0 10 0)))
    (make-polygon '((0 0 0) (10 0 0) (10 10 0)) :closed nil)"
  (unless (and (listp points) (>= (length points) 2))
    (return-from make-polygon nil))
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-shape (%make-polygon arr n (if closed 1 0))))
      (cffi:foreign-free arr))))

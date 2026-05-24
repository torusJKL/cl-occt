(in-package :cl-occt)

(defun fix-shape (shape)
  "Apply OCCT's shape fixing algorithm to repair a shape.

  **shape** -- a shape object (typically invalid or problematic)

  Attempts to fix common issues such as small edges, gaps, and
  incorrect orientations.  Returns a new fixed shape, or `nil` on error.

  **Example:**

    (let ((fixed (fix-shape some-invalid-shape)))
      (when fixed
        (shape-valid-p fixed)))

  **See also:** `fix-wire`, `fix-solid`, `fix-edge`, `fix-face`, `heal-shape`"
  (unless (shape-p shape)
    (return-from fix-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from fix-shape nil))
    (make-shape (%fix-shape ptr))))

(defun fix-wire (wire face &key (tolerance 0.1))
  "Fix a wire, optionally projecting it onto a face.

  **wire** -- a wire shape to fix
  **face** -- a face shape to project onto (or `nil`)
  **tolerance** -- merging tolerance (default 0.1)

  Returns a new fixed wire, or `nil` on error.

  **Example:**

    (fix-wire some-wire nil :tolerance 0.01)

  **See also:** `fix-shape`, `fix-edge`, `fix-face`"
  (unless (shape-p wire)
    (return-from fix-wire nil))
  (let ((wire-ptr (%ptr wire))
        (face-ptr (when (shape-p face) (%ptr face))))
    (when (or (null wire-ptr) (cffi:null-pointer-p wire-ptr))
      (return-from fix-wire nil))
    (make-shape (%fix-wire wire-ptr
                           (or face-ptr (cffi:null-pointer))
                           (coerce tolerance 'double-float)))))

(defun fix-solid (shape)
  "Fix a solid shape by repairing its shells and faces.

  Returns a new fixed solid, or `nil` on error.

  **Example:**

    (fix-solid (make-box 10 20 30))

  **See also:** `fix-shape`, `fix-face`, `fix-wire`"
  (unless (shape-p shape)
    (return-from fix-solid nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from fix-solid nil))
    (make-shape (%fix-solid ptr))))

(defun fix-edge (edge)
  "Fix an edge by repairing its curve and tolerance.

  Returns a new fixed edge, or `nil` on error.

  **Example:**

    (fix-edge some-edge)

  **See also:** `fix-wire`, `fix-face`, `fix-shape`"
  (unless (shape-p edge)
    (return-from fix-edge nil))
  (let ((ptr (%ptr edge)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from fix-edge nil))
    (make-shape (%fix-edge ptr))))

(defun fix-face (face)
  "Fix a face by repairing its surface and wires.

  Returns a new fixed face, or `nil` on error.

  **Example:**

    (fix-face some-face)

  **See also:** `fix-wire`, `fix-edge`, `fix-shape`"
  (unless (shape-p face)
    (return-from fix-face nil))
  (let ((ptr (%ptr face)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from fix-face nil))
    (make-shape (%fix-face ptr))))

(defun shape-analysis-free-edges (shape)
  "Find free edges (boundary edges) of a shape.

  Free edges are edges that belong to only one face, indicating
  open shells or boundaries.

  Returns a shape containing the free edges, or `nil` on error.

  **Example:**

    (shape-analysis-free-edges (make-box 10 20 30))
    => NIL (closed solid has no free edges)

  **See also:** `shape-analysis-check-intersections`, `shape-check`"
  (unless (shape-p shape)
    (return-from shape-analysis-free-edges nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-analysis-free-edges nil))
    (make-shape (%shape-analysis-free-edges ptr))))

(defun shape-analysis-check-intersections (shape)
  "Check a shape for self-intersecting edges.

  Returns the number of self-intersecting edges found, or `nil` on error.

  **Example:**

    (shape-analysis-check-intersections (make-box 10 20 30))
    => 0

  **See also:** `shape-analysis-free-edges`, `shape-check`"
  (unless (shape-p shape)
    (return-from shape-analysis-check-intersections nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-analysis-check-intersections nil))
    (let ((count (%shape-analysis-check-intersections ptr)))
      (when (minusp count) (return-from shape-analysis-check-intersections nil))
      count)))

(defun shape-analysis-wire-contains-p (wire point)
  "Test whether a 2D point lies inside a wire contour.

  **wire** -- a wire shape
  **point** -- 2D point as (X Y)

  Returns `t` if the point is inside the wire, `nil` otherwise or on error.

  **Example:**

    (let ((w (make-wire-2d (list (make-line (make-pnt2d 0 0) (make-pnt2d 10 0))
                                  (make-line (make-pnt2d 10 0) (make-pnt2d 10 10))
                                  (make-line (make-pnt2d 10 10) (make-pnt2d 0 10))
                                  (make-line (make-pnt2d 0 10) (make-pnt2d 0 0))))))
      (shape-analysis-wire-contains-p w '(5 5)))

  **See also:** `point-in-solid-p`"
  (unless (and (shape-p wire) (listp point) (= (length point) 2))
    (return-from shape-analysis-wire-contains-p nil))
  (let ((ptr (%ptr wire)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-analysis-wire-contains-p nil))
    (not (zerop (%shape-analysis-wire-contains ptr
                  (coerce (first point) 'double-float)
                  (coerce (second point) 'double-float))))))

(defun shape-analysis-contents (shape)
  "Return a property list describing the sub-shape count of a shape.

  Returns a plist with keys `:solids`, `:shells`, `:faces`, `:wires`, `:edges`,
  and `:vertices`, each mapping to the count of that sub-shape type.

  Returns `nil` on error.

  **Example:**

    (shape-analysis-contents (make-box 10 20 30))
    => (:SOLIDS 1 :SHELLS 1 :FACES 6 :WIRES 6 :EDGES 12 :VERTICES 8)

  **See also:** `shape-check`"
  (unless (shape-p shape)
    (return-from shape-analysis-contents nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-analysis-contents nil))
    (list :solids (count-shape-subshapes shape :solid)
          :shells (count-shape-subshapes shape :shell)
          :faces (count-shape-subshapes shape :face)
          :wires (count-shape-subshapes shape :wire)
          :edges (count-shape-subshapes shape :edge)
          :vertices (count-shape-subshapes shape :vertex))))

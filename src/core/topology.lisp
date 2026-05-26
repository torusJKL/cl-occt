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

(defvar *int-to-shape-type* nil
  "Reverse map: integer -> keyword for shape types.")

(defun %int-to-shape-type (int-val)
  (unless *int-to-shape-type*
    (setq *int-to-shape-type*
          (loop for (k . v) in *shape-type-map*
                collect (cons v k))))
  (cdr (assoc int-val *int-to-shape-type*)))

(defvar *orientation-map*
  '((:forward . 0)
    (:reversed . 1)
    (:internal . 2)
    (:external . 3)))

(defvar *int-to-orientation* nil)

(defun %int-to-orientation (int-val)
  (unless *int-to-orientation*
    (setq *int-to-orientation*
          (loop for (k . v) in *orientation-map*
                collect (cons v k))))
  (cdr (assoc int-val *int-to-orientation*)))

(defun %geomabs-surface-type->keyword (type-int)
  (ecase type-int
    (0 :plane)
    (1 :cylinder)
    (2 :cone)
    (3 :sphere)
    (4 :torus)
    (5 :bezier-surface)
    (6 :bspline-surface)
    (7 :revolution-surface)
    (8 :extrusion-surface)
    (9 :offset-surface)
    (10 :other-surface)))

(defun %geomabs-curve-type->keyword (type-int)
  (ecase type-int
    (0 :line)
    (1 :circle)
    (2 :ellipse)
    (3 :hyperbola)
    (4 :parabola)
    (5 :bezier-curve)
    (6 :bspline-curve)
    (7 :other-curve)))

(in-package :cl-occt)

(defun map-shape-subshapes (shape type &key stop-at)
  "Collect all subshapes of `shape` matching the given `type` keyword.

  - **type** keyword in (`:compound`, `:compsolid`, `:solid`, `:shell`, `:face`,
    `:wire`, `:edge`, `:vertex`, `:shape`)
  - **stop-at** optional type keyword at which to stop recursion
    (default `:shape`, meaning recurse to leaves)

  **Example:**

      (let ((box (make-box 10 20 30)))
        (map-shape-subshapes box :face))

  **See also:** `count-shape-subshapes`, `dump-shape`"
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
  "Count subshapes of `shape` matching the given `type` keyword.

  - **type** keyword in (`:compound`, `:compsolid`, `:solid`, `:shell`, `:face`,
    `:wire`, `:edge`, `:vertex`, `:shape`)
  - **stop-at** optional type keyword at which to stop recursion

  **Example:**

      (let ((box (make-box 10 20 30)))
        (count-shape-subshapes box :face))

  **See also:** `map-shape-subshapes`, `dump-shape`"
  (unless (shape-p shape)
    (return-from count-shape-subshapes nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from count-shape-subshapes nil))
    (%count-subshapes ptr
      (%shape-type-to-int type)
      (if stop-at (%shape-type-to-int stop-at) 8))))

(defun dump-shape (shape)
  "Print the topological hierarchy of `shape` to standard output.

  **Example:**

      (let ((box (make-box 10 20 30)))
        (dump-shape box))

  **See also:** `map-shape-subshapes`, `count-shape-subshapes`"
  (unless (shape-p shape)
    (return-from dump-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from dump-shape nil))
    (%dump-shape ptr)))

(defun shape-triangle-count (shape)
  "Return the number of triangles in `shape`'s mesh triangulation.

  **Example:**

      (shape-triangle-count (make-box 10 20 30))"
  (unless (shape-p shape)
    (return-from shape-triangle-count nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-triangle-count nil))
    (%shape-triangle-count ptr)))

(defun wire-order-check-p (wire &optional face)
  "Check if `wire` has its edges in consistent order (non-optional `face`).

  When `face` is provided, check edge ordering relative to that face.

  **Returns:** `t` if the wire order is correct, `nil` otherwise.

  **Example:**

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
  "Extract the geometric curve underlying an `edge`.

  **Returns:** a curve object, or `nil` if the edge has no curve.

  **Example:**

      (let* ((e (make-circle-edge 0 0 5))
             (c (edge->curve e)))
        (curve-type c))

  **See also:** `face->surface`, `curve-type`"
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
  "Extract the geometric surface underlying a `face`.

  **Returns:** a surface object, or `nil` if the face has no surface.

  **Example:**

      (let* ((f (make-face-on-plane
                  (make-wire (make-circle-edge 0 0 5))
                  0 0 0 0 0 1))
             (s (face->surface f)))
        (surface-type s))

  **See also:** `edge->curve`, `surface-type`"
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
  "Create a vertex at the 3D point (`x`, `y`, `z`).

  **Example:**

      (make-vertex 1 2 3)"
  (make-shape (%make-vertex
                (coerce x 'double-float)
                (coerce y 'double-float)
                (coerce z 'double-float))))

(defun make-polygon (points &key (closed t))
  "Create a polygonal wire from a list of 3D `points`.

  - **points** list of (`x`, `y`, `z`) coordinate triples (at least 2)
  - **closed** if `t` (default), the polygon is closed back to the first point

  **Returns:** a wire shape, or `nil` if less than 2 points are provided.

  **Example:**

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

(defun %collect-shape-array (c-ptr count)
  (loop for i from 0 below count
        collect (make-shape (cffi:mem-aref c-ptr :pointer i))))

(defun face-edges (face)
  "Return the bounding edges of a `face`.
  **Returns:** list of edge shapes, or nil."
  (unless (shape-p face) (return-from face-edges nil))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-edges nil))
    (cffi:with-foreign-object (out-arr :pointer)
      (cffi:with-foreign-object (out-count :int)
        (when (zerop (%face-edges ptr out-arr out-count))
          (return-from face-edges nil))
        (let ((count (cffi:mem-ref out-count :int))
              (arr (cffi:mem-ref out-arr :pointer)))
          (when (zerop count) (return-from face-edges nil))
          (unwind-protect
               (%collect-shape-array arr count)
            (%free-shape-array arr)))))))

(defun edge-vertices (edge)
  "Return the start and end vertices of an `edge`.
  **Returns:** two values: start-vertex, end-vertex (or nil)."
  (unless (shape-p edge) (return-from edge-vertices (values nil nil)))
  (let ((ptr (%ptr edge)))
    (when (cffi:null-pointer-p ptr) (return-from edge-vertices (values nil nil)))
    (cffi:with-foreign-object (out-start :pointer)
      (cffi:with-foreign-object (out-end :pointer)
        (when (zerop (%edge-vertices ptr out-start out-end))
          (return-from edge-vertices (values nil nil)))
        (values (make-shape (cffi:mem-ref out-start :pointer))
                (make-shape (cffi:mem-ref out-end :pointer)))))))

(defun vertex-edges (vertex parent)
  "Return all edges incident to a `vertex` within a `parent` shape.
  **Returns:** list of edge shapes, or nil."
  (unless (and (shape-p vertex) (shape-p parent))
    (return-from vertex-edges nil))
  (let ((vptr (%ptr vertex))
        (pptr (%ptr parent)))
    (when (or (cffi:null-pointer-p vptr) (cffi:null-pointer-p pptr))
      (return-from vertex-edges nil))
    (cffi:with-foreign-object (out-arr :pointer)
      (cffi:with-foreign-object (out-count :int)
        (when (zerop (%vertex-edges vptr pptr out-arr out-count))
          (return-from vertex-edges nil))
        (let ((count (cffi:mem-ref out-count :int))
              (arr (cffi:mem-ref out-arr :pointer)))
          (when (zerop count) (return-from vertex-edges nil))
          (unwind-protect
               (%collect-shape-array arr count)
            (%free-shape-array arr)))))))

(defun edge-faces (edge parent)
  "Return faces sharing an `edge` within a `parent` shape.
  **Returns:** list of face shapes, or nil."
  (unless (and (shape-p edge) (shape-p parent))
    (return-from edge-faces nil))
  (let ((eptr (%ptr edge))
        (pptr (%ptr parent)))
    (when (or (cffi:null-pointer-p eptr) (cffi:null-pointer-p pptr))
      (return-from edge-faces nil))
    (cffi:with-foreign-object (out-arr :pointer)
      (cffi:with-foreign-object (out-count :int)
        (when (zerop (%edge-faces eptr pptr out-arr out-count))
          (return-from edge-faces nil))
        (let ((count (cffi:mem-ref out-count :int))
              (arr (cffi:mem-ref out-arr :pointer)))
          (when (zerop count) (return-from edge-faces nil))
          (unwind-protect
               (%collect-shape-array arr count)
            (%free-shape-array arr)))))))

(defun face-wires (face)
  "Return the wires of a `face` (outer wire + holes).
  **Returns:** list of wire shapes, or nil."
  (unless (shape-p face) (return-from face-wires nil))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-wires nil))
    (cffi:with-foreign-object (out-arr :pointer)
      (cffi:with-foreign-object (out-count :int)
        (when (zerop (%face-wires ptr out-arr out-count))
          (return-from face-wires nil))
        (let ((count (cffi:mem-ref out-count :int))
              (arr (cffi:mem-ref out-arr :pointer)))
          (when (zerop count) (return-from face-wires nil))
          (unwind-protect
               (%collect-shape-array arr count)
            (%free-shape-array arr)))))))

(defun wire-edges (wire)
  "Return the ordered edges of a `wire`.
  **Returns:** list of edge shapes in order, or nil."
  (unless (shape-p wire) (return-from wire-edges nil))
  (let ((ptr (%ptr wire)))
    (when (cffi:null-pointer-p ptr) (return-from wire-edges nil))
    (cffi:with-foreign-object (out-arr :pointer)
      (cffi:with-foreign-object (out-count :int)
        (when (zerop (%wire-edges ptr out-arr out-count))
          (return-from wire-edges nil))
        (let ((count (cffi:mem-ref out-count :int))
              (arr (cffi:mem-ref out-arr :pointer)))
          (when (zerop count) (return-from wire-edges nil))
          (unwind-protect
               (%collect-shape-array arr count)
            (%free-shape-array arr)))))))

(defun shape-type (shape)
  "Return the type keyword of a `shape`.
  **Returns:** `:solid`, `:face`, `:edge`, `:vertex`, `:wire`, `:shell`, `:compound`, or nil."
  (unless (shape-p shape) (return-from shape-type nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr) (return-from shape-type nil))
    (let ((int-val (%shape-type-int ptr)))
      (when (minusp int-val) (return-from shape-type nil))
      (%int-to-shape-type int-val))))

(defun subshape-orientation (shape)
  "Return the orientation keyword of a subshape.
  **Returns:** `:forward`, `:reversed`, `:internal`, `:external`, or nil."
  (unless (shape-p shape) (return-from subshape-orientation nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr) (return-from subshape-orientation nil))
    (let ((int-val (%shape-orientation-int ptr)))
      (when (minusp int-val) (return-from subshape-orientation nil))
      (%int-to-orientation int-val))))



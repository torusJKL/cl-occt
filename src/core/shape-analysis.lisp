(in-package :cl-occt)

(defclass shape-extrema ()
  ((%distance :initarg :distance :reader extrema-distance)
   (%point-on-shape1 :initarg :point-on-shape1 :reader extrema-point-on-shape1)
   (%point-on-shape2 :initarg :point-on-shape2 :reader extrema-point-on-shape2)))

(in-package :cl-occt.impl)

(defun %shape-distance-extrema-internal (shape1-ptr shape2-ptr)
  (cffi:with-foreign-objects ((dist :double)
                              (p1x :double) (p1y :double) (p1z :double)
                              (p2x :double) (p2y :double) (p2z :double))
    (let ((ok (%shape-distance-extrema shape1-ptr shape2-ptr
                                       dist p1x p1y p1z p2x p2y p2z)))
      (when (zerop ok) (return-from %shape-distance-extrema-internal nil))
      (make-instance 'cl-occt:shape-extrema
        :distance (cffi:mem-ref dist :double)
        :point-on-shape1 (list (cffi:mem-ref p1x :double)
                               (cffi:mem-ref p1y :double)
                               (cffi:mem-ref p1z :double))
        :point-on-shape2 (list (cffi:mem-ref p2x :double)
                               (cffi:mem-ref p2y :double)
                               (cffi:mem-ref p2z :double))))))

(in-package :cl-occt)

(defun shape-distance (shape1 shape2)
  "Compute the minimum distance between two shapes.

  **shape1** **shape2** -- shape objects

  **Returns:** the minimum distance as a `double-float`, or `nil` on error.

  **Example:**

      (let ((a (make-box 10 10 10))
            (b (translate (make-box 10 10 10) 20 0 0)))
        (shape-distance a b))
      => 10.0d0

  **See also:** `shape-distance-extrema`"
  (unless (and (shape-p shape1) (shape-p shape2))
    (return-from shape-distance nil))
  (let ((p1 (%ptr shape1))
        (p2 (%ptr shape2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from shape-distance nil))
    (let ((d (%shape-distance p1 p2)))
      (when (minusp d) (return-from shape-distance nil))
      d)))

(defun shape-distance-extrema (shape1 shape2)
  "Compute the minimum distance and closest points between two shapes.

  **Returns:** a `shape-extrema` object with readers:
  - (`extrema-distance` `shape-extrema`) -- minimum distance
  - (`extrema-point-on-shape1` `shape-extrema`) -- closest point on `shape1` as (`x` `y` `z`)
  - (`extrema-point-on-shape2` `shape-extrema`) -- closest point on `shape2` as (`x` `y` `z`)

  Returns `nil` on error.

  **Example:**

      (let ((r (shape-distance-extrema (make-box 10 10 10)
                                       (make-sphere 5))))
        (list (extrema-distance r)
              (extrema-point-on-shape1 r)
              (extrema-point-on-shape2 r)))

  **See also:** `shape-distance`"
  (unless (and (shape-p shape1) (shape-p shape2))
    (return-from shape-distance-extrema nil))
  (let ((p1 (%ptr shape1))
        (p2 (%ptr shape2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from shape-distance-extrema nil))
    (%shape-distance-extrema-internal p1 p2)))

(defun point-in-solid-p (point shape)
  "Test whether a point is inside, outside, or on a solid shape.

  **point** -- 3D point as (`x` `y` `z`)
  **shape** -- a solid shape

  **Returns:** `:inside`, `:outside`, `:on`, or `nil` if classification fails.

  **Example:**

      (let ((b (make-box 10 10 10)))
        (point-in-solid-p '(5 5 5) b))
      => :inside

  **See also:** `classify-point-in-solid`"
  (unless (and (shape-p shape) (listp point) (= (length point) 3))
    (return-from point-in-solid-p nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from point-in-solid-p nil))
    (cffi:with-foreign-object (state :int)
      (let ((ok (%classify-point-in-solid ptr
                  (coerce (first point) 'double-float)
                  (coerce (second point) 'double-float)
                  (coerce (third point) 'double-float)
                  state (cffi:null-pointer))))
        (when (zerop ok) (return-from point-in-solid-p nil))
        (ecase (cffi:mem-ref state :int)
          (0 :inside)
          (1 :outside)
          (2 :on)
          (3 nil))))))

(defun classify-point-in-solid (point shape)
  "Classify a 3D point relative to a solid, returning the face if on the surface.

  **point** -- 3D point as (`x` `y` `z`)
  **shape** -- a solid shape

  **Returns:** two values:
  - classification (`:inside`, `:outside`, `:on`, or `nil`)
  - face shape (when `:on`, otherwise `nil`)

  **Example:**

      (classify-point-in-solid '(5 5 5) (make-box 10 10 10))
      => :inside, `nil`

  **See also:** `point-in-solid-p`"
  (unless (and (shape-p shape) (listp point) (= (length point) 3))
    (return-from classify-point-in-solid (values nil nil)))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from classify-point-in-solid (values nil nil)))
    (cffi:with-foreign-objects ((state :int) (face :pointer))
      (let ((ok (%classify-point-in-solid ptr
                  (coerce (first point) 'double-float)
                  (coerce (second point) 'double-float)
                  (coerce (third point) 'double-float)
                  state face)))
        (when (zerop ok) (return-from classify-point-in-solid (values nil nil)))
        (let ((s (ecase (cffi:mem-ref state :int)
                   (0 :inside)
                   (1 :outside)
                   (2 :on)
                   (3 nil)))
              (face-ptr (cffi:mem-ref face :pointer)))
          (values s
                  (if (and (eq s :on) (not (cffi:null-pointer-p face-ptr)))
                      (make-shape face-ptr)
                      nil)))))))

(defun shape-valid-p (shape)
  "Check whether a shape is valid (no geometric errors).

  **shape** -- a shape object

  **Returns:** `t` if the shape is valid, `nil` if invalid or on error.

  **Example:**

      (shape-valid-p (make-box 10 20 30))
      => `t`

  **See also:** `shape-check`"
  (unless (shape-p shape)
    (return-from shape-valid-p nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-valid-p nil))
    (not (zerop (%shape-is-valid ptr)))))

(defun shape-check (shape)
  "Run the OCCT shape analysis validity checker on a shape.

  **shape** -- a shape object

  **Returns:** `nil` if the shape is valid, or a list of diagnostic strings
  describing issues found.

  **Example:**

      (shape-check (make-box 10 20 30))
      => `nil`

  **See also:** `shape-valid-p`"
  (unless (shape-p shape)
    (return-from shape-check nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-check nil))
    (let ((report (%shape-analysis-report ptr)))
      (when (or (null report) (string= report "Shape is valid."))
        (return-from shape-check nil))
      (list report))))

(defun intersect-curve-shape (curve shape)
  "Compute intersection points between a curve and a shape (faces of a solid).

  **curve** -- a curve object
  **shape** -- a shape object

  **Returns:** a list of intersection records, each containing:
  - (`point` `param-on-curve` `param-on-face` `face`)

    `point` is (`x` `y` `z`), the two params are curve and face parameters,
    and `face` is the intersected face shape (or `nil`).

  Returns `nil` if no intersections exist or on error.

  **Example:**

      (let ((b (make-box 10 20 30))
            (c (make-edge (make-line 0 0 -5 0 0 10))))
        (intersect-curve-shape c b))

  **See also:** `intersect-curves`, `intersect-curve-surface`"
  (unless (and (typep curve 'curve) (shape-p shape))
    (return-from intersect-curve-shape nil))
  (let ((curve-ptr (%ptr curve))
        (shape-ptr (%ptr shape)))
    (when (or (null curve-ptr) (cffi:null-pointer-p curve-ptr)
              (null shape-ptr) (cffi:null-pointer-p shape-ptr))
      (return-from intersect-curve-shape nil))
    (let* ((max-results 256)
           (points (cffi:foreign-alloc :double :count (* 3 max-results)))
           (params (cffi:foreign-alloc :double :count (* 2 max-results)))
           (faces (cffi:foreign-alloc :pointer :count max-results)))
      (unwind-protect
           (let ((count (%intersect-curve-shape
                          curve-ptr shape-ptr points params faces max-results)))
             (when (zerop count) (return-from intersect-curve-shape nil))
             (loop for i from 0 below count
                   collect (list
                            (list (cffi:mem-aref points :double (* i 3))
                                  (cffi:mem-aref points :double (1+ (* i 3)))
                                  (cffi:mem-aref points :double (+ 2 (* i 3))))
                            (cffi:mem-aref params :double (* i 2))
                            (cffi:mem-aref params :double (1+ (* i 2)))
                            (let ((face-ptr (cffi:mem-aref faces :pointer i)))
                              (unless (cffi:null-pointer-p face-ptr)
                                (make-shape face-ptr))))))
        (cffi:foreign-free points)
        (cffi:foreign-free params)
        (cffi:foreign-free faces)))))

;; --- Proximity zone class ---

(defclass proximity-zone ()
  ((%distance :initarg :distance :reader proximity-distance)
   (%subshape1 :initarg :subshape1 :reader proximity-subshape1)
   (%subshape2 :initarg :subshape2 :reader proximity-subshape2)))

(in-package :cl-occt.impl)

(defun %shape-proximity-internal (shape1-ptr shape2-ptr tolerance)
  (let ((max-results 256))
    (cffi:with-foreign-objects ((prox-value :double)
                                (subshapes1 :pointer max-results)
                                (subshapes2 :pointer max-results))
      (let ((count (%shape-proximity shape1-ptr shape2-ptr tolerance
                                     prox-value subshapes1 subshapes2 max-results)))
        (when (zerop count) (return-from %shape-proximity-internal nil))
        (loop for i from 0 below count
              collect (make-instance 'cl-occt:proximity-zone
                        :distance (cffi:mem-ref prox-value :double)
                        :subshape1 (let ((ptr (cffi:mem-aref subshapes1 :pointer i)))
                                     (when (and ptr (not (cffi:null-pointer-p ptr)))
                                       (make-shape ptr)))
                        :subshape2 (let ((ptr (cffi:mem-aref subshapes2 :pointer i)))
                                     (when (and ptr (not (cffi:null-pointer-p ptr)))
                                       (make-shape ptr)))))))))

(defun %shape-self-intersect-internal (shape-ptr tolerance)
  (let ((max-results 256))
    (cffi:with-foreign-object (faces :pointer max-results)
      (let ((count (%shape-self-intersect shape-ptr tolerance faces max-results)))
        (when (zerop count) (return-from %shape-self-intersect-internal nil))
        (loop for i from 0 below count
              collect (make-shape (cffi:mem-aref faces :pointer i)))))))

(in-package :cl-occt)

(defun shape-proximity (shape1 shape2 tolerance)
  "Compute proximity zones between two shapes within a tolerance.

  **shape1** **shape2** -- shape objects
  **tolerance** -- maximum distance for proximity detection

  **Returns:** a list of `proximity-zone` objects, each with readers:
  - (`proximity-distance` `proximity-zone`) -- proximity value
  - (`proximity-subshape1` `proximity-zone`) -- subshape from `shape1`
  - (`proximity-subshape2` `proximity-zone`) -- subshape from `shape2`

  Returns `nil` if no proximity zones found or on error.

  **Example:**

      (let ((a (make-box 10 10 10))
            (b (translate (make-box 10 10 10) 12 0 0)))
        (shape-proximity a b 5.0))

  **See also:** `shape-distance`, `shape-overlap-p`"
  (unless (and (shape-p shape1) (shape-p shape2))
    (return-from shape-proximity nil))
  (let ((p1 (%ptr shape1))
        (p2 (%ptr shape2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from shape-proximity nil))
    (%shape-proximity-internal p1 p2 tolerance)))

(defun shape-overlap-p (shape1 shape2 &optional (tolerance 0.0d0))
  "Test whether two shapes overlap (interfere).

  **shape1** **shape2** -- shape objects
  **tolerance** -- overlap threshold (default 0.0)

  **Returns:** `t` if shapes overlap, `nil` otherwise (or on error).

  **Example:**

      (let ((a (make-box 10 10 10))
            (b (translate (make-box 10 10 10) 5 0 0)))
        (shape-overlap-p a b))

  **See also:** `shape-overlap`"
  (unless (and (shape-p shape1) (shape-p shape2))
    (return-from shape-overlap-p nil))
  (let ((p1 (%ptr shape1))
        (p2 (%ptr shape2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from shape-overlap-p nil))
    (not (zerop (%shape-overlap-p p1 p2 tolerance)))))

(defun shape-overlap (shape1 shape2 &optional (tolerance 0.0d0))
  "Return detailed overlap information between two shapes.

  **shape1** **shape2** -- shape objects
  **tolerance** -- overlap threshold (default 0.0)

  **Returns:** a list of overlapping (subshape1 subshape2) pairs,
  where each subshape is a `shape` object. Returns `nil` if no overlap
  or on error.

  **Example:**

      (let ((a (make-box 10 10 10))
            (b (translate (make-box 10 10 10) 5 0 0)))
        (shape-overlap a b))

  **See also:** `shape-overlap-p`"
  (unless (and (shape-p shape1) (shape-p shape2))
    (return-from shape-overlap nil))
  (let ((p1 (%ptr shape1))
        (p2 (%ptr shape2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from shape-overlap nil))
    (let ((max-results 256))
      (cffi:with-foreign-objects ((out1 :pointer max-results)
                                  (out2 :pointer max-results))
        (let ((count (%shape-overlap-detail p1 p2 tolerance out1 out2 max-results)))
          (when (zerop count) (return-from shape-overlap nil))
          (loop for i from 0 below count
                collect (list
                         (let ((ptr (cffi:mem-aref out1 :pointer i)))
                           (when (and ptr (not (cffi:null-pointer-p ptr)))
                             (make-shape ptr)))
                         (let ((ptr (cffi:mem-aref out2 :pointer i)))
                           (when (and ptr (not (cffi:null-pointer-p ptr)))
                             (make-shape ptr))))))))))

(defun shape-self-intersect-p (shape &optional (tolerance 0.0d0))
  "Detect self-intersections within a single shape.

  **shape** -- a shape object
  **tolerance** -- self-intersection tolerance (default 0.0)

  **Returns:** a list of face shapes involved in self-intersections.
  Returns `nil` if no self-intersections or on error.

  **Example:**

      (shape-self-intersect-p (make-box 10 20 30))

  **See also:** `shape-valid-p`, `shape-check`"
  (unless (shape-p shape)
    (return-from shape-self-intersect-p nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-self-intersect-p nil))
    (%shape-self-intersect-internal ptr tolerance)))

(defun face-distance (face1 face2)
  "Compute the minimum and maximum distance between two faces.

  **face1** **face2** -- face shape objects

  **Returns:** two values: minimum distance and maximum distance
  as double-floats, or `nil` on error.

  **Example:**

      (let* ((box (make-box 10 20 30))
             (faces (map-shape-subshapes box :face)))
        (face-distance (first faces) (second faces)))

  **See also:** `shape-distance`"
  (unless (and (shape-p face1) (shape-p face2))
    (return-from face-distance nil))
  (let ((p1 (%ptr face1))
        (p2 (%ptr face2)))
    (when (or (null p1) (cffi:null-pointer-p p1)
              (null p2) (cffi:null-pointer-p p2))
      (return-from face-distance nil))
    (cffi:with-foreign-objects ((min-dist :double) (max-dist :double))
      (let ((ok (%face-distance p1 p2 min-dist max-dist)))
        (when (zerop ok) (return-from face-distance nil))
        (values (cffi:mem-ref min-dist :double)
                (cffi:mem-ref max-dist :double))))))

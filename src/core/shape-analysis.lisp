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

  SHAPE1 SHAPE2 -- shape objects

  Returns the minimum distance as a double-float, or NIL on error.

  Example:
    (let ((a (make-box 10 10 10))
          (b (translate (make-box 10 10 10) 20 0 0)))
      (shape-distance a b))
    => 10.0d0

  See also: shape-distance-extrema"
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

  Returns a SHAPE-EXTREMA object with readers:
    (extrema-distance SHAPE-EXTREMA)             -- minimum distance
    (extrema-point-on-shape1 SHAPE-EXTREMA)      -- closest point on SHAPE1 as (X Y Z)
    (extrema-point-on-shape2 SHAPE-EXTREMA)      -- closest point on SHAPE2 as (X Y Z)

  Returns NIL on error.

  Example:
    (let ((r (shape-distance-extrema (make-box 10 10 10)
                                     (make-sphere 5))))
      (list (extrema-distance r)
            (extrema-point-on-shape1 r)
            (extrema-point-on-shape2 r)))

  See also: shape-distance"
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

  POINT -- 3D point as (X Y Z)
  SHAPE -- a solid shape

  Returns :INSIDE, :OUTSIDE, :ON, or NIL if classification fails.

  Example:
    (let ((b (make-box 10 10 10)))
      (point-in-solid-p '(5 5 5) b))
    => :INSIDE

  See also: classify-point-in-solid"
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

  POINT -- 3D point as (X Y Z)
  SHAPE -- a solid shape

  Returns two values: the classification (:INSIDE :OUTSIDE :ON or NIL)
  and the face shape (when :ON, otherwise NIL).

  Example:
    (classify-point-in-solid '(5 5 5) (make-box 10 10 10))
    => :INSIDE, NIL

  See also: point-in-solid-p"
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

  SHAPE -- a shape object

  Returns T if the shape is valid, NIL if invalid or on error.

  Example:
    (shape-valid-p (make-box 10 20 30))
    => T

  See also: shape-check"
  (unless (shape-p shape)
    (return-from shape-valid-p nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-valid-p nil))
    (not (zerop (%shape-is-valid ptr)))))

(defun shape-check (shape)
  "Run the OCCT shape analysis validity checker on a shape.

  SHAPE -- a shape object

  Returns NIL if the shape is valid, or a list of diagnostic strings
  describing issues found.

  Example:
    (shape-check (make-box 10 20 30))
    => NIL

  See also: shape-valid-p"
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

  CURVE -- a curve object
  SHAPE -- a shape object

  Returns a list of intersection records, each containing:
    (POINT PARAM-ON-CURVE PARAM-ON-FACE FACE)

  POINT is (X Y Z), the two params are curve and face parameters,
  and FACE is the intersected face shape (or NIL).

  Returns NIL if no intersections exist or on error.

  Example:
    (let ((b (make-box 10 20 30))
          (c (make-edge (make-line 0 0 -5 0 0 10))))
      (intersect-curve-shape c b))

  See also: intersect-curves, intersect-curve-surface"
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

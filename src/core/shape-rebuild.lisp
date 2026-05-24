(in-package :cl-occt)

(defun substitute-shape (shape old-or-pairs &optional new)
  "Replace sub-shapes within a shape (single or batch).

  SHAPE -- the original shape
  OLD-OR-PAIRS -- a sub-shape to replace, or a list of (OLD NEW) pairs
  NEW -- new sub-shape (required when OLD-OR-PAIRS is a single shape)

  For single replacement: (substitute-shape orig old new)
  For batch replacement: (substitute-shape orig '((old1 new1) (old2 new2)))

  Returns a new shape with the specified sub-shapes replaced.

  Example:
    (let* ((b (make-box 10 20 30))
           (faces (shape-subshapes b :face))
           (new-face (make-plane)))
      (substitute-shape b (first faces) new-face))

  See also: shape-to-nurbs, shape-reduce-degree"
  (unless (shape-p shape)
    (return-from substitute-shape nil))
  (let ((shape-ptr (%ptr shape)))
    (when (or (null shape-ptr) (cffi:null-pointer-p shape-ptr))
      (return-from substitute-shape nil))
    (if new
        (let ((old-ptr (when (shape-p old-or-pairs) (%ptr old-or-pairs)))
              (new-ptr (when (shape-p new) (%ptr new))))
          (when (or (null old-ptr) (cffi:null-pointer-p old-ptr)
                    (null new-ptr) (cffi:null-pointer-p new-ptr))
            (return-from substitute-shape nil))
          (make-shape (%substitute-single shape-ptr old-ptr new-ptr)))
        (let ((pairs old-or-pairs))
          (unless (listp pairs)
            (return-from substitute-shape nil))
          (let* ((count (length pairs))
                 (old-vec (cffi:foreign-alloc :pointer :count count))
                 (new-vec (cffi:foreign-alloc :pointer :count count)))
            (unwind-protect
                 (progn
                   (loop for pair in pairs
                         for i from 0
                         do (let ((old-s (first pair))
                                  (new-s (second pair)))
                              (setf (cffi:mem-aref old-vec :pointer i)
                                    (if (shape-p old-s) (%ptr old-s) (cffi:null-pointer))
                                    (cffi:mem-aref new-vec :pointer i)
                                    (if (shape-p new-s) (%ptr new-s) (cffi:null-pointer)))))
                   (make-shape (%substitute-batch shape-ptr old-vec new-vec count)))
              (cffi:foreign-free old-vec)
              (cffi:foreign-free new-vec)))))))

(defun shape-to-nurbs (shape)
  "Convert a shape to NURBS (Non-Uniform Rational B-Spline) representation.

  All faces and curves in the shape are converted to NURBS form.

  Returns a new shape, or NIL on error.

  Example:
    (shape-to-nurbs (make-box 10 20 30))

  See also: shape-to-rational-bspline, shape-reduce-degree, shape-upgrade-continuity"
  (unless (shape-p shape)
    (return-from shape-to-nurbs nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-to-nurbs nil))
    (make-shape (%shape-to-nurbs ptr))))

(defun shape-reduce-degree (shape max-degree)
  "Reduce the polynomial degree of a shape's curves and surfaces.

  SHAPE -- a shape object
  MAX-DEGREE -- maximum allowed degree (integer, >= 1)

  Lowers the degree of NURBS curves and surfaces to at most MAX-DEGREE
  while preserving the geometry within tolerance.

  Returns a new shape with reduced degree, or NIL on error.

  Example:
    (let ((reduced (shape-reduce-degree (shape-to-nurbs (make-box 10 20 30)) 2)))
      reduced)

  See also: shape-to-nurbs, shape-upgrade-continuity"
  (unless (shape-p shape)
    (return-from shape-reduce-degree nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-reduce-degree nil))
    (make-shape (%shape-reduce-degree ptr max-degree))))

(defun shape-to-rational-bspline (shape)
  "Convert a shape to rational B-spline representation.

  All faces and curves are converted to rational B-spline form
  (NURBS with weights).

  Returns a new shape, or NIL on error.

  Example:
    (shape-to-rational-bspline (make-box 10 20 30))

  See also: shape-to-nurbs, shape-reduce-degree"
  (unless (shape-p shape)
    (return-from shape-to-rational-bspline nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-to-rational-bspline nil))
    (make-shape (%shape-to-rational-bspline ptr))))

(defun shape-split-u (shape num-splits)
  "Split a shape's faces along the U direction.

  SHAPE -- a shape object
  NUM-SPLITS -- number of times to split each face along U

  Each face is divided into NUM-SPLITS+1 smaller faces. Useful for
  refining the mesh or creating more detailed geometry.

  Returns a new shape, or NIL on error.

  Example:
    (shape-split-u (make-box 10 20 30) 2)

  See also: shape-upgrade-continuity"
  (unless (shape-p shape)
    (return-from shape-split-u nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-split-u nil))
    (make-shape (%shape-split-u ptr num-splits))))

(defun shape-upgrade-continuity (shape &key (continuity :c1))
  "Upgrade the continuity of a shape's curves and surfaces.

  SHAPE -- a shape object
  CONTINUITY -- desired continuity level, one of :C0, :C1, :C2, :C3 (default :C1)

  Raises the parametric continuity of edges and faces to the specified
  level. Higher continuity produces smoother junctions.

  Returns a new shape, or NIL on error.

  Example:
    (shape-upgrade-continuity (shape-to-nurbs (make-box 10 20 30)) :continuity :c2)

  See also: shape-reduce-degree, shape-split-u"
  (unless (shape-p shape)
    (return-from shape-upgrade-continuity nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-upgrade-continuity nil))
    (let ((cont (ecase continuity
                  (:c0 0) (:c1 1) (:c2 2) (:c3 3))))
      (make-shape (%shape-upgrade-continuity ptr cont)))))

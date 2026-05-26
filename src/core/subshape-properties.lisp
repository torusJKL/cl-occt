(in-package :cl-occt)

(defun face-area (face)
  "Return the area of a `face` as a double-float.
  **Returns:** double-float, or nil."
  (unless (shape-p face) (return-from face-area nil))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-area nil))
    (cffi:with-foreign-object (out :double)
      (when (zerop (%face-area ptr out))
        (return-from face-area nil))
      (cffi:mem-ref out :double))))

(defun edge-length (edge)
  "Return the 3D length of an `edge` as a double-float.
  **Returns:** double-float, or nil."
  (unless (shape-p edge) (return-from edge-length nil))
  (let ((ptr (%ptr edge)))
    (when (cffi:null-pointer-p ptr) (return-from edge-length nil))
    (cffi:with-foreign-object (out :double)
      (when (zerop (%edge-length ptr out))
        (return-from edge-length nil))
      (cffi:mem-ref out :double))))

(defun face-normal-at-center (face)
  "Return the outward unit normal at the center of a `face`.
  **Returns:** three values nx, ny, nz, or nil."
  (unless (shape-p face) (return-from face-normal-at-center (values nil nil nil)))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-normal-at-center (values nil nil nil)))
    (cffi:with-foreign-objects ((nx :double) (ny :double) (nz :double))
      (when (zerop (%face-normal-at-center ptr nx ny nz))
        (return-from face-normal-at-center (values nil nil nil)))
      (values (cffi:mem-ref nx :double)
              (cffi:mem-ref ny :double)
              (cffi:mem-ref nz :double)))))

(defun face-surface-type (face)
  "Return the surface type keyword of a `face`.
  **Returns:** `:plane`, `:cylinder`, `:cone`, `:sphere`, `:torus`, or nil."
  (unless (shape-p face) (return-from face-surface-type nil))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-surface-type nil))
    (let ((int-val (%face-surface-type ptr)))
      (when (minusp int-val) (return-from face-surface-type nil))
      (cl-occt.impl::%geomabs-surface-type->keyword int-val))))

(defun edge-curve-type (edge)
  "Return the curve type keyword of an `edge`.
  **Returns:** `:line`, `:circle`, `:ellipse`, `:hyperbola`, `:parabola`, or nil."
  (unless (shape-p edge) (return-from edge-curve-type nil))
  (let ((ptr (%ptr edge)))
    (when (cffi:null-pointer-p ptr) (return-from edge-curve-type nil))
    (let ((int-val (%edge-curve-type ptr)))
      (when (minusp int-val) (return-from edge-curve-type nil))
      (cl-occt.impl::%geomabs-curve-type->keyword int-val))))

(defun %bounding-box-values (shape)
  (cffi:with-foreign-objects ((xmin :double) (ymin :double) (zmin :double)
                               (xmax :double) (ymax :double) (zmax :double))
    (when (zerop (%subshape-bounding-box shape xmin ymin zmin xmax ymax zmax))
      (return-from %bounding-box-values (values nil nil nil nil nil nil)))
    (values (cffi:mem-ref xmin :double)
            (cffi:mem-ref ymin :double)
            (cffi:mem-ref zmin :double)
            (cffi:mem-ref xmax :double)
            (cffi:mem-ref ymax :double)
            (cffi:mem-ref zmax :double))))

(defun face-bounding-box (face)
  "Return the bounding box of a `face`.
  **Returns:** six values xmin, ymin, zmin, xmax, ymax, zmax."
  (unless (shape-p face) (return-from face-bounding-box (values nil nil nil nil nil nil)))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-bounding-box (values nil nil nil nil nil nil)))
    (%bounding-box-values ptr)))

(defun edge-bounding-box (edge)
  "Return the bounding box of an `edge`.
  **Returns:** six values xmin, ymin, zmin, xmax, ymax, zmax."
  (unless (shape-p edge) (return-from edge-bounding-box (values nil nil nil nil nil nil)))
  (let ((ptr (%ptr edge)))
    (when (cffi:null-pointer-p ptr) (return-from edge-bounding-box (values nil nil nil nil nil nil)))
    (%bounding-box-values ptr)))

(defun subshape-bounding-box (shape)
  "Return the bounding box of any subshape.
  **Returns:** six values xmin, ymin, zmin, xmax, ymax, zmax."
  (unless (shape-p shape) (return-from subshape-bounding-box (values nil nil nil nil nil nil)))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr) (return-from subshape-bounding-box (values nil nil nil nil nil nil)))
    (%bounding-box-values ptr)))

(defun face-center (face)
  "Return the center (UV midpoint) of a `face` as a 3D point.
  **Returns:** three values x, y, z."
  (unless (shape-p face) (return-from face-center (values nil nil nil)))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr) (return-from face-center (values nil nil nil)))
    (cffi:with-foreign-objects ((x :double) (y :double) (z :double))
      (when (zerop (%face-center ptr x y z))
        (return-from face-center (values nil nil nil)))
      (values (cffi:mem-ref x :double)
              (cffi:mem-ref y :double)
              (cffi:mem-ref z :double)))))

(defun shape-extent-along (shape dx dy dz)
  "Return the extent (projection) of a `shape` along direction (dx dy dz).
  **Returns:** two values min-projection, max-projection."
  (unless (shape-p shape) (return-from shape-extent-along (values nil nil)))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr) (return-from shape-extent-along (values nil nil)))
    (cffi:with-foreign-objects ((min :double) (max :double))
      (when (zerop (%shape-extent-along ptr
                      (coerce dx 'double-float)
                      (coerce dy 'double-float)
                      (coerce dz 'double-float)
                      min max))
        (return-from shape-extent-along (values nil nil)))
      (values (cffi:mem-ref min :double)
              (cffi:mem-ref max :double)))))



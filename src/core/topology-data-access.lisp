(in-package :cl-occt.impl)

;; ---------------------------------------------------------------------------
;; Internal: topology-data-access (low-level BRep_Tool queries)
;; Used by the public API in cl-occt package.
;; ---------------------------------------------------------------------------

;; (already internal helpers exist in topology.lisp for orientation/type mapping)

(in-package :cl-occt)

(defun vertex-point (vertex)
  "Return the 3D coordinates of a `vertex`.
  **Returns:** three values x, y, z, or nil."
  (unless (shape-p vertex)
    (return-from vertex-point (values nil nil nil)))
  (let ((ptr (%ptr vertex)))
    (when (cffi:null-pointer-p ptr)
      (return-from vertex-point (values nil nil nil)))
    (cffi:with-foreign-objects ((x :double) (y :double) (z :double))
      (when (zerop (%vertex-point ptr x y z))
        (return-from vertex-point (values nil nil nil)))
      (values (cffi:mem-ref x :double)
              (cffi:mem-ref y :double)
              (cffi:mem-ref z :double)))))

(defun edge-curve-range (edge)
  "Return the geometric curve and parameter range of an `edge`.
  **Returns:** three values: curve, first, last. Returns nil on null edge."
  (unless (shape-p edge)
    (return-from edge-curve-range (values nil nil nil)))
  (let ((ptr (%ptr edge)))
    (when (cffi:null-pointer-p ptr)
      (return-from edge-curve-range (values nil nil nil)))
    (cffi:with-foreign-objects ((first :double) (last :double))
      (let ((curve-ptr (%edge-get-curve ptr first last)))
        (if (and curve-ptr (not (cffi:null-pointer-p curve-ptr)))
            (values (make-curve curve-ptr)
                    (cffi:mem-ref first :double)
                    (cffi:mem-ref last :double))
            (values nil nil nil))))))

(defun edge-curve (edge)
  "Return only the geometric curve of an `edge` (convenience).
  **Returns:** a curve object, or nil."
  (nth-value 0 (edge-curve-range edge)))

(defun face-surface-uv-bounds (face)
  "Return the geometric surface and UV bounds of a `face`.
  **Returns:** five values: surface, u-min, u-max, v-min, v-max. Returns nil on null face."
  (unless (shape-p face)
    (return-from face-surface-uv-bounds (values nil nil nil nil nil)))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr)
      (return-from face-surface-uv-bounds (values nil nil nil nil nil)))
    (cffi:with-foreign-objects ((umin :double) (umax :double)
                                 (vmin :double) (vmax :double))
      (let ((surface-ptr (%face-get-surface ptr umin umax vmin vmax)))
        (if (and surface-ptr (not (cffi:null-pointer-p surface-ptr)))
            (values (make-surface surface-ptr)
                    (cffi:mem-ref umin :double)
                    (cffi:mem-ref umax :double)
                    (cffi:mem-ref vmin :double)
                    (cffi:mem-ref vmax :double))
            (values nil nil nil nil nil))))))

(defun face-surface (face)
  "Return only the geometric surface of a `face` (convenience).
  **Returns:** a surface object, or nil."
  (nth-value 0 (face-surface-uv-bounds face)))

(defun shape-tolerance (shape)
  "Return the tolerance of a shape (edge or face).
  **Returns:** a double-float, or nil."
  (unless (shape-p shape)
    (return-from shape-tolerance nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr)
      (return-from shape-tolerance nil))
    (cffi:with-foreign-object (tol :double)
      (when (zerop (%shape-tolerance ptr tol))
        (return-from shape-tolerance nil))
      (cffi:mem-ref tol :double))))

(defun face-natural-restriction-p (face)
  "Return whether a `face` has natural restriction (i.e., its UV bounds match the full surface parameterization).
  **Returns:** t or nil."
  (unless (shape-p face)
    (return-from face-natural-restriction-p nil))
  (let ((ptr (%ptr face)))
    (when (cffi:null-pointer-p ptr)
      (return-from face-natural-restriction-p nil))
    (not (zerop (%face-natural-restriction ptr)))))

(defun reverse-orientation (shape)
  "Return a new shape with reversed orientation.
  **Returns:** a shape object, or nil."
  (unless (shape-p shape)
    (return-from reverse-orientation nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr)
      (return-from reverse-orientation nil))
    (let ((result (%shape-reversed ptr)))
      (if (and result (not (cffi:null-pointer-p result)))
          (make-shape result)
          nil))))

(defun shape-orientation (shape)
  "Return the orientation keyword of a shape.
  **Returns:** `:forward`, `:reversed`, `:internal`, `:external`, or nil."
  (unless (shape-p shape)
    (return-from shape-orientation nil))
  (let ((ptr (%ptr shape)))
    (when (cffi:null-pointer-p ptr)
      (return-from shape-orientation nil))
    (let ((int-val (%shape-orientation-int ptr)))
      (when (minusp int-val)
        (return-from shape-orientation nil))
      (cl-occt.impl::%int-to-orientation int-val))))

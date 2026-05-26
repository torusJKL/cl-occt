(in-package :cl-occt.impl)

(defun %curve-tangent-at-internal (curve-ptr param)
  (cffi:with-foreign-objects ((tx :double) (ty :double) (tz :double))
    (let ((ok (%curve-tangent-at curve-ptr param tx ty tz)))
      (when (zerop ok) (return-from %curve-tangent-at-internal nil))
      (values (cffi:mem-ref tx :double)
              (cffi:mem-ref ty :double)
              (cffi:mem-ref tz :double)))))

(defun %curve-curvature-at-internal (curve-ptr param)
  (cffi:with-foreign-object (k :double)
    (let ((ok (%curve-curvature-at curve-ptr param k)))
      (when (zerop ok) (return-from %curve-curvature-at-internal nil))
      (cffi:mem-ref k :double))))

(defun %surface-normal-at-internal (surface-ptr u v)
  (cffi:with-foreign-objects ((nx :double) (ny :double) (nz :double))
    (let ((ok (%surface-normal-at surface-ptr u v nx ny nz)))
      (when (zerop ok) (return-from %surface-normal-at-internal nil))
      (values (cffi:mem-ref nx :double)
              (cffi:mem-ref ny :double)
              (cffi:mem-ref nz :double)))))

(defun %surface-curvature-at-internal (surface-ptr u v)
  (cffi:with-foreign-objects ((min-k :double) (max-k :double))
    (let ((ok (%surface-curvature-at surface-ptr u v min-k max-k)))
      (when (zerop ok) (return-from %surface-curvature-at-internal nil))
      (values (cffi:mem-ref min-k :double)
              (cffi:mem-ref max-k :double)))))

(in-package :cl-occt)

(defun curve-tangent-at (curve param)
  "Compute the unit tangent vector of a curve at a given parameter.

  **curve** -- a curve object
  **param** -- parameter value on the curve

  **Returns:** three values (`tx` `ty` `tz`) representing the
  unit tangent vector, or `nil` if the tangent is not defined.

  **Example:**

      (let ((c (make-line-3d 0 0 0 1 0 0)))
        (curve-tangent-at c 0.0))

  **See also:** `curve-curvature-at`"
  (unless (typep curve 'curve)
    (return-from curve-tangent-at nil))
  (let ((ptr (%ptr curve)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from curve-tangent-at nil))
    (%curve-tangent-at-internal ptr param)))

(defun curve-curvature-at (curve param)
  "Compute the curvature of a curve at a given parameter.

  **curve** -- a curve object
  **param** -- parameter value on the curve

  **Returns:** the curvature as a `double-float`, or `nil` if
  curvature is not defined.

  **Example:**

      (let ((c (make-circle-3d 0 0 0 5)))
        (curve-curvature-at c 0.0))

  **See also:** `curve-tangent-at`"
  (unless (typep curve 'curve)
    (return-from curve-curvature-at nil))
  (let ((ptr (%ptr curve)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from curve-curvature-at nil))
    (%curve-curvature-at-internal ptr param)))

(defun surface-normal-at (surface u v)
  "Compute the unit normal vector of a surface at given UV parameters.

  **surface** -- a surface object
  **u** **v** -- UV parameter values on the surface

  **Returns:** three values (`nx` `ny` `nz`) representing the
  unit normal vector, or `nil` if the normal is not defined.

  **Example:**

      (let ((s (make-plane 0 0 0 0 0 1)))
        (surface-normal-at s 0.0 0.0))

  **See also:** `surface-curvature-at`, `face-normal-at`"
  (unless (typep surface 'surface)
    (return-from surface-normal-at nil))
  (let ((ptr (%ptr surface)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from surface-normal-at nil))
    (%surface-normal-at-internal ptr u v)))

(defun surface-curvature-at (surface u v)
  "Compute the minimum and maximum curvature of a surface at given UV.

  **surface** -- a surface object
  **u** **v** -- UV parameter values on the surface

  **Returns:** two values (`min-curvature` `max-curvature`) as
  double-floats, or `nil` if curvature is not defined.

  **Example:**

      (let ((s (make-spherical-surface 0 0 0 5)))
        (surface-curvature-at s 0.0 0.0))

  **See also:** `surface-normal-at`, `face-curvature-at`"
  (unless (typep surface 'surface)
    (return-from surface-curvature-at nil))
  (let ((ptr (%ptr surface)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from surface-curvature-at nil))
    (%surface-curvature-at-internal ptr u v)))

(defun face-normal-at (face u v)
  "Compute the unit normal vector of a face at given UV parameters.

  **face** -- a face shape object
  **u** **v** -- UV parameter values on the face's surface

  **Returns:** three values (`nx` `ny` `nz`) representing the
  unit normal vector, or `nil` if the normal is not defined.

  **Example:**

      (let* ((box (make-box 10 20 30))
             (faces (map-shape-subshapes box :face)))
        (face-normal-at (first faces) 0.5 0.5))

  **See also:** `surface-normal-at`, `face-curvature-at`"
  (unless (shape-p face)
    (return-from face-normal-at nil))
  (let ((ptr (%ptr face)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from face-normal-at nil))
    (let ((surface-ptr (%face-to-surface ptr)))
      (when (or (null surface-ptr) (cffi:null-pointer-p surface-ptr))
        (return-from face-normal-at nil))
      (%surface-normal-at-internal surface-ptr u v))))

(defun face-curvature-at (face u v)
  "Compute the minimum and maximum curvature of a face at given UV.

  **face** -- a face shape object
  **u** **v** -- UV parameter values on the face's surface

  **Returns:** two values (`min-curvature` `max-curvature`) as
  double-floats, or `nil` if curvature is not defined.

  **Example:**

      (let* ((box (make-box 10 20 30))
             (faces (map-shape-subshapes box :face)))
        (face-curvature-at (first faces) 0.5 0.5))

  **See also:** `surface-curvature-at`, `face-normal-at`"
  (unless (shape-p face)
    (return-from face-curvature-at nil))
  (let ((ptr (%ptr face)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from face-curvature-at nil))
    (let ((surface-ptr (%face-to-surface ptr)))
      (when (or (null surface-ptr) (cffi:null-pointer-p surface-ptr))
        (return-from face-curvature-at nil))
      (%surface-curvature-at-internal surface-ptr u v))))

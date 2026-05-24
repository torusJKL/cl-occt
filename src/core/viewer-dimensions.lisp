(in-package :cl-occt)

(defun make-dimension (type &key from to vertex point1 point2 shape edge edge1 edge2)
  "Creates a dimension AIS object of the given **type**.

  **type** is `:length`, `:angle`, `:diameter`, or `:radius`.
  For `:length` provide **from**/**to** or **edge**.
  For `:angle` provide **vertex**/**point1**/**point2** or **edge1**/**edge2**.
  For `:diameter` or `:radius` provide **shape**.

  Returns the dimension object on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
        (ais-display ctx dim))"
  (flet ((co (v) (coerce v 'double-float)))
    (let ((ptr (ecase type
                 (:length
                  (cond
                    ((and from to)
                     (destructuring-bind (x1 y1 z1) from
                       (destructuring-bind (x2 y2 z2) to
                         (%prsdim-make-length-2p (co x1) (co y1) (co z1)
                                                 (co x2) (co y2) (co z2)))))
                    (edge
                     (%prsdim-make-length-2p 0.0d0 0.0d0 0.0d0
                                              1.0d0 0.0d0 0.0d0))))
                 (:angle
                  (cond
                    ((and vertex point1 point2)
                     (destructuring-bind (vx vy vz) vertex
                       (destructuring-bind (p1x p1y p1z) point1
                         (destructuring-bind (p2x p2y p2z) point2
                           (%prsdim-make-angle-3p (co vx) (co vy) (co vz)
                                                  (co p1x) (co p1y) (co p1z)
                                                  (co p2x) (co p2y) (co p2z))))))
                    ((and edge1 edge2)
                     (%prsdim-make-angle-3p 0.0d0 0.0d0 0.0d0
                                             1.0d0 0.0d0 0.0d0
                                             0.0d0 1.0d0 0.0d0))))
                 (:diameter
                  (when (shape-p shape)
                    (%prsdim-make-diameter (%ptr shape))))
                 (:radius
                  (when (shape-p shape)
                    (%prsdim-make-radius (%ptr shape)))))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (when (and (eq type :length) edge (shape-p edge))
            (set-dimension-measured-edge obj edge))
          (when (and (eq type :angle) edge1 edge2 (shape-p edge1) (shape-p edge2))
            (set-dimension-angle-edges obj edge1 edge2))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun set-dimension-text-position (dim position)
  "Sets the text label position for dimension **dim** to (X Y Z).

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
        (ais-display ctx dim)
        (set-dimension-text-position dim '(5 5 0)))"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (x y z) position
          (%prsdim-set-text-position ptr
            (coerce x 'double-float)
            (coerce y 'double-float)
            (coerce z 'double-float)))
        dim))))

(defun set-dimension-units (dim units)
  "Sets the display units string for dimension **dim** (e.g. `\"mm\"`).

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-units dim \"mm\")"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-display-units ptr units)
        dim))))

(defun set-dimension-flyout (dim v)
  "Sets the flyout (extension line offset) for dimension **dim**.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-flyout dim 5.0)"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-flyout ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-arrow-length (dim v)
  "Sets the arrow length for dimension **dim**.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-arrow-length dim 3.0)"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-arrow-length ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-custom-value (dim value)
  "Sets a custom text value for dimension **dim** (overrides measured value).

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-custom-value dim \"Custom\")"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-custom-value ptr (if (stringp value) value (princ-to-string value)))
        dim))))

(defun set-dimension-angle-edges (dim edge1 edge2)
  "Sets the two edges measured by an angle dimension **dim**.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (make-box 10 20 30))
             (edge1 ( ... ))
             (edge2 ( ... ))
             (dim (make-dimension :angle :edge1 edge1 :edge2 edge2)))
        (ais-display ctx dim))"
  (when (and (ais-object-p dim) (shape-p edge1) (shape-p edge2))
    (let ((ptr (%ptr dim))
          (e1-ptr (%ptr edge1))
          (e2-ptr (%ptr edge2)))
      (when (and ptr e1-ptr e2-ptr
                 (not (cffi:null-pointer-p ptr))
                 (not (cffi:null-pointer-p e1-ptr))
                 (not (cffi:null-pointer-p e2-ptr)))
        (%prsdim-set-angle-edges ptr e1-ptr e2-ptr)
        dim))))

(defun set-dimension-extension-size (dim v)
  "Sets the extension line length beyond the dimension line for **dim**.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-extension-size dim 2.0)"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-extension-size ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-measured-edge (dim edge &key (plane-origin '(0 0 0)) (plane-normal '(0 0 1)))
  "Sets the edge measured by a length dimension **dim** with projection plane.

  **plane-origin** and **plane-normal** define the projection plane for the dimension.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (let ((dim (make-dimension :length :edge some-edge)))
        (set-dimension-measured-edge dim some-edge
          :plane-origin '(0 0 0) :plane-normal '(0 0 1))
        (ais-display ctx dim))"
  (when (and (ais-object-p dim) (shape-p edge))
    (let ((ptr (%ptr dim))
          (shape-ptr (%ptr edge)))
      (when (and ptr shape-ptr (not (cffi:null-pointer-p ptr))
                 (not (cffi:null-pointer-p shape-ptr)))
        (destructuring-bind (px py pz) plane-origin
          (destructuring-bind (nx ny nz) plane-normal
            (%prsdim-set-measured-edge ptr shape-ptr
              (coerce px 'double-float) (coerce py 'double-float) (coerce pz 'double-float)
              (coerce nx 'double-float) (coerce ny 'double-float) (coerce nz 'double-float))))
        dim))))

(defun set-dimension-text (dim value)
  "Alias for `set-dimension-custom-value`.

  Sets custom text for dimension **dim**.

  **Example:**

      (set-dimension-text dim \"Custom\")"
  (set-dimension-custom-value dim value))

(defun set-dimension-arrows (dim &key style size)
  "Configures arrow appearance for dimension **dim**.

  **style** is `:filled`, `:open`, or `:none`. **size** is the arrow length.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-arrows dim :style :filled :size 3.0)"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (when size
          (%prsdim-set-arrow-length ptr (coerce size 'double-float)))
        (when style
          (set-dimension-arrow-length dim
            (ecase style
              (:filled 3.0)
              (:open 2.0)
              (:none 0.0))))
        dim))))

(defun set-dimension-extension (dim &key offset length)
  "Configures extension line appearance for dimension **dim**.

  **offset** controls the gap from the measured point.
  **length** controls how far the extension line extends past the dimension line.

  Returns **dim** on success, `nil` otherwise.

  **Example:**

      (set-dimension-extension dim :offset 2.0 :length 5.0)"
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (when length
          (%prsdim-set-extension-size ptr (coerce length 'double-float)))
        (when offset
          (set-dimension-flyout dim offset))
        dim))))

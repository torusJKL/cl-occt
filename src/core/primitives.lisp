(in-package :cl-occt.impl)

(defun make-shape (ptr)
  "Wrap a raw TopoDS_Shape C pointer in a `shape` CLOS instance with finalization.

  Returns a `shape` object, or nil if **ptr** is null."
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((s (make-instance 'cl-occt:shape :ptr ptr)))
        (tg:finalize s (lambda () (%free-shape ptr)))
        s)))

(in-package :cl-occt)

(defun make-box (dx dy dz)
  "Create a box (rectangular parallelepiped) with the given dimensions.

  - **dx** width along X axis (positive double-float)
  - **dy** depth along Y axis (positive double-float)
  - **dz** height along Z axis (positive double-float)

  **Example:**

      (make-box 10 20 30)"
  (make-shape (%make-box (coerce dx 'double-float)
                         (coerce dy 'double-float)
                         (coerce dz 'double-float))))

(defun make-cylinder (radius height)
  "Create a cylinder with the given `radius` and `height`.

  The cylinder is centered on the Z axis, extending from z=0 to z=`height`.

  **Example:**

      (make-cylinder 5 20)"
  (make-shape (%make-cylinder (coerce radius 'double-float)
                              (coerce height 'double-float))))

(defun make-sphere (radius)
  "Create a sphere centered at the origin with the given `radius`.

  **Example:**

      (make-sphere 10)"
  (make-shape (%make-sphere (coerce radius 'double-float))))

(defun make-cone (r1 r2 height)
  "Create a cone (or frustum) with bottom radius R1 and top radius R2.

  - **r1** radius at z=0 (positive double-float)
  - **r2** radius at z=`height` (positive double-float, zero for a pointed cone)
  - **height** height along the Z axis

  **Example:**

      (make-cone 10 5 30)"
  (make-shape (%make-cone (coerce r1 'double-float)
                          (coerce r2 'double-float)
                          (coerce height 'double-float))))

(defun make-torus (major-radius minor-radius)
  "Create a torus (donut shape) with the given radii.

  - **major-radius** distance from center to tube center (positive double-float)
  - **minor-radius** radius of the tube (positive double-float)

  **Example:**

      (make-torus 20 5)"
  (make-shape (%make-torus (coerce major-radius 'double-float)
                           (coerce minor-radius 'double-float))))

(defun make-prism (shape dx dy dz)
  "Extrude (prism) a `shape` by the given vector (dx dy dz).

  - **shape** a shape object to extrude
  - **dx** translation magnitude along X
  - **dy** translation magnitude along Y
  - **dz** translation magnitude along Z

  **Example:**

      (let ((face (make-face (make-wire (make-circle-edge 0 0 5)))))
        (make-prism face 0 0 20))"
  (if (null shape)
      nil
      (make-shape (%make-prism (%ptr shape)
                               (coerce dx 'double-float)
                               (coerce dy 'double-float)
                               (coerce dz 'double-float)))))

(defun make-revol (shape ax ay az angle-deg)
  "Revolve (rotate extrude) a `shape` around the axis (ax ay az) by `angle-deg`.

  - **shape** a shape object to revolve
  - **ax** X component of the axis vector
  - **ay** Y component of the axis vector
  - **az** Z component of the axis vector
  - **angle-deg** angle of revolution in degrees

  **Example:**

      (let ((profile (make-face (make-wire (make-edge 10 0 30 0)
                                           (make-edge 30 0 30 5)
                                           (make-edge 30 5 10 5)
                                           (make-edge 10 5 10 0)))))
        (make-revol profile 0 1 0 270))"
  (if (null shape)
      nil
      (make-shape (%make-revol (%ptr shape)
                               (coerce ax 'double-float)
                               (coerce ay 'double-float)
                               (coerce az 'double-float)
                               (coerce angle-deg 'double-float)))))

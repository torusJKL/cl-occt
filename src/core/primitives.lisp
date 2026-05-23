(in-package :cl-occt.impl)

(defun make-shape (ptr)
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((s (make-instance 'cl-occt:shape :ptr ptr)))
        (tg:finalize s (lambda () (%free-shape ptr)))
        s)))

(in-package :cl-occt)

(defun make-box (dx dy dz)
  "Create a box (rectangular parallelepiped) with the given dimensions.

  DX -- width along X axis (positive double-float)
  DY -- depth along Y axis (positive double-float)
  DZ -- height along Z axis (positive double-float)

  Example:
    (make-box 10 20 30)"
  (make-shape (%make-box (coerce dx 'double-float)
                         (coerce dy 'double-float)
                         (coerce dz 'double-float))))

(defun make-cylinder (radius height)
  "Create a cylinder with the given RADIUS and HEIGHT.

  The cylinder is centered on the Z axis, extending from z=0 to z=HEIGHT.

  Example:
    (make-cylinder 5 20)"
  (make-shape (%make-cylinder (coerce radius 'double-float)
                              (coerce height 'double-float))))

(defun make-sphere (radius)
  "Create a sphere centered at the origin with the given RADIUS.

  Example:
    (make-sphere 10)"
  (make-shape (%make-sphere (coerce radius 'double-float))))

(defun make-cone (r1 r2 height)
  "Create a cone (or frustum) with bottom radius R1 and top radius R2.

  R1   -- radius at z=0 (positive double-float)
  R2   -- radius at z=HEIGHT (positive double-float, zero for a pointed cone)
  HEIGHT -- height along the Z axis

  Example:
    (make-cone 10 5 30)"
  (make-shape (%make-cone (coerce r1 'double-float)
                          (coerce r2 'double-float)
                          (coerce height 'double-float))))

(defun make-torus (major-radius minor-radius)
  "Create a torus (donut shape) with the given radii.

  MAJOR-RADIUS -- distance from center to tube center (positive double-float)
  MINOR-RADIUS -- radius of the tube (positive double-float)

  Example:
    (make-torus 20 5)"
  (make-shape (%make-torus (coerce major-radius 'double-float)
                           (coerce minor-radius 'double-float))))

(defun make-prism (shape dx dy dz)
  "Extrude (prism) a SHAPE by the given vector (DX DY DZ).

  SHAPE -- a shape object to extrude
  DX    -- translation magnitude along X
  DY    -- translation magnitude along Y
  DZ    -- translation magnitude along Z

  Example:
    (let ((face (make-face (make-wire (make-circle-edge 0 0 5)))))
      (make-prism face 0 0 20))"
  (if (null shape)
      nil
      (make-shape (%make-prism (%ptr shape)
                               (coerce dx 'double-float)
                               (coerce dy 'double-float)
                               (coerce dz 'double-float)))))

(defun make-revol (shape ax ay az angle-deg)
  "Revolve (rotate extrude) a SHAPE around the axis (AX AY AZ) by ANGLE-DEG.

  SHAPE     -- a shape object to revolve
  AX AY AZ  -- components of the axis vector
  ANGLE-DEG -- angle of revolution in degrees

  Example:
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

(in-package :cl-occt)

(defun make-cylindrical-hole (shape face radius depth &key through)
  "Create a cylindrical hole in SHAPE on a given FACE.

  RADIUS and DEPTH define the hole geometry.  When :THROUGH is T,
  the hole passes completely through the shape.  Returns a new shape,
  or NIL if SHAPE or FACE is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (faces (map-shape-subshapes box :face)))
      (when faces
        (make-cylindrical-hole box (first faces) 5 0 :through t)))

  See also: make-prism-feature, make-revol-feature, make-groove"
  (if (or (null shape) (null face))
      nil
      (make-shape (%make-cylindrical-hole (%ptr shape) (%ptr face)
                                           (coerce radius 'double-float)
                                           (coerce depth 'double-float)
                                           (if through 1 0)))))

(defun make-prism-feature (shape base-face profile height
                           &key (operation :cut) (direction nil))
  "Create a prismatic feature (depression or protrusion) on a shape.

  OPERATION is :CUT (default, depression) or :ADD (protrusion).
  DIRECTION is an optional 3-element vector (default (0 0 1)).
  Returns a new shape, or NIL if SHAPE, BASE-FACE, or PROFILE is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (faces (map-shape-subshapes box :face))
           (profile (make-wire (make-edge -5 -5 5 -5)
                               (make-edge 5 -5 5 5)
                               (make-edge 5 5 -5 5)
                               (make-edge -5 5 -5 -5))))
      (when faces
        (make-prism-feature box (first faces) profile 10 :operation :cut)))

  See also: make-revol-feature, make-pipe-feature"
  (if (or (null shape) (null base-face) (null profile))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1))
            (dir (or direction '(0 0 1))))
        (make-shape (%make-prism-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (coerce height 'double-float)
                      (coerce (first dir) 'double-float)
                      (coerce (second dir) 'double-float)
                      (coerce (third dir) 'double-float)
                      op-flag)))))

(defun make-revol-feature (shape base-face profile axis angle
                           &key (operation :cut))
  "Create a revolved feature (depression or protrusion) on a shape.

  AXIS is a 3-element vector (dx dy dz).  ANGLE is in degrees.
  OPERATION is :CUT (default, depression) or :ADD (protrusion).
  Returns a new shape, or NIL if any required argument is null.

  Example:
    (let* ((box (make-box 30 20 10))
           (faces (map-shape-subshapes box :face))
           (profile (make-wire (make-edge -5 0 5 0)
                               (make-edge 5 0 5 5)
                               (make-edge 5 5 -5 5)
                               (make-edge -5 5 -5 0))))
      (when faces
        (make-revol-feature box (first faces) profile
                            '(0 0 1) 90 :operation :cut)))

  See also: make-prism-feature, make-pipe-feature"
  (if (or (null shape) (null base-face) (null profile) (null axis))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1)))
        (make-shape (%make-revol-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (coerce (first axis) 'double-float)
                      (coerce (second axis) 'double-float)
                      (coerce (third axis) 'double-float)
                      (coerce angle 'double-float)
                      op-flag)))))

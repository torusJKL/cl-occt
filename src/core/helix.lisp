(in-package :cl-occt)

(defun make-helix-curve (&key radius pitch height (left-handed nil) (angle 0.0))
  "Create a helical curve (3D geometric curve, not an edge).

  **Returns:** a curve object suitable for use as a spine in sweeps,
  or `nil` if `radius` is zero.

  **Example:**

      (make-helix-curve :radius 5 :pitch 2 :height 20)
      (make-helix-curve :radius 5 :pitch 2 :height 20 :left-handed t)

  **See also:** `make-helix-edge`"
  (make-curve (%make-helix-curve (coerce radius 'double-float)
                                  (coerce pitch 'double-float)
                                  (coerce height 'double-float)
                                  (if left-handed 1 0)
                                  (coerce angle 'double-float))))

(defun make-helix-edge (&key radius pitch height (left-handed nil) (angle 0.0) (on-surface (cffi:null-pointer)))
  "Create a helical edge shape.

  When `on-surface` is a surface object, the helix is mapped onto
  that surface.  **Returns:** an edge shape, or `nil` if `radius` is zero.

  **Example:**

      (make-helix-edge :radius 5 :pitch 2 :height 20)
      (make-helix-edge :radius 5 :pitch 2 :height 20 :left-handed t)

  **See also:** `make-helix-curve`"
  (let ((surface-ptr (if (typep on-surface 'surface)
                         (%ptr on-surface)
                         (cffi:null-pointer))))
    (make-shape (%make-helix-edge (coerce radius 'double-float)
                                  (coerce pitch 'double-float)
                                  (coerce height 'double-float)
                                  (if left-handed 1 0)
                                  (coerce angle 'double-float)
                                  surface-ptr))))

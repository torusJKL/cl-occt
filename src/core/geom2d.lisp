(in-package :cl-occt)

(defclass geom2d ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun geom2d-p (obj)
  "**Returns:** `t` if `obj` is a 2D geometry object, `nil` otherwise."
  (typep obj 'geom2d))

(in-package :cl-occt.impl)

(defun make-geom2d (ptr)
  (if (or (null ptr) (cffi:null-pointer-p ptr))
      nil
      (let ((g (make-instance 'cl-occt:geom2d :ptr ptr)))
        (tg:finalize g (lambda () (%free-geom2d ptr)))
        g)))

(in-package :cl-occt)

(defun make-pnt2d (x y)
  "Create a 2D point at (`x`, `y`).

**Example:**

    (make-pnt2d 3.5 7.0)

**See also:** `make-vec2d`, `make-dir2d`"
  (make-geom2d (%make-pnt2d (coerce x 'double-float)
                              (coerce y 'double-float))))

(defun make-vec2d (x y)
  "Create a 2D vector with components (`x`, `y`).

**Example:**

    (make-vec2d 1 0)

**See also:** `make-pnt2d`, `make-dir2d`"
  (make-geom2d (%make-vec2d (coerce x 'double-float)
                              (coerce y 'double-float))))

(defun make-dir2d (x y)
  "Create a 2D unit direction vector from components (`x`, `y`).

The vector is normalized to unit length.

**Example:**

    (make-dir2d 1 0)

**See also:** `make-vec2d`, `make-pnt2d`"
  (make-geom2d (%make-dir2d (coerce x 'double-float)
                              (coerce y 'double-float))))

(defun make-line2d (x y dx dy)
  "Create a 2D line through point (`x`, `y`) in direction (`dx`, `dy`).

**Example:**

    (make-line2d 0 0 1 0)

**See also:** `make-circle2d`"
  (make-geom2d (%make-line-2d (coerce x 'double-float)
                                (coerce y 'double-float)
                                (coerce dx 'double-float)
                                (coerce dy 'double-float))))

(defun make-circle2d (x y radius)
  "Create a 2D circle centered at (`x`, `y`) with the given `radius`.

**Example:**

    (make-circle2d 0 0 5)

**See also:** `make-line2d`"
  (make-geom2d (%make-circle-2d (coerce x 'double-float)
                                  (coerce y 'double-float)
                                  (coerce radius 'double-float))))

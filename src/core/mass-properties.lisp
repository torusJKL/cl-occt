(in-package :cl-occt)

(defclass gprops ()
  ((%volume :initarg :volume :reader gprops-volume)
   (%area :initarg :area :reader gprops-area)
   (%center-of-mass :initarg :center-of-mass :reader gprops-center-of-mass)
   (%inertia-matrix :initarg :inertia-matrix :reader gprops-inertia-matrix)
   (%principal-moments :initarg :principal-moments :reader gprops-principal-moments)
   (%principal-axes :initarg :principal-axes :reader gprops-principal-axes)))

(in-package :cl-occt.impl)

(defun %shape-gprops-internal (shape-ptr)
  (cffi:with-foreign-objects ((com-x :double) (com-y :double) (com-z :double)
                              (inertia :double 6)
                              (pm :double 3)
                              (pa :double 9))
    (let ((volume (%shape-volume shape-ptr))
          (area (%shape-area shape-ptr))
          (com-ok (%shape-center-of-mass shape-ptr com-x com-y com-z))
          (inertia-ok (%shape-inertia shape-ptr inertia 6 pm 3 pa 9)))
      (make-instance 'cl-occt:gprops
        :volume volume
        :area area
        :center-of-mass (when (plusp com-ok)
                          (list (cffi:mem-ref com-x :double)
                                (cffi:mem-ref com-y :double)
                                (cffi:mem-ref com-z :double)))
        :inertia-matrix (when (plusp inertia-ok)
                          (list (cffi:mem-aref inertia :double 0)
                                (cffi:mem-aref inertia :double 1)
                                (cffi:mem-aref inertia :double 2)
                                (cffi:mem-aref inertia :double 3)
                                (cffi:mem-aref inertia :double 4)
                                (cffi:mem-aref inertia :double 5)))
        :principal-moments (when (plusp inertia-ok)
                             (list (cffi:mem-aref pm :double 0)
                                   (cffi:mem-aref pm :double 1)
                                   (cffi:mem-aref pm :double 2)))
        :principal-axes (when (plusp inertia-ok)
                          (list (cffi:mem-aref pa :double 0)
                                (cffi:mem-aref pa :double 1)
                                (cffi:mem-aref pa :double 2)
                                (cffi:mem-aref pa :double 3)
                                (cffi:mem-aref pa :double 4)
                                (cffi:mem-aref pa :double 5)
                                (cffi:mem-aref pa :double 6)
                                (cffi:mem-aref pa :double 7)
                                (cffi:mem-aref pa :double 8)))))))

(in-package :cl-occt)

(defun shape-gprops (shape)
  "Compute global properties of a shape (volume, area, center of mass, inertia).

  Returns a GPROPS object whose readers provide individual properties:
    (gprops-volume GPROPS)            -- total volume
    (gprops-area GPROPS)              -- surface area
    (gprops-center-of-mass GPROPS)    -- center of mass as (X Y Z) or NIL
    (gprops-inertia-matrix GPROPS)    -- 6-component inertia matrix (Ixx Iyy Izz Ixy Ixz Iyz)
    (gprops-principal-moments GPROPS) -- principal moments (I1 I2 I3)
    (gprops-principal-axes GPROPS)    -- 9-component principal axes matrix

  Returns NIL if SHAPE is null or has no mass properties.

  Example:
    (let* ((b (make-box 10 20 30))
           (g (shape-gprops b)))
      (list (gprops-volume g)
            (gprops-area g)
            (gprops-center-of-mass g)))

  See also: shape-volume, shape-area, shape-center-of-mass, shape-inertia"
  (unless (shape-p shape)
    (return-from shape-gprops nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-gprops nil))
    (%shape-gprops-internal ptr)))

(defun shape-volume (shape)
  "Return the volume of a shape.

  SHAPE -- a shape object

  Returns the volume as a double-float, or NIL if the shape has no volume
  or the computation fails.

  Example:
    (shape-volume (make-box 10 20 30))
    => 6000.0d0

  See also: shape-gprops, shape-area"
  (unless (shape-p shape)
    (return-from shape-volume nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-volume nil))
    (let ((v (%shape-volume ptr)))
      (when (minusp v) (return-from shape-volume nil))
      v)))

(defun shape-area (shape)
  "Return the surface area of a shape.

  SHAPE -- a shape object

  Returns the area as a double-float, or NIL if the shape has no area
  or the computation fails.

  Example:
    (shape-area (make-box 10 20 30))
    => 2200.0d0

  See also: shape-gprops, shape-volume"
  (unless (shape-p shape)
    (return-from shape-area nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-area nil))
    (%shape-area ptr)))

(defun shape-center-of-mass (shape)
  "Return the center of mass of a shape as three values (X Y Z).

  SHAPE -- a shape object

  Returns NIL if the center of mass cannot be computed.

  Example:
    (shape-center-of-mass (make-box 10 20 30))
    => multiple values: 5.0d0 10.0d0 15.0d0

  See also: shape-gprops, shape-volume"
  (unless (shape-p shape)
    (return-from shape-center-of-mass nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-center-of-mass nil))
    (cffi:with-foreign-objects ((x :double) (y :double) (z :double))
      (let ((ok (%shape-center-of-mass ptr x y z)))
        (when (zerop ok) (return-from shape-center-of-mass nil))
        (values (cffi:mem-ref x :double)
                (cffi:mem-ref y :double)
                (cffi:mem-ref z :double))))))

(defun shape-inertia (shape)
  "Convenience alias for SHAPE-GPROPS.

  Returns a GPROPS object with volume, area, center of mass, and inertia
  information for the given shape.

  Example:
    (shape-inertia (make-box 10 20 30))

  See also: shape-gprops, shape-volume, shape-center-of-mass"
  (shape-gprops shape))

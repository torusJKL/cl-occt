(in-package :cl-occt)

(defclass graphic-group ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_Group handle with GC via tg:finalize."))

(defun graphic-group-p (obj)
  "**Returns:** `t` if **obj** is a `graphic-group` object."
  (typep obj 'graphic-group))

(defun make-graphic-group (structure)
  "Create a Graphic3d_Group inside the given **structure**.

  Returns a `graphic-group` object, or nil on failure.

  **See also:** `free-graphic-group`, `graphic-group-p`"
  (when (graphic-structure-p structure)
    (let* ((s-ptr (%handle structure))
           (ptr (when (and s-ptr (not (cffi:null-pointer-p s-ptr)))
                  (%graphic3d-group-new s-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'graphic-group :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%graphic3d-group-free (%handle obj)))))
      obj)))

(defun free-graphic-group (gg)
  "Explicitly free a graphic-group's C handle. Safe to call on nil."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (tg:cancel-finalization gg)
        (%graphic3d-group-free ptr)
        (setf (slot-value gg '%handle) (cffi:null-pointer))))))

(defun set-graphic-group-visible (gg visible)
  "Set visibility of **gg** group. Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-group-set-visible ptr (if visible 1 0))
        gg))))

(defun graphic-group-add-triangles (gg vertices &key normals)
  "Add triangles to **gg**. **vertices** is a flat list of (x y z) float triples.
  **normals** is an optional flat list of (nx ny nz) float triples. Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) vertices)
        (let* ((v-count (length vertices))
               (verts (cffi:foreign-alloc :float :initial-contents
                         (mapcar (lambda (v) (coerce v 'single-float)) vertices)))
               (norms (if normals
                         (cffi:foreign-alloc :float :initial-contents
                           (mapcar (lambda (n) (coerce n 'single-float)) normals))
                         (cffi:null-pointer)))
               (tri-count (truncate v-count 3)))
           (unwind-protect
                (%graphic3d-group-add-triangles ptr verts norms tri-count)
             (cffi:foreign-free verts)
             (when normals (cffi:foreign-free norms))))
        gg))))

(defun graphic-group-add-lines (gg vertices)
  "Add line segments to **gg**. **vertices** is a flat list of (x y z) float pairs.
  Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) vertices)
        (let* ((verts (cffi:foreign-alloc :float :initial-contents
                        (mapcar (lambda (v) (coerce v 'single-float)) vertices)))
               (count (truncate (length vertices) 3)))
          (unwind-protect
               (%graphic3d-group-add-lines ptr verts count)
            (cffi:foreign-free verts)))
        gg))))

(defun graphic-group-add-points (gg vertices)
  "Add points to **gg**. **vertices** is a flat list of (x y z) float triples.
  Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) vertices)
        (let* ((verts (cffi:foreign-alloc :float :initial-contents
                        (mapcar (lambda (v) (coerce v 'single-float)) vertices)))
               (count (truncate (length vertices) 3)))
          (unwind-protect
               (%graphic3d-group-add-points ptr verts count)
            (cffi:foreign-free verts)))
        gg))))

(defun graphic-group-add-text (gg text position)
  "Add a text label to **gg** at **position** (x y z). Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) text position)
        (destructuring-bind (x y z) position
          (%graphic3d-group-add-text ptr text
            (coerce x 'double-float)
            (coerce y 'double-float)
            (coerce z 'double-float)))
        gg))))

(defun set-graphic-group-aspect (gg aspect)
  "Set the display aspect for **gg**. **aspect** is an `aspect-fill-area` or `aspect-line`.
  Returns the group object."
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((a-ptr (etypecase aspect
                       (aspect-fill-area (%handle aspect))
                       (aspect-line (%handle aspect)))))
          (when (and a-ptr (not (cffi:null-pointer-p a-ptr)))
            (if (typep aspect 'aspect-fill-area)
                (%graphic3d-group-set-aspect ptr a-ptr)
                (%graphic3d-group-set-line-aspect ptr a-ptr))))
        gg))))

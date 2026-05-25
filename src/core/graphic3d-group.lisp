(in-package :cl-occt)

(defclass graphic-group ()
  ((%handle :initarg :handle :reader %handle)))

(defun graphic-group-p (obj)
  (typep obj 'graphic-group))

(defun make-graphic-group (structure)
  (when (graphic-structure-p structure)
    (let* ((s-ptr (%handle structure))
           (ptr (when (and s-ptr (not (cffi:null-pointer-p s-ptr)))
                  (%graphic3d-group-new s-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'graphic-group :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%graphic3d-group-free (%handle obj)))))
      obj)))

(defun set-graphic-group-visible (gg visible)
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-group-set-visible ptr (if visible 1 0))
        gg))))

(defun graphic-group-add-triangles (gg vertices &key normals)
  (when (graphic-group-p gg)
    (let ((ptr (%handle gg)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) vertices)
        (let* ((v-count (length vertices))
               (verts (cffi:foreign-alloc :float :initial-contents
                         (mapcar (lambda (v) (coerce v 'single-float)) vertices)))
               (norms (when normals
                        (cffi:foreign-alloc :float :initial-contents
                          (mapcar (lambda (n) (coerce n 'single-float)) normals))))
               (tri-count (truncate v-count 3)))
          (unwind-protect
               (%graphic3d-group-add-triangles ptr verts norms tri-count)
            (cffi:foreign-free verts)
            (when norms (cffi:foreign-free norms))))
        gg))))

(defun graphic-group-add-lines (gg vertices)
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

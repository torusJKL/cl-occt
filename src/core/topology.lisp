(in-package :cl-occt.impl)

(defvar *shape-type-map*
  '((:compound . 0)
    (:compsolid . 1)
    (:solid . 2)
    (:shell . 3)
    (:face . 4)
    (:wire . 5)
    (:edge . 6)
    (:vertex . 7)
    (:shape . 8)))

(defun %shape-type-to-int (keyword)
  (or (cdr (assoc keyword *shape-type-map*))
      (error "Unknown shape type keyword: ~S" keyword)))

(in-package :cl-occt)

(defun map-shape-subshapes (shape type &key stop-at)
  (unless (shape-p shape)
    (return-from map-shape-subshapes nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from map-shape-subshapes nil))
    (let* ((type-int (%shape-type-to-int type))
           (stop-int (if stop-at (%shape-type-to-int stop-at) 8))
           (max-shapes 65536)
           (shapes (cffi:foreign-alloc :pointer :count max-shapes)))
      (unwind-protect
           (let ((count (%map-subshapes ptr type-int stop-int shapes max-shapes)))
             (loop for i from 0 below count
                   collect (make-shape
                            (cffi:mem-aref shapes :pointer i))))
        (cffi:foreign-free shapes)))))

(defun count-shape-subshapes (shape type &key stop-at)
  (unless (shape-p shape)
    (return-from count-shape-subshapes nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from count-shape-subshapes nil))
    (%count-subshapes ptr
      (%shape-type-to-int type)
      (if stop-at (%shape-type-to-int stop-at) 8))))

(defun dump-shape (shape)
  (unless (shape-p shape)
    (return-from dump-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from dump-shape nil))
    (%dump-shape ptr)))

(defun shape-triangle-count (shape)
  (unless (shape-p shape)
    (return-from shape-triangle-count nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-triangle-count nil))
    (%shape-triangle-count ptr)))

(defun wire-order-check-p (wire &optional face)
  (unless (shape-p wire)
    (return-from wire-order-check-p nil))
  (let ((wire-ptr (%ptr wire)))
    (when (or (null wire-ptr) (cffi:null-pointer-p wire-ptr))
      (return-from wire-order-check-p nil))
    (let ((face-ptr (if face (%ptr face) (cffi:null-pointer))))
      (not (zerop (%wire-order-check wire-ptr face-ptr))))))

(defun edge->curve (edge)
  (unless (shape-p edge)
    (return-from edge->curve nil))
  (let ((ptr (%ptr edge)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from edge->curve nil))
    (let ((curve-ptr (%edge-to-curve ptr)))
      (if (and curve-ptr (not (cffi:null-pointer-p curve-ptr)))
          (make-curve curve-ptr)
          nil))))

(defun face->surface (face)
  (unless (shape-p face)
    (return-from face->surface nil))
  (let ((ptr (%ptr face)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from face->surface nil))
    (let ((surface-ptr (%face-to-surface ptr)))
      (if (and surface-ptr (not (cffi:null-pointer-p surface-ptr)))
          (make-surface surface-ptr)
          nil))))

(defun make-vertex (x y z)
  (make-shape (%make-vertex
                (coerce x 'double-float)
                (coerce y 'double-float)
                (coerce z 'double-float))))

(defun make-polygon (points &key (closed t))
  (unless (and (listp points) (>= (length points) 2))
    (return-from make-polygon nil))
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* 3 n))))
    (unwind-protect
         (progn
           (loop for i from 0 below n
                 for p in points
                 do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce (first p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce (second p) 'double-float)
                          (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce (third p) 'double-float)))
           (make-shape (%make-polygon arr n (if closed 1 0))))
      (cffi:foreign-free arr))))

(in-package :cl-occt)

(defun make-dimension (type &key from to vertex point1 point2 shape)
  (flet ((co (v) (coerce v 'double-float)))
    (let ((ptr (ecase type
                 (:length
                  (when (and from to)
                    (destructuring-bind (x1 y1 z1) from
                      (destructuring-bind (x2 y2 z2) to
                        (%prsdim-make-length-2p (co x1) (co y1) (co z1)
                                                (co x2) (co y2) (co z2))))))
                 (:angle
                  (when (and vertex point1 point2)
                    (destructuring-bind (vx vy vz) vertex
                      (destructuring-bind (p1x p1y p1z) point1
                        (destructuring-bind (p2x p2y p2z) point2
                          (%prsdim-make-angle-3p (co vx) (co vy) (co vz)
                                                 (co p1x) (co p1y) (co p1z)
                                                 (co p2x) (co p2y) (co p2z)))))))
                 (:diameter
                  (when (shape-p shape)
                    (%prsdim-make-diameter (%ptr shape))))
                 (:radius
                  (when (shape-p shape)
                    (%prsdim-make-radius (%ptr shape)))))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun set-dimension-text-position (dim position)
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
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-display-units ptr units)
        dim))))

(defun set-dimension-flyout (dim v)
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-flyout ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-arrow-length (dim v)
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-arrow-length ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-custom-value (dim value)
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-custom-value ptr (if (stringp value) value (princ-to-string value)))
        dim))))

(defun set-dimension-angle-edges (dim edge1 edge2)
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
  (when (ais-object-p dim)
    (let ((ptr (%ptr dim)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prsdim-set-extension-size ptr (coerce v 'double-float))
        dim))))

(defun set-dimension-measured-edge (dim edge &key (plane-origin '(0 0 0)) (plane-normal '(0 0 1)))
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

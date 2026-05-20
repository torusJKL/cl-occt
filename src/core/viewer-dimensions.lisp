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

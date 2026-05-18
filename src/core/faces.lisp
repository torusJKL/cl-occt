(in-package :cl-occt)

(defun make-edge (x1 y1 x2 y2)
  (make-shape (%make-edge-line-2d (coerce x1 'double-float)
                                   (coerce y1 'double-float)
                                   (coerce x2 'double-float)
                                   (coerce y2 'double-float))))

(defun make-edge-3d (x1 y1 z1 x2 y2 z2)
  (make-shape (%make-edge-line-3d (coerce x1 'double-float)
                                   (coerce y1 'double-float)
                                   (coerce z1 'double-float)
                                   (coerce x2 'double-float)
                                   (coerce y2 'double-float)
                                   (coerce z2 'double-float))))

(defun make-circle-edge (x y radius)
  (make-shape (%make-edge-circle-2d (coerce x 'double-float)
                                     (coerce y 'double-float)
                                     (coerce radius 'double-float))))

(defun make-circular-arc (x1 y1 x2 y2 x3 y3)
  (make-shape (%make-edge-arc-2d (coerce x1 'double-float)
                                  (coerce y1 'double-float)
                                  (coerce x2 'double-float)
                                  (coerce y2 'double-float)
                                  (coerce x3 'double-float)
                                  (coerce y3 'double-float))))

(defun make-wire (&rest edges)
  (if (null edges)
      nil
      (let ((count (length edges)))
        (cffi:with-foreign-object (arr :pointer count)
          (loop for i from 0 for e in edges
                do (setf (cffi:mem-aref arr :pointer i) (if (null e)
                                                            (cffi:null-pointer)
                                                            (%ptr e))))
          (make-shape (%make-wire arr count))))))

(defun make-face (wire)
  (if (null wire)
      nil
      (make-shape (%make-face (%ptr wire)))))

(defun make-face-on-plane (wire ox oy oz nx ny nz)
  (if (null wire)
      nil
      (make-shape (%make-face-on-plane (%ptr wire)
                                        (coerce ox 'double-float)
                                        (coerce oy 'double-float)
                                        (coerce oz 'double-float)
                                        (coerce nx 'double-float)
                                        (coerce ny 'double-float)
                                        (coerce nz 'double-float)))))

(in-package :cl-occt)

(defun chamfer-edge (shape edge distance)
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-equal (%ptr shape) (%ptr edge)
                                        (coerce distance 'double-float)))))

(defun chamfer-edges (shape edges distance)
  (if (null shape)
      nil
      (let* ((count (length edges))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for e in edges
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if e (%ptr e) (cffi:null-pointer))))
               (make-shape (%chamfer-edges-equal (%ptr shape) arr count
                                                  (coerce distance 'double-float))))
          (cffi:foreign-free arr)))))

(defun chamfer-edge-asymmetric (shape edge distance1 distance2)
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-asym (%ptr shape) (%ptr edge)
                                       (coerce distance1 'double-float)
                                       (coerce distance2 'double-float)))))

(defun chamfer-edge-on-face (shape edge distance face)
  (if (or (null shape) (null edge))
      nil
      (make-shape (%chamfer-edge-on-face (%ptr shape) (%ptr edge)
                                          (coerce distance 'double-float)
                                          (if face (%ptr face) (cffi:null-pointer))))))

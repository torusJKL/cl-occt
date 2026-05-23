(in-package :cl-occt)

(defun fillet-edge (shape edge radius)
  (if (or (null shape) (null edge))
      nil
      (make-shape (%fillet-edge-constant (%ptr shape) (%ptr edge)
                                          (coerce radius 'double-float)))))

(defun fillet-edges (shape edges radius)
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
               (make-shape (%fillet-edges-constant (%ptr shape) arr count
                                                    (coerce radius 'double-float))))
          (cffi:foreign-free arr)))))

(defun fillet-edge-variable (shape edge param-radius-pairs)
  (if (or (null shape) (null edge) (null param-radius-pairs))
      nil
      (let* ((count (length param-radius-pairs))
             (arr (cffi:foreign-alloc :double :count (* count 2))))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for (param rad) in param-radius-pairs
                     do (setf (cffi:mem-aref arr :double (* i 2)) (coerce param 'double-float)
                              (cffi:mem-aref arr :double (1+ (* i 2))) (coerce rad 'double-float)))
               (make-shape (%fillet-edge-variable (%ptr shape) (%ptr edge) arr count)))
          (cffi:foreign-free arr)))))

(defun fillet-wire-corner (wire radius)
  (if (null wire)
      nil
      (make-shape (%fillet-wire-corner (%ptr wire)
                                        (coerce radius 'double-float)))))

(defun fillet-wire-all-corners (wire radius)
  (if (null wire)
      nil
      (make-shape (%fillet-wire-all-corners (%ptr wire)
                                              (coerce radius 'double-float)))))

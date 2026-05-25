(in-package :cl-occt)

;; --- IntTools Intersection Queries ---

(defun intersect-edge-edge (edge1 edge2)
  "Compute intersection between two edges using IntTools_EdgeEdge.

  Returns a plist (:points ((x y z) ...)) or nil on no intersection or invalid input."
  (when (and (shape-p edge1) (shape-p edge2))
    (let* ((p1 (%ptr edge1)) (p2 (%ptr edge2))
           (out-pts (cffi:foreign-alloc :double :count (* 3 256)))
           (out-cnt (cffi:foreign-alloc :int)))
      (unwind-protect
           (when (and p1 p2
                      (not (cffi:null-pointer-p p1))
                      (not (cffi:null-pointer-p p2))
                      (= 1 (%inttools-edge-edge p1 p2 out-pts 256 out-cnt)))
             (let ((n (cffi:mem-aref out-cnt :int)))
               (when (plusp n)
                 (list :points
                       (loop for i from 0 below n
                             collect (list (cffi:mem-aref out-pts :double (+ (* i 3) 0))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 1))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 2))))))))
        (cffi:foreign-free out-pts)
        (cffi:foreign-free out-cnt)))))

(defun intersect-edge-face (edge face)
  "Compute intersection between an edge and a face using IntTools_EdgeFace.

  Returns a plist (:points ((x y z) ...)) or nil on no intersection or invalid input."
  (when (and (shape-p edge) (shape-p face))
    (let* ((ep (%ptr edge)) (fp (%ptr face))
           (out-pts (cffi:foreign-alloc :double :count (* 3 256)))
           (out-cnt (cffi:foreign-alloc :int)))
      (unwind-protect
           (when (and ep fp
                      (not (cffi:null-pointer-p ep))
                      (not (cffi:null-pointer-p fp))
                      (= 1 (%inttools-edge-face ep fp out-pts 256 out-cnt)))
             (let ((n (cffi:mem-aref out-cnt :int)))
               (when (plusp n)
                 (list :points
                       (loop for i from 0 below n
                             collect (list (cffi:mem-aref out-pts :double (+ (* i 3) 0))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 1))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 2))))))))
        (cffi:foreign-free out-pts)
        (cffi:foreign-free out-cnt)))))

(defun intersect-face-face (face1 face2)
  "Compute intersection between two faces using IntTools_FaceFace.

  Returns a plist (:points ((x y z) ...) :curves (curve ...))
  or nil on no intersection or invalid input.

  Each curve is an occt curve object (GC-managed via tg:finalize)."
  (when (and (shape-p face1) (shape-p face2))
    (let* ((f1 (%ptr face1)) (f2 (%ptr face2))
           (out-pts (cffi:foreign-alloc :double :count (* 3 256)))
           (out-pcnt (cffi:foreign-alloc :int))
           (out-curves (cffi:foreign-alloc :pointer :count 32))
           (out-ccnt (cffi:foreign-alloc :int)))
      (unwind-protect
           (when (and f1 f2
                      (not (cffi:null-pointer-p f1))
                      (not (cffi:null-pointer-p f2))
                      (= 1 (%inttools-face-face f1 f2
                                                out-pts 256 out-pcnt
                                                out-curves 32 out-ccnt)))
             (let ((pn (cffi:mem-aref out-pcnt :int))
                   (cn (cffi:mem-aref out-ccnt :int))
                   (result nil))
               (when (plusp pn)
                 (setf (getf result :points)
                       (loop for i from 0 below pn
                             collect (list (cffi:mem-aref out-pts :double (+ (* i 3) 0))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 1))
                                           (cffi:mem-aref out-pts :double (+ (* i 3) 2))))))
               (when (plusp cn)
                 (setf (getf result :curves)
                       (loop for i from 0 below cn
                             for curve-ptr = (cffi:mem-aref out-curves :pointer i)
                             unless (or (null curve-ptr) (cffi:null-pointer-p curve-ptr))
                             collect (let ((c (make-instance 'curve :ptr curve-ptr)))
                                       (tg:finalize c (lambda () (%inttools-free-curve curve-ptr)))
                                       c))))
               (when result result)))
        (cffi:foreign-free out-pts)
        (cffi:foreign-free out-pcnt)
        (cffi:foreign-free out-curves)
        (cffi:foreign-free out-ccnt)))))

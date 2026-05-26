(in-package :cl-occt)

;; ----------------------------------------------------------------
;; Type keyword maps
;; ----------------------------------------------------------------

(defparameter *geom-tolerance-type-map*
  '((:none . 0)
    (:angularity . 1)
    (:circular-runout . 2)
    (:circularity . 3)
    (:coaxiality . 4)
    (:concentricity . 5)
    (:cylindricity . 6)
    (:flatness . 7)
    (:parallelism . 8)
    (:perpendicularity . 9)
    (:position . 10)
    (:profile-of-line . 11)
    (:profile-of-surface . 12)
    (:straightness . 13)
    (:symmetry . 14)
    (:total-runout . 15))
  "Maps Lisp keywords to XCAFDimTolObjects_GeomToleranceType integer codes.")

(defparameter *dim-tol-type-map*
  '((:flatness . 7)
    (:position . 10)
    (:parallelism . 8)
    (:perpendicularity . 9)
    (:concentricity . 5)
    (:circular-runout . 2)
    (:total-runout . 15)
    (:circularity . 3)
    (:cylindricity . 6)
    (:profile-of-line . 11)
    (:profile-of-surface . 12)
    (:angularity . 1)
    (:symmetry . 14)
    (:straightness . 13))
  "Maps Lisp keywords to tolerance type codes for xcaf-add-tolerance.")

;; ----------------------------------------------------------------
;; Helpers
;; ----------------------------------------------------------------

(defun %lookup-type (key map)
  (or (cdr (assoc key map))
      (if (integerp key) key
          (progn
            (warn "unknown type keyword ~S, using 0" key)
            0))))

(defun %pack-points (points)
  (let* ((n (length points))
         (arr (cffi:foreign-alloc :double :count (* n 3))))
    (loop for p in points
          for i from 0
          for (x y z) = (if (listp p)
                            p
                            (list 0d0 0d0 0d0))
          do (setf (cffi:mem-aref arr :double (+ (* i 3) 0)) (coerce x 'double-float)
                   (cffi:mem-aref arr :double (+ (* i 3) 1)) (coerce y 'double-float)
                   (cffi:mem-aref arr :double (+ (* i 3) 2)) (coerce z 'double-float)))
    arr))

(defun %unpack-dimensions (ptr count)
  (loop with i = 0
        while (< i count)
        collect
        (let* ((type-code (round (cffi:mem-aref ptr :double i)))
               (val (cffi:mem-aref ptr :double (+ i 1)))
               (nb-pts (round (cffi:mem-aref ptr :double (+ i 2))))
               (pts (when (plusp nb-pts)
                      (loop for j from 0 below nb-pts
                            collect
                            (list (cffi:mem-aref ptr :double (+ i 3 (* j 3) 0))
                                  (cffi:mem-aref ptr :double (+ i 3 (* j 3) 1))
                                  (cffi:mem-aref ptr :double (+ i 3 (* j 3) 2))))))
               (entry-size (max 3 (+ 3 (* nb-pts 3)))))
          (setf i (+ i entry-size))
          (list :type type-code :value val :nb-points nb-pts :points pts))))

(defun %unpack-tolerances (ptr count)
  (loop for i from 0 below count by 2
        collect
        (let* ((type-code (round (cffi:mem-aref ptr :double i)))
               (is-geom-tol (minusp type-code)))
          (list :type (if is-geom-tol (- type-code) type-code)
                :value (cffi:mem-aref ptr :double (+ i 1))
                :geom-tolerance-p is-geom-tol))))

;; ----------------------------------------------------------------
;; Public API
;; ----------------------------------------------------------------

(defun xcaf-add-linear-dimension (doc shape points &key value)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-linear-dimension: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-linear-dimension: nil shape") nil)
    ((or (null points) (< (length points) 2))
     (warn "xcaf-add-linear-dimension: need at least 2 points") nil)
    ((null value)
     (warn "xcaf-add-linear-dimension: :value required") nil)
    (t
     (let* ((packed (%pack-points (subseq points 0 2)))
            (n 2)
            (result (%xcaf-add-linear-dimension (%ptr doc) (%ptr shape)
                                                  packed n
                                                  (coerce value 'double-float))))
       (cffi:foreign-free packed)
       (if (zerop result) nil t)))))

(defun xcaf-add-angular-dimension (doc shape edges &key value)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-angular-dimension: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-angular-dimension: nil shape") nil)
    ((or (null edges) (< (length edges) 2))
     (warn "xcaf-add-angular-dimension: need at least 2 edges") nil)
    ((null value)
     (warn "xcaf-add-angular-dimension: :value required") nil)
    (t
     (let* ((edge-arr (cffi:foreign-alloc :pointer :count (length edges))))
       (unwind-protect
            (progn
              (loop for e in edges and i from 0
                    do (setf (cffi:mem-aref edge-arr :pointer i)
                             (if (and e (%ptr e)) (%ptr e) (cffi:null-pointer))))
              (let ((result (%xcaf-add-angular-dimension
                             (%ptr doc) (%ptr shape)
                             edge-arr (length edges)
                             (coerce value 'double-float))))
                (if (zerop result) nil t)))
         (cffi:foreign-free edge-arr))))))

(defun xcaf-add-diameter-dimension (doc shape subshape &key value)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-diameter-dimension: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-diameter-dimension: nil shape") nil)
    ((or (null subshape) (null (%ptr subshape)))
     (warn "xcaf-add-diameter-dimension: nil subshape") nil)
    ((null value)
     (warn "xcaf-add-diameter-dimension: :value required") nil)
    (t
     (let ((result (%xcaf-add-diameter-dimension (%ptr doc) (%ptr shape)
                                                   (%ptr subshape)
                                                   (coerce value 'double-float))))
       (if (zerop result) nil t)))))

(defun xcaf-add-tolerance (doc shape type &key value modifiers)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-tolerance: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-tolerance: nil shape") nil)
    ((null type)
     (warn "xcaf-add-tolerance: type required") nil)
    (t
     (let* ((type-code (%lookup-type type *dim-tol-type-map*))
            (mod-flags (if modifiers
                           (loop for m in modifiers
                                 sum (case m
                                       (:mmc 1)
                                       (:lmc 2)
                                       (:rfs 4)
                                       (:projected 8)
                                       (t 0)))
                           0)))
       (declare (ignorable mod-flags))
       (let ((result (%xcaf-add-tolerance (%ptr doc) (%ptr shape)
                                           type-code
                                           (coerce (or value 0d0) 'double-float)
                                           mod-flags)))
         (if (zerop result) nil t))))))

(defun xcaf-add-datum (doc shape &key label)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-datum: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-datum: nil shape") nil)
    ((or (null label) (string= label ""))
     (warn "xcaf-add-datum: :label required") nil)
    (t
     (let ((result (%xcaf-add-datum (%ptr doc) (%ptr shape) label)))
       (if (zerop result) nil t)))))

(defun xcaf-add-geometric-tolerance (doc shape type value &key datums)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-geometric-tolerance: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-geometric-tolerance: nil shape") nil)
    ((null type)
     (warn "xcaf-add-geometric-tolerance: type required") nil)
    (t
     (let* ((type-code (%lookup-type type *geom-tolerance-type-map*))
            (datum-list (if datums
                            (mapcar #'string datums)
                            nil))
            (num-datums (length datum-list))
            (datum-arr (when (plusp num-datums)
                         (cffi:foreign-alloc :pointer :count num-datums))))
       (unwind-protect
            (progn
              (loop for d in datum-list and i from 0
                    do (setf (cffi:mem-aref datum-arr :pointer i)
                             (cffi:foreign-string-alloc d)))
              (let ((result (%xcaf-add-geometric-tolerance
                             (%ptr doc) (%ptr shape)
                             type-code
                             (coerce value 'double-float)
                             datum-arr num-datums)))
                (if (zerop result) nil t)))
         (when datum-arr
           (loop for i from 0 below num-datums
                 do (cffi:foreign-free (cffi:mem-aref datum-arr :pointer i)))
           (cffi:foreign-free datum-arr)))))))

(defun xcaf-get-dimensions (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-dimensions: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-get-dimensions: nil shape") nil)
    (t
     (cffi:with-foreign-object (out-count :int)
       (let ((ptr (%xcaf-get-dimensions (%ptr doc) (%ptr shape) out-count)))
         (if (cffi:null-pointer-p ptr)
             nil
             (let* ((count (cffi:mem-ref out-count :int))
                    (dims (%unpack-dimensions ptr count)))
               (%xcaf-free-double-array ptr)
               dims)))))))

(defun xcaf-get-tolerances (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-tolerances: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-get-tolerances: nil shape") nil)
    (t
     (cffi:with-foreign-object (out-count :int)
       (let ((ptr (%xcaf-get-tolerances (%ptr doc) (%ptr shape) out-count)))
         (if (cffi:null-pointer-p ptr)
             nil
             (let* ((count (cffi:mem-ref out-count :int))
                    (tols (%unpack-tolerances ptr count)))
               (%xcaf-free-double-array ptr)
               tols)))))))

(defun xcaf-get-datums (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-datums: nil doc") nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-get-datums: nil shape") nil)
    (t
     (cffi:with-foreign-object (out-count :int)
       (let ((arr (%xcaf-get-datums (%ptr doc) (%ptr shape) out-count)))
         (if (cffi:null-pointer-p arr)
             nil
             (let* ((count (cffi:mem-ref out-count :int))
                    (result (loop for i from 0 below count
                                  collect
                                  (let ((s (cffi:mem-aref arr :pointer i)))
                                    (unless (cffi:null-pointer-p s)
                                      (cffi:foreign-string-to-lisp s))))))
               (%xcaf-free-string-array arr count)
               result)))))))

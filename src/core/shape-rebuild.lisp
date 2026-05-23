(in-package :cl-occt)

(defun substitute-shape (shape old-or-pairs &optional new)
  "Replace a single sub-shape or batch-replace multiple.
  (substitute-shape orig old new) for single replacement.
  (substitute-shape orig '((old1 new1) (old2 new2))) for batch."
  (unless (shape-p shape)
    (return-from substitute-shape nil))
  (let ((shape-ptr (%ptr shape)))
    (when (or (null shape-ptr) (cffi:null-pointer-p shape-ptr))
      (return-from substitute-shape nil))
    (if new
        (let ((old-ptr (when (shape-p old-or-pairs) (%ptr old-or-pairs)))
              (new-ptr (when (shape-p new) (%ptr new))))
          (when (or (null old-ptr) (cffi:null-pointer-p old-ptr)
                    (null new-ptr) (cffi:null-pointer-p new-ptr))
            (return-from substitute-shape nil))
          (make-shape (%substitute-single shape-ptr old-ptr new-ptr)))
        (let ((pairs old-or-pairs))
          (unless (listp pairs)
            (return-from substitute-shape nil))
          (let* ((count (length pairs))
                 (old-vec (cffi:foreign-alloc :pointer :count count))
                 (new-vec (cffi:foreign-alloc :pointer :count count)))
            (unwind-protect
                 (progn
                   (loop for pair in pairs
                         for i from 0
                         do (let ((old-s (first pair))
                                  (new-s (second pair)))
                              (setf (cffi:mem-aref old-vec :pointer i)
                                    (if (shape-p old-s) (%ptr old-s) (cffi:null-pointer))
                                    (cffi:mem-aref new-vec :pointer i)
                                    (if (shape-p new-s) (%ptr new-s) (cffi:null-pointer)))))
                   (make-shape (%substitute-batch shape-ptr old-vec new-vec count)))
              (cffi:foreign-free old-vec)
              (cffi:foreign-free new-vec)))))))

(defun shape-to-nurbs (shape)
  (unless (shape-p shape)
    (return-from shape-to-nurbs nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-to-nurbs nil))
    (make-shape (%shape-to-nurbs ptr))))

(defun shape-reduce-degree (shape max-degree)
  (unless (shape-p shape)
    (return-from shape-reduce-degree nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-reduce-degree nil))
    (make-shape (%shape-reduce-degree ptr max-degree))))

(defun shape-to-rational-bspline (shape)
  (unless (shape-p shape)
    (return-from shape-to-rational-bspline nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-to-rational-bspline nil))
    (make-shape (%shape-to-rational-bspline ptr))))

(defun shape-split-u (shape num-splits)
  (unless (shape-p shape)
    (return-from shape-split-u nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-split-u nil))
    (make-shape (%shape-split-u ptr num-splits))))

(defun shape-upgrade-continuity (shape &key (continuity :c1))
  (unless (shape-p shape)
    (return-from shape-upgrade-continuity nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from shape-upgrade-continuity nil))
    (let ((cont (ecase continuity
                  (:c0 0) (:c1 1) (:c2 2) (:c3 3))))
      (make-shape (%shape-upgrade-continuity ptr cont)))))

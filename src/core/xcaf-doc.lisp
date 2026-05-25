(in-package :cl-occt)

(defclass xcaf-doc ()
  ((%ptr :initarg :%ptr :reader %ptr :initform nil))
  )

(defmethod print-object ((obj xcaf-doc) stream)
  (print-unreadable-object (obj stream :type t :identity t)))

(defun xcaf-doc-p (obj)
  (typep obj 'xcaf-doc))

(defun make-xcaf-doc ()
  (let* ((ptr (cffi:foreign-alloc :pointer))
         (result (%xcaf-new-doc ptr)))
    (if (and (not (zerop result))
             (not (cffi:null-pointer-p (cffi:mem-ref ptr :pointer))))
        (make-instance 'xcaf-doc :%ptr (cffi:mem-ref ptr :pointer))
        nil)))

(defun xcaf-free-doc (doc)
  (when doc
    (%xcaf-free-doc (%ptr doc))
    (setf (slot-value doc '%ptr) nil)
    t))

(defun xcaf-add-shape (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-shape: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-shape: nil shape")
     nil)
    (t
     (let ((result (%xcaf-save-shape-to-doc (%ptr doc) (%ptr shape))))
       (if (zerop result) nil t)))))

(defun xcaf-add-shape-to-layer (doc shape layer)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-shape-to-layer: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-shape-to-layer: nil shape")
     nil)
    ((or (null layer) (string= layer ""))
     (warn "xcaf-add-shape-to-layer: empty layer name")
     nil)
    (t
     (let ((result (%xcaf-set-layer (%ptr doc) (%ptr shape) layer)))
       (if (zerop result) nil t)))))

(defun xcaf-remove-shape-from-layer (doc shape layer)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-remove-shape-from-layer: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-remove-shape-from-layer: nil shape")
     nil)
    ((or (null layer) (string= layer ""))
     (warn "xcaf-remove-shape-from-layer: empty layer name")
     nil)
    (t
     (let ((result (%xcaf-unset-one-layer (%ptr doc) (%ptr shape) layer)))
       (if (zerop result) nil t)))))

(defun xcaf-get-shape-layers (doc shape)
  (declare (ignore doc shape))
  (warn "xcaf-get-shape-layers: not yet implemented")
  nil)

(defun xcaf-has-material (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-has-material: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-has-material: nil shape")
     nil)
    (t
     (not (zerop (%xcaf-has-material (%ptr doc) (%ptr shape)))))))

(defun xcaf-add-view (doc)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-view: nil doc")
     nil)
    (t
     (let ((result (%xcaf-add-view (%ptr doc))))
       (if (zerop result) nil t)))))

(defun xcaf-get-views (doc)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-views: nil doc")
     nil)
    (t
     (let ((count (%xcaf-get-view-count (%ptr doc))))
       (when (plusp count)
         (loop for i from 1 to count
               collect (list :index i)))))))

(defun xcaf-get-visual-material (doc shape)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-visual-material: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-get-visual-material: nil shape")
     nil)
    (t
     (let ((out-r (cffi:foreign-alloc :double))
           (out-g (cffi:foreign-alloc :double))
           (out-b (cffi:foreign-alloc :double))
           (out-a (cffi:foreign-alloc :double)))
       (unwind-protect
            (if (not (zerop (%xcaf-get-visual-material (%ptr doc) (%ptr shape)
                                                        out-r out-g out-b out-a)))
                (list :color (list (cffi:mem-ref out-r :double)
                                   (cffi:mem-ref out-g :double)
                                   (cffi:mem-ref out-b :double))
                      :alpha (cffi:mem-ref out-a :double))
                nil)
         (cffi:foreign-free out-r)
         (cffi:foreign-free out-g)
         (cffi:foreign-free out-b)
         (cffi:foreign-free out-a))))))

(defun xcaf-get-clipping-planes (doc)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-clipping-planes: nil doc")
     nil)
    (t
     (let ((count (%xcaf-get-clipping-plane-count (%ptr doc))))
       (when (plusp count)
         (loop for i from 1 to count
               collect (list :index i)))))))

(defun xcaf-expand-assembly (doc)
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-expand-assembly: nil doc")
     nil)
    (t
     (let ((result (%xcaf-expand-assembly (%ptr doc))))
       (if (zerop result) nil t)))))

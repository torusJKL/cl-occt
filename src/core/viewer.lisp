(in-package :cl-occt)

(defclass viewer ()
  ((%driver :initarg :driver :reader %driver)
   (%viewer :initarg :viewer :reader %viewer)
   (%view   :initarg :view   :reader %view)))

(defun viewer-p (v)
  (typep v 'viewer))

(defun make-viewer ()
  (let* ((driver (%create-graphic-driver))
         (v3d-viewer (%v3d-create-viewer driver))
         (view   (%v3d-create-view v3d-viewer))
         (wrapped (make-instance 'viewer
                    :driver driver :viewer v3d-viewer :view view)))
    (tg:finalize wrapped (lambda () (free-viewer wrapped)))
    wrapped))

(defun free-viewer (v)
  (when (viewer-p v)
    (let ((driver (%driver v))
          (v3d-viewer (%viewer v))
          (view (%view v)))
      (when (and view (not (cffi:null-pointer-p view)))
        (%v3d-free-view view))
      (when (and v3d-viewer (not (cffi:null-pointer-p v3d-viewer)))
        (%v3d-free-viewer v3d-viewer))
      (when (and driver (not (cffi:null-pointer-p driver)))
        (%free-graphic-driver driver))
      (setf (slot-value v '%driver) (cffi:null-pointer)
            (slot-value v '%viewer) (cffi:null-pointer)
            (slot-value v '%view) (cffi:null-pointer)))))

(defun fit-all (v)
  (when (viewer-p v)
    (let ((view (%view v)))
      (when (and view (not (cffi:null-pointer-p view)))
        (%v3d-fit-all view)))))

(defun must-be-resized (v)
  (when (viewer-p v)
    (let ((view (%view v)))
      (when (and view (not (cffi:null-pointer-p view)))
        (%v3d-view-must-be-resized view)))))

;; --- AIS Context ---

(defclass ais-context ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun ais-context-p (v)
  (typep v 'ais-context))

(defun ais-create-context (viewer)
  (when (viewer-p viewer)
    (let* ((ptr (%ais-create-context (%viewer viewer)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-context :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free-context obj))))
      obj)))

(defun ais-free-context (ctx)
  (when (ais-context-p ctx)
    (let ((ptr (%ptr ctx)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-free-context ptr)
        (setf (slot-value ctx '%ptr) (cffi:null-pointer))))))

;; --- AIS Object ---

(defclass ais-object ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun ais-object-p (v)
  (typep v 'ais-object))

(defun ais-create-shape (shape)
  (when (and shape (shape-p shape))
    (let* ((ptr (%ais-create-shape (%ptr shape)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

(defun ais-free (obj)
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-free-shape ptr)
        (setf (slot-value obj '%ptr) (cffi:null-pointer))))))

(defun ais-display (context shape-or-obj &key (update t))
  (when (ais-context-p context)
    (let* ((obj (if (ais-object-p shape-or-obj)
                    shape-or-obj
                    (ais-create-shape shape-or-obj)))
           (ptr (when obj (%ptr obj))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-context-display (%ptr context) ptr (if update 1 0)))
      obj)))

(defun ais-erase (context obj &key (update t))
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((obj-ptr (%ptr obj))
          (ctx-ptr (%ptr context)))
      (when (and obj-ptr ctx-ptr
                 (not (cffi:null-pointer-p obj-ptr))
                 (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-erase ctx-ptr obj-ptr (if update 1 0))))))

(defun ais-remove (context obj &key (update t))
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((obj-ptr (%ptr obj))
          (ctx-ptr (%ptr context)))
      (when (and obj-ptr ctx-ptr
                 (not (cffi:null-pointer-p obj-ptr))
                 (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-remove ctx-ptr obj-ptr (if update 1 0))))))

(defun ais-remove-all (context &key (update t))
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-remove-all ctx-ptr (if update 1 0))))))

(defun ais-displayed-p (context obj)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((obj-ptr (%ptr obj))
          (ctx-ptr (%ptr context)))
      (when (and obj-ptr ctx-ptr
                 (not (cffi:null-pointer-p obj-ptr))
                 (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-is-displayed ctx-ptr obj-ptr)))))))

(defmacro with-viewer ((var) &body body)
  `(let ((,var (make-viewer)))
     (unwind-protect (progn ,@body)
       (free-viewer ,var))))

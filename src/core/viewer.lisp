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

(defun fit-all (v &optional shape)
  (when (viewer-p v)
    (let ((view (%view v)))
      (when (and view (not (cffi:null-pointer-p view)))
        (if (shape-p shape)
            (let ((shape-ptr (%ptr shape)))
              (when (and shape-ptr (not (cffi:null-pointer-p shape-ptr)))
                (%v3d-view-fit-all-shape view shape-ptr)))
            (%v3d-fit-all view))
        v))))

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
    (let* ((obj (cond ((ais-object-p shape-or-obj)
                       shape-or-obj)
                      ((ais-text-label-p shape-or-obj)
                       shape-or-obj)
                      (t
                       (ais-create-shape shape-or-obj))))
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

;; --- Enum maps ---

(defparameter *v3d-orientation-map*
  '((:x-pos . 0) (:y-pos . 1) (:z-pos . 2)
    (:x-neg . 3) (:y-neg . 4) (:z-neg . 5)
    (:iso-pers . 10)))

(defparameter *ais-display-mode-map*
  '((:wireframe . 0) (:shaded . 1)))

(defparameter *grid-type-map*
  '((:rectangular . 0) (:circular . 1)))

(defparameter *grid-draw-mode-map*
  '((:lines . 0) (:points . 1)))

(defun %lookup (key map)
  (cdr (assoc key map)))

;; --- Styling ---

(defun set-background (view r g b)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-bg-color view-ptr
                                (coerce r 'double-float)
                                (coerce g 'double-float)
                                (coerce b 'double-float))))
    (list r g b)))

(defun ais-set-color (context obj color)
  (when (and (ais-context-p context) (ais-object-p obj))
    (destructuring-bind (r g b) color
      (let ((ctx-ptr (%ptr context))
            (obj-ptr (%ptr obj)))
        (when (and ctx-ptr obj-ptr
                   (not (cffi:null-pointer-p ctx-ptr))
                   (not (cffi:null-pointer-p obj-ptr)))
          (%ais-context-set-color ctx-ptr obj-ptr
                                  (coerce r 'double-float)
                                  (coerce g 'double-float)
                                  (coerce b 'double-float)))))))

(defun ais-unset-color (context obj)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-unset-color ctx-ptr obj-ptr)))))

;; --- Display Mode ---

(defun ais-set-display-mode (context obj mode)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((mode-int (%lookup mode *ais-display-mode-map*))
          (ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and mode-int ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-set-display-mode ctx-ptr obj-ptr mode-int)))))

;; --- Camera ---

(defun set-view-projection (view orientation)
  (when (viewer-p view)
    (let ((orient-int (%lookup orientation *v3d-orientation-map*))
          (view-ptr (%view view)))
      (when (and orient-int view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-proj view-ptr orient-int)))))

;; --- MSAA ---

(defun set-msaa (view samples)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-msaa view-ptr samples)))))

(defun msaa (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-get-msaa view-ptr)))))

;; --- Antialiasing ---

(defun set-antialiasing (view on)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-antialiasing view-ptr (if on 1 0))))))

(defun antialiasing-p (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (not (zerop (%v3d-view-get-antialiasing view-ptr)))))))

;; --- Grid ---

(defun activate-grid (viewer grid-type draw-mode)
  (when (viewer-p viewer)
    (let ((gt-int (%lookup grid-type *grid-type-map*))
          (dm-int (%lookup draw-mode *grid-draw-mode-map*))
          (v3d-viewer (%viewer viewer)))
      (when (and gt-int dm-int
                 v3d-viewer
                 (not (cffi:null-pointer-p v3d-viewer)))
        (%v3d-viewer-activate-grid v3d-viewer gt-int dm-int)))))

(defun deactivate-grid (viewer)
  (when (viewer-p viewer)
    (let ((v3d-viewer (%viewer viewer)))
      (when (and v3d-viewer (not (cffi:null-pointer-p v3d-viewer)))
        (%v3d-viewer-deactivate-grid v3d-viewer)))))

;; --- Invalidate ---

(defun invalidate-view (view)
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-invalidate view-ptr)))))

(defmacro with-viewer ((var) &body body)
  `(let ((,var (make-viewer)))
     (unwind-protect (progn ,@body)
       (free-viewer ,var))))

;; --- Trihedron ---

(defparameter *trihedron-corner-map*
  '((:lower-left   . 0)
    (:upper-left   . 1)
    (:lower-right  . 2)
    (:upper-right  . 3)
    (:center       . 4)))

(defparameter *trihedron-datum-mode-map*
  '((:wireframe . 0)
    (:shaded    . 1)))

(defun make-trihedron (&key (origin '(0 0 0)) (normal '(0 0 1)) (x-direction '(1 0 0)))
  (destructuring-bind (ox oy oz) origin
    (destructuring-bind (dx dy dz) normal
      (destructuring-bind (ux uy uz) x-direction
        (let ((ptr (%ais-create-trihedron
                    (coerce ox 'double-float)
                    (coerce oy 'double-float)
                    (coerce oz 'double-float)
                    (coerce dx 'double-float)
                    (coerce dy 'double-float)
                    (coerce dz 'double-float)
                    (coerce ux 'double-float)
                    (coerce uy 'double-float)
                    (coerce uz 'double-float))))
          (if (cffi:null-pointer-p ptr)
              nil
              (let ((obj (make-instance 'ais-object :ptr ptr)))
                (tg:finalize obj (lambda () (ais-free obj)))
                obj)))))))

(defun set-trihedron-mode (tri mode)
  (when (ais-object-p tri)
    (let ((mode-int (%lookup mode *trihedron-datum-mode-map*))
          (ptr (%ptr tri)))
      (when (and mode-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-datum-mode ptr mode-int)))))

(defun set-trihedron-arrows (tri on)
  (when (ais-object-p tri)
    (let ((ptr (%ptr tri)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-draw-arrows ptr (if on 1 0))))))

(defun set-trihedron-size (tri size)
  (when (ais-object-p tri)
    (let ((ptr (%ptr tri)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-size ptr (coerce size 'double-float))))))

(defun set-trihedron-corner (tri corner &key (x-offset 50) (y-offset 50))
  (when (ais-object-p tri)
    (let ((corner-int (%lookup corner *trihedron-corner-map*))
          (ptr (%ptr tri)))
      (when (and corner-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-transform-pers ptr corner-int
                                           x-offset y-offset)))))

(defun set-trihedron-axis-colors (tri &key x y z)
  (when (ais-object-p tri)
    (let ((ptr (%ptr tri)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (flet ((set-part (part color)
                 (when color
                   (destructuring-bind (r g b) (normalize-color color)
                     (%ais-trihedron-set-datum-part-color ptr part
                       (coerce r 'double-float)
                       (coerce g 'double-float)
                       (coerce b 'double-float))))))
          (set-part 0 x)
          (set-part 1 y)
          (set-part 2 z))
        tri))))

(defun set-trihedron-text-color (tri color)
  (when (ais-object-p tri)
    (let ((rgb (normalize-color color))
          (ptr (%ptr tri)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-trihedron-set-text-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        tri))))

(defun show-trihedron (context viewer &key (corner :lower-left) (size 50))
  (let ((tri (make-trihedron)))
    (when tri
      (set-trihedron-corner tri corner :x-offset 50 :y-offset 50)
      (set-trihedron-size tri size)
      (ais-display context tri)
      tri)))

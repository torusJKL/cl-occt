(in-package :cl-occt)

(defclass viewer ()
  ((%driver :initarg :driver :reader %driver)
   (%viewer :initarg :viewer :reader %viewer)
   (%view   :initarg :view   :reader %view)))

(defun viewer-p (v)
  "Returns T if V is a VIEWER object.

  See also: make-viewer, free-viewer"
  (typep v 'viewer))

(defun make-viewer ()
  "Creates a new viewer with a 3D view.

  The viewer is automatically finalized for garbage collection.
  Uses `with-viewer` for guaranteed cleanup.

  Example:
    (let ((v (make-viewer)))
      (fit-all v)
      (free-viewer v))"
  (let* ((driver (%create-graphic-driver))
         (v3d-viewer (%v3d-create-viewer driver))
         (view   (%v3d-create-view v3d-viewer))
         (wrapped (make-instance 'viewer
                    :driver driver :viewer v3d-viewer :view view)))
    (tg:finalize wrapped (lambda () (free-viewer wrapped)))
    wrapped))

(defun free-viewer (v)
  "Frees the viewer and its underlying OCCT resources.

  Cancels the finalizer so GC won't attempt double-free.
  Safe to call multiple times.

  Example:
    (let ((v (make-viewer)))
      (free-viewer v))"
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
            (slot-value v '%view) (cffi:null-pointer)))
    ;; Cancel the finalizer so GC won't try to free again
    (tg:cancel-finalization v)))

(defun fit-all (v &optional shape)
  "Fits all displayed objects into the view.

  If SHAPE is provided, fits the view to that specific shape.
  Returns the viewer on success, NIL if V is not a valid viewer.

  Example:
    (let ((v (make-viewer))
          (ctx (ais-create-context v))
          (box (ais-create-shape (make-box 10 20 30))))
      (ais-display ctx box)
      (fit-all v))"
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
  "Notifies the view that its window size has changed.

  Call this when the viewer's window is resized so the
  projection matrix is recalculated.

  Example:
    (let ((v (make-viewer)))
      (must-be-resized v)
      (free-viewer v))"
  (when (viewer-p v)
    (let ((view (%view v)))
      (when (and view (not (cffi:null-pointer-p view)))
        (%v3d-view-must-be-resized view)))))

;; --- AIS Context ---

(defclass ais-context ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun ais-context-p (v)
  "Returns T if V is an AIS-CONTEXT object.

  See also: ais-create-context, ais-free-context"
  (typep v 'ais-context))

(defun ais-create-context (viewer)
  "Creates an AIS context for the given VIEWER.

  The context is automatically finalized for garbage collection.
  Returns the context object, or NIL on failure.

  Example:
    (let ((v (make-viewer)))
      (ais-create-context v))"
  (when (viewer-p viewer)
    (let* ((ptr (%ais-create-context (%viewer viewer)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-context :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free-context obj))))
      obj)))

(defun ais-free-context (ctx)
  "Frees the AIS context and its OCCT resources.

  Safe to call multiple times.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v)))
      (ais-free-context ctx))"
  (when (ais-context-p ctx)
    (let ((ptr (%ptr ctx)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-free-context ptr)
        (setf (slot-value ctx '%ptr) (cffi:null-pointer))))))

;; --- AIS Object ---

(defclass ais-object ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun ais-object-p (v)
  "Returns T if V is an AIS-OBJECT object.

  See also: ais-create-shape, ais-free"
  (typep v 'ais-object))

(defun ais-create-shape (shape)
  "Wraps a shape into an AIS object for display.

  The AIS object is automatically finalized for garbage collection.
  Returns the AIS object, or NIL if SHAPE is invalid.

  Example:
    (ais-create-shape (make-box 10 20 30))"
  (when (and shape (shape-p shape))
    (let* ((ptr (%ais-create-shape (%ptr shape)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

(defun ais-free (obj)
  "Frees the AIS object and its underlying OCCT shape.

  Safe to call multiple times.

  Example:
    (let ((ais (ais-create-shape (make-box 10 20 30))))
      (ais-free ais))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-free-shape ptr)
        (setf (slot-value obj '%ptr) (cffi:null-pointer))))))

(defun ais-display (context shape-or-obj &key (update t))
  "Displays a shape or AIS object in the given context.

  If SHAPE-OR-OBJ is a raw shape, it is automatically wrapped
  in an AIS object first.  Returns the AIS object.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (make-box 10 20 30)))
      (ais-display ctx box)
      (fit-all v))"
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
  "Erases OBJ from the view without removing it from the context.

  The object can be redisplayed later.  When UPDATE is NIL,
  the view is not redrawn immediately.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape (make-box 10 20 30))))
      (ais-display ctx box)
      (ais-erase ctx box))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((obj-ptr (%ptr obj))
          (ctx-ptr (%ptr context)))
      (when (and obj-ptr ctx-ptr
                 (not (cffi:null-pointer-p obj-ptr))
                 (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-erase ctx-ptr obj-ptr (if update 1 0))))))

(defun ais-remove (context obj &key (update t))
  "Removes OBJ from the context entirely.

  Unlike erase, the object cannot be redisplayed without
  re-adding it to the context.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape (make-box 10 20 30))))
      (ais-display ctx box)
      (ais-remove ctx box))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((obj-ptr (%ptr obj))
          (ctx-ptr (%ptr context)))
      (when (and obj-ptr ctx-ptr
                 (not (cffi:null-pointer-p obj-ptr))
                 (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-remove ctx-ptr obj-ptr (if update 1 0))))))

(defun ais-remove-all (context &key (update t))
  "Removes all displayed objects from the context.

  Equivalent to calling ais-remove on every displayed object.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v)))
      (ais-display ctx (make-box 10 20 30))
      (ais-remove-all ctx))"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-remove-all ctx-ptr (if update 1 0))))))

(defun ais-displayed-p (context obj)
  "Returns T if OBJ is currently displayed in the given context.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape (make-box 10 20 30))))
      (ais-display ctx box)
      (ais-displayed-p ctx box))
    => T"
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

(defparameter *selection-scheme-map*
  '((:replace . 0) (:add . 1) (:remove . 2) (:xor . 3)
    (:clear . 4) (:replace-extra . 5)))

(defparameter *status-of-detection-map*
  '((:error . 0) (:nothing . 1) (:all-bad . 2) (:selected . 3)
    (:only-one-detected . 4) (:only-one-good . 5) (:several-good . 6)))

(defparameter *status-of-pick-map*
  '((:error . 0) (:nothing-selected . 1) (:removed . 2)
    (:one-selected . 3) (:several-selected . 4)))

(defun %lookup (key map)
  (cdr (assoc key map)))

;; --- Styling ---

(defun set-background (view r g b)
  "Sets the view background to a solid RGB color.

  Each of R, G, B should be in the range 0.0 to 1.0.
  Returns the color list.

  Example:
    (with-viewer (v)
      (set-background v 0.9 0.9 1.0))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-bg-color view-ptr
                                (coerce r 'double-float)
                                (coerce g 'double-float)
                                (coerce b 'double-float))))
    (list r g b)))

(defun ais-set-color (context obj color)
  "Sets the display color of an AIS object.

  COLOR is an RGB list (r g b) with each component in 0.0-1.0.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-display ctx (make-box 10 20 30))))
      (ais-set-color ctx box '(1.0 0.0 0.0)))"
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
  "Removes a custom color from an AIS object, reverting to default.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-display ctx (make-box 10 20 30))))
      (ais-set-color ctx box '(1.0 0.0 0.0))
      (ais-unset-color ctx box))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-unset-color ctx-ptr obj-ptr)))))

;; --- Display Mode ---

(defun ais-set-display-mode (context obj mode)
  "Sets the display mode for an AIS object.

  MODE is one of :WIREFRAME or :SHADED.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-display ctx (make-box 10 20 30))))
      (ais-set-display-mode ctx box :wireframe))"
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
  "Sets the view projection to a standard orientation.

  ORIENTATION is one of :X-POS, :Y-POS, :Z-POS, :X-NEG, :Y-NEG,
  :Z-NEG, or :ISO-PERS.

  Example:
    (with-viewer (v)
      (set-view-projection v :z-pos)
      (set-view-projection v :iso-pers))"
  (when (viewer-p view)
    (let ((orient-int (%lookup orientation *v3d-orientation-map*))
          (view-ptr (%view view)))
      (when (and orient-int view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-proj view-ptr orient-int)))))

;; --- MSAA ---

(defun set-msaa (view samples)
  "Sets the multisample anti-aliasing (MSAA) sample count.

  SAMPLES is typically 0 (off), 2, 4, or 8.

  Example:
    (with-viewer (v)
      (set-msaa v 4))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-msaa view-ptr samples)))))

(defun msaa (view)
  "Returns the current MSAA sample count for VIEW.

  Example:
    (with-viewer (v)
      (set-msaa v 4)
      (msaa v))
    => 4"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-get-msaa view-ptr)))))

;; --- Antialiasing ---

(defun set-antialiasing (view on)
  "Enables or disables anti-aliasing for VIEW.

  Example:
    (with-viewer (v)
      (set-antialiasing v t))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-antialiasing view-ptr (if on 1 0))))))

(defun antialiasing-p (view)
  "Returns T if anti-aliasing is enabled for VIEW.

  Example:
    (with-viewer (v)
      (set-antialiasing v t)
      (antialiasing-p v))
    => T"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (not (zerop (%v3d-view-get-antialiasing view-ptr)))))))

;; --- Grid ---

(defun activate-grid (viewer grid-type draw-mode)
  "Activates the grid for VIEWER with the given type and draw mode.

  Grid types: :RECTANGULAR, :CIRCULAR.
  Draw modes: :LINES, :POINTS.

  Example:
    (with-viewer (v)
      (activate-grid v :rectangular :lines))"
  (when (viewer-p viewer)
    (let ((gt-int (%lookup grid-type *grid-type-map*))
          (dm-int (%lookup draw-mode *grid-draw-mode-map*))
          (v3d-viewer (%viewer viewer)))
      (when (and gt-int dm-int
                 v3d-viewer
                 (not (cffi:null-pointer-p v3d-viewer)))
        (%v3d-viewer-activate-grid v3d-viewer gt-int dm-int)))))

(defun deactivate-grid (viewer)
  "Deactivates the grid for VIEWER.

  Example:
    (with-viewer (v)
      (activate-grid v :rectangular :lines)
      (deactivate-grid v))"
  (when (viewer-p viewer)
    (let ((v3d-viewer (%viewer viewer)))
      (when (and v3d-viewer (not (cffi:null-pointer-p v3d-viewer)))
        (%v3d-viewer-deactivate-grid v3d-viewer)))))

;; --- Invalidate ---

(defun invalidate-view (view)
  "Invalidates the view, forcing a redraw on the next frame.

  Example:
    (with-viewer (v)
      (invalidate-view v))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-invalidate view-ptr)))))

(defmacro with-viewer ((var) &body body)
  "Creates a viewer, executes BODY, and frees the viewer on exit.

  Guarantees cleanup via unwind-protect even if BODY signals
  an error or non-local exit.

  Example:
    (with-viewer (v)
      (let ((ctx (ais-create-context v)))
        (ais-display ctx (make-box 10 20 30))
        (fit-all v)))"
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
  "Creates a trihedron AIS object.

  ORIGIN is the position, NORMAL is the Z direction,
  X-DIRECTION defines the X axis.  All are 3-element
  coordinate lists.

  Example:
    (with-viewer (v)
      (let ((ctx (ais-create-context v))
            (tri (make-trihedron)))
        (ais-display ctx tri)))"
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
  "Sets the display mode of trihedron TRI.

  MODE is one of :WIREFRAME or :SHADED.

  Example:
    (set-trihedron-mode tri :shaded)"
  (when (ais-object-p tri)
    (let ((mode-int (%lookup mode *trihedron-datum-mode-map*))
          (ptr (%ptr tri)))
      (when (and mode-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-datum-mode ptr mode-int)))))

(defun set-trihedron-arrows (tri on)
  "Shows or hides arrow heads on the trihedron axes.

  Example:
    (set-trihedron-arrows tri nil)"
  (when (ais-object-p tri)
    (let ((ptr (%ptr tri)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-draw-arrows ptr (if on 1 0))))))

(defun set-trihedron-size (tri size)
  "Sets the size of the trihedron in pixels.

  Example:
    (set-trihedron-size tri 100)"
  (when (ais-object-p tri)
    (let ((ptr (%ptr tri)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-size ptr (coerce size 'double-float))))))

(defun set-trihedron-corner (tri corner &key (x-offset 50) (y-offset 50))
  "Positions the trihedron in a corner of the view.

  CORNER is one of :LOWER-LEFT, :UPPER-LEFT, :LOWER-RIGHT,
  :UPPER-RIGHT, or :CENTER.  Offsets are in pixels.

  Example:
    (set-trihedron-corner tri :upper-right :x-offset 10 :y-offset 10)"
  (when (ais-object-p tri)
    (let ((corner-int (%lookup corner *trihedron-corner-map*))
          (ptr (%ptr tri)))
      (when (and corner-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-trihedron-set-transform-pers ptr corner-int
                                           x-offset y-offset)))))

(defun set-trihedron-axis-colors (tri &key x y z)
  "Sets colors for the X, Y, and Z axes of the trihedron.

  Each color is an RGB list (r g b) or a single float gray value.

  Example:
    (set-trihedron-axis-colors tri :x '(1 0 0) :y '(0 1 0) :z '(0 0 1))"
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
  "Sets the text label color of the trihedron.

  COLOR is an RGB list (r g b) or a single float gray value.

  Example:
    (set-trihedron-text-color tri '(1 1 0))"
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

(defun set-trihedron-wireframe-color (tri color)
  "Sets the wireframe color of the trihedron.

  COLOR is an RGB list (r g b) or a single float gray value.

  Example:
    (set-trihedron-wireframe-color tri '(0.5 0.5 0.5))"
  (when (ais-object-p tri)
    (let ((rgb (normalize-color color))
          (ptr (%ptr tri)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-trihedron-set-wireframe-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        tri))))

(defun show-trihedron (context viewer &key (corner :lower-left) (size 50))
  "Creates, configures, and displays a trihedron in one call.

  CORNER positions the trihedron and SIZE controls its pixel size.

  Example:
    (with-viewer (v)
      (let ((ctx (ais-create-context v)))
        (show-trihedron ctx v :corner :upper-right :size 80)))"
  (let ((tri (make-trihedron)))
    (when tri
      (set-trihedron-corner tri corner :x-offset 50 :y-offset 50)
      (set-trihedron-size tri size)
      (ais-display context tri)
      tri)))

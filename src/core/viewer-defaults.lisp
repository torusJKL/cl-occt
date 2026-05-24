(in-package :cl-occt)

(defun set-default-bg-gradient (viewer color1 color2 &key (style :y-pos))
  "Sets a gradient background for all future views in VIEWER.

  COLOR1 and COLOR2 can be any color representation accepted by NORMALIZE-COLOR.
  STYLE is one of :X-POS, :X-NEG, :Y-POS, :Y-NEG, :Z-POS, :Z-NEG.

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-bg-gradient v :sky-blue :white :style :y-pos)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let* ((rgb1 (normalize-color color1))
           (rgb2 (normalize-color color2))
           (style-int (or (cdr (assoc style *gradient-style-map*)) 2))
           (v-ptr (%viewer viewer)))
      (when (and rgb1 rgb2 v-ptr (not (cffi:null-pointer-p v-ptr)))
        (destructuring-bind (r1 g1 b1) rgb1
          (destructuring-bind (r2 g2 b2) rgb2
            (%v3d-viewer-set-default-bg-gradient v-ptr
              (coerce r1 'double-float) (coerce g1 'double-float) (coerce b1 'double-float)
              (coerce r2 'double-float) (coerce g2 'double-float) (coerce b2 'double-float)
              style-int)))
        viewer))))

(defun set-default-background (viewer color)
  "Sets a solid background color for all future views in VIEWER.

  COLOR can be any color representation accepted by NORMALIZE-COLOR.

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-background v :navy)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let ((rgb (normalize-color color))
          (v-ptr (%viewer viewer)))
      (when (and rgb v-ptr (not (cffi:null-pointer-p v-ptr)))
        (destructuring-bind (r g b) rgb
          (%v3d-viewer-set-default-bg-color v-ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        viewer))))

(defun set-default-projection (viewer orientation)
  "Sets the default projection orientation for all future views.

  ORIENTATION is a keyword from the V3d orientation map (e.g. :XYPOS :ZPOS).

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-projection v :zpos)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let ((orient-int (cdr (assoc orientation *v3d-orientation-map*)))
          (v-ptr (%viewer viewer)))
      (when (and orient-int v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-proj v-ptr orient-int)
        viewer))))

(defun set-default-view-size (viewer size)
  "Sets the default view size (in model units) for all future views.

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-view-size v 500.0)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-size v-ptr (coerce size 'double-float))
        viewer))))

(defun default-lights (viewer)
  "Enables default lighting for VIEWER (equivalent to mode :ON).

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (default-lights v)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-lights v-ptr 1)
        viewer))))

(defun set-default-view-type (viewer type)
  "Sets the default view type for all future views.

  TYPE is either :PERSPECTIVE or :ORTHOGRAPHIC.

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-view-type v :perspective)
      (free-viewer v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-type v-ptr
          (if (eq type :perspective) 1 0))
        viewer))))

(defun set-default-gradient (viewer color1 color2 &key (style :y-pos))
  "Alias for SET-DEFAULT-BG-GRADIENT.

  Sets a gradient background for all future views in VIEWER.

  Example:
    (let ((v (make-viewer)))
      (set-default-gradient v :sky-blue :white)
      (free-viewer v))"
  (set-default-bg-gradient viewer color1 color2 :style style))

(defun set-default-lights (viewer mode)
  "Enables or disables default lighting for VIEWER.

  MODE is :ON (enables), :OFF (disables), or :CUSTOM (no-op, user manages lights).

  Returns the viewer on success, NIL otherwise.

  Example:
    (let ((v (make-viewer)))
      (set-default-lights v :on)
      (free-viewer v))"
  (when (viewer-p viewer)
    (ecase mode
      (:on (default-lights viewer))
      (:off
       (let ((v-ptr (%viewer viewer)))
         (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
           (%v3d-viewer-set-default-lights v-ptr 0)
           viewer)))
      (:custom viewer))))

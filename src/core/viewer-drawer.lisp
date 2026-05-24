(in-package :cl-occt)

(defparameter *line-type-map*
  '((:solid . 0) (:dash . 1) (:dot . 2) (:dot-dash . 3)))

(defparameter *marker-type-map*
  '((:point . 0) (:plus . 1) (:star . 2) (:o . 3) (:x . 4) (:ball . 5) (:ring . 6)))

;; --- Line aspect convenience ---

(defun ais-set-drawer-line-color (obj color)
  "Sets the line color of AIS object OBJ.

  COLOR can be any color representation accepted by NORMALIZE-COLOR.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-line-color box :red))"
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-line-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-line-width (obj width)
  "Sets the line width of AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-line-width box 2.0))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-line-width ptr (coerce width 'double-float))
        obj))))

(defun ais-set-drawer-line-type (obj type)
  "Sets the line type of AIS object OBJ.

  TYPE is :SOLID, :DASH, :DOT, or :DOT-DASH.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-line-type box :dash))"
  (when (ais-object-p obj)
    (let ((type-int (cdr (assoc type *line-type-map*)))
          (ptr (%ptr obj)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-line-type ptr type-int)
        obj))))

;; --- Shading aspect convenience ---

(defun ais-set-drawer-shading-color (obj color)
  "Sets the shading (fill) color of AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-shading-color box :blue))"
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-shading-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

;; --- Point aspect convenience ---

(defun ais-set-drawer-point-color (obj color)
  "Sets the point color of AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-point-color box :yellow))"
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-point-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-point-type (obj type)
  "Sets the point marker type of AIS object OBJ.

  TYPE is :POINT, :PLUS, :STAR, :O, :X, :BALL, or :RING.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-point-type box :star))"
  (when (ais-object-p obj)
    (let ((type-int (cdr (assoc type *marker-type-map*)))
          (ptr (%ptr obj)))
      (when (and type-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-point-type ptr type-int)
        obj))))

(defun ais-set-drawer-point-scale (obj scale)
  "Sets the point marker scale for AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-point-scale box 2.0))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-point-scale ptr (coerce scale 'double-float))
        obj))))

;; --- Text aspect convenience ---

(defun ais-set-drawer-text-color (obj color)
  "Sets the text color of AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-text-color box :white))"
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-text-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

(defun ais-set-drawer-text-font (obj font)
  "Sets the text font of AIS object OBJ.

  FONT is a string naming a font (e.g. \"Arial\").

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-text-font box \"Arial\"))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-text-font ptr font)
        obj))))

(defun ais-set-drawer-text-height (obj height)
  "Sets the text height for AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-text-height box 12.0))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-text-height ptr (coerce height 'double-float))
        obj))))

;; --- Iso-line display ---

(defun ais-set-drawer-iso-display (obj &key (u-on t) (v-on t))
  "Enables or disables iso-line display for AIS object OBJ.

  U-ON controls U-direction lines, V-ON controls V-direction lines.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-iso-display box :u-on t :v-on nil))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-iso-display ptr (if u-on 1 0) (if v-on 1 0))
        obj))))

;; --- Wire aspect convenience ---

(defun ais-set-drawer-wire-color (obj color)
  "Sets the wireframe color of AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-wire-color box :green))"
  (when (ais-object-p obj)
    (let ((rgb (normalize-color color))
          (ptr (%ptr obj)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%ais-object-set-wire-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        obj))))

;; --- Boundary toggle convenience ---

(defun ais-set-drawer-face-boundaries (obj on)
  "Shows or hides face boundary edges for AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-face-boundaries box t))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-face-boundary-draw ptr (if on 1 0))
        obj))))

(defun ais-set-drawer-free-boundaries (obj on)
  "Shows or hides free boundary edges for AIS object OBJ.

  Returns OBJ on success, NIL otherwise.

  Example:
    (let* ((v (make-viewer))
           (ctx (ais-create-context v))
           (box (ais-create-shape ctx (make-box 10 20 30))))
      (ais-set-drawer-free-boundaries box t))"
  (when (ais-object-p obj)
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-object-set-free-boundary-draw ptr (if on 1 0))
        obj))))

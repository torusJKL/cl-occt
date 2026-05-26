(in-package :cl-occt)

;; --- AIS_ColoredShape ---

(defun make-colored-shape (shape)
  "Creates an AIS colored shape with per-subshape color support.

  **shape** is a shape object. Returns an `ais-object` or nil.

  **Example:**
    (let ((cs (make-colored-shape (make-box 10 20 30))))
      (ais-display ctx cs))"
  (when (shape-p shape)
    (let* ((ptr (%ais-create-colored-shape (%ptr shape)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

(defun set-colored-shape-color (colored-shape sub-shape color)
  "Sets the color of a sub-shape within a colored shape.

  **colored-shape** is an ais-object created by `make-colored-shape`.
  **sub-shape** is a shape within the original shape.
  **color** is an RGB list (r g b).

  **Example:**
    (set-colored-shape-color cs (nth-face box 1) '(1 0 0))"
  (when (ais-object-p colored-shape)
    (let ((ptr (%ptr colored-shape))
          (sub-ptr (and (shape-p sub-shape) (%ptr sub-shape))))
      (when (and ptr sub-ptr (not (cffi:null-pointer-p ptr))
                 (not (cffi:null-pointer-p sub-ptr)))
        (destructuring-bind (r g b) color
          (%ais-colored-shape-set-color ptr sub-ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))))))

;; --- AIS_Manipulator ---

(defun make-manipulator ()
  "Creates an interactive manipulator gizmo for transforming shapes.

  Returns an `ais-object` or nil.

  **Example:**
    (let ((manip (make-manipulator)))
      (attach-manipulator manip my-shape)
      (ais-display ctx manip))"
  (let* ((ptr (%ais-create-manipulator))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'ais-object :ptr ptr))))
    (when obj
      (tg:finalize obj (lambda () (ais-free obj))))
    obj))

(defun attach-manipulator (manipulator shape)
  "Attaches **manipulator** to **shape** so that transformations
  applied through the gizmo affect the shape.

  **Example:**
    (attach-manipulator manip (make-box 10 20 30))"
  (when (and (ais-object-p manipulator) (shape-p shape))
    (let ((m-ptr (%ptr manipulator))
          (s-ptr (%ptr shape)))
      (when (and m-ptr s-ptr
                 (not (cffi:null-pointer-p m-ptr))
                 (not (cffi:null-pointer-p s-ptr)))
        (%ais-manipulator-attach m-ptr s-ptr)))))

(defun set-manipulator-position (manipulator x y z)
  "Sets the position of **manipulator** in world coordinates.

  **Example:**
    (set-manipulator-position manip 10 20 30)"
  (when (ais-object-p manipulator)
    (let ((ptr (%ptr manipulator)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-manipulator-set-position ptr
          (coerce x 'double-float)
          (coerce y 'double-float)
          (coerce z 'double-float))))))

(defun set-manipulator-size (manipulator size)
  "Sets the visual size of **manipulator**.

  **Example:**
    (set-manipulator-size manip 50.0)"
  (when (ais-object-p manipulator)
    (let ((ptr (%ptr manipulator)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-manipulator-set-size ptr (coerce size 'double-float))))))

(defun set-manipulator-active-axes (manipulator &key (translate t) (rotate t) (scale t))
  "Enables or disables the translation, rotation, and scaling modes
  of the manipulator.

  Each keyword is a boolean. Disabled modes are hidden from the gizmo.

  **Example:**
    (set-manipulator-active-axes manip :translate t :rotate nil :scale nil)"
  (when (ais-object-p manipulator)
    (let ((ptr (%ptr manipulator)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-manipulator-set-active-axes ptr
          (if translate 1 0)
          (if rotate 1 0)
          (if scale 1 0))))))

;; --- AIS_ConnectedInteractive ---

(defun make-connected-interactive (source)
  "Creates a connected interactive object that shares geometry
  from **source** (an ais-object).

  Returns an `ais-object` or nil.

  **Example:**
    (let ((copy (make-connected-interactive original)))
      (ais-display ctx copy))"
  (when (ais-object-p source)
    (let* ((ptr (%ais-create-connected (%ptr source)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

;; --- AIS_PointCloud ---

(defun make-point-cloud (vertices)
  "Creates a point cloud from a list of (x y z) coordinate triples.

  Returns an `ais-object` or nil.

  **Example:**
    (make-point-cloud '((0 0 0) (1 0 0) (0 1 0) (0 0 1)))"
  (when (and vertices (listp vertices) (> (length vertices) 0))
    (let* ((count (length vertices))
           (arr (make-array (* 3 count) :element-type 'double-float
                            :initial-contents (loop for (x y z) in vertices
                                                    collect (coerce x 'double-float)
                                                    collect (coerce y 'double-float)
                                                    collect (coerce z 'double-float))))
           (c-arr (cffi:foreign-alloc :double :initial-contents arr))
           (ptr (%ais-create-point-cloud c-arr count))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (cffi:foreign-free c-arr)
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

(defun set-point-cloud-colors (point-cloud colors)
  "Sets per-point colors for **point-cloud**.

  **colors** is a list of (r g b) triples, one per point.

  **Example:**
    (set-point-cloud-colors pc '((1 0 0) (0 1 0) (0 0 1) (1 1 0)))"
  (when (ais-object-p point-cloud)
    (let* ((count (length colors))
           (arr (make-array (* 3 count) :element-type 'double-float
                            :initial-contents (loop for (r g b) in colors
                                                    collect (coerce r 'double-float)
                                                    collect (coerce g 'double-float)
                                                    collect (coerce b 'double-float))))
           (c-arr (cffi:foreign-alloc :double :initial-contents arr)))
      (%ais-point-cloud-set-colors (%ptr point-cloud) c-arr count)
      (cffi:foreign-free c-arr))))

(defun set-point-cloud-size (point-cloud size)
  "Sets the rendered point size in pixels for **point-cloud**.

  **Example:**
    (set-point-cloud-size pc 5)"
  (when (ais-object-p point-cloud)
    (let ((ptr (%ptr point-cloud)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-point-cloud-set-size ptr (coerce size 'double-float))))))

;; --- AIS_Triangulation ---

(defun make-ais-triangulation (vertices triangles &key colors)
  "Creates a colored mesh from vertex and triangle index arrays.

  **vertices** is a list of (x y z) triples.
  **triangles** is a list of (i0 i1 i2) 0-based index triples.
  **colors** when provided is a list of (r g b) triples, one per vertex.

  Returns an `ais-object` or nil.

  **Example:**
    (make-ais-triangulation '((0 0 0) (1 0 0) (0 1 0) (0 0 1))
                            '((0 1 2) (0 2 3)))"
  (when (and vertices triangles
             (> (length vertices) 0) (> (length triangles) 0))
    (let* ((vcount (length vertices))
           (tcount (length triangles))
           (v-arr (make-array (* 3 vcount) :element-type 'double-float
                              :initial-contents (loop for (x y z) in vertices
                                                      collect (coerce x 'double-float)
                                                      collect (coerce y 'double-float)
                                                      collect (coerce z 'double-float))))
           (t-arr (make-array (* 3 tcount) :element-type '(signed-byte 32)
                              :initial-contents (loop for (i0 i1 i2) in triangles
                                                      collect i0 collect i1 collect i2)))
           (c-varr (cffi:foreign-alloc :double :initial-contents v-arr))
           (c-tarr (cffi:foreign-alloc :int :initial-contents t-arr))
           (c-carr (when colors
                     (let ((c-arr (make-array (* 3 vcount) :element-type 'double-float
                                              :initial-contents (loop for (r g b) in colors
                                                                      collect (coerce r 'double-float)
                                                                      collect (coerce g 'double-float)
                                                                      collect (coerce b 'double-float)))))
                       (cffi:foreign-alloc :double :initial-contents c-arr))))
           (ptr (%ais-create-triangulation c-varr vcount c-tarr tcount
                                           (or c-carr (cffi:null-pointer))))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (cffi:foreign-free c-varr)
      (cffi:foreign-free c-tarr)
      (when c-carr (cffi:foreign-free c-carr))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

;; --- AIS_Plane ---

(defun make-ais-plane (position normal &key (size 100.0))
  "Creates an AIS plane overlay at **position** with given **normal**.

  **position** and **normal** are 3-element coordinate lists.

  **Example:**
    (make-ais-plane '(0 0 0) '(0 0 1) :size 200)"
  (destructuring-bind (ox oy oz) position
    (destructuring-bind (nx ny nz) normal
      (let* ((ptr (%ais-create-plane
                   (coerce ox 'double-float)
                   (coerce oy 'double-float)
                   (coerce oz 'double-float)
                   (coerce nx 'double-float)
                   (coerce ny 'double-float)
                   (coerce nz 'double-float)
                   (coerce size 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'ais-object :ptr ptr))))
        (when obj
          (tg:finalize obj (lambda () (ais-free obj))))
        obj))))

;; --- AIS_Axis ---

(defun make-ais-axis (origin direction)
  "Creates an AIS axis overlay from **origin** point and **direction**.

  Both are 3-element coordinate lists.

  **Example:**
    (make-ais-axis '(0 0 0) '(1 0 0))"
  (destructuring-bind (ox oy oz) origin
    (destructuring-bind (dx dy dz) direction
      (let* ((ptr (%ais-create-axis
                   (coerce ox 'double-float)
                   (coerce oy 'double-float)
                   (coerce oz 'double-float)
                   (coerce dx 'double-float)
                   (coerce dy 'double-float)
                   (coerce dz 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'ais-object :ptr ptr))))
        (when obj
          (tg:finalize obj (lambda () (ais-free obj))))
        obj))))

;; --- AIS_Line ---

(defun make-ais-line (point1 point2)
  "Creates an AIS line segment between two 3D points.

  Each is a 3-element coordinate list.

  **Example:**
    (make-ais-line '(0 0 0) '(100 0 0))"
  (destructuring-bind (x1 y1 z1) point1
    (destructuring-bind (x2 y2 z2) point2
      (let* ((ptr (%ais-create-line
                   (coerce x1 'double-float)
                   (coerce y1 'double-float)
                   (coerce z1 'double-float)
                   (coerce x2 'double-float)
                   (coerce y2 'double-float)
                   (coerce z2 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'ais-object :ptr ptr))))
        (when obj
          (tg:finalize obj (lambda () (ais-free obj))))
        obj))))

;; --- AIS_Circle ---

(defun make-ais-circle (center normal radius)
  "Creates an AIS circle overlay at **center** with given **normal**
  and **radius**.

  **center** and **normal** are 3-element coordinate lists.

  **Example:**
    (make-ais-circle '(0 0 0) '(0 0 1) 50.0)"
  (destructuring-bind (cx cy cz) center
    (destructuring-bind (nx ny nz) normal
      (let* ((ptr (%ais-create-circle
                   (coerce cx 'double-float)
                   (coerce cy 'double-float)
                   (coerce cz 'double-float)
                   (coerce nx 'double-float)
                   (coerce ny 'double-float)
                   (coerce nz 'double-float)
                   (coerce radius 'double-float)))
             (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                    (make-instance 'ais-object :ptr ptr))))
        (when obj
          (tg:finalize obj (lambda () (ais-free obj))))
        obj))))

;; --- AIS_TexturedShape ---

(defun make-textured-shape (shape texture-filename)
  "Creates a textured shape with an image applied as a texture.

  **shape** is a shape object. **texture-filename** is a string path.

  Returns an `ais-object` or nil.

  **Example:**
    (make-textured-shape (make-box 10 20 30) \"/path/to/texture.png\")"
  (when (shape-p shape)
    (let* ((ptr (%ais-create-textured-shape (%ptr shape) texture-filename))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

(defun set-texture-repeat (textured-shape u v)
  "Sets the texture repeat count in U and V directions.

  **Example:**
    (set-texture-repeat ts 2.0 2.0)"
  (when (ais-object-p textured-shape)
    (let ((ptr (%ptr textured-shape)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-textured-shape-set-repeat ptr
          (coerce u 'double-float)
          (coerce v 'double-float))))))

(defun set-texture-origin (textured-shape u v)
  "Sets the texture mapping origin offset in UV space.

  **Example:**
    (set-texture-origin ts 0.5 0.5)"
  (when (ais-object-p textured-shape)
    (let ((ptr (%ptr textured-shape)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-textured-shape-set-origin ptr
          (coerce u 'double-float)
          (coerce v 'double-float))))))

;; --- AIS_ViewCube ---

(defun make-view-cube ()
  "Creates a 3D orientation cube widget.

  Returns an `ais-object` or nil.

  **Example:**
    (let ((vc (make-view-cube)))
      (ais-display ctx vc))"
  (let* ((ptr (%ais-create-view-cube))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'ais-object :ptr ptr))))
    (when obj
      (tg:finalize obj (lambda () (ais-free obj))))
    obj))

(defun set-view-cube-size (view-cube size)
  "Sets the size of the view cube.

  **Example:**
    (set-view-cube-size vc 60.0)"
  (when (ais-object-p view-cube)
    (let ((ptr (%ptr view-cube)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-view-cube-set-size ptr (coerce size 'double-float))))))

(defun set-view-cube-box-color (view-cube color)
  "Sets the face color of the view cube.

  **color** is an RGB list (r g b).

  **Example:**
    (set-view-cube-box-color vc '(0.8 0.8 1.0))"
  (when (ais-object-p view-cube)
    (let ((ptr (%ptr view-cube)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) color
          (%ais-view-cube-set-box-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))))))

(defparameter *view-cube-corner-map*
  '((:lower-left   . 0)
    (:upper-left   . 1)
    (:lower-right  . 2)
    (:upper-right  . 3)
    (:center       . 4)))

(defun set-view-cube-corner (view-cube corner)
  "Positions the view cube in a corner of the view.

  **corner** is one of `:lower-left`, `:upper-left`, `:lower-right`,
  `:upper-right`, or `:center`.

  **Example:**
    (set-view-cube-corner vc :upper-right)"
  (when (ais-object-p view-cube)
    (let ((corner-int (cdr (assoc corner *view-cube-corner-map*)))
          (ptr (%ptr view-cube)))
      (when (and corner-int ptr (not (cffi:null-pointer-p ptr)))
        (%ais-view-cube-set-corner ptr corner-int)))))

;; --- AIS_ColorScale ---

(defun make-color-scale ()
  "Creates a color scale legend bar widget.

  Returns an `ais-object` or nil. Note that the color scale
  requires explicit size via `set-color-scale-size` before display.

  **Example:**
    (let ((cs (make-color-scale)))
      (set-color-scale-range cs 0.0 100.0)
      (set-color-scale-size cs 50 200)
      (set-color-scale-title cs \"Temperature\")
      (ais-display ctx cs))"
  (let* ((ptr (%ais-create-color-scale))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'ais-object :ptr ptr))))
    (when obj
      (tg:finalize obj (lambda () (ais-free obj))))
    obj))

(defun set-color-scale-range (color-scale min max)
  "Sets the value range of the color scale.

  **Example:**
    (set-color-scale-range cs 0.0 100.0)"
  (when (ais-object-p color-scale)
    (let ((ptr (%ptr color-scale)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-color-scale-set-range ptr
          (coerce min 'double-float)
          (coerce max 'double-float))))))

(defun set-color-scale-size (color-scale width height)
  "Sets the display dimensions of the color scale in pixels.

  **Example:**
    (set-color-scale-size cs 50 200)"
  (when (ais-object-p color-scale)
    (let ((ptr (%ptr color-scale)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-color-scale-set-size ptr
          (coerce width 'double-float)
          (coerce height 'double-float))))))

(defun set-color-scale-title (color-scale title)
  "Sets the title text of the color scale.

  **Example:**
    (set-color-scale-title cs \"Pressure\")"
  (when (ais-object-p color-scale)
    (let ((ptr (%ptr color-scale)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-color-scale-set-title ptr title)))))

(defun set-color-scale-intervals (color-scale n)
  "Sets the number of color intervals in the scale.

  **Example:**
    (set-color-scale-intervals cs 10)"
  (when (ais-object-p color-scale)
    (let ((ptr (%ptr color-scale)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-color-scale-set-intervals ptr n)))))

;; --- AIS_LightSource ---

(defun make-light-source (light)
  "Creates an interactive light source representation from a
  `viewer-light` object.

  Returns an `ais-object` or nil.

  **Example:**
    (let* ((l (make-light :directional :direction '(1 -1 0)))
           (ls (make-light-source l)))
      (ais-display ctx ls))"
  (when (and light (typep light 'viewer-light))
    (let* ((lptr (%ptr light))
           (ptr (when (and lptr (not (cffi:null-pointer-p lptr)))
                  (%ais-create-light-source lptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-object :ptr ptr))))
      (when obj
        (tg:finalize obj (lambda () (ais-free obj))))
      obj)))

;; --- AIS_MultipleConnectedInteractive ---

(defun make-multiple-connected ()
  "Creates a multiple-connected interactive object that composites
  one or more source AIS objects.

  Returns an `ais-object` or nil.

  **Example:**
    (let ((mc (make-multiple-connected)))
      (connect-to-multiple mc obj1)
      (connect-to-multiple mc obj2)
      (ais-display ctx mc))"
  (let* ((ptr (%ais-create-multiple-connected))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'ais-object :ptr ptr))))
    (when obj
      (tg:finalize obj (lambda () (ais-free obj))))
    obj))

(defun connect-to-multiple (multiple-obj source)
  "Connects **source** (an ais-object) to the multiple-connected object.

  **Example:**
    (connect-to-multiple mc (make-connected-interactive original))"
  (when (and (ais-object-p multiple-obj) (ais-object-p source))
    (let ((m-ptr (%ptr multiple-obj))
          (s-ptr (%ptr source)))
      (when (and m-ptr s-ptr
                 (not (cffi:null-pointer-p m-ptr))
                 (not (cffi:null-pointer-p s-ptr)))
        (%ais-multiple-connected-connect m-ptr s-ptr)))))

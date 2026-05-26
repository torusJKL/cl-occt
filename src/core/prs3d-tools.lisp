(in-package :cl-occt)

;; --- prs3d-triangulation CLOS class ---

(defclass prs3d-triangulation ()
  ((%ptr :initarg :ptr :reader %ptr)
   (%vertex-count-cache :initform nil)
   (%triangle-count-cache :initform nil))
  (:documentation "Wraps a Prs3d triangulation handle with GC via tg:finalize."))

(defun free-prs3d-triangulation (obj)
  "Explicitly free a prs3d-triangulation's C handle. Safe to call on nil."
  (when (and obj (typep obj 'prs3d-triangulation))
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prs3d-triangulation-free ptr)))))

(defun %make-prs3d-triangulation (ptr)
  (when (or (null ptr) (cffi:null-pointer-p ptr))
    (return-from %make-prs3d-triangulation nil))
  (let ((obj (make-instance 'prs3d-triangulation :ptr ptr)))
    (tg:finalize obj (lambda () (free-prs3d-triangulation obj)))
    obj))

(defun prs3d-triangulation-vertex-count (obj)
  "Return the number of vertices in a prs3d-triangulation, or nil."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (%prs3d-triangulation-vertex-count (%ptr obj))))

(defun prs3d-triangulation-triangle-count (obj)
  "Return the number of triangles in a prs3d-triangulation, or nil."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (%prs3d-triangulation-triangle-count (%ptr obj))))

(defun prs3d-triangulation-has-normals (obj)
  "Return t if normals are available, nil otherwise."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (not (zerop (%prs3d-triangulation-has-normals (%ptr obj))))))

(defun prs3d-triangulation-vertices (obj)
  "Return vertex positions as list of (x y z) triples, or nil."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (let* ((count (prs3d-triangulation-vertex-count obj))
           (arr (cffi:foreign-alloc :double :count (* count 3))))
      (unwind-protect
           (progn
             (%prs3d-triangulation-get-vertices (%ptr obj) arr count)
             (loop for i from 0 below count
                   collect (list (cffi:mem-aref arr :double (+ (* i 3) 0))
                                 (cffi:mem-aref arr :double (+ (* i 3) 1))
                                 (cffi:mem-aref arr :double (+ (* i 3) 2)))))
        (cffi:foreign-free arr)))))

(defun prs3d-triangulation-normals (obj)
  "Return vertex normals as list of (nx ny nz) triples, or nil."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (let* ((count (prs3d-triangulation-vertex-count obj))
           (arr (cffi:foreign-alloc :double :count (* count 3))))
      (unwind-protect
           (progn
             (%prs3d-triangulation-get-normals (%ptr obj) arr count)
             (loop for i from 0 below count
                   collect (list (cffi:mem-aref arr :double (+ (* i 3) 0))
                                 (cffi:mem-aref arr :double (+ (* i 3) 1))
                                 (cffi:mem-aref arr :double (+ (* i 3) 2)))))
        (cffi:foreign-free arr)))))

(defun prs3d-triangulation-triangles (obj)
  "Return triangle indices as list of (i0 i1 i2) 0-based triples, or nil."
  (when (and (typep obj 'prs3d-triangulation) (%ptr obj))
    (let* ((count (prs3d-triangulation-triangle-count obj))
           (arr (cffi:foreign-alloc :int :count (* count 3))))
      (unwind-protect
           (progn
             (%prs3d-triangulation-get-triangles (%ptr obj) arr count)
             (loop for i from 0 below count
                   collect (list (cffi:mem-aref arr :int (+ (* i 3) 0))
                                 (cffi:mem-aref arr :int (+ (* i 3) 1))
                                 (cffi:mem-aref arr :int (+ (* i 3) 2)))))
        (cffi:foreign-free arr)))))

;; --- Mesh Generators ---

(defun make-prs3d-cylinder-mesh (radius height &key (n-slices 32) (n-stacks 16))
  "Generate a triangulated cylinder mesh via Prs3d_ToolCylinder.
  Returns a `prs3d-triangulation` or nil on invalid parameters."
  (when (and (numberp radius) (> radius 0)
             (numberp height) (> height 0))
    (%make-prs3d-triangulation
     (%prs3d-tool-cylinder (coerce radius 'double-float)
                           (coerce height 'double-float)
                           n-slices n-stacks))))

(defun make-prs3d-sphere-mesh (radius &key (n-slices 32) (n-stacks 16))
  "Generate a triangulated sphere mesh via Prs3d_ToolSphere.
  Returns a `prs3d-triangulation` or nil on invalid parameters."
  (when (and (numberp radius) (> radius 0))
    (%make-prs3d-triangulation
     (%prs3d-tool-sphere (coerce radius 'double-float) n-slices n-stacks))))

(defun make-prs3d-torus-mesh (major-radius minor-radius &key (n-slices 32) (n-stacks 16))
  "Generate a triangulated torus mesh via Prs3d_ToolTorus.
  Returns a `prs3d-triangulation` or nil on invalid parameters."
  (when (and (numberp major-radius) (> major-radius 0)
             (numberp minor-radius) (> minor-radius 0))
    (%make-prs3d-triangulation
     (%prs3d-tool-torus (coerce major-radius 'double-float)
                        (coerce minor-radius 'double-float)
                        n-slices n-stacks))))

(defun make-prs3d-disk-mesh (inner-radius outer-radius &key (n-slices 32) (n-stacks 16))
  "Generate a triangulated disk or annular mesh via Prs3d_ToolDisk.
  Returns a `prs3d-triangulation` or nil on invalid parameters.
  inner-radius=0 creates a filled disk; inner-radius>0 creates an annulus."
  (when (and (numberp outer-radius) (> outer-radius 0)
             (numberp inner-radius) (>= inner-radius 0)
             (< inner-radius outer-radius))
    (%make-prs3d-triangulation
     (%prs3d-tool-disk (coerce inner-radius 'double-float)
                       (coerce outer-radius 'double-float)
                       n-slices n-stacks))))

;; --- Prs3d Primitives ---

(defun make-prs3d-arrow (start end &key (shaft-radius 1.0) (cone-length 3.0)
                                           (cone-radius 2.0) (n-facets 16))
  "Generate an arrow triangulation (shaft + cone head).
  **start** and **end** are (x y z) points.
  Returns a `prs3d-triangulation` or nil on invalid parameters."
  (when (and (listp start) (= (length start) 3)
             (listp end) (= (length end) 3))
    (destructuring-bind (sx sy sz) (mapcar (lambda (v) (coerce v 'double-float)) start)
      (destructuring-bind (ex ey ez) (mapcar (lambda (v) (coerce v 'double-float)) end)
        (%make-prs3d-triangulation
         (%prs3d-arrow sx sy sz ex ey ez
                       (coerce shaft-radius 'double-float)
                       (coerce cone-length 'double-float)
                       (coerce cone-radius 'double-float)
                       n-facets))))))

;; --- prs3d-segments (used by BndBox and other wireframe display) ---

(defclass prs3d-segments ()
  ((%ptr :initarg :ptr :reader %ptr))
  (:documentation "Wraps a Prs3d line segments handle with GC via tg:finalize."))

(defun free-prs3d-segments (obj)
  "Explicitly free a prs3d-segments C handle. Safe to call on nil."
  (when (and obj (typep obj 'prs3d-segments))
    (let ((ptr (%ptr obj)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%prs3d-segments-free ptr)))))

(defun %make-prs3d-segments (ptr)
  (when (or (null ptr) (cffi:null-pointer-p ptr))
    (return-from %make-prs3d-segments nil))
  (let ((obj (make-instance 'prs3d-segments :ptr ptr)))
    (tg:finalize obj (lambda () (free-prs3d-segments obj)))
    obj))

(defun prs3d-segments-p (obj)
  "**Returns:** `t` if **obj** is a `prs3d-segments` object."
  (typep obj 'prs3d-segments))

(defun prs3d-segments-vertex-count (obj)
  "Return the number of vertices in a prs3d-segments, or nil."
  (when (and (typep obj 'prs3d-segments) (%ptr obj))
    (%prs3d-segments-vertex-count (%ptr obj))))

(defun prs3d-segments-edge-count (obj)
  "Return the number of edges in a prs3d-segments, or nil."
  (when (and (typep obj 'prs3d-segments) (%ptr obj))
    (%prs3d-segments-edge-count (%ptr obj))))

(defun prs3d-segments-vertices (obj)
  "Return vertex positions as list of (x y z) triples, or nil."
  (when (and (typep obj 'prs3d-segments) (%ptr obj))
    (let* ((count (prs3d-segments-vertex-count obj))
           (arr (cffi:foreign-alloc :double :count (* count 3))))
      (unwind-protect
           (progn
             (%prs3d-segments-get-vertices (%ptr obj) arr count)
             (loop for i from 0 below count
                   collect (list (cffi:mem-aref arr :double (+ (* i 3) 0))
                                 (cffi:mem-aref arr :double (+ (* i 3) 1))
                                 (cffi:mem-aref arr :double (+ (* i 3) 2)))))
        (cffi:foreign-free arr)))))

(defun prs3d-segments-edges (obj)
  "Return edge indices as list of (i0 i1) pairs (0-based vertex indices), or nil."
  (when (and (typep obj 'prs3d-segments) (%ptr obj))
    (let* ((count (prs3d-segments-edge-count obj))
           (arr (cffi:foreign-alloc :int :count (* count 2))))
      (unwind-protect
           (progn
             (%prs3d-segments-get-edges (%ptr obj) arr count)
             (loop for i from 0 below count
                   collect (list (cffi:mem-aref arr :int (+ (* i 2) 0))
                                 (cffi:mem-aref arr :int (+ (* i 2) 1)))))
        (cffi:foreign-free arr)))))

;; --- BndBox ---

(defun make-prs3d-bndbox (min-corner max-corner)
  "Generate a bounding box display (line segments) from corner points.
  **min-corner** and **max-corner** are (x y z) lists.
  Returns a `prs3d-segments` or nil."
  (when (and (listp min-corner) (= (length min-corner) 3)
             (listp max-corner) (= (length max-corner) 3))
    (destructuring-bind (xmin ymin zmin) (mapcar (lambda (v) (coerce v 'double-float)) min-corner)
      (destructuring-bind (xmax ymax zmax) (mapcar (lambda (v) (coerce v 'double-float)) max-corner)
        (%make-prs3d-segments
         (%prs3d-bndbox xmin ymin zmin xmax ymax zmax))))))

(defun shape-bounding-box-display (shape)
  "Compute the bounding box of a shape and return it as a `prs3d-segments`.
  Returns nil on nil shape or computation failure."
  (when (shape-p shape)
    (let* ((ptr (%ptr shape))
           (xmin (cffi:foreign-alloc :double))
           (ymin (cffi:foreign-alloc :double))
           (zmin (cffi:foreign-alloc :double))
           (xmax (cffi:foreign-alloc :double))
           (ymax (cffi:foreign-alloc :double))
           (zmax (cffi:foreign-alloc :double)))
      (unwind-protect
           (when (and ptr (not (cffi:null-pointer-p ptr))
                      (= 1 (%shape-bounding-box ptr xmin ymin zmin xmax ymax zmax)))
             (make-prs3d-bndbox (list (cffi:mem-aref xmin :double)
                                      (cffi:mem-aref ymin :double)
                                      (cffi:mem-aref zmin :double))
                                (list (cffi:mem-aref xmax :double)
                                      (cffi:mem-aref ymax :double)
                                      (cffi:mem-aref zmax :double))))
        (cffi:foreign-free xmin)
        (cffi:foreign-free ymin)
        (cffi:foreign-free zmin)
        (cffi:foreign-free xmax)
        (cffi:foreign-free ymax)
        (cffi:foreign-free zmax)))))

(defun prs3d-triangulation-p (obj)
  "Predicate: returns t for prs3d-triangulation instances."
  (typep obj 'prs3d-triangulation))

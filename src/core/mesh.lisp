(in-package :cl-occt)

;; --- BRepMesh_IncrementalMesh ---

(defun mesh-shape (shape &key (deflection 0.1d0) (angle 0.5d0) (relative nil))
  "Explicitly triangulate (mesh) a **shape** using BRepMesh_IncrementalMesh.

  **deflection** controls tessellation quality (smaller = finer mesh).
  **angle** controls the angular deviation in radians (default 0.5).
  **relative** when non-nil uses relative deflection mode.

  Returns the shape for chaining, or nil on invalid input.

  **Example:**

      (mesh-shape (make-box 10 20 30) :deflection 0.05 :angle 0.2)

  **See also:** `mesh-get-vertices`, `mesh-get-triangles`, `write-stl`"
  (unless (shape-p shape)
    (return-from mesh-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from mesh-shape nil))
    (%mesh-shape ptr
                 (coerce deflection 'double-float)
                 (coerce angle 'double-float)
                 (if relative 1 0))
    shape))

;; --- Poly_Triangulation Data Extraction ---

(defun mesh-get-vertices (shape)
  "Return a list of vertex `(x y z)` triples from **shape**'s triangulation.

  Returns nil if shape has no triangulation or is invalid.

  **Example:**

      (mesh-get-vertices (mesh-shape (make-box 10 20 30)))

  **See also:** `mesh-shape`, `mesh-get-triangles`, `mesh-get-normals`"
  (unless (shape-p shape)
    (return-from mesh-get-vertices nil))
  (let* ((count (%mesh-get-triangle-count (%ptr shape)))
         (vert-capacity (* (max 100 count) 3))
         (verts (cffi:foreign-alloc :double :count vert-capacity)))
    (unwind-protect
         (let ((n (%mesh-get-vertices (%ptr shape) verts vert-capacity)))
           (when (> n 0)
             (loop for i from 0 below n by 3
                   collect (list (cffi:mem-aref verts :double i)
                                 (cffi:mem-aref verts :double (1+ i))
                                 (cffi:mem-aref verts :double (+ i 2))))))
      (cffi:foreign-free verts))))

(defun mesh-get-triangles (shape)
  "Return a list of triangle index triples `(i0 i1 i2)` from **shape**'s triangulation.

  Indices are 0-based and reference the vertex list from `mesh-get-vertices`.

  Returns nil if shape has no triangulation or is invalid.

  **Example:**

      (mesh-get-triangles (mesh-shape (make-box 10 20 30)))

  **See also:** `mesh-shape`, `mesh-get-vertices`, `mesh-get-normals`"
  (unless (shape-p shape)
    (return-from mesh-get-triangles nil))
  (let* ((count (%mesh-get-triangle-count (%ptr shape)))
         (tri-capacity (* (max 100 count) 3))
         (tris (cffi:foreign-alloc :int :count tri-capacity)))
    (unwind-protect
         (let ((n (%mesh-get-triangles (%ptr shape) tris tri-capacity)))
           (when (> n 0)
             (loop for i from 0 below n by 3
                   collect (list (cffi:mem-aref tris :int i)
                                 (cffi:mem-aref tris :int (1+ i))
                                 (cffi:mem-aref tris :int (+ i 2))))))
      (cffi:foreign-free tris))))

(defun mesh-get-normals (shape)
  "Return a list of per-vertex normal `(nx ny nz)` vectors from **shape**'s triangulation.

  Returns nil if shape has no normals, no triangulation, or is invalid.

  **Example:**

      (mesh-get-normals (mesh-shape (make-box 10 20 30)))

  **See also:** `mesh-shape`, `mesh-get-vertices`, `mesh-get-triangles`"
  (unless (shape-p shape)
    (return-from mesh-get-normals nil))
  (let* ((count (%mesh-get-triangle-count (%ptr shape)))
         (norm-capacity (* (max 100 count) 3))
         (normals (cffi:foreign-alloc :double :count norm-capacity)))
    (unwind-protect
         (let ((n (%mesh-get-normals (%ptr shape) normals norm-capacity)))
           (when (> n 0)
             (loop for i from 0 below n by 3
                   collect (list (cffi:mem-aref normals :double i)
                                 (cffi:mem-aref normals :double (1+ i))
                                 (cffi:mem-aref normals :double (+ i 2))))))
      (cffi:foreign-free normals))))

(defun mesh-get-triangle-count (shape)
  "Return the number of triangles in **shape**'s triangulation.

  This is an alias for `shape-triangle-count` that returns nil instead of 0
  for unmeshed shapes. Returns nil if shape is invalid.

  **Example:**

      (mesh-get-triangle-count (mesh-shape (make-box 10 20 30)))

  **See also:** `shape-triangle-count`, `mesh-shape`"
  (unless (shape-p shape)
    (return-from mesh-get-triangle-count nil))
  (let ((count (%mesh-get-triangle-count (%ptr shape))))
    (if (zerop count) nil count)))

;; --- Poly_Connect Connectivity ---

(defun mesh-triangle-adjacent (shape tri-index edge-index)
  "Return the index of the triangle adjacent to triangle **tri-index** across **edge-index** (0-2).

  Returns nil if no adjacent triangle exists (boundary edge), or on invalid input.

  **Example:**

      (mesh-triangle-adjacent (mesh-shape (make-box 10 20 30)) 0 0)

  **See also:** `mesh-triangle-elements`, `mesh-shape`"
  (unless (shape-p shape)
    (return-from mesh-triangle-adjacent nil))
  (let ((result (%mesh-triangle-adjacent (%ptr shape) tri-index edge-index)))
    (if (< result 0) nil result)))

(defun mesh-triangle-elements (shape tri-index)
  "Return the three vertex indices of triangle **tri-index** as multiple values.

  Returns nil on invalid input or out-of-range index.

  **Example:**

      (multiple-value-bind (i0 i1 i2) (mesh-triangle-elements (mesh-shape (make-box 10 20 30)) 0))

  **See also:** `mesh-triangle-adjacent`, `mesh-shape`"
  (unless (shape-p shape)
    (return-from mesh-triangle-elements nil))
  (cffi:with-foreign-objects ((n1 :int) (n2 :int) (n3 :int))
    (let ((result (%mesh-triangle-elements (%ptr shape) tri-index n1 n2 n3)))
      (if (zerop result)
          nil
          (values (cffi:mem-ref n1 :int)
                  (cffi:mem-ref n2 :int)
                  (cffi:mem-ref n3 :int))))))

;; --- MeshVS ---

(defclass meshvs-mesh ()
  ((handle :initarg :handle :accessor meshvs-handle)
   (verts :initarg :verts :accessor meshvs-verts)
   (tris :initarg :tris :accessor meshvs-tris)
   (colors :initarg :colors :accessor meshvs-colors))
  (:documentation "CLOS wrapper for MeshVS_Mesh. GC-managed via tg:finalize."))

(defmethod print-object ((obj meshvs-mesh) stream)
  (print-unreadable-object (obj stream :type t :identity t)))

(defun make-meshvs-mesh (vertices triangles &key colors)
  "Create a MeshVS mesh from **vertices** (list of `(x y z)` triples) and
  **triangles** (list of `(i0 i1 i2)` 0-based index triples).

  Optional **colors** is a list of `(r g b)` triples, one per vertex.

  Returns a `meshvs-mesh` instance, or nil on invalid input.

  **Example:**

      (make-meshvs-mesh '((0 0 0) (10 0 0) (10 10 0))
                         '((0 1 2)))

  **See also:** `meshvs-display`, `meshvs-free`"
  (when (or (null vertices) (null triangles)
            (zerop (length vertices)) (zerop (length triangles)))
    (return-from make-meshvs-mesh nil))
  (let* ((vcount (length vertices))
         (tcount (length triangles))
         (vert-arr (cffi:foreign-alloc :double :count (* vcount 3)))
         (tri-arr (cffi:foreign-alloc :int :count (* tcount 3)))
         (color-arr (when colors
                      (cffi:foreign-alloc :double :count (* (length colors) 3))))
         (handle (%meshvs-create-mesh)))
    (when (or (null handle) (cffi:null-pointer-p handle))
      (cffi:foreign-free vert-arr)
      (cffi:foreign-free tri-arr)
      (when color-arr (cffi:foreign-free color-arr))
      (return-from make-meshvs-mesh nil))
    (loop for i from 0 below vcount
          for (x y z) in vertices
          do (setf (cffi:mem-aref vert-arr :double (* i 3)) (coerce x 'double-float)
                   (cffi:mem-aref vert-arr :double (1+ (* i 3))) (coerce y 'double-float)
                   (cffi:mem-aref vert-arr :double (+ 2 (* i 3))) (coerce z 'double-float)))
    (loop for i from 0 below tcount
          for (i0 i1 i2) in triangles
          do (setf (cffi:mem-aref tri-arr :int (* i 3)) i0
                   (cffi:mem-aref tri-arr :int (1+ (* i 3))) i1
                   (cffi:mem-aref tri-arr :int (+ 2 (* i 3))) i2))
    (when colors
      (loop for i from 0 below (length colors)
            for (r g b) in colors
            do (setf (cffi:mem-aref color-arr :double (* i 3)) (coerce r 'double-float)
                     (cffi:mem-aref color-arr :double (1+ (* i 3))) (coerce g 'double-float)
                     (cffi:mem-aref color-arr :double (+ 2 (* i 3))) (coerce b 'double-float))))
    (%meshvs-set-data handle vert-arr vcount tri-arr tcount
                      (or color-arr (cffi:null-pointer)))
    (let ((obj (make-instance 'meshvs-mesh
                 :handle handle
                 :verts vert-arr
                 :tris tri-arr
                 :colors color-arr)))
      (tg:finalize obj (lambda () (%meshvs-free-mesh handle)))
      obj)))

(defun meshvs-display (ctx mesh)
  "Display a `meshvs-mesh` instance in an AIS context.

  **ctx** is an ais-context instance. Returns the mesh on success, nil on invalid input.

  **Example:**

      (meshvs-display ctx my-mesh)

  **See also:** `make-meshvs-mesh`, `ais-display`, `meshvs-free`"
  (when (or (null ctx) (null mesh))
    (return-from meshvs-display nil))
  (let ((handle (meshvs-handle mesh)))
    (when (or (null handle) (cffi:null-pointer-p handle))
      (return-from meshvs-display nil))
    (%meshvs-display (%ptr ctx) handle)
    mesh))

(defun meshvs-free (mesh)
  "Explicitly free a `meshvs-mesh` instance's C handle.

  Returns nil. Safe to call on nil.

  **Example:**

      (meshvs-free my-mesh)

  **See also:** `make-meshvs-mesh`, `meshvs-display`"
  (when mesh
    (let ((handle (meshvs-handle mesh)))
      (when (and handle (not (cffi:null-pointer-p handle)))
        (tg:cancel-finalization mesh)
        (%meshvs-free-mesh handle)
        (setf (slot-value mesh 'handle) (cffi:null-pointer))))))

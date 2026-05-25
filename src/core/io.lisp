(in-package :cl-occt)

;; --- Standard STEP I/O ---

(defun write-step (shape filename)
  "Write **shape** to a STEP file at **filename**.

  Returns `t` on success, signals an OCCT error on failure, or
  returns `nil` if **shape** is null or not a valid shape.

  **Example:**

    (write-step (make-box 10 20 30) \"/tmp/clocct-test-box.step\")

  **See also:** `read-step`, `write-stl`, `write-step-assembly`"
  (cond
    ((null shape)
     (warn "write-step: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-step: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-step (%ptr shape) filename)))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-step (filename)
  "Read a shape from a STEP file at **filename**.

  Returns a shape object, or `nil` if the file cannot be read.

  **Example:**

    (let ((shape (read-step \"/tmp/clocct-test-box.step\")))
      (when shape (shape-type shape)))

  **See also:** `write-step`, `read-stl`, `read-step-assembly`"
  (make-shape (%read-step filename)))

(defun write-stl (shape filename &key (deflection 0.1d0) (angle 0.5d0) (relative nil))
  "Write **shape** to an STL file at **filename**.

  **deflection** controls the tessellation quality (smaller = finer).
  **angle** controls the angular deviation in radians (default 0.5).
  **relative** when non-nil uses relative deflection mode.
  Returns `t` on success, signals an OCCT error on failure, or
  returns `nil` if **shape** is null or not a valid shape.

  **Example:**

    (write-stl (make-box 10 20 30) \"/tmp/clocct-test-box.stl\")
    (write-stl (make-sphere 10) \"/tmp/clocct-test-sphere.stl\" :deflection 0.05)
    (write-stl (make-box 10 20 30) \"/tmp/clocct-test-box.stl\" :angle 0.2 :relative t)

  **See also:** `read-stl`, `write-step`, `mesh-shape`"
  (cond
    ((null shape)
     (warn "write-stl: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-stl: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-stl (%ptr shape) filename
                               (coerce deflection 'double-float)
                               (coerce angle 'double-float)
                               (if relative 1 0))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-stl (filename)
  "Read a shape from an STL file at **filename**.

  Returns a shape object, or `nil` if the file cannot be read.

  **Example:**

    (let ((shape (read-stl \"/tmp/clocct-test-box.stl\")))
      (when shape (shape-type shape)))

  **See also:** `write-stl`, `read-step`"
  (make-shape (%read-stl filename)))

;; --- XDE Helper Functions ---

(defvar *color-types* #(:generic :surf :curv))

(defun parse-color (color)
  "Parse a color specification into component values for XDE I/O.

  **color** is a list of the form (`type` `r` `g` `b` `a`) where `type` is one of
  `:generic`, `:surf`, or `:curv` (position in `*color-types*`), and the
  components are in [0,1] range.  Returns five values: type-index,
  r, g, b, a.  When **color** is `nil`, returns -1 and 0.0 values.

  **Example:**

    (parse-color '(:generic 1.0 0.0 0.0 1.0))

  **See also:** `write-step-assembly`, `read-step-assembly`"
  (if (null color)
      (values -1 0d0 0d0 0d0 0d0)
      (values (or (position (first color) *color-types*) -1)
              (coerce (second color) 'double-float)
              (coerce (third color) 'double-float)
              (coerce (fourth color) 'double-float)
              (coerce (fifth color) 'double-float))))

(defun %xde-get-root-paths (doc)
  (let ((count (%xde-get-root-count doc)))
    (loop for i from 1 to count
          collect (let ((buf (cffi:foreign-alloc :char :count 256)))
                    (unwind-protect
                         (progn
                           (%xde-get-root-path doc i buf 256)
                           (cffi:foreign-string-to-lisp buf))
                      (cffi:foreign-free buf))))))

(defun %xde-get-child-paths (doc parent-path)
  (let ((count (%xde-get-child-count doc parent-path)))
    (loop for i from 1 to count
          collect (let ((buf (cffi:foreign-alloc :char :count 256)))
                    (unwind-protect
                         (progn
                           (%xde-get-child-path doc parent-path i buf 256)
                           (cffi:foreign-string-to-lisp buf))
                      (cffi:foreign-free buf))))))

(defun %xde-get-name (doc path)
  (let ((buf (cffi:foreign-alloc :char :count 256)))
    (unwind-protect
         (progn
           (%xde-get-name-at doc path buf 256)
           (let ((result (cffi:foreign-string-to-lisp buf)))
             (if (string= result "") nil result)))
      (cffi:foreign-free buf))))

(defun %xde-get-color (doc path)
  (cffi:with-foreign-objects ((type :int) (r :double) (g :double) (b :double) (a :double))
    (let ((found (%xde-get-color-at doc path type r g b a)))
      (if (zerop found)
          nil
          (list (aref *color-types* (cffi:mem-ref type :int))
                (cffi:mem-ref r :double)
                (cffi:mem-ref g :double)
                (cffi:mem-ref b :double)
                (cffi:mem-ref a :double))))))

(defun %xde-get-location (doc path)
  (cffi:with-foreign-object (matrix :double 16)
    (let ((found (%xde-get-location-at doc path matrix)))
      (if (zerop found)
          nil
          (let ((result (make-array 16 :element-type 'double-float)))
            (dotimes (i 16)
              (setf (aref result i) (cffi:mem-aref matrix :double i)))
            result)))))

;; --- Assembly Tree I/O ---

(defun %read-node (doc path)
  (let* ((shape-ptr (%xde-get-shape-at doc path))
         (shape (make-shape shape-ptr))
         (name (%xde-get-name doc path))
         (color (%xde-get-color doc path))
         (location (%xde-get-location doc path))
         (child-paths (%xde-get-child-paths doc path))
         (children (loop for child-path in child-paths
                         collect (%read-node doc child-path))))
    (make-instance 'assembly
      :shape shape
      :name name
      :color color
      :location location
      :children children)))

(defun read-step-assembly (filename)
  "Read an assembly tree from a STEP file using XDE.

  Returns an assembly hierarchy, or `nil` if the file cannot be
  read or has no root paths.

  **Example:**

    (let ((assy (read-step-assembly \"/tmp/clocct-test-assy.step\")))
      (when assy (assembly-branch-p assy)))

  **See also:** `write-step-assembly`, `read-step`, `make-assembly`"
  (let ((doc (%xde-read-step filename)))
    (if (cffi:null-pointer-p doc)
        nil
        (unwind-protect
             (let ((root-paths (%xde-get-root-paths doc)))
               (if (null root-paths)
                   nil
                   (make-instance 'assembly
                     :children (loop for path in root-paths
                                     collect (%read-node doc path)))))
          (%xde-free-doc doc)))))

(defun %write-node (doc parent-path node)
  (let ((buf (cffi:foreign-alloc :char :count 256)))
    (unwind-protect
         (let ((shape-ptr (when (assembly-shape node)
                            (%ptr (assembly-shape node))))
               (loc (assembly-location node)))
           (if (and shape-ptr (not (cffi:null-pointer-p shape-ptr)))
               (multiple-value-bind (color-type r g b a)
                   (parse-color (assembly-color node))
                 (%xde-add-part doc parent-path shape-ptr
                               (or (assembly-name node) "")
                               color-type r g b a
                               (if loc loc (cffi:null-pointer))
                               buf 256)
                 (let ((child-path (cffi:foreign-string-to-lisp buf)))
                   (unless (string= child-path "")
                     (dolist (child (or (assembly-children node) nil))
                       (%write-node doc child-path child)))))
               (dolist (child (or (assembly-children node) nil))
                 (%write-node doc parent-path child))))
      (cffi:foreign-free buf))))

(defun write-step-assembly (root filename)
  "Write an assembly tree to a STEP file using XDE.

  **root** is an assembly instance (from `make-part` or `make-assembly`).
  Returns `t` on success, signals an OCCT error on failure, or
  returns `nil` if **root** is null.

  **Example:**

    (let ((part (make-part (make-box 10 20 30) :name \"box\"
                           :color '(:generic 1 0 0 1))))
      (write-step-assembly part \"/tmp/clocct-test-assy.step\"))

  **See also:** `read-step-assembly`, `write-step`, `make-part`"
  (when (null root)
    (warn "write-step-assembly: nil assembly, nothing written")
    (return-from write-step-assembly nil))
  (let ((doc (%xde-new-doc)))
    (unwind-protect
         (progn
           (%write-node doc "" root)
           (let ((result (%xde-write-step doc filename)))
             (if (zerop result)
                 (error 'occt-error
                        :code (%get-error-code)
                        :message (%get-error-message))
                 t)))
      (%xde-free-doc doc))))

;; --- Mesh I/O Utility Helpers ---

(defun %coordinate-system->int (cs)
  (case cs
    (:zup 0)
    (:yup 1)
    (otherwise (error 'occt-error :code -1
                      :message (format nil "Unknown coordinate system: ~S (expected :zup or :yup)" cs)))))

(defun %name-format->int (nf)
  (case nf
    (:auto 0)
    (:short 1)
    (:full 2)
    (otherwise (error 'occt-error :code -1
                      :message (format nil "Unknown name format: ~S (expected :auto, :short, or :full)" nf)))))

;; --- IGES I/O ---

(defun write-iges (shape filename)
  (cond
    ((null shape)
     (warn "write-iges: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-iges: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-iges (%ptr shape) filename)))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-iges (filename)
  (make-shape (%read-iges filename)))

(defun write-iges-assembly (root filename)
  (when (null root)
    (warn "write-iges-assembly: nil assembly, nothing written")
    (return-from write-iges-assembly nil))
  (let ((doc (%xde-new-doc)))
    (unwind-protect
         (progn
           (%write-node doc "" root)
           (let ((result (%xde-write-iges doc filename)))
             (if (zerop result)
                 (error 'occt-error
                        :code (%get-error-code)
                        :message (%get-error-message))
                 t)))
      (%xde-free-doc doc))))

(defun read-iges-assembly (filename)
  (let ((doc (%xde-read-iges filename)))
    (if (cffi:null-pointer-p doc)
        nil
        (unwind-protect
             (let ((root-paths (%xde-get-root-paths doc)))
               (if (null root-paths)
                   nil
                   (make-instance 'assembly
                     :children (loop for path in root-paths
                                     collect (%read-node doc path)))))
          (%xde-free-doc doc)))))

;; --- OBJ Mesh I/O ---

(defun write-obj (shape filename
                  &key (coordinate-system :zup)
                    (name-format :auto)
                    (per-vertex-colors nil))
  (cond
    ((null shape)
     (warn "write-obj: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-obj: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-obj (%ptr shape) filename
                               (%coordinate-system->int coordinate-system)
                               (%name-format->int name-format)
                               (if per-vertex-colors 1 0))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-obj (filename &key (coordinate-system :zup))
  (make-shape (%read-obj filename (%coordinate-system->int coordinate-system))))

;; --- VRML Export ---

(defun write-vrml (shape filename &key (deflection 0.1d0))
  (cond
    ((null shape)
     (warn "write-vrml: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-vrml: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-vrml (%ptr shape) filename (coerce deflection 'double-float))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

;; --- glTF I/O ---

(defun write-gltf (shape filename
                   &key (coordinate-system :zup)
                     (per-vertex-colors nil))
  (cond
    ((null shape)
     (warn "write-gltf: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-gltf: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-gltf (%ptr shape) filename
                                (%coordinate-system->int coordinate-system)
                                (if per-vertex-colors 1 0))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-gltf (filename &key (coordinate-system :zup))
  (make-shape (%read-gltf filename (%coordinate-system->int coordinate-system))))

;; --- PLY Export ---

(defun write-ply (shape filename
                  &key (coordinate-system :zup)
                    (per-vertex-colors nil))
  (cond
    ((null shape)
     (warn "write-ply: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-ply: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-ply (%ptr shape) filename
                               (%coordinate-system->int coordinate-system)
                               (if per-vertex-colors 1 0))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))



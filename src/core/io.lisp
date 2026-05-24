(in-package :cl-occt)

;; --- Standard STEP I/O ---

(defun write-step (shape filename)
  "Write SHAPE to a STEP file at FILENAME.

  Returns T on success, signals an OCCT error on failure, or
  returns NIL if SHAPE is null or not a valid shape.

  Example:
    (write-step (make-box 10 20 30) \"/tmp/clocct-test-box.step\")

  See also: read-step, write-stl, write-step-assembly"
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
  "Read a shape from a STEP file at FILENAME.

  Returns a shape object, or NIL if the file cannot be read.

  Example:
    (let ((shape (read-step \"/tmp/clocct-test-box.step\")))
      (when shape (shape-type shape)))

  See also: write-step, read-stl, read-step-assembly"
  (make-shape (%read-step filename)))

(defun write-stl (shape filename &key (deflection 0.1d0))
  "Write SHAPE to an STL file at FILENAME.

  DEFLECTION controls the tessellation quality (smaller = finer).
  Returns T on success, signals an OCCT error on failure, or
  returns NIL if SHAPE is null or not a valid shape.

  Example:
    (write-stl (make-box 10 20 30) \"/tmp/clocct-test-box.stl\")
    (write-stl (make-sphere 10) \"/tmp/clocct-test-sphere.stl\" :deflection 0.05)

  See also: read-stl, write-step"
  (cond
    ((null shape)
     (warn "write-stl: nil shape, nothing written")
     nil)
    ((not (shape-p shape))
     (warn "write-stl: not a shape object, nothing written")
     nil)
    (t
     (let ((result (%write-stl (%ptr shape) filename (coerce deflection 'double-float))))
       (if (zerop result)
           (error 'occt-error
                  :code (%get-error-code)
                  :message (%get-error-message))
           t)))))

(defun read-stl (filename)
  "Read a shape from an STL file at FILENAME.

  Returns a shape object, or NIL if the file cannot be read.

  Example:
    (let ((shape (read-stl \"/tmp/clocct-test-box.stl\")))
      (when shape (shape-type shape)))

  See also: write-stl, read-step"
  (make-shape (%read-stl filename)))

;; --- XDE Helper Functions ---

(defvar *color-types* #(:generic :surf :curv))

(defun parse-color (color)
  "Parse a color specification into component values for XDE I/O.

  COLOR is a list of the form (TYPE R G B A) where TYPE is one of
  :GENERIC, :SURF, or :CURV (position in *COLOR-TYPES*), and the
  components are in [0,1] range.  Returns five values: type-index,
  r, g, b, a.  When COLOR is NIL, returns -1 and 0.0 values.

  Example:
    (parse-color '(:generic 1.0 0.0 0.0 1.0))

  See also: write-step-assembly, read-step-assembly"
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

  Returns an assembly hierarchy, or NIL if the file cannot be
  read or has no root paths.

  Example:
    (let ((assy (read-step-assembly \"/tmp/clocct-test-assy.step\")))
      (when assy (assembly-branch-p assy)))

  See also: write-step-assembly, read-step, make-assembly"
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

  ROOT is an assembly instance (from make-part or make-assembly).
  Returns T on success, signals an OCCT error on failure, or
  returns NIL if ROOT is null.

  Example:
    (let ((part (make-part (make-box 10 20 30) :name \"box\"
                           :color '(:generic 1 0 0 1))))
      (write-step-assembly part \"/tmp/clocct-test-assy.step\"))

  See also: read-step-assembly, write-step, make-part"
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



(in-package :cl-occt)

;; --- Standard STEP I/O ---

(defun write-step (shape filename)
  (if (null shape)
      (progn
        (warn "write-step: nil shape, nothing written")
        nil)
      (let ((result (%write-step (%ptr shape) filename)))
        (if (zerop result)
            (error 'occt-error
                   :code (%get-error-code)
                   :message (%get-error-message))
            t))))

(defun read-step (filename)
  (make-shape (%read-step filename)))

(defun write-stl (shape filename &key (deflection 0.1d0))
  (if (null shape)
      (progn
        (warn "write-stl: nil shape, nothing written")
        nil)
      (let ((result (%write-stl (%ptr shape) filename (coerce deflection 'double-float))))
        (if (zerop result)
            (error 'occt-error
                   :code (%get-error-code)
                   :message (%get-error-message))
            t))))

(defun read-stl (filename)
  (make-shape (%read-stl filename)))

;; --- XDE Helper Functions ---

(defvar *color-types* #(:generic :surf :curv))

(defun parse-color (color)
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

;; --- DAG Model STEP Import ---

(defvar *dag-import-counter* 0)

(defun %dag-import-name (name)
  (if name
      (intern (string-upcase (substitute #\- #\Space name)) :keyword)
      (intern (format nil "PART-~A" (incf *dag-import-counter*)) :keyword)))

(defun %import-node-into-dag (doc path)
  (let* ((shape-ptr (%xde-get-shape-at doc path))
         (shape (make-shape shape-ptr))
         (disp-name (%xde-get-name doc path))
         (color (%xde-get-color doc path))
         (model-name (%dag-import-name disp-name))
         (child-paths (%xde-get-child-paths doc path)))
    (when shape
      (let ((m (make-model :name model-name
                           :fn (lambda () shape)
                           :param-keys nil
                           :model-deps nil
                           :dirty nil
                           :cached-shape shape
                           :color color
                           :display-name disp-name)))
        (register-model model-name m)))
    (dolist (child-path child-paths)
      (%import-node-into-dag doc child-path))))

(defun read-step-into-dag (filename)
  (let ((doc (%xde-read-step filename)))
    (if (cffi:null-pointer-p doc)
        nil
        (unwind-protect
             (let ((root-paths (%xde-get-root-paths doc)))
               (if (null root-paths)
                   nil
                   (progn
                     (setf *dag-import-counter* 0)
                     (dolist (path root-paths)
                       (%import-node-into-dag doc path))
                     t)))
          (%xde-free-doc doc)))))

;; --- DAG Model STEP Export ---

(defun write-dag-models-to-step (filename)
  (let ((doc (%xde-new-doc))
        (count 0))
    (unwind-protect
         (progn
           (loop for name being the hash-keys of *model-registry*
                 using (hash-value m)
                 for shape = (model-cached-shape m)
                 when (and shape (not (cffi:null-pointer-p (%ptr shape))))
                   do (let ((buf (cffi:foreign-alloc :char :count 256)))
                       (unwind-protect
                            (multiple-value-bind (color-type r g b a)
                                (parse-color (cl-occt.impl:model-color m))
                              (%xde-add-part doc ""
                                             (%ptr shape)
                                             (or (cl-occt.impl:model-display-name m) "")
                                             color-type r g b a
                                             (cffi:null-pointer)
                                             buf 256)
                              (incf count))
                         (cffi:foreign-free buf))))
           (if (zerop count)
               (progn
                 (warn "write-dag-models-to-step: no models with shapes found")
                 nil)
               (let ((result (%xde-write-step doc filename)))
                 (if (zerop result)
                     (error 'occt-error
                            :code (%get-error-code)
                            :message (%get-error-message))
                     t))))
      (%xde-free-doc doc))))

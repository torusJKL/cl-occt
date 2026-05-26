(in-package :cl-occt)

(defclass xcaf-doc ()
  ((%ptr :initarg :%ptr :reader %ptr :initform nil))
  (:documentation "Wraps an XCAF (extended STEP with metadata) document handle."))

(defmethod print-object ((obj xcaf-doc) stream)
  (print-unreadable-object (obj stream :type t :identity t)))

(defun xcaf-doc-p (obj)
  "**Returns:** `t` if **obj** is an `xcaf-doc` object."
  (typep obj 'xcaf-doc))

(defun make-xcaf-doc ()
  "Create a new XCAF document for CAD data exchange (STEP with metadata).

  Returns an `xcaf-doc` object, or nil on failure.

  **See also:** `xcaf-free-doc`, `xcaf-add-shape`, `xcaf-add-view`"
  (let* ((ptr (cffi:foreign-alloc :pointer))
         (result (%xcaf-new-doc ptr)))
    (if (and (not (zerop result))
             (not (cffi:null-pointer-p (cffi:mem-ref ptr :pointer))))
        (make-instance 'xcaf-doc :%ptr (cffi:mem-ref ptr :pointer))
        nil)))

(defun xcaf-free-doc (doc)
  "Explicitly free an XCAF document. Returns `t` on success."
  (when doc
    (%xcaf-free-doc (%ptr doc))
    (setf (slot-value doc '%ptr) nil)
    t))

(defun xcaf-add-shape (doc shape)
  "Add a **shape** to the XCAF **doc**. Returns `t` on success, `nil` on failure.

  **See also:** `xcaf-add-shape-to-layer`, `xcaf-has-material`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-shape: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-shape: nil shape")
     nil)
    (t
     (let ((result (%xcaf-save-shape-to-doc (%ptr doc) (%ptr shape))))
       (if (zerop result) nil t)))))

(defun xcaf-add-shape-to-layer (doc shape layer)
  "Add a **shape** to a named **layer** in the XCAF **doc**.
  Returns `t` on success, `nil` on failure.

  **See also:** `xcaf-remove-shape-from-layer`, `xcaf-get-shape-layers`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-shape-to-layer: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-add-shape-to-layer: nil shape")
     nil)
    ((or (null layer) (string= layer ""))
     (warn "xcaf-add-shape-to-layer: empty layer name")
     nil)
    (t
     (let ((result (%xcaf-set-layer (%ptr doc) (%ptr shape) layer)))
       (if (zerop result) nil t)))))

(defun xcaf-remove-shape-from-layer (doc shape layer)
  "Remove a **shape** from a named **layer** in the XCAF **doc**.
  Returns `t` on success, `nil` on failure.

  **See also:** `xcaf-add-shape-to-layer`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-remove-shape-from-layer: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-remove-shape-from-layer: nil shape")
     nil)
    ((or (null layer) (string= layer ""))
     (warn "xcaf-remove-shape-from-layer: empty layer name")
     nil)
    (t
     (let ((result (%xcaf-unset-one-layer (%ptr doc) (%ptr shape) layer)))
       (if (zerop result) nil t)))))

(defun xcaf-get-shape-layers (doc shape)
  "Retrieve the layer names assigned to a **shape** in an XCAF **doc**.

  - **doc** — an `xcaf-doc` instance
  - **shape** — a `shape` instance

  **Returns:** a list of layer name strings, or `nil` if no layers or on error.

  **Example:**
    (let ((doc (make-xcaf-doc)))
      (xcaf-add-shape doc my-box)
      (xcaf-add-shape-to-layer doc my-box \"Design\")
      (xcaf-get-shape-layers doc my-box))
    ;; => (\"Design\")

  **See also:** `xcaf-add-shape-to-layer`, `xcaf-remove-shape-from-layer`"
  (when (or (null doc) (null shape))
    (return-from xcaf-get-shape-layers nil))
  (let* ((doc-ptr (%ptr doc))
         (shape-ptr (%ptr shape))
         (count (%xcaf-get-layer-count doc-ptr shape-ptr)))
    (when (zerop count)
      (return-from xcaf-get-shape-layers nil))
    (loop for i from 1 to count
          collect (let ((buf (cffi:foreign-alloc :char :count 256)))
                    (unwind-protect
                         (progn
                           (%xcaf-get-layer-name doc-ptr shape-ptr i buf 256)
                           (cffi:foreign-string-to-lisp buf))
                      (cffi:foreign-free buf))))))

(defun xcaf-has-material (doc shape)
  "Check if a **shape** has an associated material in the XCAF **doc**.
  Returns `t` if material exists, `nil` otherwise.

  **See also:** `xcaf-get-visual-material`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-has-material: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-has-material: nil shape")
     nil)
    (t
     (not (zerop (%xcaf-has-material (%ptr doc) (%ptr shape)))))))

(defun xcaf-add-view (doc)
  "Add a view to the XCAF **doc**. Returns `t` on success.

  **See also:** `xcaf-get-views`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-add-view: nil doc")
     nil)
    (t
     (let ((result (%xcaf-add-view (%ptr doc))))
       (if (zerop result) nil t)))))

(defun xcaf-get-views (doc)
  "Get the list of views in the XCAF **doc**.
  Returns a list of view plists, or nil.

  **See also:** `xcaf-add-view`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-views: nil doc")
     nil)
    (t
     (let ((count (%xcaf-get-view-count (%ptr doc))))
       (when (plusp count)
         (loop for i from 1 to count
               collect (list :index i)))))))

(defun xcaf-get-visual-material (doc shape)
  "Get the visual material (color and alpha) of a **shape** in the XCAF **doc**.
  Returns a plist with `:color` (r g b) and `:alpha`, or nil if not set.

  **See also:** `xcaf-has-material`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-visual-material: nil doc")
     nil)
    ((or (null shape) (null (%ptr shape)))
     (warn "xcaf-get-visual-material: nil shape")
     nil)
    (t
     (let ((out-r (cffi:foreign-alloc :double))
           (out-g (cffi:foreign-alloc :double))
           (out-b (cffi:foreign-alloc :double))
           (out-a (cffi:foreign-alloc :double)))
       (unwind-protect
            (if (not (zerop (%xcaf-get-visual-material (%ptr doc) (%ptr shape)
                                                        out-r out-g out-b out-a)))
                (list :color (list (cffi:mem-ref out-r :double)
                                   (cffi:mem-ref out-g :double)
                                   (cffi:mem-ref out-b :double))
                      :alpha (cffi:mem-ref out-a :double))
                nil)
         (cffi:foreign-free out-r)
         (cffi:foreign-free out-g)
         (cffi:foreign-free out-b)
         (cffi:foreign-free out-a))))))

(defun xcaf-get-clipping-planes (doc)
  "Get the list of clipping planes in the XCAF **doc**.
  Returns a list of plists, or nil."
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-get-clipping-planes: nil doc")
     nil)
    (t
     (let ((count (%xcaf-get-clipping-plane-count (%ptr doc))))
       (when (plusp count)
         (loop for i from 1 to count
               collect (list :index i)))))))

(defun xcaf-expand-assembly (doc)
  "Expand the assembly structure in the XCAF **doc**.
  Returns `t` on success, `nil` on failure.

  **See also:** `xcaf-add-shape`"
  (cond
    ((or (null doc) (null (%ptr doc)))
     (warn "xcaf-expand-assembly: nil doc")
     nil)
    (t
     (let ((result (%xcaf-expand-assembly (%ptr doc))))
       (if (zerop result) nil t)))))

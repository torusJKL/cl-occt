(in-package :cl-occt)

(defclass ocaf-doc ()
  ((%ptr :initarg :%ptr :reader %ptr :initform nil))
  (:documentation "Wraps an OCAF TDocStd_Document handle."))

(defstruct ocaf-label
  (ptr nil :read-only t))

(defmethod print-object ((obj ocaf-doc) stream)
  (print-unreadable-object (obj stream :type t :identity t)))

(defun ocaf-doc-p (obj)
  "**Returns:** `t` if **obj** is an `ocaf-doc` object."
  (typep obj 'ocaf-doc))

(defun make-ocaf-doc ()
  "Create a new OCAF document.

  Returns an `ocaf-doc` object, or nil on failure.

  **See also:** `ocaf-free-doc`, `ocaf-root-label`"
  (let ((ptr (%ocaf-new-doc)))
    (if (cffi:null-pointer-p ptr)
        nil
        (make-instance 'ocaf-doc :%ptr ptr))))

(defun ocaf-free-doc (doc)
  "Explicitly free an OCAF document. Returns `t` on success."
  (when doc
    (let ((ptr (slot-value doc '%ptr)))
      (when ptr
        (%ocaf-free-doc ptr)
        (setf (slot-value doc '%ptr) nil)))
    t))

(defun ocaf-free-label (label)
  "Explicitly free an OCAF label. Safe to call on nil."
  (when label
    (let ((ptr (ocaf-label-ptr label)))
      (unless (cffi:null-pointer-p ptr)
        (%ocaf-free-label ptr)))))

(defun ocaf-root-label (doc)
  "Get the root label of an OCAF **doc**.
  Returns an `ocaf-label` struct, or nil.

  **See also:** `ocaf-find-label`, `ocaf-label-children`"
  (let ((ptr (%ocaf-root-label (%ptr doc))))
    (if (cffi:null-pointer-p ptr)
        nil
        (make-ocaf-label :ptr ptr))))

(defun ocaf-find-label (doc tags &key (create nil))
  "Find a label in **doc** by its **tags** path (list of integers).
  When **create** is non-nil, creates the label if it does not exist.
  Returns an `ocaf-label` struct, or nil.

  **Example:**

      (ocaf-find-label my-doc '(0 1 2))         ; find existing
      (ocaf-find-label my-doc '(0 5 10) :create t)  ; create if missing

  **See also:** `ocaf-root-label`, `ocaf-label-tag`"
  (let ((tag-array (cffi:foreign-alloc :int :initial-contents tags))
        (create-flag (if create 1 0)))
    (unwind-protect
         (let ((ptr (%ocaf-find-label (%ptr doc) tag-array (length tags) create-flag)))
           (if (cffi:null-pointer-p ptr)
               nil
               (make-ocaf-label :ptr ptr)))
      (cffi:foreign-free tag-array))))

(defun ocaf-label-children (label)
  "Get the child labels of an OCAF **label**.
  Returns a list of `ocaf-label` structs, or nil.

  **See also:** `ocaf-find-label`, `ocaf-label-tag`"
  (cffi:with-foreign-object (out-count :int)
    (let ((array-ptr (%ocaf-label-children (ocaf-label-ptr label) out-count)))
      (if (cffi:null-pointer-p array-ptr)
          nil
          (let ((count (cffi:mem-ref out-count :int)))
            (unwind-protect
                 (loop for i below count
                       for label-ptr = (cffi:mem-aref array-ptr :pointer i)
                       collect (make-ocaf-label :ptr label-ptr))
              (%ocaf-free-label-array array-ptr count)))))))

(defun ocaf-label-tag (label)
  "Get the integer tag of an OCAF **label**."
  (%ocaf-label-tag (ocaf-label-ptr label)))

(defun ocaf-label-depth (label)
  "Get the depth of an OCAF **label** in the label tree."
  (%ocaf-label-depth (ocaf-label-ptr label)))

;; --- Transactions ---

(defun ocaf-begin-transaction (doc &optional name)
  "Begin a transaction on an OCAF **doc** with an optional **name**.
  Must be paired with `ocaf-commit-transaction` or `ocaf-undo-transaction`.

  **See also:** `ocaf-commit-transaction`, `ocaf-undo-transaction`"
  (%ocaf-begin-transaction (%ptr doc) (or name "")))

(defun ocaf-commit-transaction (doc)
  "Commit the current transaction on an OCAF **doc**.

  **See also:** `ocaf-begin-transaction`, `ocaf-undo-transaction`"
  (%ocaf-commit-transaction (%ptr doc)))

(defun ocaf-undo-transaction (doc)
  "Undo (roll back) the current transaction on an OCAF **doc**.

  **See also:** `ocaf-begin-transaction`, `ocaf-commit-transaction`"
  (%ocaf-undo-transaction (%ptr doc)))

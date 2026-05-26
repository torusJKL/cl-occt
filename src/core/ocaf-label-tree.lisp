(in-package :cl-occt)

(defclass ocaf-doc ()
  ((%ptr :initarg :%ptr :reader %ptr :initform nil)))

(defstruct ocaf-label
  (ptr nil :read-only t))

(defmethod print-object ((obj ocaf-doc) stream)
  (print-unreadable-object (obj stream :type t :identity t)))

(defun ocaf-doc-p (obj)
  (typep obj 'ocaf-doc))

(defun make-ocaf-doc ()
  (let ((ptr (%ocaf-new-doc)))
    (if (cffi:null-pointer-p ptr)
        nil
        (make-instance 'ocaf-doc :%ptr ptr))))

(defun ocaf-free-doc (doc)
  (when doc
    (let ((ptr (slot-value doc '%ptr)))
      (when ptr
        (%ocaf-free-doc ptr)
        (setf (slot-value doc '%ptr) nil)))
    t))

(defun ocaf-free-label (label)
  (when label
    (let ((ptr (ocaf-label-ptr label)))
      (unless (cffi:null-pointer-p ptr)
        (%ocaf-free-label ptr)))))

(defun ocaf-root-label (doc)
  (let ((ptr (%ocaf-root-label (%ptr doc))))
    (if (cffi:null-pointer-p ptr)
        nil
        (make-ocaf-label :ptr ptr))))

(defun ocaf-find-label (doc tags &key (create nil))
  (let ((tag-array (cffi:foreign-alloc :int :initial-contents tags))
        (create-flag (if create 1 0)))
    (unwind-protect
         (let ((ptr (%ocaf-find-label (%ptr doc) tag-array (length tags) create-flag)))
           (if (cffi:null-pointer-p ptr)
               nil
               (make-ocaf-label :ptr ptr)))
      (cffi:foreign-free tag-array))))

(defun ocaf-label-children (label)
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
  (%ocaf-label-tag (ocaf-label-ptr label)))

(defun ocaf-label-depth (label)
  (%ocaf-label-depth (ocaf-label-ptr label)))

;; --- Transactions ---

(defun ocaf-begin-transaction (doc &optional name)
  (%ocaf-begin-transaction (%ptr doc) (or name "")))

(defun ocaf-commit-transaction (doc)
  (%ocaf-commit-transaction (%ptr doc)))

(defun ocaf-undo-transaction (doc)
  (%ocaf-undo-transaction (%ptr doc)))

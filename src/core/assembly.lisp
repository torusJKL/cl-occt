(in-package :cl-occt)

(defclass assembly ()
  ((%shape    :initarg :shape    :initform nil :reader assembly-shape)
   (%name     :initarg :name     :initform nil :accessor assembly-name)
   (%color    :initarg :color    :initform nil :accessor assembly-color)
   (%location :initarg :location :initform nil :reader assembly-location)
   (%children :initarg :children :initform nil :accessor assembly-children))
  (:documentation "Represents a tree node in an assembly hierarchy (part or sub-assembly)."))

(defun make-part (shape &key name color location)
  "Create a leaf-level assembly part from a **shape**.

  **name** is an optional string identifier.  **color** is a list of the
  form (`type` `r` `g` `b` `a`) where `type` is `:generic`, `:surf`, or `:curv`.
  **location** is an optional 16-element transformation matrix.
  Returns an assembly instance.

  **Example:**

    (make-part (make-box 10 20 30) :name \"box\"
               :color '(:generic 1.0 0.0 0.0 1.0))

  **See also:** `make-assembly`, `assembly-leaf-p`, `assembly-branch-p`"
  (make-instance 'assembly
    :shape shape
    :name name
    :color color
    :location location))

(defun make-assembly (&key name children)
  "Create a branch-level assembly node with optional **children**.

  **children** is a list of assembly instances (parts or sub-assemblies).
  **name** is an optional string identifier.  The resulting node has no
  shape of its own — it groups its children.

  **Example:**

    (let* ((part (make-part (make-box 10 20 30) :name \"leaf\"))
           (sub (make-assembly :name \"group\" :children (list part))))
      (make-assembly :name \"root\" :children (list sub)))

  **See also:** `make-part`, `assembly-leaf-p`, `assembly-branch-p`"
  (make-instance 'assembly
    :name name
    :children children))

(defun assembly-leaf-p (node)
  "Return `t` if **node** is a leaf (has no children — i.e. is a part).

  **Example:**

    (assembly-leaf-p (make-part (make-box 1 2 3)))

  **See also:** `assembly-branch-p`, `make-part`, `make-assembly`"
  (null (slot-value node '%children)))

(defun assembly-branch-p (node)
  "Return `t` if **node** is a branch (has children — i.e. is an assembly).

  **Example:**

    (assembly-branch-p (make-assembly :children (list (make-part (make-box 1 2 3)))))

  **See also:** `assembly-leaf-p`, `make-part`, `make-assembly`"
  (not (null (slot-value node '%children))))

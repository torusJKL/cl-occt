(in-package :cl-occt)

(defclass assembly ()
  ((%shape    :initarg :shape    :initform nil :reader assembly-shape)
   (%name     :initarg :name     :initform nil :accessor assembly-name)
   (%color    :initarg :color    :initform nil :accessor assembly-color)
   (%location :initarg :location :initform nil :reader assembly-location)
   (%children :initarg :children :initform nil :accessor assembly-children)))

(defun make-part (shape &key name color location)
  (make-instance 'assembly
    :shape shape
    :name name
    :color color
    :location location))

(defun make-assembly (&key name children)
  (make-instance 'assembly
    :name name
    :children children))

(defun assembly-leaf-p (node)
  (null (slot-value node '%children)))

(defun assembly-branch-p (node)
  (not (null (slot-value node '%children))))

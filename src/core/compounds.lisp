(in-package :cl-occt)

(defun make-compound (shapes)
  "Group a list of `shapes` into a compound shape.

  Compounds are lightweight containers that group shapes without
  performing any boolean operation.  `nil` values in the list are
  filtered out silently.

  **Example:**

      (def box (make-box 10 10 10))
      (def sph (make-sphere 8))
      (make-compound (list box sph))"
  (let ((valid (remove nil shapes)))
    (if valid
        (cffi:with-foreign-object (arr :pointer (length valid))
          (loop for i from 0 for s in valid
                do (setf (cffi:mem-aref arr :pointer i) (%ptr s)))
          (make-shape (%make-compound arr (length valid))))
        nil)))

(defun add-to-compound (compound shape)
  "Add `shape` to an existing `compound`, returning a new compound.

  **Example:**

      (def comp (make-compound nil))
      (add-to-compound comp (make-box 10 10 10))"
  (cond ((null compound) nil)
        ((null shape) compound)
        (t (make-shape (%add-to-compound (%ptr compound) (%ptr shape))))))

(defun compound-shape-p (obj)
  "**Returns:** `t` if `obj` is a compound shape, `nil` otherwise.

  **See also:** `shape-p`, `make-compound`, `add-to-compound`"
  (and (shape-p obj)
       (not (cffi:null-pointer-p (%ptr obj)))
       (/= 0 (%shape-is-compound (%ptr obj)))))

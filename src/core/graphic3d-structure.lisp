(in-package :cl-occt)

(defclass graphic-structure ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_Structure handle with GC via tg:finalize."))

(defun graphic-structure-p (obj)
  "**Returns:** `t` if **obj** is a `graphic-structure` object."
  (typep obj 'graphic-structure))

(defun make-graphic-structure (viewer)
  "Create a Graphic3d_Structure in the given **viewer**.

  Returns a `graphic-structure` object, or nil on failure.

  **See also:** `free-graphic-structure`, `graphic-structure-p`"
  (when (viewer-p viewer)
    (let* ((v3d-viewer-ptr (%viewer viewer))
           (ptr (when (and v3d-viewer-ptr (not (cffi:null-pointer-p v3d-viewer-ptr)))
                  (%graphic3d-structure-new v3d-viewer-ptr)))
           (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'graphic-structure :handle ptr))))
      (when obj
        (tg:finalize obj (lambda () (%graphic3d-structure-free (%handle obj)))))
      obj)))

(defun free-graphic-structure (gs)
  "Explicitly free a graphic-structure's C handle. Safe to call on nil."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-structure-free ptr)
        (setf (slot-value gs '%handle) (cffi:null-pointer))))))

(defun set-graphic-structure-visible (gs visible)
  "Set visibility of **gs** structure. Returns the structure object."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-structure-set-visible ptr (if visible 1 0))
        gs))))

(defun set-graphic-structure-transform (gs matrix)
  "Set the 4x4 transformation **matrix** on **gs**. **matrix** is a list of 16 doubles
  in row-major order. Returns the structure object."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)) matrix)
        (cffi:with-foreign-object (mat :double 16)
          (loop for i from 0 below 16
                do (setf (cffi:mem-aref mat :double i)
                         (coerce (if (listp matrix) (nth i matrix) matrix) 'double-float)))
          (%graphic3d-structure-set-transform ptr mat))
        gs))))

(defun remove-graphic-structure-transform (gs)
  "Remove the transformation from **gs**. Returns the structure object."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-structure-remove-transform ptr)
        gs))))

(defun graphic-structure-add-child (parent child)
  "Add **child** structure as a child of **parent**. Returns the parent structure."
  (when (and (graphic-structure-p parent) (graphic-structure-p child))
    (let ((p-ptr (%handle parent))
          (c-ptr (%handle child)))
      (when (and p-ptr c-ptr
                 (not (cffi:null-pointer-p p-ptr))
                 (not (cffi:null-pointer-p c-ptr)))
        (%graphic3d-structure-add-child p-ptr c-ptr)
        parent))))

(defun graphic-structure-remove-child (parent child)
  "Remove **child** structure from **parent**. Returns the parent structure."
  (when (and (graphic-structure-p parent) (graphic-structure-p child))
    (let ((p-ptr (%handle parent))
          (c-ptr (%handle child)))
      (when (and p-ptr c-ptr
                 (not (cffi:null-pointer-p p-ptr))
                 (not (cffi:null-pointer-p c-ptr)))
        (%graphic3d-structure-remove-child p-ptr c-ptr)
        parent))))

(defun graphic-structure-display (gs)
  "Display **gs** in the viewer. Returns the structure object."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-structure-display ptr)
        gs))))

(defun graphic-structure-erase (gs)
  "Erase **gs** from the viewer. Returns the structure object."
  (when (graphic-structure-p gs)
    (let ((ptr (%handle gs)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%graphic3d-structure-erase ptr)
        gs))))

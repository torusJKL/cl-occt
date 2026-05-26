(in-package :cl-occt)

;; --- Entity Owner Classes ---

(defclass entity-owner ()
  ((%ptr :initarg :ptr :accessor %ptr))
  (:documentation "CLOS wrapper for SelectMgr_EntityOwner. GC-managed via tg:finalize."))

(defclass brep-owner (entity-owner)
  ()
  (:documentation "CLOS wrapper for StdSelect_BRepOwner. GC-managed via tg:finalize."))

;; --- Filter Classes ---

(defclass selection-filter ()
  ((%ptr :initarg :ptr :accessor %ptr))
  (:documentation "CLOS wrapper for SelectMgr_Filter. GC-managed via tg:finalize."))

(defclass edge-filter (selection-filter)
  ()
  (:documentation "CLOS wrapper for StdSelect_EdgeFilter."))

(defclass face-filter (selection-filter)
  ()
  (:documentation "CLOS wrapper for StdSelect_FaceFilter."))

(defclass shape-type-filter (selection-filter)
  ()
  (:documentation "CLOS wrapper for StdSelect_ShapeTypeFilter."))

;; --- Predicates ---

(defun entity-owner-p (obj)
  "**Returns:** `t` if **obj** is an `entity-owner` object."
  (typep obj 'entity-owner))

(defun brep-owner-p (obj)
  "**Returns:** `t` if **obj** is a `brep-owner` object."
  (typep obj 'brep-owner))

(defun selection-filter-p (obj)
  "**Returns:** `t` if **obj** is a `selection-filter` object."
  (typep obj 'selection-filter))

(defun edge-filter-p (obj)
  "**Returns:** `t` if **obj** is an `edge-filter` object."
  (typep obj 'edge-filter))

(defun face-filter-p (obj)
  "**Returns:** `t` if **obj** is a `face-filter` object."
  (typep obj 'face-filter))

(defun shape-type-filter-p (obj)
  "**Returns:** `t` if **obj** is a `shape-type-filter` object."
  (typep obj 'shape-type-filter))

;; --- TopAbs shape type conversion ---

(defparameter *shape-type-map*
  '((:compound . 0)
    (:compsolid . 1)
    (:solid . 2)
    (:shell . 3)
    (:face . 4)
    (:wire . 5)
    (:edge . 6)
    (:vertex . 7)
    (:shape . 8))
  "Maps keyword shape types to TopAbs_ShapeEnum integer values.")

;; --- StdSelect_TypeOfEdge conversion ---

(defparameter *edge-type-map*
  '((:any-edge . 0)
    (:line . 1)
    (:circle . 2))
  "Maps keyword edge types to StdSelect_TypeOfEdge integer values.")

;; --- StdSelect_TypeOfFace conversion ---

(defparameter *face-type-map*
  '((:any-face . 0)
    (:plane . 1)
    (:cylinder . 2)
    (:sphere . 3)
    (:torus . 4)
    (:revol . 5)
    (:cone . 6))
  "Maps keyword face types to StdSelect_TypeOfFace integer values.")

;; --- Filter Constructors ---

(defun make-edge-filter ()
  "Create an edge filter (StdSelect_EdgeFilter) that restricts selection to edges only."
  (let ((ptr (%make-edge-filter)))
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (let ((obj (make-instance 'edge-filter :ptr ptr)))
        (tg:finalize obj (lambda () (%free-filter (%ptr obj))))
        obj))))

(defun make-face-filter ()
  "Create a face filter (StdSelect_FaceFilter) that restricts selection to faces only."
  (let ((ptr (%make-face-filter)))
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (let ((obj (make-instance 'face-filter :ptr ptr)))
        (tg:finalize obj (lambda () (%free-filter (%ptr obj))))
        obj))))

(defun make-shape-type-filter (type)
  "Create a shape type filter (StdSelect_ShapeTypeFilter) for the given shape **type** (:edge, :face, :wire, :vertex, :shell, :solid)."
  (let* ((type-val (cdr (assoc type *shape-type-map*)))
         (ptr (when type-val (%make-shape-type-filter type-val))))
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (let ((obj (make-instance 'shape-type-filter :ptr ptr)))
        (tg:finalize obj (lambda () (%free-filter (%ptr obj))))
        obj))))

;; --- Filter Context Operations ---

(defun ais-add-filter (context filter)
  "Add a selection filter to **context**."
  (when (and (ais-context-p context)
             (selection-filter-p filter))
    (let ((ctx-ptr (%ptr context))
          (filter-ptr (%ptr filter)))
      (when (and ctx-ptr filter-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p filter-ptr)))
        (%ais-context-add-filter ctx-ptr filter-ptr)
        t))))

(defun ais-remove-filter (context filter)
  "Remove a selection filter from **context**."
  (when (and (ais-context-p context)
             (selection-filter-p filter))
    (let ((ctx-ptr (%ptr context))
          (filter-ptr (%ptr filter)))
      (when (and ctx-ptr filter-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p filter-ptr)))
        (%ais-context-remove-filter ctx-ptr filter-ptr)
        t))))

;; --- Filter Configuration ---

(defun set-filter-edge-type (filter edge-type)
  "Set the edge type for an **edge-filter**. **edge-type** is a keyword (:any-edge, :line, :circle)."
  (when (edge-filter-p filter)
    (let ((ptr (%ptr filter))
          (type-val (cdr (assoc edge-type *edge-type-map*))))
      (when (and ptr (not (cffi:null-pointer-p ptr)) type-val)
        (%filter-set-edge-type ptr type-val)
        t))))

(defun set-filter-face-type (filter face-type)
  "Set the face type for a **face-filter**. **face-type** is a keyword (:any-face, :plane, :cylinder, :sphere, :torus, :revol, :cone)."
  (when (face-filter-p filter)
    (let ((ptr (%ptr filter))
          (type-val (cdr (assoc face-type *face-type-map*))))
      (when (and ptr (not (cffi:null-pointer-p ptr)) type-val)
        (%filter-set-face-type ptr type-val)
        t))))

;; --- Entity Owner Accessors ---

(defun ais-selected-owner (context)
  "Return the current selected entity owner during selection iteration, or `nil`."
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr))
                          (not (zerop (%ais-context-nb-selected ctx-ptr))))
                  (%ais-context-selected-owner ctx-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let* ((has-shape (not (zerop (%brep-owner-has-shape ptr))))
               (class (if has-shape 'brep-owner 'entity-owner))
               (obj (make-instance class :ptr ptr)))
          (tg:finalize obj (lambda () (%free-owner (%ptr obj))))
          obj)))))

(defun owner-priority (owner)
  "Return the selection priority of an **entity-owner**."
  (when (entity-owner-p owner)
    (let ((ptr (%ptr owner)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%owner-priority ptr)))))

(defun brep-owner-shape (owner)
  "Extract the underlying TopoDS_Shape from a **brep-owner**, or `nil`."
  (when (brep-owner-p owner)
    (let ((ptr (%ptr owner)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((shape-ptr (%brep-owner-shape ptr)))
          (make-shape shape-ptr))))))

(defun owner-location (owner)
  "Return the 4x4 transformation matrix of a **brep-owner** as `#(16 double-floats)`, or `nil` for identity."
  (when (brep-owner-p owner)
    (let ((ptr (%ptr owner)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((matrix (cffi:foreign-alloc :double :count 16)))
          (unwind-protect
               (if (not (zerop (%owner-location ptr matrix)))
                   (let ((result (make-array 16 :element-type 'double-float)))
                     (dotimes (i 16)
                       (setf (aref result i) (cffi:mem-aref matrix :double i)))
                     result)
                   nil)
            (cffi:foreign-free matrix)))))))

(defun free-filter (filter)
  "Explicitly free a selection filter's C handle. Safe to call on `nil`."
  (when (selection-filter-p filter)
    (let ((ptr (%ptr filter)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%free-filter ptr)
        (setf (%ptr filter) (cffi:null-pointer))))))

(defun free-owner (owner)
  "Explicitly free an entity owner's C handle. Safe to call on `nil`."
  (when (entity-owner-p owner)
    (let ((ptr (%ptr owner)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%free-owner ptr)
        (setf (%ptr owner) (cffi:null-pointer))))))

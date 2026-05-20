(in-package :cl-occt)

(defun set-default-background (viewer color)
  (when (viewer-p viewer)
    (let ((rgb (normalize-color color))
          (v-ptr (%viewer viewer)))
      (when (and rgb v-ptr (not (cffi:null-pointer-p v-ptr)))
        (destructuring-bind (r g b) rgb
          (%v3d-viewer-set-default-bg-color v-ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        viewer))))

(defun set-default-projection (viewer orientation)
  (when (viewer-p viewer)
    (let ((orient-int (cdr (assoc orientation *v3d-orientation-map*)))
          (v-ptr (%viewer viewer)))
      (when (and orient-int v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-proj v-ptr orient-int)
        viewer))))

(defun set-default-view-size (viewer size)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-size v-ptr (coerce size 'double-float))
        viewer))))

(defun set-default-view-type (viewer type)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-type v-ptr
          (if (eq type :perspective) 1 0))
        viewer))))

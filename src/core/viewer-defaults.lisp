(in-package :cl-occt)

(defun set-default-bg-gradient (viewer color1 color2 &key (style :y-pos))
  (when (viewer-p viewer)
    (let* ((rgb1 (normalize-color color1))
           (rgb2 (normalize-color color2))
           (style-int (or (cdr (assoc style *gradient-style-map*)) 2))
           (v-ptr (%viewer viewer)))
      (when (and rgb1 rgb2 v-ptr (not (cffi:null-pointer-p v-ptr)))
        (destructuring-bind (r1 g1 b1) rgb1
          (destructuring-bind (r2 g2 b2) rgb2
            (%v3d-viewer-set-default-bg-gradient v-ptr
              (coerce r1 'double-float) (coerce g1 'double-float) (coerce b1 'double-float)
              (coerce r2 'double-float) (coerce g2 'double-float) (coerce b2 'double-float)
              style-int)))
        viewer))))

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

(defun default-lights (viewer)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-lights v-ptr 1)
        viewer))))

(defun set-default-view-type (viewer type)
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-default-view-type v-ptr
          (if (eq type :perspective) 1 0))
        viewer))))

(defun set-default-gradient (viewer color1 color2 &key (style :y-pos))
  (set-default-bg-gradient viewer color1 color2 :style style))

(defun set-default-lights (viewer mode)
  (when (viewer-p viewer)
    (ecase mode
      (:on (default-lights viewer))
      (:off
       (let ((v-ptr (%viewer viewer)))
         (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
           (%v3d-viewer-set-default-lights v-ptr 0)
           viewer)))
      (:custom viewer))))

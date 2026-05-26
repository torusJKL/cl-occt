(in-package :cl-occt.impl)

(defcfun (%face-area "face_area") :int
  (face :pointer)
  (out-area :pointer))

(defcfun (%edge-length "edge_length") :int
  (edge :pointer)
  (out-length :pointer))

(defcfun (%face-normal-at-center "face_normal_at_center") :int
  (face :pointer)
  (out-nx :pointer)
  (out-ny :pointer)
  (out-nz :pointer))

(defcfun (%face-surface-type "face_surface_type") :int
  (face :pointer))

(defcfun (%edge-curve-type "edge_curve_type") :int
  (edge :pointer))

(defcfun (%subshape-bounding-box "subshape_bounding_box") :int
  (shape :pointer)
  (out-xmin :pointer) (out-ymin :pointer) (out-zmin :pointer)
  (out-xmax :pointer) (out-ymax :pointer) (out-zmax :pointer))

(defcfun (%face-center "face_center") :int
  (face :pointer)
  (out-x :pointer) (out-y :pointer) (out-z :pointer))

(defcfun (%shape-extent-along "shape_extent_along") :int
  (shape :pointer)
  (dx :double) (dy :double) (dz :double)
  (out-min :pointer) (out-max :pointer))

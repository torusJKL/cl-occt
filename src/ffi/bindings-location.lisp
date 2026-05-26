(in-package :cl-occt.impl)

(defcfun (%location-from-translation "location_from_translation") :pointer
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%location-multiply "location_multiply") :pointer
  (loc1 :pointer)
  (loc2 :pointer))

(defcfun (%location-inverted "location_inverted") :pointer
  (loc :pointer))

(defcfun (%location-free "location_free") :void
  (loc :pointer))

(defcfun (%shape-get-location "shape_get_location") :pointer
  (shape :pointer))

(defcfun (%shape-moved "shape_moved") :pointer
  (shape :pointer)
  (loc :pointer))

(in-package :cl-occt.impl)

;; --- HLR ---

(defcfun (%hlr-project "hlr_project") :pointer
  (shape :pointer)
  (proj-dx :double) (proj-dy :double) (proj-dz :double)
  (px :double) (py :double) (pz :double))

;; --- Shape Conversion ---

(defcfun (%convert-to-revolution "convert_to_revolution") :pointer
  (shape :pointer))

(defcfun (%convert-swept-to-elementary "convert_swept_to_elementary") :pointer
  (shape :pointer))

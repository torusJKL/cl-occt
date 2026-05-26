(in-package :cl-occt.impl)

;; --- XCAF Dimension & Tolerance C Functions ---

(defcfun (%xcaf-add-linear-dimension "xcaf_add_linear_dimension") :int
  (doc :pointer)
  (shape :pointer)
  (point-coords :pointer)
  (num-points :int)
  (value :double))

(defcfun (%xcaf-add-angular-dimension "xcaf_add_angular_dimension") :int
  (doc :pointer)
  (shape :pointer)
  (edges :pointer)
  (num-edges :int)
  (value :double))

(defcfun (%xcaf-add-diameter-dimension "xcaf_add_diameter_dimension") :int
  (doc :pointer)
  (shape :pointer)
  (subshape :pointer)
  (value :double))

(defcfun (%xcaf-add-tolerance "xcaf_add_tolerance") :int
  (doc :pointer)
  (shape :pointer)
  (type-code :int)
  (value :double)
  (modifier-flags :int))

(defcfun (%xcaf-add-datum "xcaf_add_datum") :int
  (doc :pointer)
  (shape :pointer)
  (label-str :string))

(defcfun (%xcaf-add-geometric-tolerance "xcaf_add_geometric_tolerance") :int
  (doc :pointer)
  (shape :pointer)
  (type-code :int)
  (value :double)
  (datum-labels :pointer)
  (num-datums :int))

(defcfun (%xcaf-get-dimensions "xcaf_get_dimensions") :pointer
  (doc :pointer)
  (shape :pointer)
  (out-count :pointer))

(defcfun (%xcaf-get-tolerances "xcaf_get_tolerances") :pointer
  (doc :pointer)
  (shape :pointer)
  (out-count :pointer))

(defcfun (%xcaf-get-datums "xcaf_get_datums") :pointer
  (doc :pointer)
  (shape :pointer)
  (out-count :pointer))

(defcfun (%xcaf-free-double-array "xcaf_free_double_array") :void
  (arr :pointer))

(defcfun (%xcaf-free-string-array "xcaf_free_string_array") :void
  (arr :pointer)
  (count :int))

(in-package :cl-occt.impl)

;; --- Mass Properties (BRepGProp) ---

(defcfun (%shape-volume "shape_volume") :double
  (shape :pointer))

(defcfun (%shape-area "shape_area") :double
  (shape :pointer))

(defcfun (%shape-center-of-mass "shape_center_of_mass") :int
  (shape :pointer)
  (out-x :pointer)
  (out-y :pointer)
  (out-z :pointer))

(defcfun (%shape-inertia "shape_inertia") :int
  (shape :pointer)
  (out-inertia :pointer)
  (inertia-size :int)
  (out-principal-moments :pointer)
  (pm-size :int)
  (out-principal-axes :pointer)
  (pa-size :int))

;; --- Shape Analysis Queries ---

(defcfun (%shape-distance "shape_distance") :double
  (shape1 :pointer)
  (shape2 :pointer))

(defcfun (%shape-distance-extrema "shape_distance_extrema") :int
  (shape1 :pointer)
  (shape2 :pointer)
  (out-dist :pointer)
  (out-p1x :pointer) (out-p1y :pointer) (out-p1z :pointer)
  (out-p2x :pointer) (out-p2y :pointer) (out-p2z :pointer))

(defcfun (%classify-point-in-solid "classify_point_in_solid") :int
  (shape :pointer)
  (px :double) (py :double) (pz :double)
  (out-state :pointer)
  (out-face :pointer))

(defcfun (%shape-is-valid "shape_is_valid") :int
  (shape :pointer))

(defcfun (%shape-analysis-report "shape_analysis_report") :string
  (shape :pointer))

(defcfun (%intersect-curve-shape "intersect_curve_shape") :int
  (curve :pointer)
  (shape :pointer)
  (out-points :pointer)
  (out-params :pointer)
  (out-faces :pointer)
  (max-results :int))

;; --- Topology Navigation ---

(defcfun (%map-subshapes "map_subshapes") :int
  (shape :pointer)
  (shape-type :int)
  (stop-at-type :int)
  (out-shapes :pointer)
  (max-shapes :int))

(defcfun (%count-subshapes "count_subshapes") :int
  (shape :pointer)
  (shape-type :int)
  (stop-at-type :int))

(defcfun (%dump-shape "dump_shape") :string
  (shape :pointer))

(defcfun (%shape-triangle-count "shape_triangle_count") :int
  (shape :pointer))

(defcfun (%wire-order-check "wire_order_check") :int
  (wire :pointer)
  (face :pointer))

(defcfun (%edge-to-curve "edge_to_curve") :pointer
  (edge :pointer))

(defcfun (%face-to-surface "face_to_surface") :pointer
  (face :pointer))

(defcfun (%make-vertex "make_vertex") :pointer
  (x :double) (y :double) (z :double))

(defcfun (%make-polygon "make_polygon") :pointer
  (points :pointer)
  (num-points :int)
  (closed :int))

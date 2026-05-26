(in-package :cl-occt.impl)

;; --- Shape Fix ---

(defcfun (%fix-shape "fix_shape") :pointer
  (shape :pointer))

(defcfun (%fix-wire "fix_wire") :pointer
  (wire :pointer)
  (face :pointer)
  (tolerance :double))

(defcfun (%fix-solid "fix_solid") :pointer
  (shape :pointer))

(defcfun (%fix-edge "fix_edge") :pointer
  (edge :pointer))

(defcfun (%fix-face "fix_face") :pointer
  (face :pointer))

(defcfun (%shape-analysis-free-edges "shape_analysis_free_edges") :pointer
  (shape :pointer))

(defcfun (%shape-analysis-check-intersections "shape_analysis_check_intersections") :int
  (shape :pointer))

(defcfun (%shape-analysis-wire-contains "shape_analysis_wire_contains") :int
  (wire :pointer)
  (x :double)
  (y :double))

(defcfun (%shape-analysis-contents "shape_analysis_contents") :string
  (shape :pointer))

;; --- Shape Rebuild ---

(defcfun (%substitute-single "substitute_single") :pointer
  (shape :pointer)
  (old-sub :pointer)
  (new-sub :pointer))

(defcfun (%substitute-batch "substitute_batch") :pointer
  (shape :pointer)
  (old-shapes :pointer)
  (new-shapes :pointer)
  (count :int))

(defcfun (%shape-to-nurbs "shape_to_nurbs") :pointer
  (shape :pointer))

(defcfun (%shape-reduce-degree "shape_reduce_degree") :pointer
  (shape :pointer)
  (max-degree :int))

(defcfun (%shape-to-rational-bspline "shape_to_rational_bspline") :pointer
  (shape :pointer))

(defcfun (%shape-split-u "shape_split_u") :pointer
  (shape :pointer)
  (num-splits :int))

(defcfun (%shape-upgrade-continuity "shape_upgrade_continuity") :pointer
  (shape :pointer)
  (continuity :int))

;; --- Shape Process Pipeline ---

(defcfun (%apply-shape-process "apply_shape_process") :pointer
  (shape :pointer)
  (operator-name :string))

(defcfun (%apply-operator-sequence "apply_operator_sequence") :pointer
  (shape :pointer)
  (operators :pointer)
  (count :int))

(defcfun (%apply-healing-pipeline "apply_healing_pipeline") :pointer
  (shape :pointer)
  (pipeline-name :string)
  (resource :string))

(defcfun (%heal-shape-default "heal_shape_default") :pointer
  (shape :pointer))

;; --- Sewing ---

(defcfun (%sew-shapes "sew_shapes") :pointer
  (shapes :pointer)
  (num-shapes :int)
  (tolerance :double)
  (allow-non-manifold :int))

;; --- Defeaturing ---

(defcfun (%defeature-shape "defeature_shape") :pointer
  (shape :pointer)
  (faces :pointer)
  (num-faces :int))

;; --- Shape Check & Builder ---

(defcfun (%check-shape-validity "check_shape_validity") :string
  (shape :pointer))

(defcfun (%boolean-builder "boolean_builder") :pointer
  (shape1 :pointer)
  (shape2 :pointer)
  (operation :int))

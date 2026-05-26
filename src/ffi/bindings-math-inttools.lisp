(in-package :cl-occt.impl)

;; --- math_BFGS, math_FRPR, math_PSO, math_GlobOptMin ---

(defcfun (%math-bfgs-minimize "math_bfgs_minimize") :int
  (fn :pointer) (n-vars :int) (initial :pointer)
  (tolerance :double) (max-iter :int)
  (out-minimizer :pointer) (out-min-value :pointer) (out-iterations :pointer))

(defcfun (%math-frpr-minimize "math_frpr_minimize") :int
  (fn :pointer) (n-vars :int) (initial :pointer)
  (tolerance :double) (max-iter :int)
  (out-minimizer :pointer) (out-min-value :pointer) (out-iterations :pointer))

(defcfun (%math-pso-minimize "math_pso_minimize") :int
  (fn :pointer) (n-vars :int)
  (lower :pointer) (upper :pointer) (initial :pointer)
  (n-particles :int) (max-iter :int) (tolerance :double)
  (out-minimizer :pointer) (out-min-value :pointer) (out-iterations :pointer))

(defcfun (%math-globoptmin-minimize "math_globoptmin_minimize") :int
  (fn :pointer) (n-vars :int)
  (lower :pointer) (upper :pointer)
  (tolerance :double) (max-iter :int)
  (out-minimizer :pointer) (out-min-value :pointer) (out-iterations :pointer))

;; --- IntTools_EdgeEdge, IntTools_EdgeFace, IntTools_FaceFace ---

(defcfun (%inttools-edge-edge "inttools_edge_edge") :int
  (edge1 :pointer) (edge2 :pointer)
  (out-points :pointer) (max-points :int) (out-count :pointer))

(defcfun (%inttools-edge-face "inttools_edge_face") :int
  (edge :pointer) (face :pointer)
  (out-points :pointer) (max-points :int) (out-count :pointer))

(defcfun (%inttools-face-face "inttools_face_face") :int
  (face1 :pointer) (face2 :pointer)
  (out-points :pointer) (max-points :int) (out-point-count :pointer)
  (out-curves :pointer) (max-curves :int) (out-curve-count :pointer))

(defcfun (%inttools-free-curve "inttools_free_curve") :void
  (curve :pointer))

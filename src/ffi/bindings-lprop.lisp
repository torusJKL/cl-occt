(in-package :cl-occt.impl)

(defcfun (%curve-tangent-at "curve_tangent_at") :int
  (curve :pointer)
  (param :double)
  (out-tx :pointer)
  (out-ty :pointer)
  (out-tz :pointer))

(defcfun (%curve-curvature-at "curve_curvature_at") :int
  (curve :pointer)
  (param :double)
  (out-k :pointer))

(defcfun (%surface-normal-at "surface_normal_at") :int
  (surface :pointer)
  (u :double)
  (v :double)
  (out-nx :pointer)
  (out-ny :pointer)
  (out-nz :pointer))

(defcfun (%surface-curvature-at "surface_curvature_at") :int
  (surface :pointer)
  (u :double)
  (v :double)
  (out-min-k :pointer)
  (out-max-k :pointer))

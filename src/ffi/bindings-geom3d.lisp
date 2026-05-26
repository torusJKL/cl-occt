(in-package :cl-occt.impl)

;; --- 3D Curves ---

(defcfun (%make-line-3d "make_line_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-circle-3d "make_circle_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (radius :double))

(defcfun (%make-ellipse-3d "make_ellipse_3d") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-hyperbola "make_hyperbola") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-parabola "make_parabola") :pointer
  (ox :double) (oy :double) (oz :double)
  (focal :double))

(defcfun (%make-bezier-curve "make_bezier_curve") :pointer
  (points :pointer) (num-points :int))

(defcfun (%make-bspline-curve "make_bspline_curve") :pointer
  (poles :pointer) (num-poles :int)
  (knots :pointer) (mults :pointer) (num-knots :int)
  (degree :int))

(defcfun (%free-curve "free_curve") :void
  (curve :pointer))

(defcfun (%curve-type "curve_type") :int
  (curve :pointer))

(defcfun (%make-gc-line "make_gc_line") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%make-gc-arc-of-circle "make_gc_arc_of_circle") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double)
  (x3 :double) (y3 :double) (z3 :double))

(defcfun (%convert-curve-to-bspline "convert_curve_to_bspline") :pointer
  (curve :pointer))

(defcfun (%curve-bounding-box "curve_bounding_box") :int
  (curve :pointer)
  (xmin :pointer) (ymin :pointer) (zmin :pointer)
  (xmax :pointer) (ymax :pointer) (zmax :pointer))

;; --- 3D Surfaces ---

(defcfun (%make-plane "make_plane") :pointer
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%make-cylindrical-surface "make_cylindrical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (radius :double))

(defcfun (%make-conical-surface "make_conical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (radius :double) (semi-angle :double))

(defcfun (%make-spherical-surface "make_spherical_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (radius :double))

(defcfun (%make-toroidal-surface "make_toroidal_surface") :pointer
  (ox :double) (oy :double) (oz :double)
  (major-r :double) (minor-r :double))

(defcfun (%make-bezier-surface "make_bezier_surface") :pointer
  (poles :pointer) (num-u :int) (num-v :int))

(defcfun (%make-bspline-surface "make_bspline_surface") :pointer
  (poles :pointer)
  (num-u-poles :int) (num-v-poles :int)
  (uknots :pointer) (umults :pointer) (num-uknots :int)
  (vknots :pointer) (vmults :pointer) (num-vknots :int)
  (udeg :int) (vdeg :int))

(defcfun (%free-surface "free_surface") :void
  (surface :pointer))

(defcfun (%surface-type "surface_type") :int
  (surface :pointer))

(defcfun (%convert-surface-to-bspline "convert_surface_to_bspline") :pointer
  (surface :pointer))

(defcfun (%surface-bounding-box "surface_bounding_box") :int
  (surface :pointer)
  (xmin :pointer) (ymin :pointer) (zmin :pointer)
  (xmax :pointer) (ymax :pointer) (zmax :pointer))

;; --- Geometric Algorithms ---

(defcfun (%project-point-on-curve "project_point_on_curve") :int
  (curve :pointer)
  (px :double) (py :double) (pz :double)
  (out-x :pointer) (out-y :pointer) (out-z :pointer)
  (out-dist :pointer) (out-param :pointer))

(defcfun (%project-point-on-surface "project_point_on_surface") :int
  (surface :pointer)
  (px :double) (py :double) (pz :double)
  (out-x :pointer) (out-y :pointer) (out-z :pointer)
  (out-u :pointer) (out-v :pointer) (out-dist :pointer))

(defcfun (%intersect-curves "intersect_curves") :int
  (c1 :pointer) (c2 :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%intersect-curve-surface "intersect_curve_surface") :int
  (curve :pointer) (surface :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%intersect-surfaces "intersect_surfaces") :int
  (s1 :pointer) (s2 :pointer)
  (out-curves :pointer) (max-curves :int))

(defcfun (%extrema-curve-curve "extrema_curve_curve") :int
  (c1 :pointer) (c2 :pointer)
  (out-dist :pointer)
  (out-p1x :pointer) (out-p1y :pointer) (out-p1z :pointer)
  (out-p2x :pointer) (out-p2y :pointer) (out-p2z :pointer))

(defcfun (%extrema-curve-surface "extrema_curve_surface") :int
  (curve :pointer) (surface :pointer)
  (out-dist :pointer)
  (out-px :pointer) (out-py :pointer) (out-pz :pointer)
  (out-u :pointer) (out-v :pointer))

(defcfun (%intersect-curves-2d "intersect_curves_2d") :int
  (c1 :pointer) (c2 :pointer)
  (out-points :pointer) (max-points :int))

(defcfun (%project-point-on-curve-2d "project_point_on_curve_2d") :int
  (curve :pointer)
  (px :double) (py :double)
  (out-x :pointer) (out-y :pointer)
  (out-dist :pointer) (out-param :pointer))

(defcfun (%points-to-bspline "points_to_bspline") :pointer
  (points :pointer) (num-points :int) (degree :int))

(defcfun (%interpolate-points "interpolate_points") :pointer
  (points :pointer) (num-points :int)
  (init-tangent :pointer) (final-tangent :pointer))

(in-package :cl-occt)
(deftest make-line-3d-valid
  (assert-curve (make-line-3d 0 0 0 0 0 1)))
(deftest make-line-3d-zero-dir
  (assert-nil (make-line-3d 0 0 0 0 0 0)))
(deftest make-circle-3d-valid
  (assert-curve (make-circle-3d 0 0 0 10)))
(deftest make-circle-3d-zero-radius
  (assert-nil (make-circle-3d 0 0 0 0)))
(deftest make-ellipse-3d-valid
  (assert-curve (make-ellipse 0 0 0 10 5)))
(deftest make-ellipse-3d-zero-major
  (assert-nil (make-ellipse 0 0 0 0 5)))
(deftest make-hyperbola-valid
  (assert-curve (make-hyperbola 0 0 0 10 5)))
(deftest make-parabola-valid
  (assert-curve (make-parabola 0 0 0 10)))
(deftest make-parabola-zero-focal
  (assert-nil (make-parabola 0 0 0 0)))
(deftest make-bezier-curve-valid
  (assert-curve (make-bezier-curve '((0 0 0) (1 2 3) (4 5 6)))))
(deftest make-bspline-curve-valid
  (assert-curve (make-bspline-curve '((0 0 0) (1 1 1) (2 2 2))
                                     '(0.0 1.0) '(3 3) 2)))
(deftest curve-type-line
  (assert-true (eq :line (curve-type (make-line-3d 0 0 0 0 0 1)))))
(deftest curve-type-circle
  (assert-true (eq :circle (curve-type (make-circle-3d 0 0 0 10)))))
(deftest curve-type-ellipse
  (assert-true (eq :ellipse (curve-type (make-ellipse 0 0 0 10 5)))))
(deftest curve-type-bezier
  (assert-true (eq :bezier-curve (curve-type (make-bezier-curve '((0 0 0) (1 1 1) (2 2 2)))))))
(deftest curve-type-bspline
  (assert-true (eq :bspline-curve (curve-type (make-bspline-curve '((0 0 0) (1 1 1) (2 2 2))
                                                                    '(0.0 1.0) '(3 3) 2)))))

;; --- 3D Surfaces ---

(defun assert-surface (val &optional msg)
  (assert-true (surface-p val) (or msg "expected surface")))
(deftest make-plane-valid
  (assert-surface (make-plane 0 0 0 0 0 1)))
(deftest make-plane-zero-normal
  (assert-nil (make-plane 0 0 0 0 0 0)))
(deftest make-cylindrical-surface-valid
  (assert-surface (make-cylindrical-surface 0 0 0 0 0 1 5)))
(deftest make-cylindrical-surface-zero-radius
  (assert-nil (make-cylindrical-surface 0 0 0 0 0 1 0)))
(deftest make-conical-surface-valid
  (assert-surface (make-conical-surface 0 0 0 0 0 1 5 30)))
(deftest make-spherical-surface-valid
  (assert-surface (make-spherical-surface 0 0 0 10)))
(deftest make-spherical-surface-zero-radius
  (assert-nil (make-spherical-surface 0 0 0 0)))
(deftest make-toroidal-surface-valid
  (assert-surface (make-toroidal-surface 0 0 0 10 3)))
(deftest surface-type-plane
  (assert-true (eq :plane (surface-type (make-plane 0 0 0 0 0 1)))))
(deftest surface-type-cylindrical
  (assert-true (eq :cylindrical-surface (surface-type (make-cylindrical-surface 0 0 0 0 0 1 5)))))

;; --- GC Constructors ---
(deftest make-gc-line-valid
  (assert-curve (make-gc-line 0 0 0 10 10 10)))
(deftest make-gc-arc-of-circle-valid
  (assert-curve (make-gc-arc-of-circle 0 0 0 10 0 0 0 10 0)))

;; --- NURBS Conversion ---
(deftest convert-curve-to-bspline-valid
  (let* ((c (make-circle-3d 0 0 0 10))
         (b (convert-curve-to-bspline c)))
    (assert-curve b)
    (assert-true (eq :bspline-curve (curve-type b)))))
(deftest convert-surface-to-bspline-valid
  (let* ((s (make-toroidal-surface 0 0 0 10 3))
         (b (convert-surface-to-bspline s)))
    (assert-surface b)
    (assert-true (eq :bspline-surface (surface-type b)))))

;; --- Bounding Boxes ---
(deftest curve-bounding-box-valid
  (let ((c (make-line-3d 0 0 0 1 0 0)))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (curve-bounding-box c)
      (assert-true (and xmin ymin zmin xmax ymax zmax)))))
(deftest surface-bounding-box-valid
  (let ((s (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (surface-bounding-box s)
      (assert-true (and xmin ymin zmin xmax ymax zmax)))))

;; --- Geometric Algorithms ---
(deftest project-point-on-curve-valid
  (let ((c (make-line-3d 0 0 0 0 0 1)))
    (multiple-value-bind (x y z dist param)
        (project-point-on-curve c 10 10 5)
      (assert-true (and x y z dist param)))))
(deftest project-point-on-surface-valid
  (let ((s (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (x y z u v dist)
        (project-point-on-surface s 5 5 10)
      (assert-true (and x y z u v dist)))))
(deftest intersect-curves-valid
  (let* ((c1 (make-line-3d 0 0 0 1 0 0))
         (c2 (make-line-3d 0 0 0 0 1 0))
         (result (intersect-curves c1 c2)))
    (assert-true (consp result))))
(deftest intersect-curves-no-intersection
  (let* ((c1 (make-line-3d 0 0 0 1 0 0))
         (c2 (make-line-3d 0 1 0 1 0 0))
         (result (intersect-curves c1 c2)))
    (assert-nil result "parallel lines should not intersect")))
(deftest intersect-curve-surface-valid
  (let* ((c (make-line-3d 0 0 5 0 0 -1))
         (s (make-plane 0 0 0 0 0 1))
         (result (intersect-curve-surface c s)))
    (assert-true (consp result))))
(deftest points-to-bspline-valid
  (assert-curve (points-to-bspline '((0 0 0) (1 2 3) (4 5 6) (7 8 9)))))
(deftest points-to-bspline-degree
  (assert-curve (points-to-bspline '((0 0 0) (1 2 3) (4 5 6)) :degree 2)))
(deftest interpolate-points-valid
  (assert-curve (interpolate-points '((0 0 0) (10 0 0) (10 10 0) (10 10 10)))))
(deftest interpolate-points-with-tangents
  (assert-curve (interpolate-points '((0 0 0) (1 2 3) (4 5 6))
                                     :initial-tangent '(1 1 1)
                                     :final-tangent '(0 1 0))))

;; --- Helix ---
(deftest make-helix-curve-valid
  (assert-curve (make-helix-curve :radius 5 :pitch 2 :height 20)))
(deftest make-helix-curve-left-handed
  (assert-curve (make-helix-curve :radius 5 :pitch 2 :height 20 :left-handed t)))
(deftest make-helix-curve-zero-radius
  (assert-nil (make-helix-curve :radius 0 :pitch 2 :height 20)))
(deftest make-helix-edge-valid
  (assert-shape (make-helix-edge :radius 5 :pitch 2 :height 20)))
(deftest make-helix-edge-zero-radius
  (assert-nil (make-helix-edge :radius 0 :pitch 2 :height 20)))

;; --- GC Finalization ---

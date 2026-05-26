(in-package :cl-occt)

;; --- Proximity tests ---

(deftest brep-proximity-near-boxes
  (let* ((a (mesh-shape (make-box 10 10 10)))
         (b (mesh-shape (translate (make-box 10 10 10) 12 0 0)))
         (zones (shape-proximity a b 5.0d0)))
    (assert-true (and (listp zones) (plusp (length zones)))
                 "near boxes should have proximity zones")))

(deftest brep-proximity-nil-input
  (assert-nil (shape-proximity nil (make-box 10 10 10) 0.1d0)))

(deftest brep-proximity-far-shapes
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 100 0 0)))
    (assert-nil (shape-proximity a b 0.1d0)
                "far shapes should have no proximity zones within small tolerance")))

;; --- Overlap tests ---

(deftest brep-overlap-overlapping
  (let* ((a (mesh-shape (make-box 10 10 10)))
         (b (mesh-shape (translate (make-box 10 10 10) 5 0 0))))
    ;; With tolerance > 0, detect proximity between nearby faces
    (assert-true (shape-overlap-p a b 5.0d0)
                 "overlapping boxes should return t with generous tolerance")))

(deftest brep-overlap-non-overlapping
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0)))
    (assert-nil (shape-overlap-p a b 0.1d0)
                "non-overlapping boxes should return nil")))

(deftest brep-overlap-nil-input
  (assert-nil (shape-overlap-p nil (make-box 10 10 10))))

(deftest brep-overlap-detail-overlapping
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 5 0 0))
         (pairs (shape-overlap a b 5.0d0)))
    (assert-true (listp pairs) "shape-overlap should return a list")))

(deftest brep-overlap-detail-non-overlapping
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0)))
    (assert-nil (shape-overlap a b 0.1d0)
                "non-overlapping boxes should return nil from shape-overlap")))

(deftest brep-overlap-detail-nil-input
  (assert-nil (shape-overlap nil (make-box 10 10 10))))

;; --- Self-intersection tests ---

(deftest brep-self-intersect-valid-box
  (let* ((box (make-box 10 20 30))
         (result (shape-self-intersect-p box)))
    (assert-nil result "valid box should have no self-intersections")))

(deftest brep-self-intersect-nil-input
  (assert-nil (shape-self-intersect-p nil)))

;; --- Face distance tests ---

(deftest brep-face-distance-parallel
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (d (face-distance (first faces) (second faces))))
    (assert-true (and (numberp d) (>= d 0))
                 "face distance should be a non-negative number")))

(deftest brep-face-distance-nil-input
  (assert-nil (face-distance nil (make-box 10 10 10))))

;; --- Curve tangent tests ---

(deftest brep-curve-tangent-line
  (let ((c (make-line-3d 0 0 0 1 0 0)))
    (multiple-value-bind (tx ty tz) (curve-tangent-at c 0.5d0)
      (assert-true (and (numberp tx) (numberp ty) (numberp tz))
                   "line tangent should return three values"))))

(deftest brep-curve-tangent-nil-input
  (assert-nil (curve-tangent-at nil 0.0d0)))

;; --- Curve curvature tests ---

(deftest brep-curve-curvature-circle
  (let* ((r 5.0d0)
         (c (make-circle-3d 0 0 0 r))
         (k (curve-curvature-at c 0.0d0)))
    (assert-true (and (numberp k) (> k 0))
                 "circle curvature should be positive")))

(deftest brep-curve-curvature-nil-input
  (assert-nil (curve-curvature-at nil 0.0d0)))

;; --- Surface normal tests ---

(deftest brep-surface-normal-plane
  (let ((s (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (nx ny nz) (surface-normal-at s 0.0d0 0.0d0)
      (assert-true (and (numberp nx) (numberp ny) (numberp nz))
                   "plane normal should return three values"))))

(deftest brep-surface-normal-nil-input
  (assert-nil (surface-normal-at nil 0.0d0 0.0d0)))

;; --- Surface curvature tests ---

(deftest brep-surface-curvature-sphere
  (let* ((r 5.0d0)
         (s (make-spherical-surface 0 0 0 r)))
    (multiple-value-bind (min-k max-k) (surface-curvature-at s 0.0d0 0.0d0)
      (assert-true (and (numberp min-k) (numberp max-k))
                   "sphere curvature should return two values"))))

(deftest brep-surface-curvature-nil-input
  (assert-nil (surface-curvature-at nil 0.0d0 0.0d0)))

;; --- Face normal tests ---

(deftest brep-face-normal-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face)))
    (multiple-value-bind (nx ny nz) (face-normal-at (first faces) 0.5d0 0.5d0)
      (assert-true (and (numberp nx) (numberp ny) (numberp nz))
                   "face normal should return three values"))))

(deftest brep-face-normal-nil-input
  (assert-nil (face-normal-at nil 0.0d0 0.0d0)))

;; --- Face curvature tests ---

(deftest brep-face-curvature-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face)))
    (multiple-value-bind (min-k max-k) (face-curvature-at (first faces) 0.5d0 0.5d0)
      (assert-true (and (numberp min-k) (numberp max-k))
                   "face curvature should return two values"))))

(deftest brep-face-curvature-nil-input
  (assert-nil (face-curvature-at nil 0.0d0 0.0d0)))

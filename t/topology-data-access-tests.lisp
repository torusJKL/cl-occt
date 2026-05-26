(in-package :cl-occt)

;; --- Vertex Point ---

(deftest vertex-point-box-corner
  (let* ((box (make-box 10 20 30))
         (verts (map-shape-subshapes box :vertex)))
    (assert-true (>= (length verts) 1) "box should have vertices")
    (multiple-value-bind (x y z) (vertex-point (first verts))
      (assert-true (and (numberp x) (numberp y) (numberp z))
                   "should return three values")
      (assert-true (or (= x 0) (= x 10))
                   "vertex x should be 0 or 10"))))

(deftest vertex-point-null
  (multiple-value-bind (x y z) (vertex-point nil)
    (assert-nil x)
    (assert-nil y)
    (assert-nil z)))

;; --- Edge Curve Range ---

(deftest edge-curve-range-box
  (let* ((box (make-box 10 20 30))
         (edges (map-shape-subshapes box :edge))
         (edge (first edges)))
    (multiple-value-bind (curve first last) (edge-curve-range edge)
      (assert-true (curve-p curve) "should return a curve")
      (assert-true (numberp first) "first should be a number")
      (assert-true (numberp last) "last should be a number")
      (assert-true (< first last) "first should be less than last"))))

(deftest edge-curve-range-circle
  (let ((circ (make-cylinder 5 10)))
    (dolist (edge (map-shape-subshapes circ :edge))
      (multiple-value-bind (curve first last) (edge-curve-range edge)
        (when (and (curve-p curve) (eq (curve-type curve) :circle))
          (assert-true (approx (abs (- last first)) (* 2 pi) 1e-6)
                       "circular edge should span ~2*PI"))))))

(deftest edge-curve-range-null
  (multiple-value-bind (curve first last) (edge-curve-range nil)
    (assert-nil curve)
    (assert-nil first)
    (assert-nil last)))

(deftest edge-curve-convenience
  (let* ((box (make-box 10 20 30))
         (edges (map-shape-subshapes box :edge))
         (edge (first edges)))
    (let ((curve (edge-curve edge)))
      (assert-true (curve-p curve) "should return a curve"))))

;; --- Face Surface UV Bounds ---

(deftest face-surface-uv-bounds-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (multiple-value-bind (surface umin umax vmin vmax)
        (face-surface-uv-bounds face)
      (assert-true (surface-p surface) "should return a surface")
      (assert-true (and (numberp umin) (numberp umax) (numberp vmin) (numberp vmax))
                   "should return four numeric bounds")
      (assert-true (and (< umin umax) (< vmin vmax))
                   "UV bounds should be valid"))))

(deftest face-surface-uv-bounds-cylinder
  (let* ((cyl (make-cylinder 5 10))
         (faces (map-shape-subshapes cyl :face)))
    (dolist (face faces)
      (if (eq (face-surface-type face) :cylinder)
          (multiple-value-bind (surface umin umax vmin vmax)
              (face-surface-uv-bounds face)
            (declare (ignore surface))
            (assert-true (approx umin 0.0 1e-6)
                         "U min should be ~0")
            (assert-true (approx (- umax umin) (* 2 pi) 1e-6)
                         "U range should be ~2*PI")
            (assert-true (approx vmin 0.0 1e-6)
                         "V min should be ~0")
            (assert-true (approx (- vmax vmin) 10.0 1e-6)
                         "V range should be ~10"))))))

(deftest face-surface-uv-bounds-null
  (multiple-value-bind (surface umin umax vmin vmax)
      (face-surface-uv-bounds nil)
    (assert-nil surface)
    (assert-nil umin)
    (assert-nil umax)
    (assert-nil vmin)
    (assert-nil vmax)))

(deftest face-surface-convenience
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (let ((surface (face-surface face)))
      (assert-true (surface-p surface) "should return a surface"))))

;; --- Shape Tolerance ---

(deftest shape-tolerance-edge
  (let* ((box (make-box 10 20 30))
         (edge (first (map-shape-subshapes box :edge))))
    (let ((tol (shape-tolerance edge)))
      (assert-true (and (numberp tol) (>= tol 0))
                   "edge tolerance should be non-negative"))))

(deftest shape-tolerance-face
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (let ((tol (shape-tolerance face)))
      (assert-true (and (numberp tol) (>= tol 0))
                   "face tolerance should be non-negative"))))

(deftest shape-tolerance-null
  (assert-nil (shape-tolerance nil)))

;; --- Face Natural Restriction ---

(deftest face-natural-restriction-returns-boolean
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (let ((result (face-natural-restriction-p face)))
      (assert-true (member result '(t nil))
                   "natural restriction should return t or nil"))))

(deftest face-natural-restriction-null
  (assert-nil (face-natural-restriction-p nil)))

;; --- Reverse Orientation ---

(deftest reverse-orientation-flips
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (original-orientation (shape-orientation face))
         (reversed (reverse-orientation face)))
    (assert-true (shape-p reversed) "reversed should be a shape")
    (assert-true (not (eq (shape-orientation reversed) original-orientation))
                 "orientation should flip after reversal")))

(deftest reverse-orientation-null
  (assert-nil (reverse-orientation nil)))

;; --- Shape Orientation ---

(deftest shape-orientation-forward
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (let ((orient (shape-orientation face)))
      (assert-true (member orient '(:forward :reversed))
                   "orientation should be :forward or :reversed"))))

(deftest shape-orientation-null
  (assert-nil (shape-orientation nil)))

;; --- Curve Value ---

(deftest curve-value-line
  (let* ((line (make-line-3d 0 0 0 1 0 0)))
    (multiple-value-bind (x y z) (curve-value line 5.0)
      (assert-true (approx x 5.0 1e-10) "line at t=5 should have x=5")
      (assert-true (approx y 0.0 1e-10) "line at t=5 should have y=0")
      (assert-true (approx z 0.0 1e-10) "line at t=5 should have z=0"))))

(deftest curve-value-circle
  (let* ((circle (make-circle-3d 0 0 0 5)))
    (multiple-value-bind (x y z) (curve-value circle (/ pi 2))
      (assert-true (approx x 0.0 1e-6) "circle at PI/2 should have x~0")
      (assert-true (approx y 5.0 1e-6) "circle at PI/2 should have y=5")
      (assert-true (approx z 0.0 1e-6) "circle at PI/2 should have z=0"))))

(deftest curve-value-null
  (multiple-value-bind (x y z) (curve-value nil 0.0)
    (assert-nil x)
    (assert-nil y)
    (assert-nil z)))

;; --- Surface Value ---

(deftest surface-value-plane
  (let* ((plane (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (x y z) (surface-value plane 10.0 20.0)
      (assert-true (approx x 10.0 1e-10) "plane u=10,v=20 should have x=10")
      (assert-true (approx y 20.0 1e-10) "plane u=10,v=20 should have y=20")
      (assert-true (approx z 0.0 1e-10) "plane u=10,v=20 should have z=0"))))

(deftest surface-value-cylinder
  (let* ((cyl (make-cylindrical-surface 0 0 0 0 0 1 5)))
    (multiple-value-bind (x y z) (surface-value cyl 0.0 0.0)
      (assert-true (approx x 5.0 1e-6) "cylinder u=0,v=0 should have x=5")
      (assert-true (approx y 0.0 1e-6) "cylinder u=0,v=0 should have y=0")
      (assert-true (approx z 0.0 1e-6) "cylinder u=0,v=0 should have z=0"))))

(deftest surface-value-null
  (multiple-value-bind (x y z) (surface-value nil 0.0 0.0)
    (assert-nil x)
    (assert-nil y)
    (assert-nil z)))

;; --- Copy Shape ---

(deftest copy-shape-independence
  (let* ((original (make-box 10 20 30))
         (copy (copy-shape original)))
    (assert-true (shape-p copy) "copy should be a shape")
    (assert-true (approx (shape-volume original) (shape-volume copy) 1e-6)
                 "copy should have same volume")
    (assert-true (not (eq (%ptr original) (%ptr copy)))
                 "copy should have different C pointer")))

(deftest copy-shape-preserves-geometry
  (let* ((box (make-box 10 20 30))
         (copy (copy-shape box)))
    (assert-true (= (length (map-shape-subshapes box :face))
                    (length (map-shape-subshapes copy :face)))
                 "same face count")
    (assert-true (= (length (map-shape-subshapes box :edge))
                    (length (map-shape-subshapes copy :edge)))
                 "same edge count")))

(deftest copy-shape-null
  (assert-nil (copy-shape nil)))

;; --- Precision Constants ---

(deftest precision-confusion-positive
  (assert-true (and (numberp +precision-confusion+)
                    (> +precision-confusion+ 0))
               "precision-confusion should be positive"))

(deftest precision-angular-positive
  (assert-true (and (numberp +precision-angular+)
                    (> +precision-angular+ 0))
               "precision-angular should be positive"))

(deftest precision-intersection-positive
  (assert-true (and (numberp +precision-intersection+)
                    (> +precision-intersection+ 0))
               "precision-intersection should be positive"))

(deftest precision-confusion-magnitude
  (assert-true (approx +precision-confusion+ 1e-7 1e-8)
               "precision-confusion should be approx 1e-7"))

(deftest precision-angular-magnitude
  (assert-true (approx +precision-angular+ 1e-12 1e-13)
               "precision-angular should be approx 1e-12"))

(deftest precision-intersection-magnitude
  (assert-true (approx +precision-intersection+ 1e-9 1e-10)
               "precision-intersection should be approx 1e-9"))

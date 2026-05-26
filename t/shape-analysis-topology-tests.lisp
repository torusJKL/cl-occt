(in-package :cl-occt)
(deftest shape-analysis-distance
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0))
         (d (shape-distance a b)))
    (assert-true (and (numberp d) (> d 9) (< d 11))
                 "distance between offset boxes should be ~10")))
(deftest shape-analysis-distance-nil
  (assert-nil (shape-distance (make-box 10 10 10) nil)))
(deftest shape-analysis-distance-extrema
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0))
         (e (shape-distance-extrema a b)))
    (assert-true (typep e 'shape-extrema) "should return shape-extrema")
    (assert-true (numberp (extrema-distance e)))
    (assert-true (listp (extrema-point-on-shape1 e)))))
(deftest shape-analysis-point-in-solid-inside
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :inside (point-in-solid-p '(5 10 15) box)))))
(deftest shape-analysis-point-in-solid-outside
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :outside (point-in-solid-p '(100 100 100) box)))))
(deftest shape-analysis-point-in-solid-on
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :on (point-in-solid-p '(0 10 15) box)))))
(deftest shape-analysis-classify
  (let ((box (make-box 10 20 30)))
    (multiple-value-bind (state face) (classify-point-in-solid '(5 10 15) box)
      (assert-true (eq :inside state))
      (assert-nil face))))
(deftest shape-analysis-valid-p
  (assert-true (shape-valid-p (make-box 10 20 30))))
(deftest shape-analysis-valid-p-nil
  (assert-nil (shape-valid-p nil)))
(deftest shape-analysis-check
  (assert-nil (shape-check (make-box 10 20 30))
              "valid shape should return nil from shape-check"))

;; --- Topology Navigation ---
(deftest topology-map-faces
  (let ((faces (map-shape-subshapes (make-box 10 20 30) :face)))
    (assert-true (= (length faces) 6) "box should have 6 faces")))
(deftest topology-map-edges
  (let ((edges (map-shape-subshapes (make-box 10 20 30) :edge)))
    (assert-true (= (length edges) 24) "box should have 24 edge entries (6 faces x 4 edges)")))
(deftest topology-map-vertices
  (let ((verts (map-shape-subshapes (make-box 10 20 30) :vertex)))
    (assert-true (= (length verts) 48) "box should have 48 vertex entries (24 edges x 2 vertices)")))
(deftest topology-count-faces
  (let ((n (count-shape-subshapes (make-box 10 20 30) :face)))
    (assert-true (= n 6) "box should have 6 faces")))
(deftest topology-count-edges
  (let ((n (count-shape-subshapes (make-box 10 20 30) :edge)))
    (assert-true (= n 24) "box should have 24 edge entries (6 faces x 4 edges)")))
(deftest topology-dump-shape
  (let ((dump (dump-shape (make-box 10 20 30))))
    (assert-true (and (stringp dump) (> (length dump) 0))
                 "dump-shape should return a non-empty string")))
(deftest topology-dump-shape-nil
  (assert-nil (dump-shape nil)))
(deftest topology-make-vertex
  (let ((v (make-vertex 1.0 2.0 3.0)))
    (assert-true (shape-p v) "make-vertex should return a shape")))
(deftest topology-make-polygon-closed
  (let ((p (make-polygon '((0 0 0) (10 0 0) (10 10 0) (0 10 0)) :closed t)))
    (assert-true (shape-p p) "make-polygon closed should return shape")))
(deftest topology-make-polygon-open
  (let ((p (make-polygon '((0 0 0) (10 0 0) (10 10 0)) :closed nil)))
    (assert-true (shape-p p) "make-polygon open should return shape")))
(deftest topology-make-polygon-too-few-points
  (assert-nil (make-polygon '((0 0 0)) :closed nil)
              "single point should return nil"))
(deftest topology-triangle-count
  (let ((n (shape-triangle-count (make-box 10 20 30))))
    (assert-true (and (integerp n) (> n 0))
                 "triangle count should be positive integer")))
(deftest topology-wire-order-check
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w)))
    (assert-true (wire-order-check-p w f)
                 "valid square wire should pass order check")))
(deftest topology-edge->curve
  (let* ((e (make-edge-3d 0 0 0 10 0 0))
         (c (edge->curve e)))
    (assert-true (or (null c) (typep c 'curve))
                 "edge->curve should return curve or nil")))
(deftest topology-face->surface
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w))
         (s (face->surface f)))
    (assert-true (or (null s) (typep s 'surface))
                 "face->surface should return surface or nil")))

;; --- Fillet / Chamfer / Blend tests ---

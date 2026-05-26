(in-package :cl-occt)

;; --- 8.1 Topology Navigation ---

(deftest topology-face-edges-box
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (edges (face-edges (first faces))))
    (assert-true (= (length edges) 4) "box face should have 4 edges")))

(deftest topology-face-edges-nil
  (assert-nil (face-edges nil)))

(deftest topology-edge-vertices-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (multiple-value-bind (v1 v2) (edge-vertices edge)
      (assert-true (shape-p v1) "edge start vertex should be a shape")
      (assert-true (shape-p v2) "edge end vertex should be a shape"))))

(deftest topology-edge-vertices-nil
  (multiple-value-bind (v1 v2) (edge-vertices nil)
    (assert-nil v1)
    (assert-nil v2)))

(deftest topology-vertex-edges-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (multiple-value-bind (v1 v2) (edge-vertices edge)
      (let ((v-edges (vertex-edges v1 box)))
        (assert-true (>= (length v-edges) 3) "corner vertex should have at least 3 incident edges")))))

(deftest topology-vertex-edges-nil
  (assert-nil (vertex-edges nil (make-box 10 10 10))))

(deftest topology-edge-faces-box
  (let* ((box (make-box 10 20 30))
         (edges (map-shape-subshapes box :edge)))
    (let ((sharing (edge-faces (first edges) box)))
      (assert-true (>= (length sharing) 1)
                   "box edge should be shared by at least 1 face"))))

(deftest topology-edge-faces-nil
  (assert-nil (edge-faces nil (make-box 10 10 10))))

(deftest topology-face-wires-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (wires (face-wires face)))
    (assert-true (= (length wires) 1) "box face should have 1 outer wire")))

(deftest topology-face-wires-nil
  (assert-nil (face-wires nil)))

(deftest topology-wire-edges-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (wire (first (face-wires face)))
         (edges (wire-edges wire)))
    (assert-true (= (length edges) 4) "rectangular wire should have 4 edges")))

(deftest topology-wire-edges-nil
  (assert-nil (wire-edges nil)))

;; --- 8.3 Shape Type ---

(deftest topology-shape-type-box
  (assert-true (eq (shape-type (make-box 10 20 30)) :solid)))

(deftest topology-shape-type-wire
  (let ((w (make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10)
                      (make-edge 10 10 0 10) (make-edge 0 10 0 0))))
    (assert-true (eq (shape-type w) :wire))))

(deftest topology-shape-type-nil
  (assert-nil (shape-type nil)))

;; --- 8.4 Orientation ---

(deftest topology-orientation-face
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (orient (subshape-orientation face)))
    (assert-true (member orient '(:forward :reversed))
                 "face orientation should be :forward or :reversed")))

(deftest topology-orientation-nil
  (assert-nil (subshape-orientation nil)))

;; --- 8.5 Face Area ---

(deftest topology-face-area-box
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face)))
    (dolist (f faces)
      (let ((area (face-area f)))
        (assert-true (and (numberp area) (> area 0))
                     "face area should be a positive number")))))

(deftest topology-face-area-known
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (areas (mapcar #'face-area faces)))
    (assert-true (some (lambda (a) (< (abs (- a 200.0d0)) 0.01)) areas)
                 "should have a 200-area face")
    (assert-true (some (lambda (a) (< (abs (- a 300.0d0)) 0.01)) areas)
                 "should have a 300-area face")
    (assert-true (some (lambda (a) (< (abs (- a 600.0d0)) 0.01)) areas)
                 "should have a 600-area face")))

(deftest topology-face-area-nil
  (assert-nil (face-area nil)))

;; --- 8.6 Edge Length ---

(deftest topology-edge-length-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (let ((len (edge-length edge)))
      (assert-true (and (numberp len) (> len 0))
                   "edge length should be a positive number"))))

(deftest topology-edge-length-nil
  (assert-nil (edge-length nil)))

;; --- 8.7 Face Normal ---

(deftest topology-face-normal-box
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face)))
    (dolist (f faces)
      (multiple-value-bind (nx ny nz) (face-normal-at-center f)
        (assert-true (and (numberp nx) (numberp ny) (numberp nz))
                     "normal components should be numbers")
        (let ((len (sqrt (+ (* nx nx) (* ny ny) (* nz nz)))))
          (assert-true (< (abs (- len 1.0)) 0.001)
                       "normal should be unit length"))))))

;; --- 8.8 Surface/Curve Type ---

(deftest topology-face-surface-type-planar
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (assert-true (eq (face-surface-type face) :plane)
                 "box face should be planar")))

(deftest topology-edge-curve-type-linear
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (assert-true (eq (edge-curve-type edge) :line)
                 "box edge should be linear")))

;; --- 8.9 Bounding Box ---

(deftest topology-face-bounding-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (face-bounding-box face)
      (assert-true (and (numberp xmin) (numberp ymin) (numberp zmin)
                        (numberp xmax) (numberp ymax) (numberp zmax))
                   "bounding box should return six values")
      (assert-true (and (<= xmin xmax) (<= ymin ymax) (<= zmin zmax))
                   "bounds should be consistent"))))

(deftest topology-edge-bounding-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (edge-bounding-box edge)
      (assert-true (and (numberp xmin) (numberp ymin) (numberp zmin)
                        (numberp xmax) (numberp ymax) (numberp zmax))
                   "edge bounding box should return six values"))))

(deftest topology-subshape-bounding-box-vertex
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face)))
         (edge (first (face-edges face))))
    (multiple-value-bind (v1 v2) (edge-vertices edge)
      (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
          (subshape-bounding-box v1)
        (assert-true (and (numberp xmin) (numberp ymin) (numberp zmin)
                          (numberp xmax) (numberp ymax) (numberp zmax))
                     "vertex bounding box should return six values")))))

;; --- 8.10 Face Center and Extent Along ---

(deftest topology-face-center-box
  (let* ((box (make-box 10 20 30))
         (face (first (map-shape-subshapes box :face))))
    (multiple-value-bind (x y z) (face-center face)
      (assert-true (and (numberp x) (numberp y) (numberp z))
                   "face center should return three values"))))

(deftest topology-shape-extent-along
  (let ((box (make-box 10 20 30)))
    (multiple-value-bind (min max) (shape-extent-along box 0 0 1)
      (assert-true (and (numberp min) (numberp max))
                   "extent should return two values")
      (assert-true (<= min max) "min should be <= max")
      (assert-true (>= (- max min) 29.0) "height should be ~30"))))



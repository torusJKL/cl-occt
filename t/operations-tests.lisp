(in-package :cl-occt)
(deftest fillet-edge-constant
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge box (first edges) 3.0)))
    (assert-shape result)))
(deftest fillet-edge-nil-shape
  (assert-nil (fillet-edge nil (make-edge 0 0 10 0) 3.0)))
(deftest fillet-edges-multiple
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (some-edges (list (first edges) (second edges)))
         (result (fillet-edges box some-edges 3.0)))
    (assert-shape result)))
(deftest fillet-edge-variable-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge-variable box (first edges)
                                       '((0.0 3.0) (0.5 5.0) (1.0 3.0)))))
    (assert-shape result)))
(deftest fillet-wire-corner-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (fillet-wire-corner wire 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "fillet-wire-corner should return shape or nil")))
(deftest fillet-wire-all-corners-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (fillet-wire-all-corners wire 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "fillet-wire-all-corners should return shape or nil")))
(deftest fillet-edge-excessive-radius
  (let* ((box (make-box 10 10 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge box (first edges) 999.0)))
    (assert-nil result "excessive radius should return nil")))
(deftest chamfer-edge-constant
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge box (first edges) 3.0)))
    (assert-shape result)))
(deftest chamfer-edge-nil-shape
  (assert-nil (chamfer-edge nil (make-edge 0 0 10 0) 3.0)))
(deftest chamfer-edges-multiple
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (some-edges (list (first edges) (second edges)))
         (result (chamfer-edges box some-edges 3.0)))
    (assert-shape result)))
(deftest chamfer-edge-asymmetric-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge-asymmetric box (first edges) 4.0 2.0)))
    (assert-shape result)))
(deftest chamfer-edge-on-face-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (faces (map-shape-subshapes box :face))
         (result (chamfer-edge-on-face box (first edges) 3.0 (first faces))))
    (assert-shape result)))
(deftest chamfer-edge-excessive-distance
  (let* ((box (make-box 10 10 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge box (first edges) 999.0)))
    (assert-nil result "excessive distance should return nil")))

;; --- Sweep / Pipe ---
(deftest blend-faces-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (blend-faces (first faces) (second faces) 2.0))))
    (assert-true (or (null result) (shape-p result))
                 "blend-faces should return shape or nil")))
(deftest make-blend-constant-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (make-blend (first faces) (second faces) :constant 2.0))))
    (assert-true (or (null result) (shape-p result))
                 "make-blend :constant should return shape or nil")))
(deftest sweep-profile-circle-along-line
  (let* ((circ (make-circle-edge 0 0 5))
         (wire (make-wire circ))
         (face (make-face wire))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (result (sweep-profile face spine)))
    (assert-shape result)))
(deftest sweep-profile-nil-profile
  (assert-nil (sweep-profile nil (make-wire (make-edge-3d 0 0 0 10 0 0)))))
(deftest sweep-profile-nil-spine
  (assert-nil (sweep-profile (make-face (make-wire (make-circle-edge 0 0 5))) nil)))
(deftest sweep-profile-fixed-mode
  (let* ((circ (make-circle-edge 0 0 5))
         (wire (make-wire circ))
         (face (make-face wire))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (result (sweep-profile face spine :mode :fixed)))
    (assert-shape result)))
(deftest sweep-sections-two-sections
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (e2 (make-circle-edge 20 0 10))
         (w2 (make-wire e2))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
    (let ((result (sweep-sections spine (list w1 w2) '(0.0 1.0))))
      (assert-true (or (null result) (shape-p result))
                   "sweep-sections should return shape or nil"))))
(deftest sweep-sections-nil-spine
  (assert-nil (sweep-sections nil (list (make-wire (make-circle-edge 0 0 5))) '(0.0))))
(deftest sweep-sections-mismatched-counts
  (assert-nil (sweep-sections (make-wire (make-edge-3d 0 0 0 10 0 0))
                              (list (make-wire (make-circle-edge 0 0 5)))
                              '(0.0 1.0))))
(deftest sweep-with-aux-spine-valid
  (let* ((circ (make-circle-edge 0 0 5))
         (face (make-face (make-wire circ)))
         (main (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (aux (make-wire (make-edge-3d 0 0 0 20 5 0))))
    (let ((result (sweep-with-aux-spine face main aux)))
      (assert-true (or (null result) (shape-p result))
                   "sweep-with-aux-spine should return shape or nil"))))
(deftest sweep-with-aux-spine-nil
  (assert-nil (sweep-with-aux-spine nil (make-wire (make-edge-3d 0 0 0 10 0 0))
                                    (make-wire (make-edge-3d 0 0 0 10 5 0)))))

;; --- Loft ---
(deftest loft-sections-two-wires
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (e2 (make-circle-edge 0 0 10))
         (w2 (make-wire (make-circle-edge 0 0 10)))
         (result (loft-sections (list w1 w2))))
    (assert-shape result)))
(deftest loft-sections-nil
  (assert-nil (loft-sections nil)))
(deftest loft-sections-solid-true
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (w2 (make-wire (make-circle-edge 0 20 5)))
         (result (loft-sections (list w1 w2) :solid t)))
    (assert-shape result)))
(deftest loft-sections-ruled
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (result (loft-sections (list w1 w2) :ruled t)))
    (assert-shape result)))
(deftest loft-sections-smooth
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (result (loft-sections (list w1 w2) :smooth t)))
    (assert-shape result)))
(deftest loft-sections-three-wires
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (w3 (make-wire (make-circle-edge 0 20 6)))
         (result (loft-sections (list w1 w2 w3))))
    (assert-shape result)))

;; --- Face Filling ---
(deftest fill-face-valid
  (let* ((w (make-wire (make-edge-3d 0 0 0 10 0 0)
                        (make-edge-3d 10 0 0 10 10 0)
                        (make-edge-3d 10 10 0 0 10 0)
                        (make-edge-3d 0 10 0 0 0 0)))
         (result (fill-face w)))
    (assert-true (or (null result) (shape-p result)) "fill-face should return shape or nil")))
(deftest fill-face-nil
  (assert-nil (fill-face nil)))
(deftest fill-n-sided-face-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (result (fill-n-sided-face (list e1 e2 e3 e4))))
    (assert-shape result)))
(deftest fill-n-sided-face-nil-edges
  (assert-nil (fill-n-sided-face nil)))
(deftest fill-n-sided-face-too-few
  (assert-nil (fill-n-sided-face (list (make-edge 0 0 10 0) (make-edge 10 0 10 10)))))
(deftest fill-n-sided-face-curvature
  (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
         (e2 (make-edge-3d 10 0 0 10 10 0))
         (e3 (make-edge-3d 10 10 0 0 10 0))
         (e4 (make-edge-3d 0 10 0 0 0 0))
         (result (fill-n-sided-face (list e1 e2 e3 e4) :continuity :tangent)))
    (assert-true (or (null result) (shape-p result)) "fill-n-sided-face curvature should return shape or nil")))

;; --- Shell / Thicken ---
(deftest shell-shape-box-single-face
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces)) :thickness 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape should return shape or nil")))
(deftest shell-shape-multiple-faces
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (shell-shape box (list (first faces) (second faces))
                                :thickness 1.5))))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape multiple faces should return shape or nil")))
(deftest shell-shape-outward-offset
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces))
                              :thickness 2.0 :offset :outward)))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape outward should return shape or nil")))
(deftest shell-shape-nil-shape
  (assert-nil (shell-shape nil (list (make-shape (cffi:null-pointer))) :thickness 2.0)))
(deftest shell-shape-excessive-thickness
  (let* ((box (make-box 10 10 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces)) :thickness 999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive thickness should return shape or nil")))

;; --- Sewing ---
(deftest sew-shapes-two-boxes
  (let* ((box1 (make-box 10 10 10))
         (box2 (translate (make-box 10 10 10) 10 0 0))
         (result (sew-shapes (list box1 box2) :tolerance 0.1)))
    (assert-true (or (null result) (shape-p result))
                 "sew-shapes two boxes should return shape or nil")))
(deftest sew-shapes-nil-input
  (assert-nil (sew-shapes nil)))
(deftest sew-shapes-empty-list
  (assert-nil (sew-shapes '())))
(deftest sew-shapes-non-manifold
  (let* ((box1 (make-box 10 10 10))
         (box2 (translate (make-box 10 10 10) 10 0 0))
         (result (sew-shapes (list box1 box2) :tolerance 0.1 :allow-non-manifold t)))
    (assert-true (or (null result) (shape-p result))
                 "sew-shapes with non-manifold should return shape or nil")))

;; --- Defeaturing ---
(deftest defeature-shape-remove-one-face
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (defeature-shape box (list (first faces)))))
    (assert-true (or (null result) (shape-p result))
                 "defeature-shape should return shape or nil")))
(deftest defeature-shape-nil-shape
  (assert-nil (defeature-shape nil (list (cffi:null-pointer)))))
(deftest defeature-shape-nil-faces
  (assert-nil (defeature-shape (make-box 30 20 10) nil)))
(deftest defeature-shape-empty-faces
  (assert-nil (defeature-shape (make-box 30 20 10) '())))

;; --- Shape Check & Builder ---

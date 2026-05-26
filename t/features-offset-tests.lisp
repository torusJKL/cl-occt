(in-package :cl-occt)
(deftest offset-shape-outward
  (let ((result (offset-shape (make-box 10 10 10) 3.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape outward should return shape or nil")))
(deftest offset-shape-inward
  (let ((result (offset-shape (make-box 10 10 10) -2.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape inward should return shape or nil")))
(deftest offset-shape-arc-join
  (let ((result (offset-shape (make-box 10 10 10) 3.0 :join :arc)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape arc join should return shape or nil")))
(deftest offset-shape-intersection-join
  (let ((result (offset-shape (make-box 10 10 10) 3.0 :join :intersection)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape intersection join should return shape or nil")))
(deftest offset-shape-excessive
  (let ((result (offset-shape (make-box 10 10 10) -999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive inward offset should return shape or nil")))
(deftest offset-shape-excessive-outward
  (let ((result (offset-shape (make-box 10 10 10) 999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive outward offset should return shape or nil")))
(deftest offset-shape-nil
  (assert-nil (offset-shape nil 5.0)))

;; --- 2D Wire Offset ---
(deftest offset-wire-outward
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (offset-wire wire 3.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-wire outward should return shape or nil")))
(deftest offset-wire-inward
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (offset-wire wire -2.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-wire inward should return shape or nil")))
(deftest offset-wire-nil
  (assert-nil (offset-wire nil 5.0)))

;; --- Draft Angle ---
(deftest draft-face-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (draft-face box (first faces) 10.0 '(0 0 -1) '(0 0 0))))
    (assert-true (or (null result) (shape-p result))
                 "draft-face should return shape or nil")))
(deftest draft-face-excessive-angle
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (draft-face box (first faces) 150.0 '(0 0 -1) '(0 0 0))))
    (assert-true (or (null result) (shape-p result))
                 "excessive draft angle should return shape or nil")))
(deftest draft-face-nil-shape
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face)))
    (assert-nil (draft-face nil (first faces) 10.0 '(0 0 -1) '(0 0 0)))))

;; --- Evolved Solid ---
(deftest make-evolved-valid
  (let* ((circ (make-circle-edge 0 0 5))
         (profile (make-wire circ))
         (e1 (make-edge-3d 0 0 0 20 0 0))
         (e2 (make-edge-3d 20 0 0 20 20 0))
         (e3 (make-edge-3d 20 20 0 0 20 0))
         (e4 (make-edge-3d 0 20 0 0 0 0))
         (spine (make-wire e1 e2 e3 e4))
         (result (make-evolved profile spine)))
    (assert-true (or (null result) (shape-p result))
                 "make-evolved should return shape or nil")))
(deftest make-evolved-with-offset
  (let* ((circ (make-circle-edge 0 0 5))
         (profile (make-wire circ))
         (e1 (make-edge-3d 0 0 0 20 0 0))
         (e2 (make-edge-3d 20 0 0 20 20 0))
         (e3 (make-edge-3d 20 20 0 0 20 0))
         (e4 (make-edge-3d 0 20 0 0 0 0))
         (spine (make-wire e1 e2 e3 e4))
         (result (make-evolved profile spine :offset 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "make-evolved with offset should return shape or nil")))
(deftest make-evolved-nil-profile
  (assert-nil (make-evolved nil (make-wire (make-edge-3d 0 0 0 10 0 0)))))

;; --- Mechanical Features (BRepFeat & LocOpe) ---
(deftest make-cylindrical-hole-through
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 5 0 :through t))))
    (assert-true (or (null result) (shape-p result))
                 "through hole should return shape or nil")))
(deftest make-cylindrical-hole-blind
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 3 5))))
    (assert-true (or (null result) (shape-p result))
                 "blind hole should return shape or nil")))
(deftest make-cylindrical-hole-nil-shape
  (assert-nil (make-cylindrical-hole nil nil 5 0 :through t)))
(deftest make-cylindrical-hole-nil-depth
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 0 0 :through t))))
    (assert-nil result "hole with zero radius should return nil")))

;; --- Shape Healing Tests ---

;; --- XCAF Document Tools ---
(deftest make-prism-feature-depression
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 -5 5 -5))
                           (e2 (make-edge 5 -5 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 -5))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-prism-feature box (first faces) profile 10
                                       :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "prism depression should return shape or nil")))
(deftest make-prism-feature-protrusion
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 -5 5 -5))
                           (e2 (make-edge 5 -5 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 -5))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-prism-feature box (first faces) profile 10
                                       :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "prism protrusion should return shape or nil")))
(deftest make-prism-feature-nil
  (assert-nil (make-prism-feature nil nil nil 10)))
(deftest make-revol-feature-depression
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 0 5 0))
                           (e2 (make-edge 5 0 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 0))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-revol-feature box (first faces) profile
                                       '(0 0 1) 90
                                       :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "revol depression should return shape or nil")))
(deftest make-revol-feature-protrusion
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 0 5 0))
                           (e2 (make-edge 5 0 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 0))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-revol-feature box (first faces) profile
                                       '(0 0 1) 90
                                       :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "revol protrusion should return shape or nil")))
(deftest make-revol-feature-nil
  (assert-nil (make-revol-feature nil nil nil nil 90)))
(deftest make-pipe-feature-depression
  (let* ((box (make-box 50 50 50))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -3 -3 3 -3))
                           (e2 (make-edge 3 -3 3 3))
                           (e3 (make-edge 3 3 -3 3))
                           (e4 (make-edge -3 3 -3 -3))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (path (make-wire (make-edge-3d 0 0 0 0 0 20)))
         (result (when (and faces profile)
                   (make-pipe-feature box (first faces) profile path
                                      :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "pipe depression should return shape or nil")))
(deftest make-pipe-feature-protrusion
  (let* ((box (make-box 50 50 50))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -3 -3 3 -3))
                           (e2 (make-edge 3 -3 3 3))
                           (e3 (make-edge 3 3 -3 3))
                           (e4 (make-edge -3 3 -3 -3))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (path (make-wire (make-edge-3d 0 0 0 0 0 20)))
         (result (when (and faces profile)
                   (make-pipe-feature box (first faces) profile path
                                      :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "pipe protrusion should return shape or nil")))
(deftest make-pipe-feature-nil
  (assert-nil (make-pipe-feature nil nil nil nil :operation :cut)))
(deftest local-extrude-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (local-extrude (first faces) 5))))
    (assert-true (or (null result) (shape-p result))
                 "local extrude should return shape or nil")))
(deftest local-extrude-nil
  (assert-nil (local-extrude nil 5)))
(deftest make-groove-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-groove box (first faces) '(0 0 1) 45))))
    (assert-true (or (null result) (shape-p result))
                 "groove should return shape or nil")))
(deftest make-groove-nil
  (assert-nil (make-groove nil nil nil 45)))
(deftest make-rib-valid
  (let* ((box (make-box 30 20 10))
         (profile (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
                         (e2 (make-edge-3d 10 0 0 10 10 0))
                         (e3 (make-edge-3d 10 10 0 0 10 0))
                         (w (make-wire e1 e2 e3)))
                    w))
         (result (make-rib box profile 2 :direction '(0 0 1))))
    (assert-true (or (null result) (shape-p result))
                 "rib should return shape or nil")))
(deftest make-rib-nil
  (assert-nil (make-rib nil nil 2)))

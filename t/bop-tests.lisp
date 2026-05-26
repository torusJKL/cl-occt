(in-package :cl-occt)

;; --- Splitter ---

(deftest split-shape-box-by-plane
  (let* ((box (make-box 30 20 10))
         (e1 (make-edge-3d -15 -10 5 15 -10 5))
         (e2 (make-edge-3d 15 -10 5 15 10 5))
         (e3 (make-edge-3d 15 10 5 -15 10 5))
         (e4 (make-edge-3d -15 10 5 -15 -10 5))
         (w (make-wire e4 e3 e2 e1))
         (face (make-face w))
         (result (split-shape box face)))
    (assert-shape result)))

(deftest split-shape-multiple-tools
  (let* ((box (make-box 30 20 10))
         (e1 (make-edge-3d -15 -10 3 15 -10 3))
         (e2 (make-edge-3d 15 -10 3 15 10 3))
         (e3 (make-edge-3d 15 10 3 -15 10 3))
         (e4 (make-edge-3d -15 10 3 -15 -10 3))
         (w1 (make-wire e4 e3 e2 e1))
         (plane1 (make-face w1))
         (e5 (make-edge-3d -15 -10 -3 15 -10 -3))
         (e6 (make-edge-3d 15 -10 -3 15 10 -3))
         (e7 (make-edge-3d 15 10 -3 -15 10 -3))
         (e8 (make-edge-3d -15 10 -3 -15 -10 -3))
         (w2 (make-wire e8 e7 e6 e5))
         (plane2 (make-face w2))
         (result (split-shape box (list plane1 plane2))))
    (assert-shape result)))

(deftest split-shape-nil-shape
  (assert-nil (split-shape nil (make-box 5 5 5))))

;; --- MakerVolume ---

(deftest make-volume-two-shells
  (let* ((inner (make-box 10 10 10))
         (outer (make-box 20 20 20))
         (result (make-volume (list inner outer))))
    (assert-shape result)))

(deftest make-volume-nil-input
  (assert-nil (make-volume nil)))

;; --- CellsBuilder ---

(deftest cells-builder-select-all
  (let* ((box1 (make-box 20 20 20))
         (box2 (translate (make-box 20 20 20) 10 10 10))
         (result (cells-builder (list box1 box2) 0)))
    (assert-shape result)))

(deftest cells-builder-with-selection
  (let* ((box1 (make-box 20 20 20))
         (box2 (translate (make-box 20 20 20) 10 10 10))
         (result (cells-builder (list box1 box2) 0 '(0))))
    (assert-shape result)))

(deftest cells-builder-nil-input
  (assert-nil (cells-builder nil 0)))

;; --- ArgumentAnalyzer ---

(deftest argument-analyzer-valid-shapes
  (let* ((box (make-box 10 20 30))
         (sph (make-sphere 5))
         (result (boolean-argument-analyzer (list box sph))))
    (assert-true (or (null result) (stringp result)))))

(deftest argument-analyzer-nil-input
  (assert-nil (boolean-argument-analyzer nil)))

;; --- MakeConnected ---

(deftest make-connected-two-boxes
  (let* ((box1 (make-box 20 20 20))
         (box2 (translate (make-box 20 20 20) 10 0 0))
         (result (make-connected (list box1 box2))))
    (assert-shape result)))

(deftest make-connected-nil-input
  (assert-nil (make-connected nil)))

;; --- MakePeriodic ---

(deftest make-periodic-box-along-x
  (let* ((box (make-box 10 20 30))
         (result (make-periodic box 1.0 0.0 0.0)))
    (assert-shape result)))

(deftest make-periodic-nil-shape
  (assert-nil (make-periodic nil 1.0 0.0 0.0)))

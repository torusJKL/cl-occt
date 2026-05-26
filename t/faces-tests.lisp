(in-package :cl-occt)
(deftest make-edge-valid
  (assert-shape (make-edge 0 0 10 0)))
(deftest make-edge-3d-valid
  (assert-shape (make-edge-3d 0 0 0 10 0 0)))
(deftest make-circle-edge-valid
  (assert-shape (make-circle-edge 0 0 10)))
(deftest make-circular-arc-valid
  (assert-shape (make-circular-arc 0 0 5 5 10 0)))
(deftest make-circular-arc-collinear
  (assert-nil (make-circular-arc 0 0 5 5 10 10)))
(deftest make-wire-two-edges
  (assert-shape (make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10))))
(deftest make-wire-empty
  (assert-nil (make-wire)))
(deftest make-face-square
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4)))
    (assert-shape (make-face w))))
(deftest make-face-nil
  (assert-nil (make-face nil)))
(deftest make-face-on-plane-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4)))
    (assert-shape (make-face-on-plane w 0 0 0 0 0 1))))

;; --- Booleans ---

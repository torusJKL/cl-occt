(in-package :cl-occt)
(deftest make-box-valid
  (assert-shape (make-box 10 20 30)))
(deftest make-box-zero-dim
  (assert-nil (make-box 0 20 30)))
(deftest make-box-negative
  (assert-nil (make-box -1 20 30)))
(deftest make-cylinder-valid
  (assert-shape (make-cylinder 5 20)))
(deftest make-sphere-valid
  (assert-shape (make-sphere 10)))
(deftest make-cone-valid
  (assert-shape (make-cone 5 10 15)))
(deftest make-torus-valid
  (assert-shape (make-torus 10 3)))
(deftest make-torus-zero-major
  (assert-nil (make-torus 0 3)))
(deftest make-torus-zero-minor
  (assert-nil (make-torus 10 0)))
(deftest make-prism-zero-vector
  (assert-nil (make-prism (make-box 5 5 1) 0 0 0)))
(deftest make-prism-nil-shape
  (assert-nil (make-prism nil 0 0 10)))
(deftest make-revol-zero-angle
  (assert-nil (make-revol (make-box 5 5 1) 0 0 1 0)))
(deftest make-revol-nil-shape
  (assert-nil (make-revol nil 0 0 1 360)))
(deftest shape-distinct
  (let ((a (make-box 1 2 3))
        (b (make-box 1 2 3)))
    (assert-true (not (eq a b)) "shapes should be distinct")))

;; --- 2D Geometry ---

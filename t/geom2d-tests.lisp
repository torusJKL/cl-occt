(in-package :cl-occt)
(deftest make-pnt2d-valid
  (assert-geom2d (make-pnt2d 10 20)))
(deftest make-vec2d-valid
  (assert-geom2d (make-vec2d 3 4)))
(deftest make-dir2d-valid
  (assert-geom2d (make-dir2d 1 0)))
(deftest make-dir2d-zero
  (assert-nil (make-dir2d 0 0)))

;; --- 2D Curves ---
(deftest make-line2d-valid
  (assert-geom2d (make-line2d 0 0 1 0)))
(deftest make-circle2d-valid
  (assert-geom2d (make-circle2d 5 5 10)))
(deftest make-circle2d-zero-radius
  (assert-nil (make-circle2d 0 0 0)))

;; --- 3D Curves ---

(defun assert-curve (val &optional msg)
  (assert-true (curve-p val) (or msg "expected curve")))

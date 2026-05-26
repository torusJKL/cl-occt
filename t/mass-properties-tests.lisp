(in-package :cl-occt)
(deftest gprops-volume-box
  (let ((v (shape-volume (make-box 10 20 30))))
    (assert-true (and (numberp v) (> v 5999) (< v 6001))
                 "box 10x20x30 volume should be ~6000")))
(deftest gprops-volume-nil
  (assert-nil (shape-volume nil)))
(deftest gprops-area-sphere
  (let ((a (shape-area (make-sphere 10))))
    (assert-true (and (numberp a) (> a 1250) (< a 1260))
                 "sphere r=10 area should be ~1256.637")))
(deftest gprops-com-box
  (multiple-value-bind (x y z) (shape-center-of-mass (make-box 10 20 30))
    (assert-true (and (= x 5.0) (= y 10.0) (= z 15.0))
                 "box 10x20x30 COM should be (5 10 15)")))
(deftest gprops-com-nil
  (assert-nil (shape-center-of-mass nil)))
(deftest gprops-gprops-box
  (let ((g (shape-gprops (make-box 10 20 30))))
    (assert-true (typep g 'gprops) "shape-gprops should return gprops")
    (assert-true (and (numberp (gprops-volume g)) (> (gprops-volume g) 0))
                 "gprops-volume should be positive")))
(deftest gprops-gprops-nil
  (assert-nil (shape-gprops nil)))
(deftest gprops-inertia-box
  (let ((g (shape-gprops (make-box 10 20 30))))
    (assert-true (listp (gprops-inertia-matrix g))
                 "inertia matrix should be a list")
    (assert-true (= (length (gprops-inertia-matrix g)) 6)
                 "inertia matrix should have 6 components")))

;; --- Shape Analysis ---

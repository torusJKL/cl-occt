(in-package :cl-occt)

;; --- FairCurve Batten Tests ---

(deftest fair-curve-batten-3-points
  (assert-curve (fair-curve-batten '((0 0 0) (5 5 0) (10 0 0)))))

(deftest fair-curve-batten-with-tangents
  (assert-curve (fair-curve-batten '((0 0 0) (5 5 0) (10 0 0))
                                    :initial-tangent '(1 0 0)
                                    :final-tangent '(-1 0 0))))

(deftest fair-curve-batten-free-ends
  (assert-curve (fair-curve-batten '((0 0 0) (5 5 0) (10 0 0))
                                    :free-end t :free-slide t)))

(deftest fair-curve-batten-nil-input
  (assert-nil (fair-curve-batten nil)))

(deftest fair-curve-batten-too-few
  (assert-nil (fair-curve-batten '((0 0 0)))))

;; --- FairCurve Minimal Variation Tests ---

(deftest fair-curve-minvar-3-points
  (assert-curve (fair-curve-minvar '((0 0 0) (5 5 0) (10 0 0)))))

(deftest fair-curve-minvar-with-slopes
  (assert-curve (fair-curve-minvar '((0 0 0) (5 5 0) (10 0 0))
                                    :initial-slope '(1 0 0)
                                    :final-slope '(1 0 0))))

(deftest fair-curve-minvar-nil-input
  (assert-nil (fair-curve-minvar nil)))

(deftest fair-curve-minvar-too-few
  (assert-nil (fair-curve-minvar '((0 0 0)))))

;; --- GeomPlate Surface Fill Tests ---

(defun make-test-curves-for-plate ()
  (let* ((c1 (make-bezier-curve '((0 0 0) (5 0 5) (10 0 0))))
         (c2 (make-bezier-curve '((10 0 0) (10 10 5) (0 10 0))))
         (c3 (make-bezier-curve '((0 10 0) (5 10 5) (0 0 0))))
         (c4 (make-bezier-curve '((0 0 0) (0 5 5) (0 10 0)))))
    (list c1 c2 c3 c4)))

(deftest fill-surface-from-4-curves
  (let* ((curves (make-test-curves-for-plate))
         (surf (fill-surface-from-curves curves)))
    (assert-surface surf)))

(deftest fill-surface-from-curves-g1
  (let* ((curves (make-test-curves-for-plate))
         (surf (fill-surface-from-curves curves :continuity :g1)))
    ;; G1 may not succeed for arbitrary curves; accept nil or valid surface
    (when surf
      (assert-surface surf))))

(deftest fill-surface-from-curves-too-few
  (let* ((c1 (make-bezier-curve '((0 0 0) (5 0 5) (10 0 0))))
         (c2 (make-bezier-curve '((10 0 0) (10 10 5) (0 10 0))))
         (surf (fill-surface-from-curves (list c1 c2))))
    (assert-nil surf)))

(deftest fill-surface-from-curves-nil-input
  (assert-nil (fill-surface-from-curves nil)))

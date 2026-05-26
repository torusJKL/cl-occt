(in-package :cl-occt)
(deftest translate-shape
  (let ((result (translate (make-box 10 10 10) 5 0 0)))
    (assert-shape result)))
(deftest translate-preserves-original
  (let ((a (make-box 10 10 10)))
    (translate a 5 0 0)
    (assert-shape a "original should remain unchanged")))
(deftest translate-nil
  (assert-nil (translate nil 5 0 0)))
(deftest rotate-shape
  (let ((result (rotate (make-box 10 10 10) 0 0 1 45)))
    (assert-shape result)))

;; --- STEP I/O ---

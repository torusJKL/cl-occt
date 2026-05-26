(in-package :cl-occt)
(deftest cut-two-boxes
  (let ((result (cut (make-box 10 20 30) (make-box 5 5 5))))
    (assert-shape result)))
(deftest cut-nil-first
  (assert-nil (cut nil (make-box 5 5 5))))
(deftest cut-nil-second
  (assert-nil (cut (make-box 5 5 5) nil)))
(deftest fuse-two-boxes
  (let ((result (fuse (make-box 10 10 10) (translate (make-box 10 10 10) 5 0 0))))
    (assert-shape result)))
(deftest common-overlap
  (let ((result (common (make-box 10 10 10) (translate (make-box 10 10 10) 5 5 5))))
    (assert-shape result)))
(deftest common-no-overlap
  (let* ((a (translate (make-box 10 10 10) 0 0 0))
         (b (translate (make-box 10 10 10) 100 100 100))
         (result (common a b)))
    (assert-nil result "non-overlapping common should be nil")))
(deftest boolean-variadic
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5))
        (c (translate (make-box 10 10 10) 0 5 0)))
    (assert-shape (fuse a b c))))
(deftest section-intersecting-boxes
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5)))
    (assert-shape (section a b))))
(deftest section-non-intersecting
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 100 100 100)))
    (assert-nil (section a b) "non-intersecting section should be nil")))
(deftest section-nil-first
  (assert-nil (section nil (make-box 5 5 5))))
(deftest section-nil-second
  (assert-nil (section (make-box 5 5 5) nil)))
(deftest section-variadic
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5))
        (c (translate (make-box 10 10 10) 0 5 0)))
    (assert-shape (section a b c))))
(deftest section-solid-plane
  (let* ((e1 (make-edge -10 -10 10 -10))
         (e2 (make-edge 10 -10 10 10))
         (e3 (make-edge 10 10 -10 10))
         (e4 (make-edge -10 10 -10 -10))
         (w (make-wire e1 e2 e3 e4))
         (face (make-face w)))
    (assert-shape (section (make-box 20 20 20) face))))

;; --- 2D Booleans ---
(deftest face-cut-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (cut face-a face-b))))
(deftest face-fuse-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (fuse face-a face-b))))
(deftest face-common-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (common face-a face-b))))
(deftest face-common-no-overlap
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 100 100 110 100))
         (e6 (make-edge 110 100 110 110))
         (e7 (make-edge 110 110 100 110))
         (e8 (make-edge 100 110 100 100))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-nil (common face-a face-b) "non-overlapping faces should be nil")))
(deftest face-cut-nil
  (assert-nil (cut nil (make-face (make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10) (make-edge 10 10 0 10) (make-edge 0 10 0 0))))))

;; --- Transforms ---

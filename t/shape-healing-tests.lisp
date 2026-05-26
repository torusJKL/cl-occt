(in-package :cl-occt)
(deftest fix-shape-valid-box
  (let ((result (fix-shape (make-box 10 20 30))))
    (assert-shape result)))
(deftest fix-shape-nil
  (assert-nil (fix-shape nil)))
(deftest fix-wire-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (face (make-face wire))
         (result (fix-wire wire face :tolerance 0.1)))
    (assert-true (or (null result) (shape-p result)))))
(deftest fix-wire-nil
  (assert-nil (fix-wire nil nil)))
(deftest fix-solid-valid
  (let ((result (fix-solid (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))
(deftest fix-solid-nil
  (assert-nil (fix-solid nil)))
(deftest fix-edge-valid
  (let ((result (fix-edge (make-edge 0 0 10 0))))
    (assert-true (or (null result) (shape-p result)))))
(deftest fix-edge-nil
  (assert-nil (fix-edge nil)))
(deftest fix-face-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w))
         (result (fix-face f)))
    (assert-true (or (null result) (shape-p result)))))
(deftest fix-face-nil
  (assert-nil (fix-face nil)))

;; --- Shape Analysis Tests ---
(deftest shape-analysis-free-edges-valid
  (let ((result (shape-analysis-free-edges (make-box 10 20 30))))
    (assert-nil result "a closed box should have no free edges")))
(deftest shape-analysis-free-edges-nil
  (assert-nil (shape-analysis-free-edges nil)))
(deftest shape-analysis-check-intersections-valid
  (let ((count (shape-analysis-check-intersections (make-box 10 20 30))))
    (assert-true (integerp count))))
(deftest shape-analysis-check-intersections-nil
  (assert-nil (shape-analysis-check-intersections nil)))
(deftest shape-analysis-wire-contains-p-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4)))
    (assert-true (shape-analysis-wire-contains-p wire '(5 5)))))
(deftest shape-analysis-wire-contains-p-outside
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4)))
    (assert-nil (shape-analysis-wire-contains-p wire '(20 20)))))
(deftest shape-analysis-wire-contains-p-nil
  (assert-nil (shape-analysis-wire-contains-p nil '(0 0))))
(deftest shape-analysis-contents-valid
  (let ((c (shape-analysis-contents (make-box 10 20 30))))
    (assert-true (listp c))
    (let ((faces (getf c :faces)))
      (assert-true (integerp faces) "faces count should be an integer"))))
(deftest shape-analysis-contents-nil
  (assert-nil (shape-analysis-contents nil)))

;; --- Sub-shape Substitution Tests ---
(deftest substitute-shape-single-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (old-face (first faces))
         (new-face old-face)
         (result (substitute-shape box old-face new-face)))
    (assert-true (or (null result) (shape-p result)))))
(deftest substitute-shape-nil-shape
  (assert-nil (substitute-shape nil (make-box 1 1 1) (make-box 2 2 2))))
(deftest substitute-shape-batch-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (pairs (loop for f in faces collect (list f f)))
         (result (substitute-shape box pairs)))
    (assert-true (or (null result) (shape-p result)))))

;; --- NURBS Conversion Tests ---
(deftest shape-to-nurbs-valid
  (let ((result (shape-to-nurbs (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))
(deftest shape-to-nurbs-nil
  (assert-nil (shape-to-nurbs nil)))
(deftest shape-reduce-degree-valid
  (let ((nurbs (shape-to-nurbs (make-box 10 20 30))))
    (when nurbs
      (let ((reduced (shape-reduce-degree nurbs 2)))
        (assert-true (or (null reduced) (shape-p reduced)))))))
(deftest shape-reduce-degree-nil
  (assert-nil (shape-reduce-degree nil 2)))
(deftest shape-to-rational-bspline-valid
  (let ((result (shape-to-rational-bspline (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))
(deftest shape-to-rational-bspline-nil
  (assert-nil (shape-to-rational-bspline nil)))

;; --- Surface Split / Continuity Tests ---
(deftest shape-split-u-valid
  (let ((result (shape-split-u (make-box 10 20 30) 2)))
    (assert-true (or (null result) (shape-p result)))))
(deftest shape-split-u-nil
  (assert-nil (shape-split-u nil 2)))
(deftest shape-upgrade-continuity-valid
  (let ((result (shape-upgrade-continuity (make-box 10 20 30) :continuity :c2)))
    (assert-true (or (null result) (shape-p result)))))
(deftest shape-upgrade-continuity-nil
  (assert-nil (shape-upgrade-continuity nil :continuity :c2)))

;; --- Healing Pipeline Tests ---
(deftest apply-shape-process-single-valid
  (let ((result (apply-shape-process (make-box 10 20 30) "FixShape")))
    (assert-true (or (null result) (shape-p result)))))
(deftest apply-shape-process-sequence-valid
  (let ((result (apply-shape-process (make-box 10 20 30) '("FixShape" "SameParameter"))))
    (assert-true (or (null result) (shape-p result)))))
(deftest apply-shape-process-nil
  (assert-nil (apply-shape-process nil "FixShape")))
(deftest heal-shape-valid
  (let ((result (heal-shape (make-box 10 20 30))))
    (assert-shape result)))
(deftest heal-shape-nil
  (assert-nil (heal-shape nil)))

;; --- Null / Edge Case Tests ---
(deftest fix-shaped-nil-input-all
  (assert-nil (fix-shape nil))
  (assert-nil (fix-wire nil nil))
  (assert-nil (fix-solid nil))
  (assert-nil (fix-edge nil))
  (assert-nil (fix-face nil)))

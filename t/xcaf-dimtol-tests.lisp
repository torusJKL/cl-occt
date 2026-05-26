(in-package :cl-occt)

;; --- Helpers ---

(defun %make-doc-with-box ()
  (let ((doc (make-xcaf-doc))
        (box (make-box 100 80 60)))
    (xcaf-add-shape doc box)
    (values doc box)))

;; --- 5.1 Linear dimension ---

(deftest xcaf-dimtol-linear-dimension-on-box-face
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let* ((face (car (face-edges box))) ;; get a face
           (pt1 (list 0d0 0d0 0d0))
           (pt2 (list 100d0 0d0 0d0))
           (result (xcaf-add-linear-dimension doc box (list pt1 pt2) :value 100d0)))
      (assert-true result "linear dimension creation should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-linear-dimension-nil-doc
  (assert-nil (xcaf-add-linear-dimension nil (make-box 1 2 3) '((0 0 0) (1 0 0)) :value 10d0)
              "nil doc returns nil"))

(deftest xcaf-dimtol-linear-dimension-nil-shape
  (let ((doc (make-xcaf-doc)))
    (assert-nil (xcaf-add-linear-dimension doc nil '((0 0 0) (1 0 0)) :value 10d0)
                "nil shape returns nil")
    (xcaf-free-doc doc)))

(deftest xcaf-dimtol-linear-dimension-too-few-points
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-linear-dimension doc box '((0 0 0)) :value 10d0)
                "need at least 2 points")
    (xcaf-free-doc doc)))

;; --- 5.2 Angular dimension ---

(deftest xcaf-dimtol-angular-dimension-on-edges
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let* ((edges (face-edges box))
           (e1 (first edges))
           (e2 (second edges))
           (result (xcaf-add-angular-dimension doc box (list e1 e2) :value 45d0)))
      (assert-true result "angular dimension creation should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-angular-dimension-nil-input
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-angular-dimension nil box '() :value 45d0) "nil doc returns nil")
    (assert-nil (xcaf-add-angular-dimension doc nil '() :value 45d0) "nil shape returns nil")
    (xcaf-free-doc doc)))

;; --- 5.3 Diameter dimension ---

(deftest xcaf-dimtol-diameter-dimension-on-cylinder
  (let* ((doc (make-xcaf-doc))
         (cyl (make-cylinder 10 30)))
    (xcaf-add-shape doc cyl)
    (let ((result (xcaf-add-diameter-dimension doc cyl cyl :value 20d0)))
      (assert-true result "diameter dimension creation should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-diameter-dimension-nil-input
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-diameter-dimension nil box box :value 10d0) "nil doc returns nil")
    (assert-nil (xcaf-add-diameter-dimension doc nil box :value 10d0) "nil shape returns nil")
    (xcaf-free-doc doc)))

;; --- 5.4 Tolerance ---

(deftest xcaf-dimtol-tolerance-flatness
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((result (xcaf-add-tolerance doc box :flatness :value 0.1d0)))
      (assert-true result "flatness tolerance should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-tolerance-position-with-modifiers
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((result (xcaf-add-tolerance doc box :position :value 0.5d0
                                       :modifiers '(:mmc :rfs))))
      (assert-true result "position tolerance with modifiers should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-tolerance-nil-input
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-tolerance nil box :flatness :value 0.1d0) "nil doc returns nil")
    (assert-nil (xcaf-add-tolerance doc nil :flatness :value 0.1d0) "nil shape returns nil")
    (xcaf-free-doc doc)))

;; --- 5.5 Datum ---

(deftest xcaf-dimtol-datum-single
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((result (xcaf-add-datum doc box :label "A")))
      (assert-true result "single datum should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-datum-compound
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((result (xcaf-add-datum doc box :label "A-B")))
      (assert-true result "compound datum should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-datum-nil-input
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-datum nil box :label "A") "nil doc returns nil")
    (assert-nil (xcaf-add-datum doc nil :label "A") "nil shape returns nil")
    (assert-nil (xcaf-add-datum doc box :label "") "empty label returns nil")
    (xcaf-free-doc doc)))

;; --- 5.6 Geometric tolerance ---

(deftest xcaf-dimtol-geometric-tolerance-position-with-datum
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((result (xcaf-add-geometric-tolerance doc box :position 0.5d0
                                                 :datums '("A"))))
      (assert-true result "geometric tolerance with datum should return t")
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-geometric-tolerance-nil-input
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-nil (xcaf-add-geometric-tolerance nil box :position 0.5d0) "nil doc returns nil")
    (assert-nil (xcaf-add-geometric-tolerance doc nil :position 0.5d0) "nil shape returns nil")
    (xcaf-free-doc doc)))

;; --- 5.7 STEP round-trip ---

(deftest xcaf-dimtol-step-roundtrip
  (let* ((doc (make-xcaf-doc))
         (box (make-box 50 40 30))
         (tmpfile (format nil "/tmp/cl-occt-dimtol-test-~D.step" (get-universal-time))))
    (xcaf-add-shape doc box)
    (xcaf-add-tolerance doc box :flatness :value 0.1d0)
    (xcaf-add-datum doc box :label "A")
    (let ((result (%xde-write-step (%ptr doc) tmpfile)))
      (assert-true (plusp result) "step write should succeed"))
    (let* ((new-ptr (%xde-read-step tmpfile)))
      (assert-true (not (cffi:null-pointer-p new-ptr)) "read should succeed")
      (%xde-free-doc new-ptr))
    (delete-file tmpfile)
    (ignore-errors (delete-file tmpfile))
    (xcaf-free-doc doc)))

;; --- 5.8 Query tests ---

(deftest xcaf-dimtol-get-dimensions-after-add
  (multiple-value-bind (doc box) (%make-doc-with-box)
    (let ((pt1 (list 0d0 0d0 0d0))
          (pt2 (list 100d0 0d0 0d0)))
      (xcaf-add-linear-dimension doc box (list pt1 pt2) :value 100d0)
      (let ((dims (xcaf-get-dimensions doc box)))
        (assert-true (listp dims) "should return a list")
        (when dims
          (assert-true (getf (car dims) :type) "dimension should have :type")))
      (xcaf-free-doc doc))))

(deftest xcaf-dimtol-get-dimensions-nil-input
  (assert-nil (xcaf-get-dimensions nil (make-box 1 2 3)) "nil doc returns nil")
  (let ((doc (make-xcaf-doc)))
    (assert-nil (xcaf-get-dimensions doc nil) "nil shape returns nil")
    (xcaf-free-doc doc)))

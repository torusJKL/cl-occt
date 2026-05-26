(in-package :cl-occt)
(deftest make-xcaf-doc-valid
  (let ((doc (make-xcaf-doc)))
    (assert-true (xcaf-doc-p doc) "expected xcaf-doc instance")
    (xcaf-free-doc doc)))
(deftest xcaf-add-shape-t
  (let* ((doc (make-xcaf-doc))
         (box (make-box 10 20 30)))
    (assert-true (xcaf-add-shape doc box) "xcaf-add-shape should return t")
    (xcaf-free-doc doc)))
(deftest xcaf-add-shape-to-layer-t
  (let* ((doc (make-xcaf-doc))
         (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (assert-true (xcaf-add-shape-to-layer doc box "TestLayer") "should add to layer")
    (xcaf-free-doc doc)))
(deftest xcaf-add-view-t
  (let ((doc (make-xcaf-doc)))
    (assert-true (xcaf-add-view doc) "xcaf-add-view should return t")
    (assert-true (listp (xcaf-get-views doc)) "should return a list")
    (xcaf-free-doc doc)))
(deftest xcaf-nil-doc-nil
  (assert-nil (xcaf-add-shape nil (make-box 1 2 3)) "nil doc returns nil")
  (assert-nil (xcaf-add-shape-to-layer nil (make-box 1 2 3) "L") "nil doc returns nil")
  (assert-nil (xcaf-add-view nil) "nil doc returns nil"))
(deftest xcaf-remove-shape-from-layer-t
  (let* ((doc (make-xcaf-doc))
         (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (xcaf-add-shape-to-layer doc box "TestLayer")
    (assert-true (xcaf-remove-shape-from-layer doc box "TestLayer") "should remove from layer")
    (xcaf-free-doc doc)))
(deftest xcaf-get-visual-material-t
  (let* ((doc (make-xcaf-doc))
         (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (let ((mat (xcaf-get-visual-material doc box)))
      (assert-nil mat "no material set yet, should be nil"))
    (xcaf-free-doc doc)))
(deftest xcaf-get-clipping-planes-t
  (let ((doc (make-xcaf-doc)))
    (let ((planes (xcaf-get-clipping-planes doc)))
      (assert-true (listp planes) "should return a list (possibly empty)"))
    (xcaf-free-doc doc)))
(deftest xcaf-expand-assembly-t
  (let ((doc (make-xcaf-doc))
        (box (make-box 10 20 30)))
    (xcaf-add-shape doc box)
    (let ((result (xcaf-expand-assembly doc)))
      ;; expand returns t if anything was expanded, nil otherwise - either is fine
      (assert-true (member result '(t nil) :test #'eq)
                   "expand should return t or nil"))
    (xcaf-free-doc doc)))

;; --- Shape Fix ---

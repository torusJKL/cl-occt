(in-package :cl-occt)
(deftest named-color-red
  (let ((c (named-color :red)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 0.0) (= (caddr c) 0.0))
                 "named-color :red should be (1 0 0)")))
(deftest named-color-blue
  (let ((c (named-color :blue)))
    (assert-true (and (= (car c) 0.0) (= (cadr c) 0.0) (= (caddr c) 1.0))
                 "named-color :blue should be (0 0 1)")))
(deftest named-color-white
  (let ((c (named-color :white)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 1.0) (= (caddr c) 1.0))
                 "named-color :white should be (1 1 1)")))
(deftest named-color-unknown
  (assert-nil (named-color :nonexistent-color) "unknown named color should return nil"))
(deftest named-color-exists-p-true
  (assert-true (named-color-exists-p :red) "named-color-exists-p should be t for :red"))
(deftest named-color-exists-p-false
  (assert-nil (named-color-exists-p :nonexistent) "named-color-exists-p should be nil for unknown"))
(deftest hex-to-rgb-6-digit
  (let ((c (hex-to-rgb "#FF8800")))
    (assert-true c "hex-to-rgb should return a list")
    (destructuring-bind (r g b) c
      (assert-true (and (> r 0.99) (< r 1.01)))
      (assert-true (and (> g 0.53) (< g 0.54)))
      (assert-true (zerop b)))))
(deftest hex-to-rgb-3-digit
  (let ((c (hex-to-rgb "#F80")))
    (assert-true c "hex-to-rgb short should return a list")
    (destructuring-bind (r g b) c
      (assert-true (and (> r 0.99) (< r 1.01)))
      (assert-true (and (> g 0.53) (< g 0.54)))
      (assert-true (zerop b)))))
(deftest hex-to-rgb-invalid
  (assert-nil (hex-to-rgb "#GGG") "invalid hex string returns nil")
  (assert-nil (hex-to-rgb "not-hex") "non-hex string returns nil")
  (assert-nil (hex-to-rgb "") "empty string returns nil"))
(deftest normalize-color-keyword
  (let ((c (normalize-color :red)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 0.0) (= (caddr c) 0.0)))))
(deftest normalize-color-rgb-list
  (let ((c (normalize-color '(0.5 0.5 0.5))))
    (assert-true (and (= (car c) 0.5) (= (cadr c) 0.5) (= (caddr c) 0.5)))))
(deftest normalize-color-hex
  (assert-true (normalize-color "#FFF") "hex string normalization should work"))
(deftest make-color-from-keyword
  (let ((c (make-color :keyword :steel-blue)))
    (assert-true (viewer-color-p c) "make-color :keyword should return viewer-color")
    (assert-true (eql (color-name c) :steel-blue) "name slot should be :steel-blue")))
(deftest make-color-from-rgb
  (let ((c (make-color :rgb '(0.2 0.4 0.6))))
    (assert-true (viewer-color-p c))
    (assert-nil (color-name c) "RGB-made color should have nil name")
    (assert-true (and (= (color-r c) 0.2) (= (color-g c) 0.4) (= (color-b c) 0.6)))))
(deftest make-color-from-hls
  (let ((c (make-color :hls '(0.0 0.5 1.0))))
    (assert-true (viewer-color-p c) "HLS color creation should work")
    (let ((rgb (color-rgb c)))
      (destructuring-bind (r g b) rgb
        (assert-true (and (> r 0.9) (< g 0.1) (< b 0.1))
                     "HLS(0,0.5,1) should be roughly red")))))
(deftest color-delta-same
  (assert-true (zerop (color-delta :red :red)) "same color delta should be 0"))
(deftest color-delta-different
  (let ((d (color-delta :red :blue)))
    (assert-true (and (numberp d) (> d 1.0)) "red-blue delta should be > 1")))
(deftest color-delta-nil-input
  (assert-nil (color-delta :nonexistent :red) "nil color input returns nil for delta"))
(deftest viewer-color-p-predicate
  (let ((c (make-color :keyword :red)))
    (assert-true (viewer-color-p c) "viewer-color-p should be t for viewer-color")
    (assert-nil (viewer-color-p :not-a-color) "viewer-color-p should be nil for non-viewer-color")))
(deftest list-named-colors-includes-red
  (let ((colors (list-named-colors)))
    (assert-true (member :red colors) "list-named-colors should include :red")
    (assert-true (member :blue colors) "list-named-colors should include :blue")))

;; --- Font & Text ---

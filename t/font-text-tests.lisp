(in-package :cl-occt)
(deftest make-brep-font-from-file-valid
  (let ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-true (brep-font-p font) "expected brep-font-p from valid font file")))
(deftest make-brep-font-from-file-nonexistent
  (assert-nil (make-brep-font-from-file "/nonexistent/font.ttf" 10.0)))
(deftest make-brep-font-from-file-zero-size
  (assert-nil (make-brep-font-from-file *test-font-path* 0.0)))
(deftest make-text-shape-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape font "Hello")))
    (assert-shape text)))
(deftest make-text-shape-nil-font
  (assert-nil (make-text-shape nil "Hello")))
(deftest make-text-shape-empty-string
  (let ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-nil (make-text-shape font ""))))
(deftest make-text-shape-3d-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape-3d font "Hello 3D!" 2.0)))
    (assert-shape text "expected shape from make-text-shape-3d")))
(deftest make-text-shape-3d-nil-font
  (assert-nil (make-text-shape-3d nil "Hello" 2.0)))
(deftest make-text-shape-3d-zero-depth
  (let ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-nil (make-text-shape-3d font "Hello" 0.0))))
(deftest brep-font-p-valid
  (let ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-true (brep-font-p font))))
(deftest brep-font-p-nil
  (assert-nil (brep-font-p nil)))
(deftest text-step-roundtrip
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape-3d font "Export" 2.0)))
    (assert-true (write-step text "/tmp/clocct-text-test.step"))
    (assert-true (probe-file "/tmp/clocct-text-test.step"))))
(deftest text-stl-export
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape-3d font "Export" 2.0)))
    (assert-true (write-stl text "/tmp/clocct-text-test.stl"))
    (assert-true (probe-file "/tmp/clocct-text-test.stl"))))
(deftest text-shape-on-yz-plane
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape font "Rotated" :position '(0 0 0) :normal '(1 0 0))))
    (assert-shape text "text on YZ plane should return shape")))
(deftest text-shape-with-position-only
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape font "Pos" :position '(10 20 0))))
    (assert-shape text "text with position only should return shape")))
(deftest text-shape-on-plane-convenience
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape-on-plane font "Hi" :position '(5 5 5) :normal '(0 0 1))))
    (assert-shape text "make-text-shape-on-plane should return shape")))
(deftest text-shape-3d-on-rotated-plane
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-text-shape-3d font "Deep" 3.0 :position '(0 0 0) :normal '(0 1 0))))
    (assert-shape text "extruded text on rotated plane should return shape")))
(deftest text-bounding-box-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (multiple-value-bind (w h) (text-bounding-box font "Hello")
      (assert-true (and (numberp w) (numberp h) (> w 0) (> h 0))
                   "text-bounding-box should return width and height"))))
(deftest text-bounding-box-empty-string
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (bb (text-bounding-box font "")))
    (assert-nil bb "bounding box of empty string should be nil")))
(deftest list-available-fonts-valid
  (let ((fonts (list-available-fonts)))
    (assert-true (and (listp fonts) (every #'stringp fonts))
                 "list-available-fonts should return a list of strings")))
(deftest font-info-valid
  (let* ((fonts (list-available-fonts))
         (first-font (first fonts)))
    (assert-true first-font "should have at least one font")
    (let ((info (font-info first-font)))
      (assert-true (listp info) "font-info should return a plist")
      (assert-true (getf info :name) "font-info plist should have :name"))))
(deftest make-ais-text-label-valid
  (let ((label (make-ais-text-label "Test Label" :position '(0 0 0))))
    (assert-true (ais-text-label-p label) "make-ais-text-label should return ais-text-label")))
(deftest ais-text-label-predicate
  (assert-nil (ais-text-label-p nil)
              "ais-text-label-p should return nil for nil")
  (assert-nil (ais-text-label-p "not a label")
              "ais-text-label-p should return nil for strings"))
(deftest text-glyph-as-shape-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (glyph (text-glyph-as-shape font (char-code #\A))))
    (assert-shape glyph "render glyph should produce shape")))
(deftest text-glyph-as-shape-3d-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (glyph (text-glyph-as-shape-3d font (char-code #\B) 2.0)))
    (assert-shape glyph "render extruded glyph should produce shape")))
(deftest text-font-ascender-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (asc (text-font-ascender font)))
    (assert-true (and (numberp asc) (> asc 0)) "ascender should be positive")))
(deftest text-font-descender-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (desc (text-font-descender font)))
    (assert-true (numberp desc) "descender should be a number")))
(deftest text-font-line-spacing-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (ls (text-font-line-spacing font)))
    (assert-true (and (numberp ls) (> ls 0)) "line spacing should be positive")))
(deftest text-font-advance-x-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (ax (text-font-advance-x font (char-code #\A) (char-code #\B))))
    (assert-true (and (numberp ax) (> ax 0)) "advance-x should be positive")))
(deftest text-font-advance-y-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (ay (text-font-advance-y font (char-code #\A) (char-code #\B))))
    (assert-true (numberp ay) "advance-y should be a number")))
(deftest text-font-set-width-scaling-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-true (null (text-font-set-width-scaling font 0.8))
                 "set-width-scaling should return nil")))
(deftest text-font-set-composite-curve-mode-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0)))
    (assert-true (null (text-font-set-composite-curve-mode font t))
                 "set-composite-curve-mode should return nil")))
(deftest write-step-skips-ais-label
  (let ((label (make-ais-text-label "Skip me")))
    (assert-nil (write-step label "/tmp/clocct-label-test.step")
                "write-step should reject non-shape objects")))
(deftest write-stl-skips-ais-label
  (let ((label (make-ais-text-label "Skip me")))
    (assert-nil (write-stl label "/tmp/clocct-label-test.stl")
                "write-stl should reject non-shape objects")))

;; --- Feature Gap Tests ---
(deftest make-multi-line-text-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-multi-line-text font "Line1\nLine2")))
    (assert-shape text "multi-line text should return a shape")))
(deftest make-multi-line-text-single-line
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-multi-line-text font "SingleLine")))
    (assert-shape text "single-line multi-line should return a shape")))
(deftest make-formatted-text-valid
  (let* ((font (make-brep-font-from-file *test-font-path* 10.0))
         (text (make-formatted-text font "Hello\nWorld" :line-spacing 1.5)))
    (assert-shape text "formatted text should return a shape")))

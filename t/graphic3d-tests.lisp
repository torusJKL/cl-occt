(in-package :cl-occt)
(deftest clip-plane-make-valid
  (let ((cp (make-clip-plane)))
    (assert-true (clip-plane-p cp))
    (free-clip-plane cp)))
(deftest clip-plane-make-with-equation
  (let ((cp (make-clip-plane :equation '(1 0 0 -5))))
    (assert-true (clip-plane-p cp))
    (free-clip-plane cp)))
(deftest clip-plane-free-nil-safe
  (free-clip-plane nil)
  t)
(deftest clip-plane-free-double-safe
  (let ((cp (make-clip-plane)))
    (free-clip-plane cp)
    (free-clip-plane cp))
  t)
(deftest clip-plane-p-nil
  (assert-nil (clip-plane-p nil)))
(deftest clip-plane-p-non-plane
  (assert-nil (clip-plane-p :not-a-plane)))
(deftest clip-plane-set-equation
  (let ((cp (make-clip-plane)))
    (set-clip-plane-equation cp '(1 0 0 0))
    (assert-true (clip-plane-p cp))
    (free-clip-plane cp)))
(deftest clip-plane-get-equation
  (let ((cp (make-clip-plane :equation '(1 0 0 0))))
    (let ((eq (clip-plane-equation cp)))
      (assert-true (listp eq))
      (assert-true (= (length eq) 4)))
    (free-clip-plane cp)))
(deftest clip-plane-set-on-off
  (let ((cp (make-clip-plane)))
    (set-clip-plane-on cp nil)
    (assert-nil (clip-plane-on-p cp))
    (set-clip-plane-on cp t)
    (assert-true (clip-plane-on-p cp))
    (free-clip-plane cp)))
(deftest clip-plane-set-capping
  (let ((cp (make-clip-plane)))
    (set-clip-plane-capping cp t)
    (set-clip-plane-cap-color cp '(0.5 0.5 0.5))
    (free-clip-plane cp)))

;; --- Graphic3d ShaderProgram (core) ---
(deftest shader-program-make-valid
  (let ((prog (make-shader-program)))
    (assert-true (shader-program-p prog))
    (free-shader-program prog)))
(deftest shader-program-free-nil-safe
  (free-shader-program nil)
  t)
(deftest shader-program-free-double-safe
  (let ((prog (make-shader-program)))
    (free-shader-program prog)
    (free-shader-program prog))
  t)
(deftest shader-program-set-vertex-source
  (let ((prog (make-shader-program)))
    (set-shader-vertex-source prog "void main() {}")
    (free-shader-program prog)))
(deftest shader-program-set-fragment-source
  (let ((prog (make-shader-program)))
    (set-shader-fragment-source prog "void main() {}")
    (free-shader-program prog)))
(deftest shader-program-set-header
  (let ((prog (make-shader-program)))
    (set-shader-header prog "#version 330 core")
    (free-shader-program prog)))

;; --- Graphic3d Aspects (core) ---
(deftest aspect-fill-area-make-valid
  (let ((a (make-aspect-fill-area)))
    (assert-true (aspect-fill-area-p a))
    (free-aspect-fill-area a)))
(deftest aspect-fill-area-free-nil-safe
  (free-aspect-fill-area nil)
  t)
(deftest aspect-fill-area-get-color
  (let ((a (make-aspect-fill-area :color '(1 0 0))))
    (assert-true (equal (aspect-fill-area-color a) '(1.0d0 0.0d0 0.0d0)))
    (free-aspect-fill-area a)))
(deftest aspect-line-make-valid
  (let ((a (make-aspect-line :color '(0 1 0) :type :dash :width 2.0)))
    (assert-true (aspect-line-p a))
    (assert-true (= (aspect-line-width a) 2.0d0))
    (free-aspect-line a)))
(deftest aspect-line-get-color
  (let ((a (make-aspect-line :color '(0 1 0))))
    (destructuring-bind (r g b) (aspect-line-color a)
      (assert-true (< (abs (- r 0.0)) 0.001))
      (assert-true (< (abs (- g 1.0)) 0.001))
      (assert-true (< (abs (- b 0.0)) 0.001)))
    (free-aspect-line a)))
(deftest aspect-marker-make-valid
  (let ((a (make-aspect-marker :color '(0 0 1) :type :ball :scale 3.0)))
    (assert-true (aspect-marker-p a))
    (assert-true (= (aspect-marker-scale a) 3.0d0))
    (free-aspect-marker a)))
(deftest aspect-marker-get-type
  (let ((a (make-aspect-marker :type :x)))
    (assert-true (eq (aspect-marker-type a) :x))
    (free-aspect-marker a)))
(deftest aspect-text-make-valid
  (let ((a (make-aspect-text :color '(1 1 1) :font "Arial" :style :bold)))
    (assert-true (aspect-text-p a))
    (free-aspect-text a)))
(deftest aspect-text-get-font
  (let ((a (make-aspect-text :font "Courier")))
    (assert-true (stringp (aspect-text-font a)))
    (free-aspect-text a)))

;; --- Animation (core: no viewer needed) ---

(in-package :cl-occt)
(deftest ais-set-drawer-line-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-color obj :red)
                 "drawer line color should work")))
(deftest ais-set-drawer-line-width-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-width obj 2.0)
                 "drawer line width should work")))
(deftest ais-set-drawer-line-type-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-type obj :dash)
                 "ais-set-drawer-line-type should work")))
(deftest ais-set-drawer-point-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-color obj :red)
                 "drawer point color should work")))
(deftest ais-set-drawer-point-type-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-type obj :x)
                 "drawer point type should work")))
(deftest ais-set-drawer-point-scale-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-scale obj 2.0)
                 "drawer point scale should work")))
(deftest ais-set-drawer-text-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-color obj :white)
                 "drawer text color should work")))
(deftest ais-set-drawer-text-font-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-font obj "Arial")
                 "drawer text font should work")))
(deftest ais-set-drawer-text-height-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-height obj 12.0)
                 "drawer text height should work")))
(deftest ais-set-drawer-iso-display-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-iso-display obj)
                 "drawer iso display should work")))
(deftest ais-set-drawer-wire-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-wire-color obj :cyan)
                 "drawer wire color should work")))
(deftest ais-set-drawer-shading-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-shading-color obj :steel-blue)
                 "drawer shading color should work")))
(deftest ais-set-drawer-face-boundaries-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-face-boundaries obj t)
                 "drawer face boundaries toggle should work")))
(deftest ais-set-drawer-free-boundaries-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-free-boundaries obj t)
                 "drawer free boundaries toggle should work")))

;; --- Colors ---

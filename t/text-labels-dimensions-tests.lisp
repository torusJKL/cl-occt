(in-package :cl-occt)
(deftest set-text-label-angle-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-angle label 45.0)
                 "set-text-label-angle should work")
    (ais-free-text-label label)))
(deftest set-text-label-hjustification-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-hjustification label :center)
                 "set-text-label-hjustification should work")
    (ais-free-text-label label)))
(deftest set-text-label-vjustification-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-vjustification label :top)
                 "set-text-label-vjustification should work")
    (ais-free-text-label label)))
(deftest set-text-label-subtitle-color-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-subtitle-color label :dark-grey)
                 "set-text-label-subtitle-color should work")
    (ais-free-text-label label)))
(deftest set-text-label-display-type-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-display-type label :subtitle)
                 "set-text-label-display-type should work")
    (ais-free-text-label label)))
(deftest make-text-label-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (label (make-text-label ctx "Hello" '(0 0 0) :color :white :angle 90.0)))
      (assert-true (ais-text-label-p label)
                   "make-text-label convenience should return ais-text-label"))))

;; --- Viewer Defaults ---
(deftest set-text-label-align-convenience
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-align label :horizontal :center :vertical :top)
                 "set-text-label-align should work")
    (ais-free-text-label label)))
(deftest set-default-background-valid
  (with-viewer (v)
    (assert-true (set-default-background v :dark-slate-gray)
                 "set-default-background should work")))
(deftest set-default-projection-valid
  (with-viewer (v)
    (assert-true (set-default-projection v :iso-pers)
                 "set-default-projection should work")))
(deftest set-default-view-size-valid
  (with-viewer (v)
    (assert-true (set-default-view-size v 200.0)
                 "set-default-view-size should work")))
(deftest set-default-view-type-valid
  (with-viewer (v)
    (assert-true (set-default-view-type v :orthographic)
                 "set-default-view-type should work")))

;; --- Dimensions ---
(deftest set-default-bg-gradient-valid
  (with-viewer (v)
    (assert-true (set-default-bg-gradient v :dark-blue :sky-blue)
                 "set-default-bg-gradient should work")))
(deftest set-default-gradient-alias
  (with-viewer (v)
    (assert-true (set-default-gradient v :dark-blue :sky-blue)
                 "set-default-gradient alias should work")))
(deftest set-default-lights-modes
  (with-viewer (v)
    (assert-true (set-default-lights v :on) "set-default-lights :on should work")
    (assert-true (set-default-lights v :off) "set-default-lights :off should work")
    (assert-true (set-default-lights v :custom) "set-default-lights :custom should work")))
(deftest set-rectangular-grid-values-valid
  (with-viewer (v)
    (assert-true (set-rectangular-grid-values v :x-step 5.0 :y-step 5.0)
                 "set-rectangular-grid-values should work")))
(deftest set-grid-xy-size-valid
  (with-viewer (v)
    (assert-true (set-grid-xy-size v 5.0 10.0)
                 "set-grid-xy-size should work")))
(deftest set-grid-offset-valid
  (with-viewer (v)
    (assert-true (set-grid-offset v 2.5 3.5)
                 "set-grid-offset should work")))
(deftest grid-display-valid
  (with-viewer (v)
    (assert-true (grid-display v :color :grey :size-x 10.0 :size-y 10.0)
                 "grid-display should work")))
(deftest set-grid-color-convenience
  (with-viewer (v)
    (assert-true (set-grid-color v :grey) "set-grid-color should work")))
(deftest set-grid-size-convenience
  (with-viewer (v)
    (assert-true (set-grid-size v 10.0) "set-grid-size should work")))
(deftest grid-getter-stubs
  (with-viewer (v)
    (assert-nil (grid-color v) "grid-color should be nil")
    (assert-nil (grid-size v) "grid-size should be nil")
    (assert-nil (grid-offset v) "grid-offset should be nil")))
(deftest make-length-dimension-2p
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (assert-true (ais-object-p dim) "length dimension should be ais-object")
      (ais-display ctx dim)
      t)))
(deftest make-angle-dimension-3p
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :angle :vertex '(0 0 0) :point1 '(1 0 0) :point2 '(0 1 0))))
      (assert-true (ais-object-p dim) "angle dimension should be ais-object")
      (ais-display ctx dim)
      t)))

;; Diameter/radius dimensions require circular edges with proper topology.
;; Skipped for automated tests.
(deftest set-dimension-text-position-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-text-position dim '(5 5 0))
                   "set-dimension-text-position should work"))))
(deftest set-dimension-units-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-units dim "mm")
                   "set-dimension-units should work"))))

;; Drawer CLOS hierarchy tests are manual (require displayed objects with proper handle setup).

;; --- Existing Drawer Convenience ---
(deftest set-dimension-arrow-length-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-arrow-length dim 5.0)
                   "set-dimension-arrow-length should work"))))
(deftest set-dimension-extension-size-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-extension-size dim 3.0)
                   "set-dimension-extension-size should work"))))
(deftest set-dimension-custom-value-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-custom-value dim "Custom")
                   "set-dimension-custom-value should work"))))
(deftest make-dimension-edge-keyword
  (let ((edge (make-edge 0 0 10 0)))
    (let ((dim (make-dimension :length :edge edge)))
      (assert-true (ais-object-p dim) "length dimension with :edge should work"))))
(deftest set-dimension-text-alias
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-text dim "Custom Label")
                   "set-dimension-text alias should work"))))
(deftest set-dimension-arrows-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-arrows dim :style :filled :size 5.0)
                   "set-dimension-arrows should work"))))
(deftest set-dimension-extension-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-extension dim :offset 5.0 :length 10.0)
                   "set-dimension-extension should work"))))

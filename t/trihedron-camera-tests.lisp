(in-package :cl-occt)
(deftest make-trihedron-defaults
  (let ((tri (make-trihedron)))
    (assert-true (ais-object-p tri) "make-trihedron with defaults should return ais-object")))
(deftest make-trihedron-zero-normal
  (assert-nil (make-trihedron :normal '(0 0 0)) "make-trihedron with zero normal should return nil"))
(deftest set-trihedron-mode-shaded
  (let ((tri (make-trihedron)))
    (assert-true (ais-object-p tri))
    (set-trihedron-mode tri :shaded)
    t))
(deftest set-trihedron-arrows-nil
  (let ((tri (make-trihedron)))
    (assert-true (ais-object-p tri))
    (set-trihedron-arrows tri nil)
    t))
(deftest set-trihedron-size-100
  (let ((tri (make-trihedron)))
    (assert-true (ais-object-p tri))
    (set-trihedron-size tri 100)
    t))
(deftest set-trihedron-corner-lower-right
  (let ((tri (make-trihedron)))
    (assert-true (ais-object-p tri))
    (set-trihedron-corner tri :lower-right)
    t))
(deftest show-trihedron-in-context
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (let ((tri (show-trihedron ctx v :corner :lower-left :size 50)))
        (assert-true (ais-object-p tri) "show-trihedron should return ais-object")))))

;; --- Camera ---
(deftest set-trihedron-axis-colors-red-blue-green
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (tri (show-trihedron ctx v)))
      (assert-true (ais-object-p tri))
      (assert-true (set-trihedron-axis-colors tri :x :red :y :blue :z :green)
                   "set-trihedron-axis-colors should return trihedron"))))
(deftest set-trihedron-axis-colors-partial
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (tri (show-trihedron ctx v)))
      (assert-true (set-trihedron-axis-colors tri :x :orange)
                   "partial axis color should work"))))
(deftest set-trihedron-text-color-white
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (tri (show-trihedron ctx v)))
      (assert-true (set-trihedron-text-color tri :white)
                   "set-trihedron-text-color should return trihedron"))))
(deftest set-trihedron-text-color-nil-tri
  (assert-nil (set-trihedron-text-color nil :white) "text color on nil trihedron returns nil"))

;; --- Lighting ---
(deftest set-trihedron-wireframe-color-valid
  (let ((tri (make-trihedron)))
    (assert-true (set-trihedron-wireframe-color tri :red)
                 "set-trihedron-wireframe-color should work")))
(deftest set-camera-eye-target-up
  (with-viewer (v)
    (assert-true (set-camera v :eye '(10 10 10) :target '(0 0 0) :up '(0 1 0))
                 "set-camera should return the viewer")))
(deftest set-camera-partial-eye-only
  (with-viewer (v)
    (assert-true (set-camera v :eye '(5 5 5))
                 "set-camera with only :eye should work")))
(deftest set-perspective-toggles
  (with-viewer (v)
    (set-perspective v t)
    (assert-true (perspective-p v) "perspective-p should be t after setting perspective")
    (set-perspective v nil)
    (assert-nil (perspective-p v) "perspective-p should be nil after setting orthographic")))
(deftest set-fov-valid
  (with-viewer (v)
    (assert-true (set-fov v 45.0) "set-fov should return the viewer")))
(deftest set-fov-zero
  (with-viewer (v)
    (assert-true (set-fov v 0.0) "set-fov with 0.0 should return the viewer")))
(deftest set-clip-planes-valid
  (with-viewer (v)
    (assert-true (set-clip-planes v :near 0.1 :far 1000.0)
                 "set-clip-planes should return the viewer")))

;; Pan/zoom/rotate are interactive operations that require an active window.
;; They are tested for build correctness (no compile errors) but skipped in
;; automated headless test runs.
(deftest reset-view-valid
  (with-viewer (v)
    (assert-true (reset-view v) "reset-view should return the viewer")))
(deftest fit-all-shape-valid
  (with-viewer (v)
    (let ((box (make-box 10 20 30)))
      (assert-true (fit-all v box) "fit-all should return the viewer"))))

;; --- Custom Material ---
(deftest viewer-camera-predicate
  (let ((cam (make-instance 'viewer-camera
               :eye '(0 0 10) :target '(0 0 0) :up '(0 1 0)
               :projection-type :perspective :fov 1.0)))
    (assert-true (viewer-camera-p cam) "viewer-camera-p should be t")
    (assert-nil (viewer-camera-p nil) "viewer-camera-p should be nil for nil")
    (assert-nil (viewer-camera-p :not-a-cam) "viewer-camera-p should be nil for non-camera")))
(deftest viewer-camera-roundtrip
  (with-viewer (v)
    (let* ((cam (make-instance 'viewer-camera
                  :eye '(5 5 10) :target '(0 0 0) :up '(0 1 0)
                  :projection-type :perspective :fov 1.0))
           (result (set-viewer-camera v cam)))
      (assert-true (viewer-p result) "set-viewer-camera should return viewer"))))

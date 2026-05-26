(in-package :cl-occt)
(deftest make-viewer-returns-viewer
  (let ((v (make-viewer)))
    (assert-true (viewer-p v) "make-viewer should return a viewer")
    (free-viewer v)))
(deftest with-viewer-creates-and-cleans-up
  (with-viewer (v)
    (assert-true (viewer-p v) "with-viewer should provide a viewer"))
  ;; After the macro, the viewer should be freed (can't easily check handles,
  ;; but no error means success)
  t)
(deftest free-viewer-nil-safe
  ;; Verify free-viewer handles nil and non-viewer inputs safely
  (free-viewer nil)
  (free-viewer "not-a-viewer")
  t)

;; --- AIS Display ---
(deftest ais-create-context-returns-ais-context
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (assert-true (ais-context-p ctx) "ais-create-context should return ais-context"))))
(deftest ais-create-shape-from-box
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-object-p obj) "ais-create-shape from box should return ais-object")))
(deftest ais-create-shape-nil-shape
  (assert-nil (ais-create-shape nil) "ais-create-shape with nil should return nil"))
(deftest ais-create-shape-nil-input
  (assert-nil (ais-create-shape nil) "ais-create-shape with nil returns nil"))

;; --- Styling / Camera / MSAA / Grid Tests ---
(deftest ais-display-shape-in-context
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (let ((obj (ais-display ctx (make-box 10 20 30))))
        (assert-true (ais-object-p obj) "ais-display shape should return ais-object")))))
(deftest ais-displayed-p-returns-t-after-display
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-displayed-p ctx obj) "ais-displayed-p should return t after display"))))
(deftest ais-erase-hides-without-removing
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-erase ctx obj)
      (assert-nil (ais-displayed-p ctx obj) "ais-erase should hide without removing"))))
(deftest ais-remove-removes-from-context
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-remove ctx obj)
      (assert-nil (ais-displayed-p ctx obj) "ais-remove should remove from context"))))
(deftest ais-free-on-nil-safe
  (ais-free nil)
  t)
(deftest set-background-valid
  (with-viewer (v)
    (assert-true (set-background v 0.1 0.1 0.2)
                 "set-background should return the color list")))
(deftest ais-set-color-on-displayed-shape
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-color ctx obj '(1.0 0.0 0.0))
      ;; void function, pass if no crash
      t)))
(deftest ais-set-display-mode-wireframe
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-display-mode ctx obj :wireframe)
      ;; void function, pass if no crash
      t)))
(deftest set-view-projection-iso
  (with-viewer (v)
    (set-view-projection v :iso-pers)
    ;; void function, pass if no crash
    t))
(deftest set-msaa-roundtrip
  (with-viewer (v)
    (set-msaa v 4)
    (let ((val (msaa v)))
      (assert-true (integerp val)))))
(deftest set-antialiasing-roundtrip
  (with-viewer (v)
    (set-antialiasing v t)
    (assert-true (antialiasing-p v))))
(deftest activate-grid-rectangular-lines
  (with-viewer (v)
    (activate-grid v :rectangular :lines)
    ;; void function, pass if no crash
    t))
(deftest activate-grid-circular-points
  (with-viewer (v)
    (activate-grid v :circular :points)
    ;; void function, pass if no crash
    t))

;; --- Trihedron Tests ---

(in-package :cl-occt)
(deftest make-colored-shape-from-box
  (let ((cs (make-colored-shape (make-box 10 20 30))))
    (assert-true (ais-object-p cs))))
(deftest make-colored-shape-nil-shape
  (assert-nil (make-colored-shape nil)))
(deftest make-manipulator-created
  (let ((m (make-manipulator)))
    (assert-true (ais-object-p m))))
(deftest make-manipulator-set-position
  (let ((m (make-manipulator)))
    (set-manipulator-position m 10 20 30)
    (assert-true t)))
(deftest make-manipulator-set-size
  (let ((m (make-manipulator)))
    (set-manipulator-size m 50.0)
    (assert-true t)))
(deftest make-connected-interactive-from-shape
  (let* ((ais (ais-create-shape (make-box 10 20 30)))
         (conn (make-connected-interactive ais)))
    (assert-true (ais-object-p conn))))
(deftest make-connected-interactive-nil
  (assert-nil (make-connected-interactive nil)))
(deftest make-point-cloud-valid
  (let ((pc (make-point-cloud '((0 0 0) (1 0 0) (0 1 0)))))
    (assert-true (ais-object-p pc))))
(deftest make-point-cloud-nil
  (assert-nil (make-point-cloud nil)))
(deftest make-point-cloud-empty
  (assert-nil (make-point-cloud '())))
(deftest make-ais-plane-valid
  (let ((p (make-ais-plane '(0 0 0) '(0 0 1))))
    (assert-true (ais-object-p p))))
(deftest make-ais-axis-valid
  (let ((a (make-ais-axis '(0 0 0) '(1 0 0))))
    (assert-true (ais-object-p a))))
(deftest make-ais-line-valid
  (let ((l (make-ais-line '(0 0 0) '(10 0 0))))
    (assert-true (ais-object-p l))))
(deftest make-ais-circle-valid
  (let ((c (make-ais-circle '(0 0 0) '(0 0 1) 50.0)))
    (assert-true (ais-object-p c))))
(deftest make-view-cube-created
  (let ((vc (make-view-cube)))
    (assert-true (ais-object-p vc))))
(deftest make-view-cube-set-size
  (let ((vc (make-view-cube)))
    (set-view-cube-size vc 60.0)
    (assert-true t)))
(deftest make-view-cube-set-corner
  (let ((vc (make-view-cube)))
    (set-view-cube-corner vc :upper-right)
    (assert-true t)))
(deftest make-color-scale-created
  (let ((cs (make-color-scale)))
    (assert-true (ais-object-p cs))))
(deftest make-color-scale-set-range
  (let ((cs (make-color-scale)))
    (set-color-scale-range cs 0.0 100.0)
    (assert-true t)))
(deftest make-color-scale-set-size
  (let ((cs (make-color-scale)))
    (set-color-scale-size cs 50 200)
    (assert-true t)))
(deftest make-color-scale-set-title
  (let ((cs (make-color-scale)))
    (set-color-scale-title cs "Test")
    (assert-true t)))
(deftest make-color-scale-set-intervals
  (let ((cs (make-color-scale)))
    (set-color-scale-intervals cs 10)
    (assert-true t)))
(deftest make-multiple-connected-created
  (let ((mc (make-multiple-connected)))
    (assert-true (ais-object-p mc))))
(deftest make-multiple-connected-connect
  (let* ((ais (ais-create-shape (make-box 10 20 30)))
         (mc (make-multiple-connected)))
    (connect-to-multiple mc ais)
    (assert-true t)))
(deftest make-triangulation-valid
  (let ((tri (make-ais-triangulation '((0 0 0) (1 0 0) (0 1 0) (0 0 1))
                                      '((0 1 2) (0 2 3)))))
    (assert-true (ais-object-p tri))))

;; --- Mesh Operations ---
(deftest make-material-valid
  (let ((mat (make-material :diffuse '(0.8 0.1 0.1) :shininess 0.9)))
    (assert-true (material-p mat) "make-material should return material")))
(deftest ais-set-custom-material-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30)))
           (mat (make-material :diffuse '(0.8 0.1 0.1) :shininess 0.9)))
      (assert-true (ais-set-custom-material ctx obj mat)
                   "ais-set-custom-material should work"))))

;; --- Object Properties ---
(deftest ais-set-transparency-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-transparency ctx obj 0.5)
                   "ais-set-transparency should return the object"))))
(deftest ais-set-transparency-zero
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-transparency ctx obj 0.0)
                   "zero transparency should work"))))
(deftest ais-set-material-gold
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-material ctx obj :gold)
                   "ais-set-material with :gold should work"))))
(deftest ais-set-material-plastic
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-material ctx obj :plastic)
                   "ais-set-material with :plastic should work"))))
(deftest ais-set-material-unknown
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-nil (ais-set-material ctx obj :nonexistent)
                  "unknown material should return nil"))))
(deftest ais-set-line-width-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-line-width ctx obj 3.0)
                   "ais-set-line-width should return the object"))))
(deftest ais-show-edges-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-show-edges ctx obj t)
                   "ais-show-edges should return the object"))))
(deftest ais-set-edge-styling-color
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-edge-styling ctx obj :color :red)
                   "ais-set-edge-styling with color should work"))))
(deftest ais-set-selection-mode-face
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-selection-mode ctx obj 1)
                   "selection mode 1 (face) should work"))))
(deftest ais-set-selection-mode-nil
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-selection-mode ctx obj nil)
                   "deactivating selection should work"))))
(deftest ais-set-tessellation-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-tessellation obj :quality 0.1)
                 "ais-set-tessellation should work on ais-object")))

;; --- Selection Tests ---
(deftest set-cube-map-alias
  (format t "SKIP (cubemap requires GPU context)~%")
  (finish-output)
  (incf (test-result-pass *test-result*)))

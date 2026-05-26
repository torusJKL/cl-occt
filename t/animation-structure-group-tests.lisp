(in-package :cl-occt)
(deftest animation-make-valid
  (let ((anim (make-animation "test")))
    (assert-true (ais-animation-p anim))
    (ais-animation-free anim)))
(deftest animation-make-nil-name
  (assert-nil (make-animation nil)))
(deftest animation-free-nil-safe
  (ais-animation-free nil)
  t)
(deftest animation-free-double-safe
  (let ((anim (make-animation "double-free")))
    (ais-animation-free anim)
    (ais-animation-free anim))
  t)
(deftest animation-duration-set-get
  (let ((anim (make-animation "dur")))
    (setf (ais-animation-duration anim) 5.0)
    (assert-true (= (ais-animation-duration anim) 5.0))
    (ais-animation-free anim)))
(deftest animation-progress-set-get
  (let ((anim (make-animation "prog")))
    (setf (ais-animation-duration anim) 10.0)
    (setf (ais-animation-progress anim) 0.5)
    (assert-true (>= (ais-animation-progress anim) 0.49))
    (ais-animation-free anim)))
(deftest animation-start-pause-set
  (let ((anim (make-animation "pause")))
    (setf (ais-animation-start-pause anim) 2.0)
    (ais-animation-free anim)))
(deftest animation-add-remove-child
  (let ((parent (make-animation "parent"))
        (child (make-animation "child")))
    (add-animation parent child)
    (remove-animation parent child)
    (ais-animation-free child)
    (ais-animation-free parent)))

;; --- Prs3d Tools Tests ---
(deftest animation-object-make-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (ais-obj (ais-display ctx (make-box 10 20 30)))
           (anim (make-animation-object "obj-anim" ctx ais-obj
                                        :translation '(50 0 0))))
      (assert-true (ais-animation-object-p anim))
      (ais-animation-free anim))))
(deftest animation-axis-rotation-make-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (ais-obj (ais-display ctx (make-box 10 20 30)))
           (anim (make-animation-axis-rotation "spin" ctx ais-obj
                                                '(0 0 0) '(0 0 1)
                                                :angle-end 360)))
      (assert-true (ais-animation-axis-rotation-p anim))
      (ais-animation-free anim))))

;; --- Graphic3d Structure (needs viewer) ---
(deftest graphic-structure-make-valid
  (with-viewer (v)
    (let ((gs (make-graphic-structure v)))
      (assert-true (graphic-structure-p gs))
      (free-graphic-structure gs))))
(deftest graphic-structure-free-nil-safe
  (free-graphic-structure nil)
  t)
(deftest graphic-structure-free-double-safe
  (with-viewer (v)
    (let ((gs (make-graphic-structure v)))
      (free-graphic-structure gs)
      (free-graphic-structure gs))
    t))
(deftest graphic-structure-set-visible
  (with-viewer (v)
    (let ((gs (make-graphic-structure v)))
      (set-graphic-structure-visible gs t)
      (free-graphic-structure gs))))
(deftest graphic-structure-display-erase
  (with-viewer (v)
    (let ((gs (make-graphic-structure v)))
      (graphic-structure-display gs)
      (graphic-structure-erase gs)
      (free-graphic-structure gs))))
(deftest graphic-structure-add-remove-child
  (with-viewer (v)
    (let ((parent (make-graphic-structure v))
          (child (make-graphic-structure v)))
      (graphic-structure-add-child parent child)
      (graphic-structure-remove-child parent child)
      (free-graphic-structure child)
      (free-graphic-structure parent))))

;; --- Graphic3d Group (needs viewer) ---
(deftest graphic-group-make-valid
  (with-viewer (v)
    (let* ((gs (make-graphic-structure v))
           (gg (make-graphic-group gs)))
      (assert-true (graphic-group-p gg))
      (free-graphic-structure gs))))
(deftest graphic-group-set-visible
  (with-viewer (v)
    (let* ((gs (make-graphic-structure v))
           (gg (make-graphic-group gs)))
      (set-graphic-group-visible gg t)
      (free-graphic-structure gs))))
(deftest graphic-group-add-primitives
  (with-viewer (v)
    (let* ((gs (make-graphic-structure v))
           (gg (make-graphic-group gs)))
      (graphic-group-add-points gg '(0.0 0.0 0.0 1.0 1.0 1.0))
      (graphic-group-add-lines gg '(0.0 0.0 0.0 1.0 0.0 0.0))
      (graphic-group-add-text gg "test" '(0 0 0))
      (free-graphic-structure gs))))
(deftest graphic-group-add-triangles-valid
  (with-viewer (v)
    (let* ((gs (make-graphic-structure v))
           (gg (make-graphic-group gs)))
      (graphic-group-add-triangles gg '(0 0 0 1 0 0 0 1 0))
      (free-graphic-structure gs))))
(deftest graphic-group-set-aspect
  (with-viewer (v)
    (let* ((gs (make-graphic-structure v))
           (gg (make-graphic-group gs))
           (fa (make-aspect-fill-area :color '(1 0 0))))
      (set-graphic-group-aspect gg fa)
      (free-aspect-fill-area fa)
      (free-graphic-structure gs))))

;; --- Graphic3d RenderingParams (needs viewer) ---
(deftest viewer-rendering-params-valid
  (with-viewer (v)
    (let ((rp (viewer-rendering-params v)))
      (assert-true (rendering-params-p rp)))))
(deftest rendering-params-method-roundtrip
  (with-viewer (v)
    (let ((rp (viewer-rendering-params v)))
      (set-rendering-method rp :ray-tracing)
      (assert-true (eq (rendering-method rp) :ray-tracing))
      (set-rendering-method rp :rasterization)
      (assert-true (eq (rendering-method rp) :rasterization)))))
(deftest rendering-params-shadows-toggle
  (with-viewer (v)
    (let ((rp (viewer-rendering-params v)))
      (set-ray-traced-shadows rp t)
      (assert-true (ray-traced-shadows-p rp))
      (set-ray-traced-shadows rp nil)
      (assert-nil (ray-traced-shadows-p rp)))))
(deftest rendering-params-reflections-toggle
  (with-viewer (v)
    (let ((rp (viewer-rendering-params v)))
      (set-ray-traced-reflections rp t)
      (assert-true (ray-traced-reflections-p rp))
      (set-ray-traced-reflections rp nil)
      (assert-nil (ray-traced-reflections-p rp)))))
(deftest rendering-params-antialiasing-toggle
  (with-viewer (v)
    (let ((rp (viewer-rendering-params v)))
      (set-ray-traced-antialiasing rp t)
      (assert-true (ray-traced-antialiasing-p rp))
      (set-ray-traced-antialiasing rp nil)
      (assert-nil (ray-traced-antialiasing-p rp)))))

;; --- Viewer ---

(in-package :cl-occt)

(defstruct test-result
  (pass 0)
  (fail 0)
  (errors 0))

(defvar *test-result* (make-test-result))

(defmacro deftest (name &body body)
  `(defun ,name ()
     (format t "~&Test: ~A ... " ',name)
     (finish-output)
     (handler-case
         (progn ,@body
                (format t "PASS~%")
                (incf (test-result-pass *test-result*)))
       (error (e)
         (format t "FAIL (~A)~%" e)
         (incf (test-result-fail *test-result*))))))

(defun assert-true (val &optional msg)
  (unless val
    (error (or msg "expected true"))))

(defun assert-nil (val &optional msg)
  (when val
    (error (or msg "expected nil"))))

(defun assert-shape (val &optional msg)
  (assert-true (shape-p val) (or msg "expected shape")))

(defun assert-geom2d (val &optional msg)
  (assert-true (geom2d-p val) (or msg "expected geom2d")))

;; --- Primitives ---

(deftest make-box-valid
  (assert-shape (make-box 10 20 30)))

(deftest make-box-zero-dim
  (assert-nil (make-box 0 20 30)))

(deftest make-box-negative
  (assert-nil (make-box -1 20 30)))

(deftest make-cylinder-valid
  (assert-shape (make-cylinder 5 20)))

(deftest make-sphere-valid
  (assert-shape (make-sphere 10)))

(deftest make-cone-valid
  (assert-shape (make-cone 5 10 15)))

(deftest make-torus-valid
  (assert-shape (make-torus 10 3)))

(deftest make-torus-zero-major
  (assert-nil (make-torus 0 3)))

(deftest make-torus-zero-minor
  (assert-nil (make-torus 10 0)))

(deftest make-prism-zero-vector
  (assert-nil (make-prism (make-box 5 5 1) 0 0 0)))

(deftest make-prism-nil-shape
  (assert-nil (make-prism nil 0 0 10)))

(deftest make-revol-zero-angle
  (assert-nil (make-revol (make-box 5 5 1) 0 0 1 0)))

(deftest make-revol-nil-shape
  (assert-nil (make-revol nil 0 0 1 360)))

(deftest shape-distinct
  (let ((a (make-box 1 2 3))
        (b (make-box 1 2 3)))
    (assert-true (not (eq a b)) "shapes should be distinct")))

;; --- 2D Geometry ---

(deftest make-pnt2d-valid
  (assert-geom2d (make-pnt2d 10 20)))

(deftest make-vec2d-valid
  (assert-geom2d (make-vec2d 3 4)))

(deftest make-dir2d-valid
  (assert-geom2d (make-dir2d 1 0)))

(deftest make-dir2d-zero
  (assert-nil (make-dir2d 0 0)))

;; --- 2D Curves ---

(deftest make-line2d-valid
  (assert-geom2d (make-line2d 0 0 1 0)))

(deftest make-circle2d-valid
  (assert-geom2d (make-circle2d 5 5 10)))

(deftest make-circle2d-zero-radius
  (assert-nil (make-circle2d 0 0 0)))

;; --- Face Construction ---

(deftest make-edge-valid
  (assert-shape (make-edge 0 0 10 0)))

(deftest make-edge-3d-valid
  (assert-shape (make-edge-3d 0 0 0 10 0 0)))

(deftest make-circle-edge-valid
  (assert-shape (make-circle-edge 0 0 10)))

(deftest make-circular-arc-valid
  (assert-shape (make-circular-arc 0 0 5 5 10 0)))

(deftest make-circular-arc-collinear
  (assert-nil (make-circular-arc 0 0 5 5 10 10)))

(deftest make-wire-two-edges
  (assert-shape (make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10))))

(deftest make-wire-empty
  (assert-nil (make-wire)))

(deftest make-face-square
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4)))
    (assert-shape (make-face w))))

(deftest make-face-nil
  (assert-nil (make-face nil)))

(deftest make-face-on-plane-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4)))
    (assert-shape (make-face-on-plane w 0 0 0 0 0 1))))

;; --- Booleans ---

(deftest cut-two-boxes
  (let ((result (cut (make-box 10 20 30) (make-box 5 5 5))))
    (assert-shape result)))

(deftest cut-nil-first
  (assert-nil (cut nil (make-box 5 5 5))))

(deftest cut-nil-second
  (assert-nil (cut (make-box 5 5 5) nil)))

(deftest fuse-two-boxes
  (let ((result (fuse (make-box 10 10 10) (translate (make-box 10 10 10) 5 0 0))))
    (assert-shape result)))

(deftest common-overlap
  (let ((result (common (make-box 10 10 10) (translate (make-box 10 10 10) 5 5 5))))
    (assert-shape result)))

(deftest common-no-overlap
  (let* ((a (translate (make-box 10 10 10) 0 0 0))
         (b (translate (make-box 10 10 10) 100 100 100))
         (result (common a b)))
    (assert-nil result "non-overlapping common should be nil")))

(deftest boolean-variadic
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5))
        (c (translate (make-box 10 10 10) 0 5 0)))
    (assert-shape (fuse a b c))))

(deftest section-intersecting-boxes
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5)))
    (assert-shape (section a b))))

(deftest section-non-intersecting
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 100 100 100)))
    (assert-nil (section a b) "non-intersecting section should be nil")))

(deftest section-nil-first
  (assert-nil (section nil (make-box 5 5 5))))

(deftest section-nil-second
  (assert-nil (section (make-box 5 5 5) nil)))

(deftest section-variadic
  (let ((a (make-box 10 10 10))
        (b (translate (make-box 10 10 10) 5 5 5))
        (c (translate (make-box 10 10 10) 0 5 0)))
    (assert-shape (section a b c))))

(deftest section-solid-plane
  (let* ((e1 (make-edge -10 -10 10 -10))
         (e2 (make-edge 10 -10 10 10))
         (e3 (make-edge 10 10 -10 10))
         (e4 (make-edge -10 10 -10 -10))
         (w (make-wire e1 e2 e3 e4))
         (face (make-face w)))
    (assert-shape (section (make-box 20 20 20) face))))

;; --- 2D Booleans ---

(deftest face-cut-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (cut face-a face-b))))

(deftest face-fuse-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (fuse face-a face-b))))

(deftest face-common-overlapping
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 5 5 15 5))
         (e6 (make-edge 15 5 15 15))
         (e7 (make-edge 15 15 5 15))
         (e8 (make-edge 5 15 5 5))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-shape (common face-a face-b))))

(deftest face-common-no-overlap
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (face-a (make-face (make-wire e1 e2 e3 e4)))
         (e5 (make-edge 100 100 110 100))
         (e6 (make-edge 110 100 110 110))
         (e7 (make-edge 110 110 100 110))
         (e8 (make-edge 100 110 100 100))
         (face-b (make-face (make-wire e5 e6 e7 e8))))
    (assert-nil (common face-a face-b) "non-overlapping faces should be nil")))

(deftest face-cut-nil
  (assert-nil (cut nil (make-face (make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10) (make-edge 10 10 0 10) (make-edge 0 10 0 0))))))

;; --- Transforms ---

(deftest translate-shape
  (let ((result (translate (make-box 10 10 10) 5 0 0)))
    (assert-shape result)))

(deftest translate-preserves-original
  (let ((a (make-box 10 10 10)))
    (translate a 5 0 0)
    (assert-shape a "original should remain unchanged")))

(deftest translate-nil
  (assert-nil (translate nil 5 0 0)))

(deftest rotate-shape
  (let ((result (rotate (make-box 10 10 10) 0 0 1 45)))
    (assert-shape result)))

;; --- STEP I/O ---

(deftest write-step-valid
  (let ((result (write-step (make-box 10 20 30) "/tmp/clocct-test-box.step")))
    (assert-true result "write-step should return t")))

(deftest write-step-nil
  (assert-nil (write-step nil "/tmp/clocct-test-nil.step")))

(deftest read-step-roundtrip
  (write-step (make-box 10 20 30) "/tmp/clocct-test-roundtrip.step")
  (let ((shape (read-step "/tmp/clocct-test-roundtrip.step")))
    (assert-shape shape "read-step should return a shape")))

(deftest read-step-nonexistent
  (assert-nil (read-step "/tmp/clocct-nonexistent.step")))

;; --- DAG ---

(deftest dag-set-param
  (let ((key (gensym "PARAM")))
    (set-param! key 42)
    (assert-true (eql (getf cl-occt.impl:*params* key) 42))))

(deftest dag-set-params-batch
  (set-params! :test-a 1 :test-b 2)
  (assert-true (and (eql (getf cl-occt.impl:*params* :test-a) 1)
                    (eql (getf cl-occt.impl:*params* :test-b) 2))))

;; --- DSL ---

(deftest param-function-global
  (set-param! :dsl-test 99)
  (assert-true (eql (param :dsl-test) 99)))

(deftest with-params-local
  (with-params (:local-x 50)
    (assert-true (eql (param :local-x) 50))))

(deftest with-params-does-not-leak
  (with-params (:leak-test "local")
    (param :leak-test))
  (assert-nil (getf cl-occt.impl:*params* :leak-test)))

(defun run-tests ()
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt smoke tests ===~2%")
    (dolist (test-sym
             '(make-box-valid make-box-zero-dim make-box-negative
               make-cylinder-valid make-sphere-valid make-cone-valid
               make-torus-valid make-torus-zero-major make-torus-zero-minor
               make-prism-zero-vector make-prism-nil-shape
               make-revol-zero-angle make-revol-nil-shape
               shape-distinct
               make-pnt2d-valid make-vec2d-valid make-dir2d-valid make-dir2d-zero
               make-line2d-valid make-circle2d-valid make-circle2d-zero-radius
               make-edge-valid make-edge-3d-valid make-circle-edge-valid
               make-circular-arc-valid make-circular-arc-collinear
               make-wire-two-edges make-wire-empty
               make-face-square make-face-nil make-face-on-plane-valid
               cut-two-boxes cut-nil-first cut-nil-second
               fuse-two-boxes common-overlap common-no-overlap
               boolean-variadic
               section-intersecting-boxes section-non-intersecting
               section-nil-first section-nil-second
               section-variadic section-solid-plane
               face-cut-overlapping face-fuse-overlapping
               face-common-overlapping face-common-no-overlap face-cut-nil
               translate-shape translate-preserves-original translate-nil
               rotate-shape
               write-step-valid write-step-nil
               read-step-roundtrip read-step-nonexistent
               dag-set-param dag-set-params-batch
               param-function-global with-params-local with-params-does-not-leak))
      (funcall test-sym))
    (format t "~2&=== Results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

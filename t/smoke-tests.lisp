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

;; --- STL I/O ---

(deftest write-stl-valid
  (let ((result (write-stl (make-box 10 20 30) "/tmp/clocct-test-box.stl")))
    (assert-true result "write-stl should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.stl") "STL file should exist"))

(deftest write-stl-nil
  (assert-nil (write-stl nil "/tmp/clocct-test-nil.stl")))

(deftest read-stl-roundtrip
  (write-stl (make-box 10 20 30) "/tmp/clocct-test-roundtrip.stl")
  (let ((shape (read-stl "/tmp/clocct-test-roundtrip.stl")))
    (assert-shape shape "read-stl should return a shape")))

(deftest read-stl-nonexistent
  (assert-nil (read-stl "/tmp/clocct-nonexistent.stl")))

(deftest write-stl-deflection
  (let ((result (write-stl (make-sphere 10) "/tmp/clocct-test-sphere.stl" :deflection 0.05)))
    (assert-true result "write-stl with custom deflection should return t"))
  (assert-true (probe-file "/tmp/clocct-test-sphere.stl") "STL file should exist"))

;; --- Compounds ---

(deftest make-compound-two-boxes
  (assert-shape (make-compound (list (make-box 10 20 30) (make-box 5 5 5)))))

(deftest make-compound-skips-nil
  (let ((c (make-compound (list (make-box 10 20 30) nil (make-box 5 5 5)))))
    (assert-shape c)))

(deftest make-compound-all-nil
  (assert-nil (make-compound (list nil nil))))

(deftest make-compound-empty-list
  (assert-nil (make-compound '())))

(deftest add-to-compound-valid
  (let ((c (make-compound (list (make-box 1 2 3)))))
    (assert-shape (add-to-compound c (make-box 10 20 30)))))

(deftest add-to-compound-nil-shape
  (let ((c (make-compound (list (make-box 10 20 30)))))
    (assert-shape (add-to-compound c nil))))

(deftest add-to-compound-nil-compound
  (assert-nil (add-to-compound nil (make-box 10 20 30))))

(deftest compound-shape-p-returns-t
  (assert-true (compound-shape-p (make-compound (list (make-box 1 2 3))))))

(deftest compound-shape-p-returns-nil-for-simple-shape
  (assert-nil (compound-shape-p (make-box 1 2 3))))

(deftest compound-shape-p-returns-nil-for-nil
  (assert-nil (compound-shape-p nil)))

(deftest write-stl-compound
  (let ((result (write-stl (make-compound (list (make-box 10 20 30) (make-box 5 5 5)))
                           "/tmp/clocct-test-compound.stl")))
    (assert-true result "write-stl with compound should return t"))
  (assert-true (probe-file "/tmp/clocct-test-compound.stl") "compound STL file should exist"))

(deftest write-stl-empty-compound
  (assert-nil (write-stl (make-compound '()) "/tmp/clocct-test-empty-compound.stl")))

(deftest write-step-assembly-valid
  (let ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1 0 0 1))))
    (assert-true (write-step-assembly part "/tmp/clocct-test-assy.step"))))

(deftest write-step-assembly-nil
  (assert-nil (write-step-assembly nil "/tmp/clocct-test-nil-assy.step")))

(deftest read-step-assembly-nonexistent
  (assert-nil (read-step-assembly "/tmp/clocct-nonexistent.step")))

(deftest read-step-assembly-roundtrip
  (let* ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1.0 0.0 0.0 1.0)))
         (_ (write-step-assembly part "/tmp/clocct-test-assy-rt.step"))
         (result (read-step-assembly "/tmp/clocct-test-assy-rt.step")))
    (assert-true (typep result 'assembly))
    (assert-true (assembly-branch-p result) "roundtrip result should have children")
    (let ((child (first (assembly-children result))))
      (assert-true (typep child 'assembly))
      (assert-shape (assembly-shape child))
      (assert-true (string= (assembly-name child) "box"))
      (assert-true (not (null (assembly-color child)))
                   "roundtrip should preserve a color"))))

(deftest read-step-assembly-multi-part
  (let* ((a (make-part (make-box 10 20 30) :name "a" :color '(:generic 1.0 0.0 0.0 1.0)))
         (b (make-part (make-cylinder 5 20) :name "b" :color '(:generic 0.0 0.0 1.0 1.0)))
         (assy (make-assembly :name "multi" :children (list a b)))
         (_ (write-step-assembly assy "/tmp/clocct-test-multi.step"))
         (result (read-step-assembly "/tmp/clocct-test-multi.step")))
    (assert-true (typep result 'assembly))
    (let ((children (assembly-children result)))
      (assert-true (= (length children) 2)))))

(deftest read-step-assembly-nested
  (let* ((inner (make-assembly :name "inner"
                               :children (list (make-part (make-box 1 2 3) :name "leaf"))))
         (outer (make-assembly :name "outer" :children (list inner)))
         (_ (write-step-assembly outer "/tmp/clocct-test-nested.step"))
         (result (read-step-assembly "/tmp/clocct-test-nested.step")))
    (assert-true (typep result 'assembly))
    (assert-true (> (length (assembly-children result)) 0))))

;; --- Assembly Tree ---

(deftest make-part-valid
  (let ((p (make-part (make-box 10 20 30) :name "test" :color '(:generic 1.0 0.0 0.0 1.0))))
    (assert-true (typep p 'assembly))
    (assert-shape (assembly-shape p))
    (assert-true (string= (assembly-name p) "test"))
    (assert-true (equalp (assembly-color p) '(:generic 1.0 0.0 0.0 1.0)))
    (assert-nil (assembly-children p))))

(deftest make-assembly-valid
  (let ((a (make-assembly :name "root" :children nil)))
    (assert-true (typep a 'assembly))
    (assert-true (string= (assembly-name a) "root"))
    (assert-nil (assembly-children a))
    (assert-nil (assembly-shape a))))

(deftest assembly-leaf-predicate
  (let ((leaf (make-part (make-box 1 2 3)))
        (branch (make-assembly :children (list (make-part (make-box 1 2 3))))))
    (assert-true (assembly-leaf-p leaf))
    (assert-nil (assembly-leaf-p branch))))

(deftest assembly-branch-predicate
  (let ((leaf (make-part (make-box 1 2 3)))
        (branch (make-assembly :children (list (make-part (make-box 1 2 3))))))
    (assert-true (assembly-branch-p branch))
    (assert-nil (assembly-branch-p leaf))))

(deftest assembly-setf-name
  (let ((node (make-part (make-box 1 2 3))))
    (setf (assembly-name node) "renamed")
    (assert-true (string= (assembly-name node) "renamed"))))

(deftest assembly-setf-color
  (let ((node (make-part (make-box 1 2 3))))
    (setf (assembly-color node) '(:generic 0.0 0.0 1.0 1.0))
    (assert-true (equalp (assembly-color node) '(:generic 0.0 0.0 1.0 1.0)))))

(deftest assembly-setf-children
  (let ((node (make-part (make-box 1 2 3)))
        (child (make-part (make-box 4 5 6))))
    (setf (assembly-children node) (list child))
    (assert-true (assembly-branch-p node))
    (assert-true (eq (first (assembly-children node)) child))))

(deftest assembly-color-components
  (let* ((color '(:generic 0.5 0.25 0.75 0.8))
         (node (make-part (make-box 1 2 3) :color color)))
    (assert-true (eql (first (assembly-color node)) :generic))
    (assert-true (= (second (assembly-color node)) 0.5))
    (assert-true (= (third (assembly-color node)) 0.25))
    (assert-true (= (fourth (assembly-color node)) 0.75))
    (assert-true (= (fifth (assembly-color node)) 0.8))))

(deftest assembly-no-color
  (let ((node (make-part (make-box 1 2 3))))
    (assert-nil (assembly-color node))))

(deftest assembly-no-name
  (let ((node (make-part (make-box 1 2 3))))
    (assert-nil (assembly-name node))))

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

;; --- DSL Metadata ---

(deftest defmodel-static-metadata
  (defmodel meta-static-box ()
    (:color (:generic 1.0 0.0 0.0 1.0))
    (:name "Static Box")
    (:layer "mechanical")
    (make-box 10 20 30))
  (assert-true (equalp (model-color 'meta-static-box) '(:generic 1.0 0.0 0.0 1.0)))
  (assert-true (string= (model-display-name 'meta-static-box) "Static Box"))
  (assert-true (string= (model-layer 'meta-static-box) "mechanical")))

(deftest defmodel-metadata-from-params
  (set-params! :meta-color '(:generic 0.0 1.0 0.0 1.0)
               :meta-name "Param Box"
               :meta-layer "electric")
  (defmodel meta-param-box ()
    (:color (param :meta-color))
    (:name (param :meta-name))
    (:layer (param :meta-layer))
    (make-box 10 20 30))
  (assert-true (equalp (model-color 'meta-param-box) '(:generic 0.0 1.0 0.0 1.0)))
  (assert-true (string= (model-display-name 'meta-param-box) "Param Box"))
  (assert-true (string= (model-layer 'meta-param-box) "electric")))

(deftest defmodel-no-metadata
  (defmodel meta-plain-box ()
    (make-box 10 20 30))
  (assert-nil (model-color 'meta-plain-box))
  (assert-nil (model-display-name 'meta-plain-box))
  (assert-nil (model-layer 'meta-plain-box)))

(deftest defmodel-metadata-re-evaluation
  (set-params! :re-color '(:generic 1.0 0.0 0.0 1.0) :re-w 10)
  (defmodel meta-re-box ()
    (:color (param :re-color))
    (make-box (param :re-w) 20 30))
  (assert-true (equalp (model-color 'meta-re-box) '(:generic 1.0 0.0 0.0 1.0)))
  (set-param! :re-color '(:generic 0.0 0.0 1.0 1.0))
  (assert-true (equalp (model-color 'meta-re-box) '(:generic 0.0 0.0 1.0 1.0))))

(deftest write-dag-models-to-step-valid
  (defmodel dag-export-box ()
    (:name "DAG Box")
    (:color (:generic 1.0 0.0 0.0 1.0))
    (make-box 10 20 30))
  (assert-true (write-dag-models-to-step "/tmp/clocct-test-dag-export.step")))

(deftest read-step-into-dag-valid
  (assert-true (read-step-into-dag "/tmp/clocct-test-dag-export.step")))

;; --- Viewer ---

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

(deftest free-viewer-double-free-safe
  (let ((v (make-viewer)))
    (free-viewer v)
    ;; Second free should be safe
    (free-viewer v))
  t)

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
               write-stl-valid write-stl-nil
               read-stl-roundtrip read-stl-nonexistent write-stl-deflection
               make-compound-two-boxes make-compound-skips-nil
               make-compound-all-nil make-compound-empty-list
               add-to-compound-valid add-to-compound-nil-shape add-to-compound-nil-compound
               compound-shape-p-returns-t compound-shape-p-returns-nil-for-simple-shape
               compound-shape-p-returns-nil-for-nil
               write-stl-compound write-stl-empty-compound
               make-part-valid make-assembly-valid
               assembly-leaf-predicate assembly-branch-predicate
               assembly-setf-name assembly-setf-color assembly-setf-children
               assembly-color-components assembly-no-color assembly-no-name
               write-step-assembly-valid write-step-assembly-nil
               read-step-assembly-nonexistent read-step-assembly-roundtrip
               read-step-assembly-multi-part read-step-assembly-nested
               dag-set-param dag-set-params-batch
               param-function-global with-params-local with-params-does-not-leak
               defmodel-static-metadata defmodel-metadata-from-params
               defmodel-no-metadata defmodel-metadata-re-evaluation
               write-dag-models-to-step-valid read-step-into-dag-valid
               make-viewer-returns-viewer with-viewer-creates-and-cleans-up
               free-viewer-double-free-safe))
      (funcall test-sym))
    (format t "~2&=== Results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

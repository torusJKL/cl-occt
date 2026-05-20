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

(defparameter *test-font-path*
  (namestring (merge-pathnames "t/fonts/Cousine-Regular.ttf"
                               (asdf:system-source-directory :cl-occt/tests))))

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

(deftest read-step-corrupted
  (with-open-file (s "/tmp/clocct-corrupted.step"
                     :direction :output
                     :if-exists :supersede
                     :element-type '(unsigned-byte 8))
    (write-sequence (make-array 64 :element-type '(unsigned-byte 8) :initial-element 255) s))
  (assert-nil (read-step "/tmp/clocct-corrupted.step")))

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

(deftest read-stl-corrupted
  (with-open-file (s "/tmp/clocct-corrupted.stl"
                     :direction :output
                     :if-exists :supersede
                     :element-type '(unsigned-byte 8))
    (write-sequence (make-array 64 :element-type '(unsigned-byte 8) :initial-element 255) s))
  (assert-nil (read-stl "/tmp/clocct-corrupted.stl")))

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

(deftest ais-create-shape-nil-input
  (assert-nil (ais-create-shape nil) "ais-create-shape with nil returns nil"))

;; --- Styling / Camera / MSAA / Grid Tests ---

(deftest set-background-valid
  (with-viewer (v)
    (set-background v 0.1 0.1 0.2)
    t))

(deftest ais-set-color-on-displayed-shape
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-color ctx obj '(1.0 0.0 0.0))
      t)))

(deftest ais-set-display-mode-wireframe
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-display-mode ctx obj :wireframe)
      t)))

(deftest set-view-projection-iso
  (with-viewer (v)
    (set-view-projection v :iso-pers)
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
    t))

(deftest activate-grid-circular-points
  (with-viewer (v)
    (activate-grid v :circular :points)
    t))

;; --- Trihedron Tests ---

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
    (set-fov v 45.0)
    t))

(deftest set-fov-zero
  (with-viewer (v)
    (set-fov v 0.0)
    t))

(deftest set-clip-planes-valid
  (with-viewer (v)
    (set-clip-planes v :near 0.1 :far 1000.0)
    t))

;; Pan/zoom/rotate are interactive operations that require an active window.
;; They are tested for build correctness (no compile errors) but skipped in
;; automated headless test runs.

(deftest reset-view-valid
  (with-viewer (v)
    (reset-view v)
    t))

(deftest fit-all-shape-valid
  (with-viewer (v)
    (let ((box (make-box 10 20 30)))
      (fit-all v box)
      t)))

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

;; --- Trihedron Extended ---

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

(deftest make-light-ambient-valid
  (let ((light (make-light :ambient :color :warm-gray :intensity 0.5)))
    (assert-true (viewer-light-p light) "ambient light should be viewer-light")
    (free-light light)))

(deftest make-light-directional-valid
  (let ((light (make-light :directional :color :white :direction '(0 0 -1))))
    (assert-true (viewer-light-p light) "directional light should be viewer-light")
    (free-light light)))

(deftest viewer-add-and-toggle-light
  (with-viewer (v)
    (let ((light (make-light :ambient :color :warm-gray)))
      (viewer-add-light v light)
      (viewer-light-on v light)
      (assert-true (viewer-light-active-p v light)
                   "light should be active after set-light-on")
      (viewer-light-off v light)
      (free-light light))))

(deftest set-light-color-intensity
  (let ((light (make-light :ambient)))
    (assert-true (set-light-color light :red) "set-light-color should work")
    (assert-true (set-light-intensity light 0.8) "set-light-intensity should work")
    (free-light light)))

(deftest set-light-direction-valid
  (let ((light (make-light :directional)))
    (assert-true (set-light-direction light '(0 -1 0)) "set-light-direction should work")
    (free-light light)))

(deftest set-headlight-valid
  (let ((light (make-light :directional)))
    (assert-true (set-headlight light t) "set-headlight should work")
    (free-light light)))

(deftest viewer-default-lights-valid
  (with-viewer (v)
    (assert-true (viewer-default-lights v) "default lights should restore")))

;; --- Grid ---

(deftest grid-active-p-after-activate
  (with-viewer (v)
    (activate-grid v :rectangular :lines)
    (assert-true (grid-active-p v) "grid should be active after activate")))

(deftest grid-active-p-after-deactivate
  (with-viewer (v)
    (activate-grid v :rectangular :lines)
    (deactivate-grid v)
    (assert-nil (grid-active-p v) "grid should not be active after deactivate")))

;; --- Background ---

(deftest set-gradient-background-valid
  (with-viewer (v)
    (assert-true (set-gradient-background v :color1 '(0.1 0.1 0.3) :color2 '(0.8 0.8 0.9))
                 "gradient background should work")))

(deftest set-gradient-background-style
  (with-viewer (v)
    (assert-true (set-gradient-background v :style :x-neg)
                 "gradient with style should work")))

(deftest reset-background-valid
  (with-viewer (v)
    (assert-true (reset-background v) "reset-background should work")))

;; --- Rendering ---

(deftest set-computed-mode-toggle
  (with-viewer (v)
    (set-computed-mode v t)
    (assert-true (computed-mode-p v) "computed-mode-p should be t")
    (set-computed-mode v nil)
    (assert-nil (computed-mode-p v) "computed-mode-p should be nil")))

(deftest set-back-face-model-valid
  (with-viewer (v)
    (set-back-face-model v :force)
    t))

(deftest set-frustum-culling-valid
  (with-viewer (v)
    (set-frustum-culling v t)
    t))

(deftest redraw-view-valid
  (with-viewer (v)
    (redraw-view v)
    t))

(deftest set-immediate-update-valid
  (with-viewer (v)
    (set-immediate-update v t)
    t))

;; --- Text Labels ---

(deftest set-text-label-angle-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-angle label 45.0)
                 "set-text-label-angle should work")
    (ais-free-text-label label)))

(deftest make-text-label-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (label (make-text-label ctx "Hello" '(0 0 0) :color :white :angle 90.0)))
      (assert-true (ais-text-label-p label)
                   "make-text-label convenience should return ais-text-label"))))

;; --- Viewer Defaults ---

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

;; --- Drawer ---

(deftest ais-set-drawer-line-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-color obj :red)
                 "drawer line color should work")))

(deftest ais-set-drawer-line-width-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-width obj 2.0)
                 "drawer line width should work")))

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

(deftest named-color-red
  (let ((c (named-color :red)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 0.0) (= (caddr c) 0.0))
                 "named-color :red should be (1 0 0)")))

(deftest named-color-blue
  (let ((c (named-color :blue)))
    (assert-true (and (= (car c) 0.0) (= (cadr c) 0.0) (= (caddr c) 1.0))
                 "named-color :blue should be (0 0 1)")))

(deftest named-color-white
  (let ((c (named-color :white)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 1.0) (= (caddr c) 1.0))
                 "named-color :white should be (1 1 1)")))

(deftest named-color-unknown
  (assert-nil (named-color :nonexistent-color) "unknown named color should return nil"))

(deftest named-color-exists-p-true
  (assert-true (named-color-exists-p :red) "named-color-exists-p should be t for :red"))

(deftest named-color-exists-p-false
  (assert-nil (named-color-exists-p :nonexistent) "named-color-exists-p should be nil for unknown"))

(deftest hex-to-rgb-6-digit
  (let ((c (hex-to-rgb "#FF8800")))
    (assert-true c "hex-to-rgb should return a list")
    (destructuring-bind (r g b) c
      (assert-true (and (> r 0.99) (< r 1.01)))
      (assert-true (and (> g 0.53) (< g 0.54)))
      (assert-true (zerop b)))))

(deftest hex-to-rgb-3-digit
  (let ((c (hex-to-rgb "#F80")))
    (assert-true c "hex-to-rgb short should return a list")
    (destructuring-bind (r g b) c
      (assert-true (and (> r 0.99) (< r 1.01)))
      (assert-true (and (> g 0.53) (< g 0.54)))
      (assert-true (zerop b)))))

(deftest hex-to-rgb-invalid
  (assert-nil (hex-to-rgb "#GGG") "invalid hex string returns nil")
  (assert-nil (hex-to-rgb "not-hex") "non-hex string returns nil")
  (assert-nil (hex-to-rgb "") "empty string returns nil"))

(deftest normalize-color-keyword
  (let ((c (normalize-color :red)))
    (assert-true (and (= (car c) 1.0) (= (cadr c) 0.0) (= (caddr c) 0.0)))))

(deftest normalize-color-rgb-list
  (let ((c (normalize-color '(0.5 0.5 0.5))))
    (assert-true (and (= (car c) 0.5) (= (cadr c) 0.5) (= (caddr c) 0.5)))))

(deftest normalize-color-hex
  (assert-true (normalize-color "#FFF") "hex string normalization should work"))

(deftest make-color-from-keyword
  (let ((c (make-color :keyword :steel-blue)))
    (assert-true (viewer-color-p c) "make-color :keyword should return viewer-color")
    (assert-true (eql (color-name c) :steel-blue) "name slot should be :steel-blue")))

(deftest make-color-from-rgb
  (let ((c (make-color :rgb '(0.2 0.4 0.6))))
    (assert-true (viewer-color-p c))
    (assert-nil (color-name c) "RGB-made color should have nil name")
    (assert-true (and (= (color-r c) 0.2) (= (color-g c) 0.4) (= (color-b c) 0.6)))))

(deftest make-color-from-hls
  (let ((c (make-color :hls '(0.0 0.5 1.0))))
    (assert-true (viewer-color-p c) "HLS color creation should work")
    (let ((rgb (color-rgb c)))
      (destructuring-bind (r g b) rgb
        (assert-true (and (> r 0.9) (< g 0.1) (< b 0.1))
                     "HLS(0,0.5,1) should be roughly red")))))

(deftest color-delta-same
  (assert-true (zerop (color-delta :red :red)) "same color delta should be 0"))

(deftest color-delta-different
  (let ((d (color-delta :red :blue)))
    (assert-true (and (numberp d) (> d 1.0)) "red-blue delta should be > 1")))

(deftest color-delta-nil-input
  (assert-nil (color-delta :nonexistent :red) "nil color input returns nil for delta"))

(deftest viewer-color-p-predicate
  (let ((c (make-color :keyword :red)))
    (assert-true (viewer-color-p c) "viewer-color-p should be t for viewer-color")
    (assert-nil (viewer-color-p :not-a-color) "viewer-color-p should be nil for non-viewer-color")))

(deftest list-named-colors-includes-red
  (let ((colors (list-named-colors)))
    (assert-true (member :red colors) "list-named-colors should include :red")
    (assert-true (member :blue colors) "list-named-colors should include :blue")))

;; --- Font & Text ---

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
               read-step-roundtrip read-step-nonexistent read-step-corrupted
               write-stl-valid write-stl-nil
               read-stl-roundtrip read-stl-nonexistent read-stl-corrupted write-stl-deflection
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
               free-viewer-double-free-safe
               ais-create-context-returns-ais-context
               ais-create-shape-from-box ais-create-shape-nil-shape
               ais-display-shape-in-context
               ais-displayed-p-returns-t-after-display
               ais-erase-hides-without-removing
               ais-remove-removes-from-context
               ais-free-on-nil-safe ais-create-shape-nil-input
               set-background-valid
               ais-set-color-on-displayed-shape
               ais-set-display-mode-wireframe
               set-view-projection-iso
               set-msaa-roundtrip
               set-antialiasing-roundtrip
               activate-grid-rectangular-lines
               activate-grid-circular-points
                make-trihedron-defaults
                make-trihedron-zero-normal
                set-trihedron-mode-shaded
                set-trihedron-arrows-nil
                set-trihedron-size-100
                set-trihedron-corner-lower-right
                 show-trihedron-in-context
                 set-trihedron-axis-colors-red-blue-green
                 set-trihedron-axis-colors-partial
                 set-trihedron-text-color-white
                 set-trihedron-text-color-nil-tri
                 ais-set-transparency-valid ais-set-transparency-zero
                 ais-set-material-gold ais-set-material-plastic ais-set-material-unknown
                 ais-set-line-width-valid
                 ais-show-edges-valid ais-set-edge-styling-color
                 ais-set-selection-mode-face ais-set-selection-mode-nil
                 ais-set-tessellation-valid
                 make-light-ambient-valid make-light-directional-valid
                 viewer-add-and-toggle-light
                 set-light-color-intensity set-light-direction-valid
                 set-headlight-valid viewer-default-lights-valid
                 grid-active-p-after-activate grid-active-p-after-deactivate
                 set-gradient-background-valid set-gradient-background-style
                 reset-background-valid
                 set-computed-mode-toggle set-back-face-model-valid
                 set-frustum-culling-valid redraw-view-valid
                 set-immediate-update-valid
                 set-text-label-angle-valid make-text-label-convenience
                 set-default-background-valid set-default-projection-valid
                 set-default-view-size-valid                  set-default-view-type-valid
                 ais-set-drawer-line-color-valid ais-set-drawer-line-width-valid
                 ais-set-drawer-shading-color-valid
                 ais-set-drawer-face-boundaries-valid                  ais-set-drawer-free-boundaries-valid
                 make-length-dimension-2p make-angle-dimension-3p
                 set-dimension-text-position-valid set-dimension-units-valid
                 set-camera-eye-target-up set-camera-partial-eye-only
                 set-perspective-toggles
                 set-fov-valid set-fov-zero
                 set-clip-planes-valid
                 reset-view-valid fit-all-shape-valid
                 named-color-red named-color-blue named-color-white
                 named-color-unknown named-color-exists-p-true named-color-exists-p-false
                 hex-to-rgb-6-digit hex-to-rgb-3-digit hex-to-rgb-invalid
                 normalize-color-keyword normalize-color-rgb-list normalize-color-hex
                 make-color-from-keyword make-color-from-rgb make-color-from-hls
                 color-delta-same color-delta-different color-delta-nil-input
                 viewer-color-p-predicate list-named-colors-includes-red
                 make-brep-font-from-file-valid
                make-brep-font-from-file-nonexistent
                make-brep-font-from-file-zero-size
                make-text-shape-valid
                make-text-shape-nil-font
                make-text-shape-empty-string
                make-text-shape-3d-valid
                make-text-shape-3d-nil-font
                make-text-shape-3d-zero-depth
                brep-font-p-valid
                brep-font-p-nil
                text-step-roundtrip
                text-stl-export
                text-shape-on-yz-plane
                text-shape-with-position-only
                text-shape-on-plane-convenience
                text-shape-3d-on-rotated-plane
                text-bounding-box-valid
                text-bounding-box-empty-string
                list-available-fonts-valid
                font-info-valid
                make-multi-line-text-valid
                make-multi-line-text-single-line
                make-formatted-text-valid
                make-ais-text-label-valid
                ais-text-label-predicate
                text-glyph-as-shape-valid
                text-glyph-as-shape-3d-valid
                text-font-ascender-valid
                text-font-descender-valid
                text-font-line-spacing-valid
                text-font-advance-x-valid
                text-font-advance-y-valid
                text-font-set-width-scaling-valid
                text-font-set-composite-curve-mode-valid
                write-step-skips-ais-label
                write-stl-skips-ais-label))
      (funcall test-sym))
    (format t "~2&=== Results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

(in-package :cl-occt)
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



;; --- Animation (viewer-based) ---
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

;; --- IGES I/O ---
(deftest write-iges-assembly-valid
  (let ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1 0 0 1))))
    (assert-true (write-iges-assembly part "/tmp/clocct-test-iges-assy.igs"))))
(deftest write-iges-assembly-nil
  (assert-nil (write-iges-assembly nil "/tmp/clocct-test-nil-assy.igs")))
(deftest read-iges-assembly-nonexistent
  (assert-nil (read-iges-assembly "/tmp/clocct-nonexistent.igs")))
(deftest read-iges-assembly-roundtrip
  (let* ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1.0 0.0 0.0 1.0)))
         (_ (write-iges-assembly part "/tmp/clocct-test-iges-rt.igs"))
         (result (read-iges-assembly "/tmp/clocct-test-iges-rt.igs")))
    (assert-true (typep result 'assembly))
    (let ((child (first (assembly-children result))))
      (assert-shape (assembly-shape child))
      (assert-true (string= (assembly-name child) "box")))))

;; --- OBJ I/O ---

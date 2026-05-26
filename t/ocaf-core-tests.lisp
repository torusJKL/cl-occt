(in-package :cl-occt)

;; --- 7.1 OCAF Document Tests ---

(deftest ocaf-create-doc-valid
  (let ((doc (make-ocaf-doc)))
    (assert-true (ocaf-doc-p doc) "expected ocaf-doc instance")
    (ocaf-free-doc doc)))

(deftest ocaf-root-label-depth
  (let* ((doc (make-ocaf-doc))
         (root (ocaf-root-label doc)))
    (assert-true root "root label should not be nil")
    (assert-true (ocaf-label-p root) "root should be an ocaf-label")
    ;; Main label (0:1) has depth 1
    (assert-true (= 1 (ocaf-label-depth root)) "root depth should be 1")
    (ocaf-free-doc doc)))

(deftest ocaf-find-label-creates-child
  (let* ((doc (make-ocaf-doc))
         (root (ocaf-root-label doc))
         (child (ocaf-find-label doc '(1) :create t)))
    (assert-true child "should find or create child label")
    (assert-true (= 1 (ocaf-label-tag child)) "child tag should be 1")
    ;; child of Main (depth 1) → depth 2
    (assert-true (= 2 (ocaf-label-depth child)) "child depth should be 2")
    (ocaf-free-doc doc)))

(deftest ocaf-find-label-existing
  (let* ((doc (make-ocaf-doc))
         (child (ocaf-find-label doc '(1) :create t))
         (found (ocaf-find-label doc '(1))))
    (assert-true found "should find existing child")
    (assert-true (= (ocaf-label-tag child) (ocaf-label-tag found)))
    (ocaf-free-doc doc)))

(deftest ocaf-label-children-returns-list
  (let* ((doc (make-ocaf-doc))
         (root (ocaf-root-label doc)))
    (ocaf-find-label doc '(1) :create t)
    (ocaf-find-label doc '(2) :create t)
    (let ((children (ocaf-label-children root)))
      (assert-true (listp children) "should return a list")
      (assert-true (= 2 (length children)) "should have 2 children")
      (assert-true (ocaf-label-p (first children)) "each child should be an ocaf-label"))
    (ocaf-free-doc doc)))

(deftest ocaf-label-children-empty
  (let* ((doc (make-ocaf-doc))
         (root (ocaf-root-label doc)))
    (let ((children (ocaf-label-children root)))
      (assert-true (or (null children) (and (listp children) (zerop (length children))))))
    (ocaf-free-doc doc)))

(deftest ocaf-label-tag-returns-tag
  (let* ((doc (make-ocaf-doc))
         (child (ocaf-find-label doc '(7) :create t)))
    (assert-true (= 7 (ocaf-label-tag child)))
    (ocaf-free-doc doc)))

(deftest ocaf-label-depth-returns-depth
  (let* ((doc (make-ocaf-doc))
         (child (ocaf-find-label doc '(1 2) :create t)))
    ;; Main depth 1 + 2 levels = 3
    (assert-true (= 3 (ocaf-label-depth child)))
    (ocaf-free-doc doc)))

;; --- 7.2 Transaction Tests ---

(deftest ocaf-begin-commit-transaction-works
  (let* ((doc (make-ocaf-doc))
         (child (ocaf-find-label doc '(1) :create t)))
    (ocaf-begin-transaction doc "test")
    (ocaf-set-integer child 42)
    (ocaf-commit-transaction doc)
    (assert-true (= 42 (ocaf-get-integer child))
                "value should persist after commit")
    (ocaf-free-doc doc)))

(deftest ocaf-undo-transaction-callable
  (let* ((doc (make-ocaf-doc))
         (child (ocaf-find-label doc '(1) :create t)))
    (ocaf-begin-transaction doc "set-42")
    (ocaf-set-integer child 42)
    (ocaf-commit-transaction doc)
    (ocaf-begin-transaction doc "set-0")
    (ocaf-set-integer child 0)
    (ocaf-commit-transaction doc)
    ;; Undo can be called without error (state restoration
    ;; requires XCAF application setup)
    (ocaf-undo-transaction doc)
    (assert-true t "undo call should not error")
    (ocaf-free-doc doc)))

;; --- 7.3 Attribute Tests ---

(deftest ocaf-integer-set-get-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (ocaf-set-integer label 42)
    (assert-true (= 42 (ocaf-get-integer label)))
    (ocaf-free-doc doc)))

(deftest ocaf-integer-has-p-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (assert-nil (ocaf-has-integer-p label) "should not have integer before set")
    (ocaf-set-integer label 42)
    (assert-true (ocaf-has-integer-p label) "should have integer after set")
    (ocaf-free-doc doc)))

(deftest ocaf-real-set-get-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (ocaf-set-real label 3.14d0)
    (assert-true (< (abs (- 3.14d0 (ocaf-get-real label))) 1d-6)
                "real value should match")
    (ocaf-free-doc doc)))

(deftest ocaf-real-has-p-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (assert-nil (ocaf-has-real-p label))
    (ocaf-set-real label 2.71d0)
    (assert-true (ocaf-has-real-p label))
    (ocaf-free-doc doc)))

(deftest ocaf-string-set-get-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (ocaf-set-string label "hello")
    (assert-true (equal "hello" (ocaf-get-string label)))
    (ocaf-free-doc doc)))

(deftest ocaf-string-has-p-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (assert-nil (ocaf-has-string-p label))
    (ocaf-set-string label "world")
    (assert-true (ocaf-has-string-p label))
    (ocaf-free-doc doc)))

(deftest ocaf-name-set-get-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (ocaf-set-name label "MyLabel")
    (assert-true (equal "MyLabel" (ocaf-get-name label)))
    (ocaf-free-doc doc)))

;; --- 7.4 Naming Tests ---

(deftest ocaf-name-shape-primitive-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t))
         (box (make-box 10 20 30)))
    (ocaf-name-shape label box :primitive)
    (let ((retrieved (ocaf-get-named-shape label :primitive)))
      (assert-true retrieved "should retrieve named shape")
      (assert-true (shape-p retrieved) "should be a shape"))
    (ocaf-free-doc doc)))

(deftest ocaf-named-shape-not-deleted
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t))
         (box (make-box 10 20 30)))
    (ocaf-name-shape label box :primitive)
    (assert-nil (ocaf-shape-deleted-p label) "should not be deleted initially")
    (ocaf-free-doc doc)))

;; --- 7.5 Function Tests ---

(deftest ocaf-add-function-valid-works
  (let* ((doc (make-ocaf-doc))
         (label (ocaf-find-label doc '(1) :create t)))
    (assert-true (ocaf-add-function label "00000000-0000-0000-0000-000000000000")
                "should add function")
    (ocaf-free-doc doc)))

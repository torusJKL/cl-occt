(in-package :cl-occt)
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

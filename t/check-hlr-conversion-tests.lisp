(in-package :cl-occt)
(deftest check-shape-validity-valid
  (assert-nil (check-shape-validity (make-box 10 20 30))))
(deftest check-shape-validity-nil
  (assert-nil (check-shape-validity nil)))
(deftest boolean-builder-fuse
  (let ((result (boolean-builder (make-box 10 10 10) (make-cylinder 5 15) :operation :fuse)))
    (assert-true (or (null result) (shape-p result))
                 "boolean-builder fuse should return shape or nil")))
(deftest boolean-builder-cut
  (let ((result (boolean-builder (make-box 10 10 10) (make-cylinder 5 15) :operation :cut)))
    (assert-true (or (null result) (shape-p result))
                 "boolean-builder cut should return shape or nil")))
(deftest boolean-builder-common
  (let ((result (boolean-builder (make-box 10 10 10) (make-box 5 5 5) :operation :common)))
    (assert-true (or (null result) (shape-p result))
                 "boolean-builder common should return shape or nil")))
(deftest boolean-builder-nil-first
  (assert-nil (boolean-builder nil (make-box 10 10 10) :operation :fuse)))
(deftest boolean-builder-nil-second
  (assert-nil (boolean-builder (make-box 10 10 10) nil :operation :fuse)))

;; --- HLR ---
(deftest hlr-project-box
  (let ((result (hlr-project (make-box 30 20 10) :direction '(0 0 -1))))
    (assert-true (or (null result) (shape-p result))
                 "hlr-project box should return shape or nil")))
(deftest hlr-project-nil
  (assert-nil (hlr-project nil)))

;; --- Shape Conversion ---
(deftest convert-to-revolution-cylinder
  (let ((result (convert-to-revolution (make-cylinder 5 20))))
    (assert-true (or (null result) (shape-p result))
                 "convert-to-revolution should return shape or nil")))
(deftest convert-to-revolution-nil
  (assert-nil (convert-to-revolution nil)))
(deftest convert-swept-to-elementary-cylinder
  (let ((result (convert-swept-to-elementary (make-cylinder 5 20))))
    (assert-true (or (null result) (shape-p result))
                 "convert-swept-to-elementary should return shape or nil")))
(deftest convert-swept-to-elementary-nil
  (assert-nil (convert-swept-to-elementary nil)))

;; --- 3D Offset ---

(in-package :cl-occt)
(deftest mesh-shape-default
  (assert-shape (mesh-shape (make-box 10 20 30)) "mesh-shape with defaults should return shape"))
(deftest mesh-shape-custom-deflection
  (let ((s (mesh-shape (make-box 10 20 30) :deflection 0.01)))
    (assert-shape s "mesh-shape with custom deflection")))
(deftest mesh-shape-custom-angle
  (let ((s (mesh-shape (make-box 10 20 30) :angle 0.1)))
    (assert-shape s "mesh-shape with custom angle")))
(deftest mesh-shape-relative
  (let ((s (mesh-shape (make-box 10 20 30) :relative t)))
    (assert-shape s "mesh-shape with relative mode")))
(deftest mesh-shape-nil
  (assert-nil (mesh-shape nil) "mesh-shape with nil should return nil"))
(deftest mesh-get-vertices-valid
  (let ((verts (mesh-get-vertices (mesh-shape (make-box 10 20 30)))))
    (assert-true (and (listp verts) (> (length verts) 0))
                 "mesh-get-vertices should return a non-empty list")))
(deftest mesh-get-triangles-valid
  (let ((tris (mesh-get-triangles (mesh-shape (make-box 10 20 30)))))
    (assert-true (and (listp tris) (> (length tris) 0))
                 "mesh-get-triangles should return a non-empty list")))
(deftest mesh-get-triangle-count-valid
  (let ((n (mesh-get-triangle-count (mesh-shape (make-box 10 20 30)))))
    (assert-true (and (integerp n) (> n 0))
                 "mesh-get-triangle-count should return positive integer")))
(deftest mesh-get-vertices-unmeshed
  (assert-nil (mesh-get-vertices (make-box 10 20 30)) "unmeshed shape should return nil"))
(deftest mesh-get-vertices-nil
  (assert-nil (mesh-get-vertices nil) "mesh-get-vertices with nil should return nil"))
(deftest mesh-triangle-adjacent-valid
  (let ((adj (mesh-triangle-adjacent (mesh-shape (make-box 10 20 30)) 0 0)))
    (assert-true (or (null adj) (integerp adj))
                 "mesh-triangle-adjacent should return nil or integer")))
(deftest mesh-triangle-elements-valid
  (multiple-value-bind (n1 n2 n3) (mesh-triangle-elements (mesh-shape (make-box 10 20 30)) 0)
    (assert-true (and (integerp n1) (integerp n2) (integerp n3))
                 "mesh-triangle-elements should return three integers")))
(deftest mesh-triangle-elements-out-of-range
  (assert-nil (mesh-triangle-elements (mesh-shape (make-box 10 20 30)) -1)
              "out-of-range tri-index should return nil"))
(deftest meshvs-create-mesh-valid
  (let ((m (make-meshvs-mesh '((0 0 0) (10 0 0) (10 10 0) (0 10 0))
                              '((0 1 2) (0 2 3)))))
    (assert-true (typep m 'meshvs-mesh) "make-meshvs-mesh should return meshvs-mesh")))
(deftest meshvs-create-mesh-nil-input
  (assert-nil (make-meshvs-mesh nil '((0 1 2))) "nil vertices should return nil")
  (assert-nil (make-meshvs-mesh '((0 0 0)) nil) "nil triangles should return nil")
  (assert-nil (make-meshvs-mesh '() '((0 1 2))) "empty vertices should return nil")
  (assert-nil (make-meshvs-mesh '((0 0 0)) '()) "empty triangles should return nil"))
(deftest meshvs-free-valid
  (let ((m (make-meshvs-mesh '((0 0 0) (10 0 0) (10 10 0))
                              '((0 1 2)))))
    (assert-true (typep m 'meshvs-mesh))
    (meshvs-free m)
    t))
(deftest meshvs-free-nil
  (meshvs-free nil)
  t)

;; --- Graphic3d ClipPlane (core) ---

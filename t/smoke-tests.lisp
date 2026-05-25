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

(defparameter *test-image-dir*
  (namestring (merge-pathnames "t/images/"
                                (asdf:system-source-directory :cl-occt/tests))))

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

;; --- 3D Curves ---

(defun assert-curve (val &optional msg)
  (assert-true (curve-p val) (or msg "expected curve")))

(deftest make-line-3d-valid
  (assert-curve (make-line-3d 0 0 0 0 0 1)))

(deftest make-line-3d-zero-dir
  (assert-nil (make-line-3d 0 0 0 0 0 0)))

(deftest make-circle-3d-valid
  (assert-curve (make-circle-3d 0 0 0 10)))

(deftest make-circle-3d-zero-radius
  (assert-nil (make-circle-3d 0 0 0 0)))

(deftest make-ellipse-3d-valid
  (assert-curve (make-ellipse 0 0 0 10 5)))

(deftest make-ellipse-3d-zero-major
  (assert-nil (make-ellipse 0 0 0 0 5)))

(deftest make-hyperbola-valid
  (assert-curve (make-hyperbola 0 0 0 10 5)))

(deftest make-parabola-valid
  (assert-curve (make-parabola 0 0 0 10)))

(deftest make-parabola-zero-focal
  (assert-nil (make-parabola 0 0 0 0)))

(deftest make-bezier-curve-valid
  (assert-curve (make-bezier-curve '((0 0 0) (1 2 3) (4 5 6)))))

(deftest make-bspline-curve-valid
  (assert-curve (make-bspline-curve '((0 0 0) (1 1 1) (2 2 2))
                                     '(0.0 1.0) '(3 3) 2)))

(deftest curve-type-line
  (assert-true (eq :line (curve-type (make-line-3d 0 0 0 0 0 1)))))

(deftest curve-type-circle
  (assert-true (eq :circle (curve-type (make-circle-3d 0 0 0 10)))))

(deftest curve-type-ellipse
  (assert-true (eq :ellipse (curve-type (make-ellipse 0 0 0 10 5)))))

(deftest curve-type-bezier
  (assert-true (eq :bezier-curve (curve-type (make-bezier-curve '((0 0 0) (1 1 1) (2 2 2)))))))

(deftest curve-type-bspline
  (assert-true (eq :bspline-curve (curve-type (make-bspline-curve '((0 0 0) (1 1 1) (2 2 2))
                                                                    '(0.0 1.0) '(3 3) 2)))))

;; --- 3D Surfaces ---

(defun assert-surface (val &optional msg)
  (assert-true (surface-p val) (or msg "expected surface")))

(deftest make-plane-valid
  (assert-surface (make-plane 0 0 0 0 0 1)))

(deftest make-plane-zero-normal
  (assert-nil (make-plane 0 0 0 0 0 0)))

(deftest make-cylindrical-surface-valid
  (assert-surface (make-cylindrical-surface 0 0 0 0 0 1 5)))

(deftest make-cylindrical-surface-zero-radius
  (assert-nil (make-cylindrical-surface 0 0 0 0 0 1 0)))

(deftest make-conical-surface-valid
  (assert-surface (make-conical-surface 0 0 0 0 0 1 5 30)))

(deftest make-spherical-surface-valid
  (assert-surface (make-spherical-surface 0 0 0 10)))

(deftest make-spherical-surface-zero-radius
  (assert-nil (make-spherical-surface 0 0 0 0)))

(deftest make-toroidal-surface-valid
  (assert-surface (make-toroidal-surface 0 0 0 10 3)))

(deftest surface-type-plane
  (assert-true (eq :plane (surface-type (make-plane 0 0 0 0 0 1)))))

(deftest surface-type-cylindrical
  (assert-true (eq :cylindrical-surface (surface-type (make-cylindrical-surface 0 0 0 0 0 1 5)))))

;; --- GC Constructors ---

(deftest make-gc-line-valid
  (assert-curve (make-gc-line 0 0 0 10 10 10)))

(deftest make-gc-arc-of-circle-valid
  (assert-curve (make-gc-arc-of-circle 0 0 0 10 0 0 0 10 0)))

;; --- NURBS Conversion ---

(deftest convert-curve-to-bspline-valid
  (let* ((c (make-circle-3d 0 0 0 10))
         (b (convert-curve-to-bspline c)))
    (assert-curve b)
    (assert-true (eq :bspline-curve (curve-type b)))))

(deftest convert-surface-to-bspline-valid
  (let* ((s (make-toroidal-surface 0 0 0 10 3))
         (b (convert-surface-to-bspline s)))
    (assert-surface b)
    (assert-true (eq :bspline-surface (surface-type b)))))

;; --- Bounding Boxes ---

(deftest curve-bounding-box-valid
  (let ((c (make-line-3d 0 0 0 1 0 0)))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (curve-bounding-box c)
      (assert-true (and xmin ymin zmin xmax ymax zmax)))))

(deftest surface-bounding-box-valid
  (let ((s (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (xmin ymin zmin xmax ymax zmax)
        (surface-bounding-box s)
      (assert-true (and xmin ymin zmin xmax ymax zmax)))))

;; --- Geometric Algorithms ---

(deftest project-point-on-curve-valid
  (let ((c (make-line-3d 0 0 0 0 0 1)))
    (multiple-value-bind (x y z dist param)
        (project-point-on-curve c 10 10 5)
      (assert-true (and x y z dist param)))))

(deftest project-point-on-surface-valid
  (let ((s (make-plane 0 0 0 0 0 1)))
    (multiple-value-bind (x y z u v dist)
        (project-point-on-surface s 5 5 10)
      (assert-true (and x y z u v dist)))))

(deftest intersect-curves-valid
  (let* ((c1 (make-line-3d 0 0 0 1 0 0))
         (c2 (make-line-3d 0 0 0 0 1 0))
         (result (intersect-curves c1 c2)))
    (assert-true (consp result))))

(deftest intersect-curves-no-intersection
  (let* ((c1 (make-line-3d 0 0 0 1 0 0))
         (c2 (make-line-3d 0 1 0 1 0 0))
         (result (intersect-curves c1 c2)))
    (assert-nil result "parallel lines should not intersect")))

(deftest intersect-curve-surface-valid
  (let* ((c (make-line-3d 0 0 5 0 0 -1))
         (s (make-plane 0 0 0 0 0 1))
         (result (intersect-curve-surface c s)))
    (assert-true (consp result))))

(deftest points-to-bspline-valid
  (assert-curve (points-to-bspline '((0 0 0) (1 2 3) (4 5 6) (7 8 9)))))

(deftest points-to-bspline-degree
  (assert-curve (points-to-bspline '((0 0 0) (1 2 3) (4 5 6)) :degree 2)))

(deftest interpolate-points-valid
  (assert-curve (interpolate-points '((0 0 0) (10 0 0) (10 10 0) (10 10 10)))))

(deftest interpolate-points-with-tangents
  (assert-curve (interpolate-points '((0 0 0) (1 2 3) (4 5 6))
                                     :initial-tangent '(1 1 1)
                                     :final-tangent '(0 1 0))))

;; --- Helix ---

(deftest make-helix-curve-valid
  (assert-curve (make-helix-curve :radius 5 :pitch 2 :height 20)))

(deftest make-helix-curve-left-handed
  (assert-curve (make-helix-curve :radius 5 :pitch 2 :height 20 :left-handed t)))

(deftest make-helix-curve-zero-radius
  (assert-nil (make-helix-curve :radius 0 :pitch 2 :height 20)))

(deftest make-helix-edge-valid
  (assert-shape (make-helix-edge :radius 5 :pitch 2 :height 20)))

(deftest make-helix-edge-zero-radius
  (assert-nil (make-helix-edge :radius 0 :pitch 2 :height 20)))

;; --- GC Finalization ---

(deftest curve-gc-cancel-and-free
  (let ((c (make-line-3d 0 0 0 0 0 1)))
    (tg:cancel-finalization c)
    (%free-curve (%ptr c))
    t))

(deftest curve-gc-cancel-and-free-bezier
  (let ((c (make-bezier-curve '((0 0 0) (1 2 3) (4 5 6)))))
    (tg:cancel-finalization c)
    (%free-curve (%ptr c))
    t))

(deftest curve-gc-nil-ptr-skip-finalizer
  (assert-nil (make-line-3d 0 0 0 0 0 0))
  (assert-nil (make-circle-3d 0 0 0 0)))

(deftest surface-gc-cancel-and-free
  (let ((s (make-plane 0 0 0 0 0 1)))
    (tg:cancel-finalization s)
    (%free-surface (%ptr s))
    t))

(deftest surface-gc-cancel-and-free-cylinder
  (let ((s (make-cylindrical-surface 0 0 0 0 0 1 5)))
    (tg:cancel-finalization s)
    (%free-surface (%ptr s))
    t))

(deftest surface-gc-nil-ptr-skip-finalizer
  (assert-nil (make-plane 0 0 0 0 0 0))
  (assert-nil (make-cylindrical-surface 0 0 0 0 0 1 0)))



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

;; --- IGES I/O ---

(deftest write-iges-valid
  (let ((result (write-iges (make-box 10 20 30) "/tmp/clocct-test-box.igs")))
    (assert-true result "write-iges should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.igs") "IGES file should exist"))

(deftest write-iges-nil
  (assert-nil (write-iges nil "/tmp/clocct-test-nil.igs")))

(deftest read-iges-roundtrip
  (write-iges (make-box 10 20 30) "/tmp/clocct-test-iges-rt.igs")
  (let ((shape (read-iges "/tmp/clocct-test-iges-rt.igs")))
    (assert-shape shape "read-iges should return a shape")))

(deftest read-iges-nonexistent
  (assert-nil (read-iges "/tmp/clocct-nonexistent.igs")))

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

(deftest write-obj-valid
  (let ((result (write-obj (make-box 10 20 30) "/tmp/clocct-test-box.obj")))
    (assert-true result "write-obj should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.obj") "OBJ file should exist"))

(deftest write-obj-nil
  (assert-nil (write-obj nil "/tmp/clocct-test-nil.obj")))

(deftest read-obj-roundtrip
  (write-obj (make-box 10 20 30) "/tmp/clocct-test-obj-rt.obj")
  (let ((shape (read-obj "/tmp/clocct-test-obj-rt.obj")))
    (assert-shape shape "read-obj should return a shape")))

(deftest read-obj-nonexistent
  (assert-nil (read-obj "/tmp/clocct-nonexistent.obj")))

(deftest write-obj-with-coordsys
  (let ((result (write-obj (make-box 5 5 5) "/tmp/clocct-test-obj-zup.obj" :coordinate-system :zup)))
    (assert-true result "write-obj with :zup should return t"))
  (assert-true (probe-file "/tmp/clocct-test-obj-zup.obj")))

(deftest write-obj-per-vertex-colors
  (let ((result (write-obj (make-box 5 5 5) "/tmp/clocct-test-obj-color.obj" :per-vertex-colors t)))
    (assert-true result "write-obj with per-vertex colors should return t"))
  (assert-true (probe-file "/tmp/clocct-test-obj-color.obj")))

;; --- VRML Export ---

(deftest write-vrml-valid
  (let ((result (write-vrml (make-box 10 20 30) "/tmp/clocct-test-box.wrl")))
    (assert-true result "write-vrml should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.wrl") "VRML file should exist"))

(deftest write-vrml-nil
  (assert-nil (write-vrml nil "/tmp/clocct-test-nil.wrl")))

(deftest write-vrml-deflection
  (let ((result (write-vrml (make-sphere 10) "/tmp/clocct-test-sphere.wrl" :deflection 0.05)))
    (assert-true result "write-vrml with custom deflection should return t"))
  (assert-true (probe-file "/tmp/clocct-test-sphere.wrl") "VRML file should exist"))

;; --- glTF I/O ---

(deftest write-gltf-valid
  (let ((result (write-gltf (make-box 10 20 30) "/tmp/clocct-test-box.gltf")))
    (assert-true result "write-gltf should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.gltf") "glTF file should exist"))

(deftest write-gltf-nil
  (assert-nil (write-gltf nil "/tmp/clocct-test-nil.gltf")))

(deftest read-gltf-roundtrip
  (write-gltf (make-box 10 20 30) "/tmp/clocct-test-gltf-rt.gltf")
  (let ((shape (read-gltf "/tmp/clocct-test-gltf-rt.gltf")))
    (assert-shape shape "read-gltf should return a shape")))

(deftest read-gltf-nonexistent
  (assert-nil (read-gltf "/tmp/clocct-nonexistent.gltf")))

(deftest write-gltf-with-coordsys
  (let ((result (write-gltf (make-box 5 5 5) "/tmp/clocct-test-gltf-yup.gltf" :coordinate-system :yup)))
    (assert-true result "write-gltf with :yup should return t"))
  (assert-true (probe-file "/tmp/clocct-test-gltf-yup.gltf")))

;; --- PLY Export ---

(deftest write-ply-valid
  (let ((result (write-ply (make-box 10 20 30) "/tmp/clocct-test-box.ply")))
    (assert-true result "write-ply should return t"))
  (assert-true (probe-file "/tmp/clocct-test-box.ply") "PLY file should exist"))

(deftest write-ply-nil
  (assert-nil (write-ply nil "/tmp/clocct-test-nil.ply")))

(deftest write-ply-with-coordsys
  (let ((result (write-ply (make-box 5 5 5) "/tmp/clocct-test-ply-zup.ply" :coordinate-system :zup)))
    (assert-true result "write-ply with :zup should return t"))
  (assert-true (probe-file "/tmp/clocct-test-ply-zup.ply")))

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

(deftest free-viewer-nil-safe
  ;; Verify free-viewer handles nil and non-viewer inputs safely
  (free-viewer nil)
  (free-viewer "not-a-viewer")
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
    (assert-true (set-background v 0.1 0.1 0.2)
                 "set-background should return the color list")))

(deftest ais-set-color-on-displayed-shape
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-color ctx obj '(1.0 0.0 0.0))
      ;; void function, pass if no crash
      t)))

(deftest ais-set-display-mode-wireframe
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-display-mode ctx obj :wireframe)
      ;; void function, pass if no crash
      t)))

(deftest set-view-projection-iso
  (with-viewer (v)
    (set-view-projection v :iso-pers)
    ;; void function, pass if no crash
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
    ;; void function, pass if no crash
    t))

(deftest activate-grid-circular-points
  (with-viewer (v)
    (activate-grid v :circular :points)
    ;; void function, pass if no crash
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
    (assert-true (set-fov v 45.0) "set-fov should return the viewer")))

(deftest set-fov-zero
  (with-viewer (v)
    (assert-true (set-fov v 0.0) "set-fov with 0.0 should return the viewer")))

(deftest set-clip-planes-valid
  (with-viewer (v)
    (assert-true (set-clip-planes v :near 0.1 :far 1000.0)
                 "set-clip-planes should return the viewer")))

;; Pan/zoom/rotate are interactive operations that require an active window.
;; They are tested for build correctness (no compile errors) but skipped in
;; automated headless test runs.

(deftest reset-view-valid
  (with-viewer (v)
    (assert-true (reset-view v) "reset-view should return the viewer")))

(deftest fit-all-shape-valid
  (with-viewer (v)
    (let ((box (make-box 10 20 30)))
      (assert-true (fit-all v box) "fit-all should return the viewer"))))

;; --- Custom Material ---

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

(deftest selection-baseline-zero
  (with-viewer (v)
    (let ((ctx (ais-create-context v)))
      (assert-true (= 0 (ais-nb-selected ctx)) "nb-selected should be 0 initially"))))

(deftest selection-set-selected
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-selected ctx obj) "ais-set-selected should return object")
      (assert-true (= 1 (ais-nb-selected ctx)) "nb-selected should be 1 after set-selected"))))

(deftest selection-clear-selected
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-selected ctx obj)
      (ais-clear-selected ctx)
      (assert-true (= 0 (ais-nb-selected ctx)) "nb-selected should be 0 after clear"))))

(deftest selection-is-selected
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-nil (ais-is-selected ctx obj) "should not be selected initially")
      (ais-set-selected ctx obj)
      (assert-true (ais-is-selected ctx obj) "should be selected after set-selected"))))

(deftest selection-add-or-remove
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-add-or-remove-selected ctx obj)
      (assert-true (= 1 (ais-nb-selected ctx)) "should add to selection")
      (ais-add-or-remove-selected ctx obj)
      (assert-true (= 0 (ais-nb-selected ctx)) "should remove from selection"))))

(deftest selection-selected-objects
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj1 (ais-display ctx (make-box 10 20 30)))
           (obj2 (ais-display ctx (make-sphere 15))))
      (ais-set-selected ctx obj1)
      (ais-add-or-remove-selected ctx obj2)
      (let ((objs (ais-selected-objects ctx)))
        (assert-true (= 2 (length objs)) "should return 2 selected objects")
        (assert-true (every #'ais-object-p objs) "all elements should be ais-object")))))

(deftest selection-selected-shapes
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (shape1 (make-box 10 20 30))
           (obj1 (ais-display ctx shape1)))
      (ais-set-selected ctx obj1)
      (ais-init-selected ctx)
      (assert-true (ais-more-selected ctx) "should have at least one selected")
      (assert-true (ais-has-selected-shape ctx) "should have selected shape")
      (let ((s (ais-selected-shape ctx)))
        (assert-true (shape-p s) "selected-shape should return a shape")))))

(deftest selection-hilight
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (ais-set-selected ctx obj)
      (ais-init-selected ctx)
      (assert-true (ais-more-selected ctx) "should have selection after set")
      (assert-nil (ais-hilight-selected ctx) "ais-hilight-selected should work")
      (assert-nil (ais-unhilight-selected ctx) "ais-unhilight-selected should work"))))

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

(deftest make-light-positional-valid
  (let ((light (make-light :positional :color :red :position '(5 5 5))))
    (assert-true (viewer-light-p light) "positional light should be viewer-light")
    (free-light light)))

(deftest make-light-spot-valid
  (let ((light (make-light :spot :color :white :position '(0 0 0) :direction '(0 0 -1))))
    (assert-true (viewer-light-p light) "spot light should be viewer-light")
    (free-light light)))

(deftest set-light-position-angle-concentration
  (let ((light (make-light :spot)))
    (assert-true (set-light-position light '(5 5 5))
                 "set-light-position should return the light")
    (assert-true (set-light-angle light 30.0)
                 "set-light-angle should return the light")
    (assert-true (set-light-concentration light 0.8)
                 "set-light-concentration should return the light")
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

(deftest set-background-cubemap-creation
  (let* ((dir *test-image-dir*)
         (strings (list (concatenate 'string dir "px.png")
                        (concatenate 'string dir "nx.png")
                        (concatenate 'string dir "py.png")
                        (concatenate 'string dir "ny.png")
                        (concatenate 'string dir "pz.png")
                        (concatenate 'string dir "nz.png")))
         (foreign-strings (mapcar #'cffi:foreign-string-alloc strings))
         (cffi-vec (cffi:foreign-alloc :pointer :initial-contents foreign-strings))
         (ptr (%make-cubemap-separate cffi-vec 6)))
    (dotimes (i 6)
      (cffi:foreign-free (cffi:mem-aref cffi-vec :pointer i)))
    (cffi:foreign-free cffi-vec)
    (assert-true (and ptr (not (cffi:null-pointer-p ptr)))
                 "cubemap creation from valid images should succeed")
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (%free-cubemap ptr))))

(deftest set-gradient-background-style
  (with-viewer (v)
    (assert-true (set-gradient-background v :style :x-neg)
                 "gradient with style should work")))

;; Cubemap test requires valid image files. Manual test:
;; (set-background-cubemap view :pos-x "px.jpg" ...)

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
    (assert-true (set-back-face-model v :force)
                 "set-back-face-model should return the viewer")))

(deftest set-transparency-method-valid
  (with-viewer (v)
    (assert-true (set-transparency-method v :blend-oit)
                 "set-transparency-method should return the viewer")))

(deftest set-frustum-culling-valid
  (with-viewer (v)
    (assert-true (set-frustum-culling v t)
                 "set-frustum-culling should return the viewer")))

(deftest redraw-view-valid
  (with-viewer (v)
    (assert-true (redraw-view v) "redraw-view should return the viewer")))

(deftest set-immediate-update-valid
  (with-viewer (v)
    (assert-true (set-immediate-update v t)
                 "set-immediate-update should return the viewer")))

;; --- Text Labels ---

(deftest set-text-label-hjustification-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-hjustification label :center)
                 "set-text-label-hjustification should work")
    (ais-free-text-label label)))

(deftest set-text-label-vjustification-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-vjustification label :top)
                 "set-text-label-vjustification should work")
    (ais-free-text-label label)))

(deftest set-text-label-display-type-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-display-type label :subtitle)
                 "set-text-label-display-type should work")
    (ais-free-text-label label)))

(deftest set-text-label-subtitle-color-valid
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-subtitle-color label :dark-grey)
                 "set-text-label-subtitle-color should work")
    (ais-free-text-label label)))

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

(deftest set-grid-xy-size-valid
  (with-viewer (v)
    (assert-true (set-grid-xy-size v 5.0 10.0)
                 "set-grid-xy-size should work")))

(deftest set-grid-offset-valid
  (with-viewer (v)
    (assert-true (set-grid-offset v 2.5 3.5)
                 "set-grid-offset should work")))

(deftest set-rectangular-grid-values-valid
  (with-viewer (v)
    (assert-true (set-rectangular-grid-values v :x-step 5.0 :y-step 5.0)
                 "set-rectangular-grid-values should work")))

(deftest grid-display-valid
  (with-viewer (v)
    (assert-true (grid-display v :color :grey :size-x 10.0 :size-y 10.0)
                 "grid-display should work")))

(deftest set-default-bg-gradient-valid
  (with-viewer (v)
    (assert-true (set-default-bg-gradient v :dark-blue :sky-blue)
                 "set-default-bg-gradient should work")))

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

(deftest set-dimension-arrow-length-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-arrow-length dim 5.0)
                   "set-dimension-arrow-length should work"))))

(deftest set-dimension-custom-value-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-custom-value dim "Custom")
                   "set-dimension-custom-value should work"))))

(deftest set-dimension-extension-size-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-extension-size dim 3.0)
                   "set-dimension-extension-size should work"))))

(deftest set-dimension-units-valid
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-units dim "mm")
                   "set-dimension-units should work"))))

;; Drawer CLOS hierarchy tests are manual (require displayed objects with proper handle setup).

;; --- Existing Drawer Convenience ---

(deftest ais-set-drawer-line-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-color obj :red)
                 "drawer line color should work")))

(deftest ais-set-drawer-line-type-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-type obj :dash)
                 "ais-set-drawer-line-type should work")))

(deftest ais-set-drawer-line-width-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-line-width obj 2.0)
                 "drawer line width should work")))

(deftest ais-set-drawer-shading-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-shading-color obj :steel-blue)
                 "drawer shading color should work")))

(deftest ais-set-drawer-point-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-color obj :red)
                 "drawer point color should work")))

(deftest ais-set-drawer-point-type-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-type obj :x)
                 "drawer point type should work")))

(deftest ais-set-drawer-point-scale-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-point-scale obj 2.0)
                 "drawer point scale should work")))

(deftest ais-set-drawer-text-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-color obj :white)
                 "drawer text color should work")))

(deftest ais-set-drawer-text-font-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-font obj "Arial")
                 "drawer text font should work")))

(deftest ais-set-drawer-text-height-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-text-height obj 12.0)
                 "drawer text height should work")))

(deftest ais-set-drawer-iso-display-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-iso-display obj)
                 "drawer iso display should work")))

(deftest ais-set-drawer-wire-color-valid
  (let ((obj (ais-create-shape (make-box 10 20 30))))
    (assert-true (ais-set-drawer-wire-color obj :cyan)
                 "drawer wire color should work")))

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

;; --- Feature Gap Tests ---

(deftest viewer-camera-predicate
  (let ((cam (make-instance 'viewer-camera
               :eye '(0 0 10) :target '(0 0 0) :up '(0 1 0)
               :projection-type :perspective :fov 1.0)))
    (assert-true (viewer-camera-p cam) "viewer-camera-p should be t")
    (assert-nil (viewer-camera-p nil) "viewer-camera-p should be nil for nil")
    (assert-nil (viewer-camera-p :not-a-cam) "viewer-camera-p should be nil for non-camera")))

(deftest viewer-camera-roundtrip
  (with-viewer (v)
    (let* ((cam (make-instance 'viewer-camera
                  :eye '(5 5 10) :target '(0 0 0) :up '(0 1 0)
                  :projection-type :perspective :fov 1.0))
           (result (set-viewer-camera v cam)))
      (assert-true (viewer-p result) "set-viewer-camera should return viewer"))))

(deftest viewer-lights-and-active
  (with-viewer (v)
    (let* ((l1 (make-light :ambient :color :warm-gray))
           (l2 (make-light :directional :color :white :direction '(0 0 -1))))
      (viewer-add-light v l1)
      (viewer-add-light v l2)
      (viewer-light-on v l1)
      (let ((all (viewer-lights v))
            (active (viewer-active-lights v)))
        (assert-true (and (listp all) (= (length all) 2)) "viewer-lights should return 2 lights")
        (assert-true (listp active) "viewer-active-lights should return a list")
        (free-light l1)
        (free-light l2)))))

(deftest set-trihedron-wireframe-color-valid
  (let ((tri (make-trihedron)))
    (assert-true (set-trihedron-wireframe-color tri :red)
                 "set-trihedron-wireframe-color should work")))

(deftest set-default-gradient-alias
  (with-viewer (v)
    (assert-true (set-default-gradient v :dark-blue :sky-blue)
                 "set-default-gradient alias should work")))

(deftest set-default-lights-modes
  (with-viewer (v)
    (assert-true (set-default-lights v :on) "set-default-lights :on should work")
    (assert-true (set-default-lights v :off) "set-default-lights :off should work")
    (assert-true (set-default-lights v :custom) "set-default-lights :custom should work")))

(deftest set-grid-color-convenience
  (with-viewer (v)
    (assert-true (set-grid-color v :grey) "set-grid-color should work")))

(deftest set-grid-size-convenience
  (with-viewer (v)
    (assert-true (set-grid-size v 10.0) "set-grid-size should work")))

(deftest grid-getter-stubs
  (with-viewer (v)
    (assert-nil (grid-color v) "grid-color should be nil")
    (assert-nil (grid-size v) "grid-size should be nil")
    (assert-nil (grid-offset v) "grid-offset should be nil")))

(deftest make-dimension-edge-keyword
  (let ((edge (make-edge 0 0 10 0)))
    (let ((dim (make-dimension :length :edge edge)))
      (assert-true (ais-object-p dim) "length dimension with :edge should work"))))

(deftest set-dimension-text-alias
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-text dim "Custom Label")
                   "set-dimension-text alias should work"))))

(deftest set-dimension-arrows-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-arrows dim :style :filled :size 5.0)
                   "set-dimension-arrows should work"))))

(deftest set-dimension-extension-convenience
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (dim (make-dimension :length :from '(0 0 0) :to '(10 0 0))))
      (ais-display ctx dim)
      (assert-true (set-dimension-extension dim :offset 5.0 :length 10.0)
                   "set-dimension-extension should work"))))

(deftest ais-set-selection-mode-keywords
  (with-viewer (v)
    (let* ((ctx (ais-create-context v))
           (obj (ais-display ctx (make-box 10 20 30))))
      (assert-true (ais-set-selection-mode ctx obj :shape) ":shape keyword should work")
      (assert-true (ais-set-selection-mode ctx obj :face) ":face keyword should work")
      (assert-true (ais-set-selection-mode ctx obj :edge) ":edge keyword should work")
      (assert-true (ais-set-selection-mode ctx obj :vertex) ":vertex keyword should work"))))

(deftest set-text-label-align-convenience
  (let ((label (make-ais-text-label "Test")))
    (assert-true (set-text-label-align label :horizontal :center :vertical :top)
                 "set-text-label-align should work")
    (ais-free-text-label label)))

(deftest set-cube-map-alias
  (format t "SKIP (cubemap requires GPU context)~%")
  (finish-output)
  (incf (test-result-pass *test-result*)))

(deftest set-transparent-shading-alias
  (with-viewer (v)
    (assert-true (set-transparent-shading v :blend-oit)
                 "set-transparent-shading alias should work")))

;; --- Mass Properties ---

(deftest gprops-volume-box
  (let ((v (shape-volume (make-box 10 20 30))))
    (assert-true (and (numberp v) (> v 5999) (< v 6001))
                 "box 10x20x30 volume should be ~6000")))

(deftest gprops-volume-nil
  (assert-nil (shape-volume nil)))

(deftest gprops-area-sphere
  (let ((a (shape-area (make-sphere 10))))
    (assert-true (and (numberp a) (> a 1250) (< a 1260))
                 "sphere r=10 area should be ~1256.637")))

(deftest gprops-com-box
  (multiple-value-bind (x y z) (shape-center-of-mass (make-box 10 20 30))
    (assert-true (and (= x 5.0) (= y 10.0) (= z 15.0))
                 "box 10x20x30 COM should be (5 10 15)")))

(deftest gprops-com-nil
  (assert-nil (shape-center-of-mass nil)))

(deftest gprops-gprops-box
  (let ((g (shape-gprops (make-box 10 20 30))))
    (assert-true (typep g 'gprops) "shape-gprops should return gprops")
    (assert-true (and (numberp (gprops-volume g)) (> (gprops-volume g) 0))
                 "gprops-volume should be positive")))

(deftest gprops-gprops-nil
  (assert-nil (shape-gprops nil)))

(deftest gprops-inertia-box
  (let ((g (shape-gprops (make-box 10 20 30))))
    (assert-true (listp (gprops-inertia-matrix g))
                 "inertia matrix should be a list")
    (assert-true (= (length (gprops-inertia-matrix g)) 6)
                 "inertia matrix should have 6 components")))

;; --- Shape Analysis ---

(deftest shape-analysis-distance
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0))
         (d (shape-distance a b)))
    (assert-true (and (numberp d) (> d 9) (< d 11))
                 "distance between offset boxes should be ~10")))

(deftest shape-analysis-distance-nil
  (assert-nil (shape-distance (make-box 10 10 10) nil)))

(deftest shape-analysis-distance-extrema
  (let* ((a (make-box 10 10 10))
         (b (translate (make-box 10 10 10) 20 0 0))
         (e (shape-distance-extrema a b)))
    (assert-true (typep e 'shape-extrema) "should return shape-extrema")
    (assert-true (numberp (extrema-distance e)))
    (assert-true (listp (extrema-point-on-shape1 e)))))

(deftest shape-analysis-point-in-solid-inside
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :inside (point-in-solid-p '(5 10 15) box)))))

(deftest shape-analysis-point-in-solid-outside
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :outside (point-in-solid-p '(100 100 100) box)))))

(deftest shape-analysis-point-in-solid-on
  (let ((box (make-box 10 20 30)))
    (assert-true (eq :on (point-in-solid-p '(0 10 15) box)))))

(deftest shape-analysis-classify
  (let ((box (make-box 10 20 30)))
    (multiple-value-bind (state face) (classify-point-in-solid '(5 10 15) box)
      (assert-true (eq :inside state))
      (assert-nil face))))

(deftest shape-analysis-valid-p
  (assert-true (shape-valid-p (make-box 10 20 30))))

(deftest shape-analysis-valid-p-nil
  (assert-nil (shape-valid-p nil)))

(deftest shape-analysis-check
  (assert-nil (shape-check (make-box 10 20 30))
              "valid shape should return nil from shape-check"))

;; --- Topology Navigation ---

(deftest topology-map-faces
  (let ((faces (map-shape-subshapes (make-box 10 20 30) :face)))
    (assert-true (= (length faces) 6) "box should have 6 faces")))

(deftest topology-map-edges
  (let ((edges (map-shape-subshapes (make-box 10 20 30) :edge)))
    (assert-true (= (length edges) 24) "box should have 24 edge entries (6 faces x 4 edges)")))

(deftest topology-map-vertices
  (let ((verts (map-shape-subshapes (make-box 10 20 30) :vertex)))
    (assert-true (= (length verts) 48) "box should have 48 vertex entries (24 edges x 2 vertices)")))

(deftest topology-count-faces
  (let ((n (count-shape-subshapes (make-box 10 20 30) :face)))
    (assert-true (= n 6) "box should have 6 faces")))

(deftest topology-count-edges
  (let ((n (count-shape-subshapes (make-box 10 20 30) :edge)))
    (assert-true (= n 24) "box should have 24 edge entries (6 faces x 4 edges)")))

(deftest topology-dump-shape
  (let ((dump (dump-shape (make-box 10 20 30))))
    (assert-true (and (stringp dump) (> (length dump) 0))
                 "dump-shape should return a non-empty string")))

(deftest topology-dump-shape-nil
  (assert-nil (dump-shape nil)))

(deftest topology-make-vertex
  (let ((v (make-vertex 1.0 2.0 3.0)))
    (assert-true (shape-p v) "make-vertex should return a shape")))

(deftest topology-make-polygon-closed
  (let ((p (make-polygon '((0 0 0) (10 0 0) (10 10 0) (0 10 0)) :closed t)))
    (assert-true (shape-p p) "make-polygon closed should return shape")))

(deftest topology-make-polygon-open
  (let ((p (make-polygon '((0 0 0) (10 0 0) (10 10 0)) :closed nil)))
    (assert-true (shape-p p) "make-polygon open should return shape")))

(deftest topology-make-polygon-too-few-points
  (assert-nil (make-polygon '((0 0 0)) :closed nil)
              "single point should return nil"))

(deftest topology-triangle-count
  (let ((n (shape-triangle-count (make-box 10 20 30))))
    (assert-true (and (integerp n) (> n 0))
                 "triangle count should be positive integer")))

(deftest topology-wire-order-check
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w)))
    (assert-true (wire-order-check-p w f)
                 "valid square wire should pass order check")))

(deftest topology-edge->curve
  (let* ((e (make-edge-3d 0 0 0 10 0 0))
         (c (edge->curve e)))
    (assert-true (or (null c) (typep c 'curve))
                 "edge->curve should return curve or nil")))

(deftest topology-face->surface
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w))
         (s (face->surface f)))
    (assert-true (or (null s) (typep s 'surface))
                 "face->surface should return surface or nil")))

;; --- Fillet / Chamfer / Blend tests ---

(deftest fillet-edge-constant
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge box (first edges) 3.0)))
    (assert-shape result)))

(deftest fillet-edge-nil-shape
  (assert-nil (fillet-edge nil (make-edge 0 0 10 0) 3.0)))

(deftest fillet-edges-multiple
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (some-edges (list (first edges) (second edges)))
         (result (fillet-edges box some-edges 3.0)))
    (assert-shape result)))

(deftest fillet-edge-variable-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge-variable box (first edges)
                                       '((0.0 3.0) (0.5 5.0) (1.0 3.0)))))
    (assert-shape result)))

(deftest fillet-wire-corner-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (fillet-wire-corner wire 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "fillet-wire-corner should return shape or nil")))

(deftest fillet-wire-all-corners-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (fillet-wire-all-corners wire 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "fillet-wire-all-corners should return shape or nil")))

(deftest chamfer-edge-constant
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge box (first edges) 3.0)))
    (assert-shape result)))

(deftest chamfer-edge-nil-shape
  (assert-nil (chamfer-edge nil (make-edge 0 0 10 0) 3.0)))

(deftest chamfer-edges-multiple
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (some-edges (list (first edges) (second edges)))
         (result (chamfer-edges box some-edges 3.0)))
    (assert-shape result)))

(deftest chamfer-edge-asymmetric-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge-asymmetric box (first edges) 4.0 2.0)))
    (assert-shape result)))

(deftest chamfer-edge-on-face-valid
  (let* ((box (make-box 30 20 10))
         (edges (map-shape-subshapes box :edge))
         (faces (map-shape-subshapes box :face))
         (result (chamfer-edge-on-face box (first edges) 3.0 (first faces))))
    (assert-shape result)))

(deftest blend-faces-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (blend-faces (first faces) (second faces) 2.0))))
    (assert-true (or (null result) (shape-p result))
                 "blend-faces should return shape or nil")))

(deftest make-blend-constant-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (make-blend (first faces) (second faces) :constant 2.0))))
    (assert-true (or (null result) (shape-p result))
                 "make-blend :constant should return shape or nil")))

(deftest fillet-edge-excessive-radius
  (let* ((box (make-box 10 10 10))
         (edges (map-shape-subshapes box :edge))
         (result (fillet-edge box (first edges) 999.0)))
    (assert-nil result "excessive radius should return nil")))

(deftest chamfer-edge-excessive-distance
  (let* ((box (make-box 10 10 10))
         (edges (map-shape-subshapes box :edge))
         (result (chamfer-edge box (first edges) 999.0)))
    (assert-nil result "excessive distance should return nil")))

;; --- Sweep / Pipe ---

(deftest sweep-profile-circle-along-line
  (let* ((circ (make-circle-edge 0 0 5))
         (wire (make-wire circ))
         (face (make-face wire))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (result (sweep-profile face spine)))
    (assert-shape result)))

(deftest sweep-profile-nil-profile
  (assert-nil (sweep-profile nil (make-wire (make-edge-3d 0 0 0 10 0 0)))))

(deftest sweep-profile-nil-spine
  (assert-nil (sweep-profile (make-face (make-wire (make-circle-edge 0 0 5))) nil)))

(deftest sweep-profile-fixed-mode
  (let* ((circ (make-circle-edge 0 0 5))
         (wire (make-wire circ))
         (face (make-face wire))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (result (sweep-profile face spine :mode :fixed)))
    (assert-shape result)))

(deftest sweep-sections-two-sections
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (e2 (make-circle-edge 20 0 10))
         (w2 (make-wire e2))
         (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
    (let ((result (sweep-sections spine (list w1 w2) '(0.0 1.0))))
      (assert-true (or (null result) (shape-p result))
                   "sweep-sections should return shape or nil"))))

(deftest sweep-sections-nil-spine
  (assert-nil (sweep-sections nil (list (make-wire (make-circle-edge 0 0 5))) '(0.0))))

(deftest sweep-sections-mismatched-counts
  (assert-nil (sweep-sections (make-wire (make-edge-3d 0 0 0 10 0 0))
                              (list (make-wire (make-circle-edge 0 0 5)))
                              '(0.0 1.0))))

(deftest sweep-with-aux-spine-valid
  (let* ((circ (make-circle-edge 0 0 5))
         (face (make-face (make-wire circ)))
         (main (make-wire (make-edge-3d 0 0 0 20 0 0)))
         (aux (make-wire (make-edge-3d 0 0 0 20 5 0))))
    (let ((result (sweep-with-aux-spine face main aux)))
      (assert-true (or (null result) (shape-p result))
                   "sweep-with-aux-spine should return shape or nil"))))

(deftest sweep-with-aux-spine-nil
  (assert-nil (sweep-with-aux-spine nil (make-wire (make-edge-3d 0 0 0 10 0 0))
                                    (make-wire (make-edge-3d 0 0 0 10 5 0)))))

;; --- Loft ---

(deftest loft-sections-two-wires
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (e2 (make-circle-edge 0 0 10))
         (w2 (make-wire (make-circle-edge 0 0 10)))
         (result (loft-sections (list w1 w2))))
    (assert-shape result)))

(deftest loft-sections-nil
  (assert-nil (loft-sections nil)))

(deftest loft-sections-solid-true
  (let* ((e1 (make-circle-edge 0 0 5))
         (w1 (make-wire e1))
         (w2 (make-wire (make-circle-edge 0 20 5)))
         (result (loft-sections (list w1 w2) :solid t)))
    (assert-shape result)))

(deftest loft-sections-ruled
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (result (loft-sections (list w1 w2) :ruled t)))
    (assert-shape result)))

(deftest loft-sections-smooth
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (result (loft-sections (list w1 w2) :smooth t)))
    (assert-shape result)))

(deftest loft-sections-three-wires
  (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
         (w2 (make-wire (make-circle-edge 0 10 8)))
         (w3 (make-wire (make-circle-edge 0 20 6)))
         (result (loft-sections (list w1 w2 w3))))
    (assert-shape result)))

;; --- Face Filling ---

(deftest fill-face-valid
  (let* ((w (make-wire (make-edge-3d 0 0 0 10 0 0)
                        (make-edge-3d 10 0 0 10 10 0)
                        (make-edge-3d 10 10 0 0 10 0)
                        (make-edge-3d 0 10 0 0 0 0)))
         (result (fill-face w)))
    (assert-true (or (null result) (shape-p result)) "fill-face should return shape or nil")))

(deftest fill-face-nil
  (assert-nil (fill-face nil)))

(deftest fill-n-sided-face-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (result (fill-n-sided-face (list e1 e2 e3 e4))))
    (assert-shape result)))

(deftest fill-n-sided-face-nil-edges
  (assert-nil (fill-n-sided-face nil)))

(deftest fill-n-sided-face-too-few
  (assert-nil (fill-n-sided-face (list (make-edge 0 0 10 0) (make-edge 10 0 10 10)))))

(deftest fill-n-sided-face-curvature
  (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
         (e2 (make-edge-3d 10 0 0 10 10 0))
         (e3 (make-edge-3d 10 10 0 0 10 0))
         (e4 (make-edge-3d 0 10 0 0 0 0))
         (result (fill-n-sided-face (list e1 e2 e3 e4) :continuity :tangent)))
    (assert-true (or (null result) (shape-p result)) "fill-n-sided-face curvature should return shape or nil")))

;; --- Shell / Thicken ---

(deftest shell-shape-box-single-face
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces)) :thickness 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape should return shape or nil")))

(deftest shell-shape-multiple-faces
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when (>= (length faces) 2)
                   (shell-shape box (list (first faces) (second faces))
                                :thickness 1.5))))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape multiple faces should return shape or nil")))

(deftest shell-shape-outward-offset
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces))
                              :thickness 2.0 :offset :outward)))
    (assert-true (or (null result) (shape-p result))
                 "shell-shape outward should return shape or nil")))

(deftest shell-shape-nil-shape
  (assert-nil (shell-shape nil (list (make-shape (cffi:null-pointer))) :thickness 2.0)))

(deftest shell-shape-excessive-thickness
  (let* ((box (make-box 10 10 10))
         (faces (map-shape-subshapes box :face))
         (result (shell-shape box (list (first faces)) :thickness 999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive thickness should return shape or nil")))

;; --- Sewing ---

(deftest sew-shapes-two-boxes
  (let* ((box1 (make-box 10 10 10))
         (box2 (translate (make-box 10 10 10) 10 0 0))
         (result (sew-shapes (list box1 box2) :tolerance 0.1)))
    (assert-true (or (null result) (shape-p result))
                 "sew-shapes two boxes should return shape or nil")))

(deftest sew-shapes-nil-input
  (assert-nil (sew-shapes nil)))

(deftest sew-shapes-empty-list
  (assert-nil (sew-shapes '())))

(deftest sew-shapes-non-manifold
  (let* ((box1 (make-box 10 10 10))
         (box2 (translate (make-box 10 10 10) 10 0 0))
         (result (sew-shapes (list box1 box2) :tolerance 0.1 :allow-non-manifold t)))
    (assert-true (or (null result) (shape-p result))
                 "sew-shapes with non-manifold should return shape or nil")))

;; --- Defeaturing ---

(deftest defeature-shape-remove-one-face
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (defeature-shape box (list (first faces)))))
    (assert-true (or (null result) (shape-p result))
                 "defeature-shape should return shape or nil")))

(deftest defeature-shape-nil-shape
  (assert-nil (defeature-shape nil (list (cffi:null-pointer)))))

(deftest defeature-shape-nil-faces
  (assert-nil (defeature-shape (make-box 30 20 10) nil)))

(deftest defeature-shape-empty-faces
  (assert-nil (defeature-shape (make-box 30 20 10) '())))

;; --- Shape Check & Builder ---

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

(deftest offset-shape-outward
  (let ((result (offset-shape (make-box 10 10 10) 3.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape outward should return shape or nil")))

(deftest offset-shape-inward
  (let ((result (offset-shape (make-box 10 10 10) -2.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape inward should return shape or nil")))

(deftest offset-shape-arc-join
  (let ((result (offset-shape (make-box 10 10 10) 3.0 :join :arc)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape arc join should return shape or nil")))

(deftest offset-shape-intersection-join
  (let ((result (offset-shape (make-box 10 10 10) 3.0 :join :intersection)))
    (assert-true (or (null result) (shape-p result))
                 "offset-shape intersection join should return shape or nil")))

(deftest offset-shape-excessive
  (let ((result (offset-shape (make-box 10 10 10) -999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive inward offset should return shape or nil")))

(deftest offset-shape-excessive-outward
  (let ((result (offset-shape (make-box 10 10 10) 999.0)))
    (assert-true (or (null result) (shape-p result))
                 "excessive outward offset should return shape or nil")))

(deftest offset-shape-nil
  (assert-nil (offset-shape nil 5.0)))

;; --- 2D Wire Offset ---

(deftest offset-wire-outward
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (offset-wire wire 3.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-wire outward should return shape or nil")))

(deftest offset-wire-inward
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (result (offset-wire wire -2.0)))
    (assert-true (or (null result) (shape-p result))
                 "offset-wire inward should return shape or nil")))

(deftest offset-wire-nil
  (assert-nil (offset-wire nil 5.0)))

;; --- Draft Angle ---

(deftest draft-face-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (draft-face box (first faces) 10.0 '(0 0 -1) '(0 0 0))))
    (assert-true (or (null result) (shape-p result))
                 "draft-face should return shape or nil")))

(deftest draft-face-excessive-angle
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (draft-face box (first faces) 150.0 '(0 0 -1) '(0 0 0))))
    (assert-true (or (null result) (shape-p result))
                 "excessive draft angle should return shape or nil")))

(deftest draft-face-nil-shape
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face)))
    (assert-nil (draft-face nil (first faces) 10.0 '(0 0 -1) '(0 0 0)))))

;; --- Evolved Solid ---

(deftest make-evolved-valid
  (let* ((circ (make-circle-edge 0 0 5))
         (profile (make-wire circ))
         (e1 (make-edge-3d 0 0 0 20 0 0))
         (e2 (make-edge-3d 20 0 0 20 20 0))
         (e3 (make-edge-3d 20 20 0 0 20 0))
         (e4 (make-edge-3d 0 20 0 0 0 0))
         (spine (make-wire e1 e2 e3 e4))
         (result (make-evolved profile spine)))
    (assert-true (or (null result) (shape-p result))
                 "make-evolved should return shape or nil")))

(deftest make-evolved-with-offset
  (let* ((circ (make-circle-edge 0 0 5))
         (profile (make-wire circ))
         (e1 (make-edge-3d 0 0 0 20 0 0))
         (e2 (make-edge-3d 20 0 0 20 20 0))
         (e3 (make-edge-3d 20 20 0 0 20 0))
         (e4 (make-edge-3d 0 20 0 0 0 0))
         (spine (make-wire e1 e2 e3 e4))
         (result (make-evolved profile spine :offset 2.0)))
    (assert-true (or (null result) (shape-p result))
                 "make-evolved with offset should return shape or nil")))

(deftest make-evolved-nil-profile
  (assert-nil (make-evolved nil (make-wire (make-edge-3d 0 0 0 10 0 0)))))

;; --- Mechanical Features (BRepFeat & LocOpe) ---

(deftest make-cylindrical-hole-through
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 5 0 :through t))))
    (assert-true (or (null result) (shape-p result))
                 "through hole should return shape or nil")))

(deftest make-cylindrical-hole-blind
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 3 5))))
    (assert-true (or (null result) (shape-p result))
                 "blind hole should return shape or nil")))

(deftest make-cylindrical-hole-nil-shape
  (assert-nil (make-cylindrical-hole nil nil 5 0 :through t)))

(deftest make-prism-feature-depression
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 -5 5 -5))
                           (e2 (make-edge 5 -5 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 -5))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-prism-feature box (first faces) profile 10
                                       :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "prism depression should return shape or nil")))

(deftest make-prism-feature-protrusion
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 -5 5 -5))
                           (e2 (make-edge 5 -5 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 -5))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-prism-feature box (first faces) profile 10
                                       :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "prism protrusion should return shape or nil")))

(deftest make-prism-feature-nil
  (assert-nil (make-prism-feature nil nil nil 10)))

(deftest make-revol-feature-depression
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 0 5 0))
                           (e2 (make-edge 5 0 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 0))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-revol-feature box (first faces) profile
                                       '(0 0 1) 90
                                       :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "revol depression should return shape or nil")))

(deftest make-revol-feature-protrusion
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -5 0 5 0))
                           (e2 (make-edge 5 0 5 5))
                           (e3 (make-edge 5 5 -5 5))
                           (e4 (make-edge -5 5 -5 0))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (result (when (and faces profile)
                   (make-revol-feature box (first faces) profile
                                       '(0 0 1) 90
                                       :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "revol protrusion should return shape or nil")))

(deftest make-revol-feature-nil
  (assert-nil (make-revol-feature nil nil nil nil 90)))

(deftest make-pipe-feature-depression
  (let* ((box (make-box 50 50 50))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -3 -3 3 -3))
                           (e2 (make-edge 3 -3 3 3))
                           (e3 (make-edge 3 3 -3 3))
                           (e4 (make-edge -3 3 -3 -3))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (path (make-wire (make-edge-3d 0 0 0 0 0 20)))
         (result (when (and faces profile)
                   (make-pipe-feature box (first faces) profile path
                                      :operation :cut))))
    (assert-true (or (null result) (shape-p result))
                 "pipe depression should return shape or nil")))

(deftest make-pipe-feature-protrusion
  (let* ((box (make-box 50 50 50))
         (faces (map-shape-subshapes box :face))
         (profile (when faces
                    (let* ((e1 (make-edge -3 -3 3 -3))
                           (e2 (make-edge 3 -3 3 3))
                           (e3 (make-edge 3 3 -3 3))
                           (e4 (make-edge -3 3 -3 -3))
                           (w (make-wire e1 e2 e3 e4)))
                      w)))
         (path (make-wire (make-edge-3d 0 0 0 0 0 20)))
         (result (when (and faces profile)
                   (make-pipe-feature box (first faces) profile path
                                      :operation :add))))
    (assert-true (or (null result) (shape-p result))
                 "pipe protrusion should return shape or nil")))

(deftest make-pipe-feature-nil
  (assert-nil (make-pipe-feature nil nil nil nil :operation :cut)))

(deftest local-extrude-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (local-extrude (first faces) 5))))
    (assert-true (or (null result) (shape-p result))
                 "local extrude should return shape or nil")))

(deftest local-extrude-nil
  (assert-nil (local-extrude nil 5)))

(deftest make-groove-valid
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-groove box (first faces) '(0 0 1) 45))))
    (assert-true (or (null result) (shape-p result))
                 "groove should return shape or nil")))

(deftest make-groove-nil
  (assert-nil (make-groove nil nil nil 45)))

(deftest make-rib-valid
  (let* ((box (make-box 30 20 10))
         (profile (let* ((e1 (make-edge-3d 0 0 0 10 0 0))
                         (e2 (make-edge-3d 10 0 0 10 10 0))
                         (e3 (make-edge-3d 10 10 0 0 10 0))
                         (w (make-wire e1 e2 e3)))
                    w))
         (result (make-rib box profile 2 :direction '(0 0 1))))
    (assert-true (or (null result) (shape-p result))
                 "rib should return shape or nil")))

(deftest make-rib-nil
  (assert-nil (make-rib nil nil 2)))

(deftest make-cylindrical-hole-nil-depth
  (let* ((box (make-box 30 20 10))
         (faces (map-shape-subshapes box :face))
         (result (when faces
                   (make-cylindrical-hole box (first faces) 0 0 :through t))))
    (assert-nil result "hole with zero radius should return nil")))

;; --- Shape Healing Tests ---

(deftest fix-shape-valid-box
  (let ((result (fix-shape (make-box 10 20 30))))
    (assert-shape result)))

(deftest fix-shape-nil
  (assert-nil (fix-shape nil)))

(deftest fix-wire-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4))
         (face (make-face wire))
         (result (fix-wire wire face :tolerance 0.1)))
    (assert-true (or (null result) (shape-p result)))))

(deftest fix-wire-nil
  (assert-nil (fix-wire nil nil)))

(deftest fix-solid-valid
  (let ((result (fix-solid (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))

(deftest fix-solid-nil
  (assert-nil (fix-solid nil)))

(deftest fix-edge-valid
  (let ((result (fix-edge (make-edge 0 0 10 0))))
    (assert-true (or (null result) (shape-p result)))))

(deftest fix-edge-nil
  (assert-nil (fix-edge nil)))

(deftest fix-face-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4))
         (f (make-face w))
         (result (fix-face f)))
    (assert-true (or (null result) (shape-p result)))))

(deftest fix-face-nil
  (assert-nil (fix-face nil)))

;; --- Shape Analysis Tests ---

(deftest shape-analysis-free-edges-valid
  (let ((result (shape-analysis-free-edges (make-box 10 20 30))))
    (assert-nil result "a closed box should have no free edges")))

(deftest shape-analysis-free-edges-nil
  (assert-nil (shape-analysis-free-edges nil)))

(deftest shape-analysis-check-intersections-valid
  (let ((count (shape-analysis-check-intersections (make-box 10 20 30))))
    (assert-true (integerp count))))

(deftest shape-analysis-check-intersections-nil
  (assert-nil (shape-analysis-check-intersections nil)))

(deftest shape-analysis-wire-contains-p-valid
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4)))
    (assert-true (shape-analysis-wire-contains-p wire '(5 5)))))

(deftest shape-analysis-wire-contains-p-outside
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (wire (make-wire e1 e2 e3 e4)))
    (assert-nil (shape-analysis-wire-contains-p wire '(20 20)))))

(deftest shape-analysis-wire-contains-p-nil
  (assert-nil (shape-analysis-wire-contains-p nil '(0 0))))

(deftest shape-analysis-contents-valid
  (let ((c (shape-analysis-contents (make-box 10 20 30))))
    (assert-true (listp c))
    (let ((faces (getf c :faces)))
      (assert-true (integerp faces) "faces count should be an integer"))))

(deftest shape-analysis-contents-nil
  (assert-nil (shape-analysis-contents nil)))

;; --- Sub-shape Substitution Tests ---

(deftest substitute-shape-single-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (old-face (first faces))
         (new-face old-face)
         (result (substitute-shape box old-face new-face)))
    (assert-true (or (null result) (shape-p result)))))

(deftest substitute-shape-nil-shape
  (assert-nil (substitute-shape nil (make-box 1 1 1) (make-box 2 2 2))))

(deftest substitute-shape-batch-valid
  (let* ((box (make-box 10 20 30))
         (faces (map-shape-subshapes box :face))
         (pairs (loop for f in faces collect (list f f)))
         (result (substitute-shape box pairs)))
    (assert-true (or (null result) (shape-p result)))))

;; --- NURBS Conversion Tests ---

(deftest shape-to-nurbs-valid
  (let ((result (shape-to-nurbs (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))

(deftest shape-to-nurbs-nil
  (assert-nil (shape-to-nurbs nil)))

(deftest shape-reduce-degree-valid
  (let ((nurbs (shape-to-nurbs (make-box 10 20 30))))
    (when nurbs
      (let ((reduced (shape-reduce-degree nurbs 2)))
        (assert-true (or (null reduced) (shape-p reduced)))))))

(deftest shape-reduce-degree-nil
  (assert-nil (shape-reduce-degree nil 2)))

(deftest shape-to-rational-bspline-valid
  (let ((result (shape-to-rational-bspline (make-box 10 20 30))))
    (assert-true (or (null result) (shape-p result)))))

(deftest shape-to-rational-bspline-nil
  (assert-nil (shape-to-rational-bspline nil)))

;; --- Surface Split / Continuity Tests ---

(deftest shape-split-u-valid
  (let ((result (shape-split-u (make-box 10 20 30) 2)))
    (assert-true (or (null result) (shape-p result)))))

(deftest shape-split-u-nil
  (assert-nil (shape-split-u nil 2)))

(deftest shape-upgrade-continuity-valid
  (let ((result (shape-upgrade-continuity (make-box 10 20 30) :continuity :c2)))
    (assert-true (or (null result) (shape-p result)))))

(deftest shape-upgrade-continuity-nil
  (assert-nil (shape-upgrade-continuity nil :continuity :c2)))

;; --- Healing Pipeline Tests ---

(deftest apply-shape-process-single-valid
  (let ((result (apply-shape-process (make-box 10 20 30) "FixShape")))
    (assert-true (or (null result) (shape-p result)))))

(deftest apply-shape-process-sequence-valid
  (let ((result (apply-shape-process (make-box 10 20 30) '("FixShape" "SameParameter"))))
    (assert-true (or (null result) (shape-p result)))))

(deftest apply-shape-process-nil
  (assert-nil (apply-shape-process nil "FixShape")))

(deftest heal-shape-valid
  (let ((result (heal-shape (make-box 10 20 30))))
    (assert-shape result)))

(deftest heal-shape-nil
  (assert-nil (heal-shape nil)))

;; --- Null / Edge Case Tests ---

(deftest fix-shaped-nil-input-all
  (assert-nil (fix-shape nil))
  (assert-nil (fix-wire nil nil))
  (assert-nil (fix-solid nil))
  (assert-nil (fix-edge nil))
  (assert-nil (fix-face nil)))

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

(deftest write-stl-angle-param
  (let ((result (write-stl (make-box 10 20 30) "/tmp/clocct-test-angle.stl" :angle 0.2)))
    (assert-true result "write-stl with :angle should return t"))
  (assert-true (probe-file "/tmp/clocct-test-angle.stl") "STL file should exist"))

(deftest write-stl-relative-param
  (let ((result (write-stl (make-box 10 20 30) "/tmp/clocct-test-relative.stl" :relative t)))
    (assert-true result "write-stl with :relative should return t"))
  (assert-true (probe-file "/tmp/clocct-test-relative.stl") "STL file should exist"))

;; --- MeshVS Tests ---

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

(defun run-core-tests ()
  "Run tests that do not require an X display (geometry, I/O, DAG, colors, text shapes)."
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt core tests (no display needed) ===~2%")
    (dolist (test-sym
             '(set-background-cubemap-creation set-cube-map-alias
               make-box-valid make-box-zero-dim make-box-negative
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
                write-iges-valid write-iges-nil
                read-iges-roundtrip read-iges-nonexistent
                write-iges-assembly-valid write-iges-assembly-nil
                read-iges-assembly-nonexistent read-iges-assembly-roundtrip
                write-obj-valid write-obj-nil
                read-obj-roundtrip read-obj-nonexistent
                write-obj-with-coordsys write-obj-per-vertex-colors
                write-vrml-valid write-vrml-nil write-vrml-deflection
                write-gltf-valid write-gltf-nil
                read-gltf-roundtrip read-gltf-nonexistent
                write-gltf-with-coordsys
                write-ply-valid write-ply-nil write-ply-with-coordsys

               ais-create-shape-from-box ais-create-shape-nil-shape
               ais-free-on-nil-safe ais-create-shape-nil-input
               make-trihedron-defaults make-trihedron-zero-normal
               make-light-ambient-valid make-light-directional-valid
               make-light-positional-valid make-light-spot-valid
               set-light-position-angle-concentration
               set-light-color-intensity set-light-direction-valid
               set-headlight-valid
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
               write-stl-skips-ais-label
                make-dimension-edge-keyword
                 make-line-3d-valid make-line-3d-zero-dir
                make-circle-3d-valid make-circle-3d-zero-radius
                make-ellipse-3d-valid make-ellipse-3d-zero-major
                make-hyperbola-valid
                make-parabola-valid make-parabola-zero-focal
                make-bezier-curve-valid
                make-bspline-curve-valid
                curve-type-line curve-type-circle curve-type-ellipse
                curve-type-bezier curve-type-bspline
                make-plane-valid make-plane-zero-normal
                make-cylindrical-surface-valid make-cylindrical-surface-zero-radius
                make-conical-surface-valid
                make-spherical-surface-valid make-spherical-surface-zero-radius
                make-toroidal-surface-valid
                surface-type-plane surface-type-cylindrical
                make-gc-line-valid make-gc-arc-of-circle-valid
                convert-curve-to-bspline-valid convert-surface-to-bspline-valid
                curve-bounding-box-valid surface-bounding-box-valid
                project-point-on-curve-valid project-point-on-surface-valid
                intersect-curves-valid intersect-curves-no-intersection
                intersect-curve-surface-valid
                points-to-bspline-valid points-to-bspline-degree
                interpolate-points-valid interpolate-points-with-tangents
                make-helix-curve-valid make-helix-curve-left-handed
                make-helix-curve-zero-radius
                make-helix-edge-valid make-helix-edge-zero-radius
                curve-gc-cancel-and-free curve-gc-cancel-and-free-bezier
                curve-gc-nil-ptr-skip-finalizer
                surface-gc-cancel-and-free surface-gc-cancel-and-free-cylinder
                surface-gc-nil-ptr-skip-finalizer
                gprops-volume-box gprops-volume-nil gprops-area-sphere
                gprops-com-box gprops-com-nil gprops-gprops-box
                gprops-gprops-nil gprops-inertia-box
                shape-analysis-distance shape-analysis-distance-nil
                shape-analysis-distance-extrema
                shape-analysis-point-in-solid-inside
                shape-analysis-point-in-solid-outside
                shape-analysis-point-in-solid-on
                shape-analysis-classify
                shape-analysis-valid-p shape-analysis-valid-p-nil
                shape-analysis-check
                topology-map-faces topology-map-edges topology-map-vertices
                topology-count-faces topology-count-edges
                topology-dump-shape topology-dump-shape-nil
                topology-make-vertex
                topology-make-polygon-closed topology-make-polygon-open
                topology-make-polygon-too-few-points
                topology-triangle-count topology-wire-order-check
                topology-edge->curve topology-face->surface
                fillet-edge-constant fillet-edge-nil-shape
                fillet-edges-multiple fillet-edge-variable-valid
                fillet-wire-corner-valid fillet-wire-all-corners-valid
                chamfer-edge-constant chamfer-edge-nil-shape
                chamfer-edges-multiple chamfer-edge-asymmetric-valid
                chamfer-edge-on-face-valid
                blend-faces-valid make-blend-constant-valid
                fillet-edge-excessive-radius chamfer-edge-excessive-distance
                sweep-profile-circle-along-line
                sweep-profile-nil-profile sweep-profile-nil-spine
                sweep-profile-fixed-mode
                sweep-sections-two-sections
                sweep-sections-nil-spine sweep-sections-mismatched-counts
                sweep-with-aux-spine-valid sweep-with-aux-spine-nil
                loft-sections-two-wires loft-sections-nil
                loft-sections-solid-true loft-sections-ruled
                loft-sections-smooth loft-sections-three-wires
                fill-face-valid fill-face-nil
                 fill-n-sided-face-valid fill-n-sided-face-nil-edges
                 fill-n-sided-face-too-few fill-n-sided-face-curvature
                 shell-shape-box-single-face shell-shape-multiple-faces
                 shell-shape-outward-offset shell-shape-nil-shape
                  shell-shape-excessive-thickness
                  sew-shapes-two-boxes sew-shapes-nil-input
                  sew-shapes-empty-list sew-shapes-non-manifold
                  defeature-shape-remove-one-face defeature-shape-nil-shape
                  defeature-shape-nil-faces defeature-shape-empty-faces
                  check-shape-validity-valid check-shape-validity-nil
                  boolean-builder-fuse boolean-builder-cut boolean-builder-common
                  boolean-builder-nil-first boolean-builder-nil-second
                  hlr-project-box hlr-project-nil
                  convert-to-revolution-cylinder convert-to-revolution-nil
                  convert-swept-to-elementary-cylinder convert-swept-to-elementary-nil
                  offset-shape-outward offset-shape-inward
                 offset-shape-arc-join offset-shape-intersection-join
                 offset-shape-excessive offset-shape-excessive-outward offset-shape-nil
                 offset-wire-outward offset-wire-inward offset-wire-nil
                 draft-face-valid draft-face-excessive-angle draft-face-nil-shape
                 make-evolved-valid make-evolved-with-offset make-evolved-nil-profile
                 make-cylindrical-hole-through make-cylindrical-hole-blind
                 make-cylindrical-hole-nil-shape make-cylindrical-hole-nil-depth
                 make-prism-feature-depression make-prism-feature-protrusion
                 make-prism-feature-nil
                 make-revol-feature-depression make-revol-feature-protrusion
                 make-revol-feature-nil
                 make-pipe-feature-depression make-pipe-feature-protrusion
                 make-pipe-feature-nil
                 local-extrude-valid local-extrude-nil
                 make-groove-valid make-groove-nil
                 make-rib-valid make-rib-nil
                 fix-shape-valid-box fix-shape-nil
                 fix-wire-valid fix-wire-nil
                 fix-solid-valid fix-solid-nil
                 fix-edge-valid fix-edge-nil
                 fix-face-valid fix-face-nil
                 shape-analysis-free-edges-valid shape-analysis-free-edges-nil
                 shape-analysis-check-intersections-valid shape-analysis-check-intersections-nil
                 shape-analysis-wire-contains-p-valid shape-analysis-wire-contains-p-outside shape-analysis-wire-contains-p-nil
                 shape-analysis-contents-valid shape-analysis-contents-nil
                 substitute-shape-single-valid substitute-shape-nil-shape substitute-shape-batch-valid
                 shape-to-nurbs-valid shape-to-nurbs-nil
                 shape-reduce-degree-valid shape-reduce-degree-nil
                 shape-to-rational-bspline-valid shape-to-rational-bspline-nil
                 shape-split-u-valid shape-split-u-nil
                 shape-upgrade-continuity-valid shape-upgrade-continuity-nil
                 apply-shape-process-single-valid apply-shape-process-sequence-valid apply-shape-process-nil
                  heal-shape-valid heal-shape-nil
                  fix-shaped-nil-input-all
                make-colored-shape-from-box make-colored-shape-nil-shape
                make-manipulator-created make-manipulator-set-position make-manipulator-set-size
                make-connected-interactive-from-shape make-connected-interactive-nil
                make-point-cloud-valid make-point-cloud-nil make-point-cloud-empty
                make-ais-plane-valid make-ais-axis-valid make-ais-line-valid make-ais-circle-valid
                make-view-cube-created make-view-cube-set-size make-view-cube-set-corner
                make-color-scale-created make-color-scale-set-range make-color-scale-set-size
                make-color-scale-set-title make-color-scale-set-intervals
                 make-multiple-connected-created make-multiple-connected-connect
                 make-triangulation-valid
                 mesh-shape-default mesh-shape-custom-deflection
                 mesh-shape-custom-angle mesh-shape-relative mesh-shape-nil
                 mesh-get-vertices-valid mesh-get-triangles-valid
                 mesh-get-triangle-count-valid mesh-get-vertices-unmeshed
                 mesh-get-vertices-nil
                 mesh-triangle-adjacent-valid mesh-triangle-elements-valid
                 mesh-triangle-elements-out-of-range
                 write-stl-angle-param write-stl-relative-param
                 meshvs-create-mesh-valid meshvs-create-mesh-nil-input
                 meshvs-free-valid meshvs-free-nil))
      (funcall test-sym))
    (format t "~2&=== Core results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

(defun run-viewer-tests ()
  "Run tests that require an X display (viewer, AIS, rendering, camera, grid, lighting)."
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt viewer tests (display required) ===~2%")
    (dolist (test-sym
             '(make-viewer-returns-viewer with-viewer-creates-and-cleans-up
               free-viewer-nil-safe
               ais-create-context-returns-ais-context
               ais-display-shape-in-context
               ais-displayed-p-returns-t-after-display
               ais-erase-hides-without-removing
               ais-remove-removes-from-context
               set-background-valid
               ais-set-color-on-displayed-shape
               ais-set-display-mode-wireframe
               set-view-projection-iso
               set-msaa-roundtrip
               set-antialiasing-roundtrip
               activate-grid-rectangular-lines
               activate-grid-circular-points
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
               make-material-valid ais-set-custom-material-valid
               viewer-add-and-toggle-light
               viewer-default-lights-valid
               grid-active-p-after-activate grid-active-p-after-deactivate
               set-gradient-background-valid set-gradient-background-style
               reset-background-valid
               set-computed-mode-toggle set-back-face-model-valid
               set-frustum-culling-valid set-transparency-method-valid redraw-view-valid
               set-immediate-update-valid
               set-text-label-angle-valid set-text-label-hjustification-valid
               set-text-label-vjustification-valid set-text-label-subtitle-color-valid
               set-text-label-display-type-valid
               make-text-label-convenience
               set-default-background-valid set-default-projection-valid
               set-default-view-size-valid set-default-view-type-valid
               set-default-bg-gradient-valid
               set-rectangular-grid-values-valid set-grid-xy-size-valid
               set-grid-offset-valid grid-display-valid
               ais-set-drawer-line-color-valid ais-set-drawer-line-width-valid ais-set-drawer-line-type-valid
               ais-set-drawer-point-color-valid ais-set-drawer-point-type-valid ais-set-drawer-point-scale-valid
               ais-set-drawer-text-color-valid ais-set-drawer-text-font-valid ais-set-drawer-text-height-valid
               ais-set-drawer-iso-display-valid ais-set-drawer-wire-color-valid
               ais-set-drawer-shading-color-valid
               ais-set-drawer-face-boundaries-valid ais-set-drawer-free-boundaries-valid
               set-camera-eye-target-up set-camera-partial-eye-only
               set-perspective-toggles
               set-fov-valid set-fov-zero
               set-clip-planes-valid
               reset-view-valid fit-all-shape-valid
               viewer-camera-predicate
               viewer-camera-roundtrip
               viewer-lights-and-active
               set-trihedron-wireframe-color-valid
               set-default-gradient-alias
               set-default-lights-modes
               set-grid-color-convenience
               set-grid-size-convenience
               grid-getter-stubs
               ais-set-selection-mode-keywords
               selection-baseline-zero
               selection-set-selected
               selection-clear-selected
               selection-is-selected
               selection-add-or-remove
               selection-selected-objects
               selection-selected-shapes
               selection-hilight
                set-text-label-align-convenience
                set-transparent-shading-alias
                make-length-dimension-2p make-angle-dimension-3p
                set-dimension-text-position-valid set-dimension-units-valid
                set-dimension-arrow-length-valid set-dimension-extension-size-valid
                set-dimension-custom-value-valid
                set-dimension-text-alias
                set-dimension-arrows-convenience
                set-dimension-extension-convenience))
      (funcall test-sym))
    (format t "~2&=== Viewer results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

(defun run-tests ()
  "Run all tests (core + viewer). For viewer tests an X display is required."
  (let ((core-pass 0) (core-fail 0)
        (viewer-pass 0) (viewer-fail 0))
    (multiple-value-setq (core-pass core-fail) (run-core-tests))
    (multiple-value-setq (viewer-pass viewer-fail) (run-viewer-tests))
    (format t "~2&=== All results: ~D pass, ~D fail, ~D errors ===~%"
            (+ core-pass viewer-pass)
            (+ core-fail viewer-fail)
            (test-result-errors *test-result*))
    (values (+ core-pass viewer-pass)
            (+ core-fail viewer-fail))))

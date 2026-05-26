(in-package :cl-occt)

;; ─── GCPnts: Uniform point distribution ──────────────────────────────

(deftest uniform-abscissa-null-curve
  (assert-nil (uniform-abscissa-points nil 0.0 10.0 5)))

(deftest uniform-deflection-circle
  (let* ((circle (make-circle-3d 0 0 0 10))
         (pts (uniform-deflection-points circle 0.0 (* 2 pi) 0.1)))
    (assert-true (> (length pts) 10))))

(deftest uniform-deflection-null-curve
  (assert-nil (uniform-deflection-points nil 0.0 10.0 0.1)))

;; ─── Location / Assembly ──────────────────────────────────────────────

(deftest location-create-from-translation
  (let ((loc (make-location 5 10 15)))
    (assert-true (not (null loc)))))

(deftest location-compose
  (let* ((a (make-location 5 0 0))
         (b (make-location 3 0 0))
         (c (compose-locations a b)))
    (assert-true (not (null c)))))

(deftest location-invert
  (let* ((loc (make-location 5 0 0))
         (inv (invert-location loc)))
    (assert-true (not (null inv)))))

(deftest shape-get-location-identity
  (let ((box (make-box 10 20 30)))
    (assert-true (not (null (shape-location box))))))

(deftest shape-move-by-location
  (let* ((box (make-box 10 20 30))
         (loc (make-location 5 0 0))
         (moved (move-shape box loc)))
    (assert-shape moved)))

;; ─── Edge Finding ─────────────────────────────────────────────────────

(deftest find-edges-by-type-box-lines
  (let* ((box (make-box 10 20 30))
         (edges (find-edges-by-type box 0))) ; 0 = GeomAbs_Line
    (assert-true (= 12 (length edges)))))

(deftest find-edges-by-type-cylinder-circles
  (let* ((cyl (make-cylinder 5 20))
         (edges (find-edges-by-type cyl 1))) ; 1 = GeomAbs_Circle
    (assert-true (> (length edges) 0))))

(deftest find-edges-by-radius-cylinder
  (let* ((cyl (make-cylinder 5 20))
         (edges (find-edges-by-radius cyl 5.0)))
    (assert-true (>= (length edges) 1))))

(deftest find-edges-by-radius-box-returns-nil
  (let* ((box (make-box 10 20 30))
         (edges (find-edges-by-radius box 5.0)))
    (assert-nil edges)))

;; ─── Normal Projection ────────────────────────────────────────────────

(deftest normal-project-null-input
  (assert-nil (normal-project nil nil)))

(deftest normal-project-null-shape
  (assert-nil (normal-project nil (make-face (make-wire (make-circle-edge 0 0 5))))))

;; ─── BREP I/O ─────────────────────────────────────────────────────────

(deftest brep-io-roundtrip-box
  (let* ((box (make-box 10 20 30))
         (tmpfile (merge-pathnames "test-roundtrip.brep"
                                    (uiop:temporary-directory))))
    (unwind-protect
         (progn
           (assert-true (write-brep box (namestring tmpfile)))
           (let ((read-back (read-brep (namestring tmpfile))))
             (assert-shape read-back)))
      (when (probe-file tmpfile) (delete-file tmpfile)))))

(deftest brep-read-nonexistent
  (assert-nil (read-brep "/nonexistent/path.brep")))

;; ─── Wedge Primitive ─────────────────────────────────────────────────

(deftest make-wedge-full-valid
  (let ((w (make-wedge 10 20 30 5)))
    (assert-shape w)))

(deftest make-wedge-corner-valid
  (let ((w (make-wedge 10 20 30 0 0 10 30)))
    (assert-shape w)))

(deftest make-wedge-zero-dim
  (assert-nil (make-wedge 0 20 30 5)))

(deftest make-wedge-negative
  (assert-nil (make-wedge -1 20 30 5)))

;; ─── Drafted Prism ───────────────────────────────────────────────────

(deftest make-drafted-prism-nil-shape
  (assert-nil (make-drafted-prism nil (make-face (make-wire (make-circle-edge 0 0 5)))
                                   (make-face (make-wire (make-circle-edge 0 0 3)))
                                   10 5 1)))

;; ─── Remove Features ─────────────────────────────────────────────────

(deftest remove-features-null-shape
  (assert-nil (remove-features nil (list (make-box 5 5 5)))))

(deftest remove-features-empty-faces
  (assert-nil (remove-features (make-box 10 20 30) nil)))

;; ─── Fix Small Faces ─────────────────────────────────────────────────

(deftest fix-small-faces-clean-box
  (let ((box (make-box 10 20 30)))
    (assert-shape (fix-small-faces box))))

(deftest fix-small-faces-null
  (assert-nil (fix-small-faces nil)))

;; ─── Shape Tolerance ─────────────────────────────────────────────────

(deftest set-shape-tolerance-on-vertices
  (let ((box (make-box 10 20 30)))
    (assert-true (set-shape-tolerance box 0.1 7)))) ; 7 = TopAbs_VERTEX

(deftest set-shape-tolerance-null
  (assert-nil (set-shape-tolerance nil 0.1 7)))

;; ─── RWStl ───────────────────────────────────────────────────────────

(deftest rwstl-read-null-path
  (assert-nil (read-stl-triangulation "/nonexistent.stl")))

(deftest rwstl-write-null-input
  (assert-nil (write-stl-triangulation nil "/tmp/test.stl")))

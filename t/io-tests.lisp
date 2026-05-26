(in-package :cl-occt)
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
(deftest write-stl-angle-param
  (let ((result (write-stl (make-box 10 20 30) "/tmp/clocct-test-angle.stl" :angle 0.2)))
    (assert-true result "write-stl with :angle should return t"))
  (assert-true (probe-file "/tmp/clocct-test-angle.stl") "STL file should exist"))
(deftest write-stl-relative-param
  (let ((result (write-stl (make-box 10 20 30) "/tmp/clocct-test-relative.stl" :relative t)))
    (assert-true result "write-stl with :relative should return t"))
  (assert-true (probe-file "/tmp/clocct-test-relative.stl") "STL file should exist"))

;; --- MeshVS Tests ---

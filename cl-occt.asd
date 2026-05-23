(asdf:defsystem :cl-occt
  :description "Common Lisp bindings to OCCT CAD kernel"
  :author "clocct"
  :license "MIT"
  :depends-on (:cffi :trivial-garbage :alexandria)
  :serial t
  :components
  ((:module "src"
    :components
    ((:file "package")
     (:module "ffi"
      :components
      ((:file "loader")
       (:file "bindings")))
      (:module "core"
        :components
        ((:file "shape")
         (:file "errors")
         (:file "primitives")
         (:file "text")
          (:file "geom2d")
          (:file "curves")
          (:file "surfaces")
          (:file "geom-algorithms")
          (:file "helix")
           (:file "faces")
           (:file "booleans")
            (:file "compounds")
            (:file "transforms")
            (:file "assembly")
            (:file "io")
            (:file "mass-properties")
            (:file "shape-analysis")
             (:file "topology")
             (:file "fillet")
             (:file "chamfer")
             (:file "blend")
             (:file "sweep")
             (:file "loft")
              (:file "face-filling")
              (:file "shell")
              (:file "offset")
              (:file "draft")
               (:file "shape-fix")
               (:file "shape-rebuild")
               (:file "shape-process")
               (:file "hole-prism-revol")
               (:file "pipe-feature")
               (:file "local-ops")
              (:file "viewer")
            (:file "viewer-colors")
            (:file "viewer-camera")
            (:file "viewer-object-props")
            (:file "viewer-lighting")
            (:file "viewer-grid")
            (:file "viewer-background")
            (:file "viewer-rendering")
            (:file "viewer-text-labels")
            (:file "viewer-defaults")
            (:file "viewer-drawer")
             (:file "viewer-dimensions")))))))

(asdf:defsystem :cl-occt/tests
  :description "Tests for cl-occt"
  :depends-on (:cl-occt)
  :components
  ((:module "t"
    :components
    ((:file "smoke-tests"))))
  :perform (test-op (o c)
             (let ((*package* (find-package :cl-occt)))
               (asdf:load-system :cl-occt/tests)
               (multiple-value-bind (pass fail)
                   (funcall (find-symbol "RUN-CORE-TESTS" :cl-occt))
                  (unless (zerop fail)
                    (uiop:quit 1))))))

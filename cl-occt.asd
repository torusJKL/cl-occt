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
        (:file "geom2d")
        (:file "faces")
        (:file "booleans")
        (:file "transforms")
        (:file "io")))
     (:module "dag"
      :components
      ((:file "params")
       (:file "registry")
       (:file "model")
       (:file "propagation")))
     (:module "dsl"
       :components
       ((:file "param")
        (:file "defmodel")
        (:file "api")))
     (:file "core/api")))))

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
               (funcall (find-symbol "RUN-TESTS" :cl-occt)))))

(in-package :cl-occt.impl)

(define-foreign-library libocctwrap
  (:unix (:or "libocctwrap.so"
              (merge-pathnames "lib/libocctwrap.so"
                               (asdf:system-source-directory :cl-occt))))
  (t (:default "libocctwrap")))

(use-foreign-library libocctwrap)

(in-package :cl-occt.impl)

(define-foreign-library libocctwrap
  (:unix (:or "libocctwrap.so"
              (merge-pathnames "lib/libocctwrap.so"
                               (asdf:system-source-directory :cl-occt))
              #p"/home/gal/code/cl-occt/adv-occt-features/lib/libocctwrap.so"))
  (t (:default "libocctwrap")))

(use-foreign-library libocctwrap)

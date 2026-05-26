(in-package :cl-occt)
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

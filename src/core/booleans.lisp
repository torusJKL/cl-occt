(in-package :cl-occt)

(defun cut (shape &rest others)
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-cut (when a (%ptr a))
                                              (when b (%ptr b))))))
              others
              :initial-value shape)))

(defun fuse (shape &rest others)
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-fuse (when a (%ptr a))
                                               (when b (%ptr b))))))
              others
              :initial-value shape)))

(defun common (shape &rest others)
  (if (null shape)
      nil
      (reduce (lambda (a b)
                (if (null b)
                    nil
                    (make-shape (%boolean-common (when a (%ptr a))
                                                 (when b (%ptr b))))))
              others
              :initial-value shape)))

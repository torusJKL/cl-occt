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


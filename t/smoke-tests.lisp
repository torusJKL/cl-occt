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

(deftest shape-distinct
  (let ((a (make-box 1 2 3))
        (b (make-box 1 2 3)))
    (assert-true (not (eq a b)) "shapes should be distinct")))

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

;; --- DAG ---

(deftest dag-set-param
  (let ((key (gensym "PARAM")))
    (set-param! key 42)
    (assert-true (eql (getf cl-occt.impl:*params* key) 42))))

(deftest dag-set-params-batch
  (set-params! :test-a 1 :test-b 2)
  (assert-true (and (eql (getf cl-occt.impl:*params* :test-a) 1)
                    (eql (getf cl-occt.impl:*params* :test-b) 2))))

;; --- DSL ---

(deftest param-function-global
  (set-param! :dsl-test 99)
  (assert-true (eql (param :dsl-test) 99)))

(deftest with-params-local
  (with-params (:local-x 50)
    (assert-true (eql (param :local-x) 50))))

(deftest with-params-does-not-leak
  (with-params (:leak-test "local")
    (param :leak-test))
  (assert-nil (getf cl-occt.impl:*params* :leak-test)))

(defun run-tests ()
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt smoke tests ===~2%")
    (dolist (test-sym
             '(make-box-valid make-box-zero-dim make-box-negative
               make-cylinder-valid make-sphere-valid make-cone-valid
               shape-distinct
               cut-two-boxes cut-nil-first cut-nil-second
               fuse-two-boxes common-overlap common-no-overlap
               boolean-variadic
               translate-shape translate-preserves-original translate-nil
               rotate-shape
               write-step-valid write-step-nil
               read-step-roundtrip read-step-nonexistent
               dag-set-param dag-set-params-batch
               param-function-global with-params-local with-params-does-not-leak))
      (funcall test-sym))
    (format t "~2&=== Results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

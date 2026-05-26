(in-package :cl-occt)

(defun transfer-parameter (source-edge target-curve param)
  "Transfer a parameter value from **source-edge** to **target-curve**.

  Returns two values: the transferred parameter (double-float) and a
  boolean indicating success. Returns (nil nil) on invalid input.

  **See also:** `edge-curve`, `edge-curve-range`"
  (if (or (null source-edge) (null target-curve))
      (values nil nil)
      (cffi:with-foreign-object (out-param :double)
        (let ((ok (%transfer-params (%ptr source-edge)
                                    (%ptr target-curve)
                                    (coerce param 'double-float)
                                    out-param)))
          (if (= ok 0)
              (values nil nil)
              (values (cffi:mem-ref out-param :double) t))))))

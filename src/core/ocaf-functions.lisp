(in-package :cl-occt)

(defun ocaf-add-function (label driver-guid)
  "Add a function with **driver-guid** to an OCAF **label**.
  Returns `t` on success, `nil` on failure.

  **See also:** `ocaf-set-function-input`, `ocaf-set-function-output`, `ocaf-recompute-function`"
  (not (zerop (%ocaf-add-function (ocaf-label-ptr label) driver-guid))))

(defun ocaf-set-function-input (func-label input-label)
  "Set **input-label** as an input to the function on **func-label**.
  Returns `t` on success.

  **See also:** `ocaf-set-function-output`, `ocaf-recompute-function`"
  (not (zerop (%ocaf-set-function-input (ocaf-label-ptr func-label)
                                        (ocaf-label-ptr input-label)))))

(defun ocaf-set-function-output (func-label output-label)
  "Set **output-label** as an output of the function on **func-label**.
  Returns `t` on success.

  **See also:** `ocaf-set-function-input`, `ocaf-recompute-function`"
  (not (zerop (%ocaf-set-function-output (ocaf-label-ptr func-label)
                                         (ocaf-label-ptr output-label)))))

(defun ocaf-recompute (doc)
  "Recompute all functions in the OCAF **doc**.

  **See also:** `ocaf-recompute-function`"
  (%ocaf-recompute-doc (%ptr doc)))

(defun ocaf-recompute-function (func-label)
  "Recompute the function on **func-label**.
  Returns `t` on success, `nil` on failure.

  **See also:** `ocaf-recompute`, `ocaf-add-function`"
  (not (zerop (%ocaf-recompute-function (ocaf-label-ptr func-label)))))

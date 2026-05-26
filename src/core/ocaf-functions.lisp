(in-package :cl-occt)

(defun ocaf-add-function (label driver-guid)
  (not (zerop (%ocaf-add-function (ocaf-label-ptr label) driver-guid))))

(defun ocaf-set-function-input (func-label input-label)
  (not (zerop (%ocaf-set-function-input (ocaf-label-ptr func-label)
                                        (ocaf-label-ptr input-label)))))

(defun ocaf-set-function-output (func-label output-label)
  (not (zerop (%ocaf-set-function-output (ocaf-label-ptr func-label)
                                         (ocaf-label-ptr output-label)))))

(defun ocaf-recompute (doc)
  (%ocaf-recompute-doc (%ptr doc)))

(defun ocaf-recompute-function (func-label)
  (not (zerop (%ocaf-recompute-function (ocaf-label-ptr func-label)))))

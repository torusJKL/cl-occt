(in-package :cl-occt)

;; --- Integer Attributes ---

(defun ocaf-set-integer (label value)
  (%ocaf-set-integer (ocaf-label-ptr label) value))

(defun ocaf-get-integer (label)
  (%ocaf-get-integer (ocaf-label-ptr label)))

(defun ocaf-has-integer-p (label)
  (not (zerop (%ocaf-has-integer (ocaf-label-ptr label)))))

;; --- Real Attributes ---

(defun ocaf-set-real (label value)
  (%ocaf-set-real (ocaf-label-ptr label) (coerce value 'double-float)))

(defun ocaf-get-real (label)
  (%ocaf-get-real (ocaf-label-ptr label)))

(defun ocaf-has-real-p (label)
  (not (zerop (%ocaf-has-real (ocaf-label-ptr label)))))

;; --- String Attributes ---

(defun ocaf-set-string (label value)
  (%ocaf-set-string (ocaf-label-ptr label) value))

(defun ocaf-get-string (label)
  (%ocaf-get-string (ocaf-label-ptr label)))

(defun ocaf-has-string-p (label)
  (not (zerop (%ocaf-has-string (ocaf-label-ptr label)))))

;; --- Name Attributes ---

(defun ocaf-set-name (label name)
  (%ocaf-set-name (ocaf-label-ptr label) name))

(defun ocaf-get-name (label)
  (%ocaf-get-name (ocaf-label-ptr label)))

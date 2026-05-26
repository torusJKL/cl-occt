(in-package :cl-occt)

;; --- Integer Attributes ---

(defun ocaf-set-integer (label value)
  "Set an integer attribute on an OCAF **label**."
  (%ocaf-set-integer (ocaf-label-ptr label) value))

(defun ocaf-get-integer (label)
  "Get the integer attribute value from an OCAF **label**."
  (%ocaf-get-integer (ocaf-label-ptr label)))

(defun ocaf-has-integer-p (label)
  "**Returns:** `t` if **label** has an integer attribute."
  (not (zerop (%ocaf-has-integer (ocaf-label-ptr label)))))

;; --- Real Attributes ---

(defun ocaf-set-real (label value)
  "Set a real (double-float) attribute on an OCAF **label**."
  (%ocaf-set-real (ocaf-label-ptr label) (coerce value 'double-float)))

(defun ocaf-get-real (label)
  "Get the real (double-float) attribute value from an OCAF **label**."
  (%ocaf-get-real (ocaf-label-ptr label)))

(defun ocaf-has-real-p (label)
  "**Returns:** `t` if **label** has a real attribute."
  (not (zerop (%ocaf-has-real (ocaf-label-ptr label)))))

;; --- String Attributes ---

(defun ocaf-set-string (label value)
  "Set a string attribute on an OCAF **label**."
  (%ocaf-set-string (ocaf-label-ptr label) value))

(defun ocaf-get-string (label)
  "Get the string attribute value from an OCAF **label**."
  (%ocaf-get-string (ocaf-label-ptr label)))

(defun ocaf-has-string-p (label)
  "**Returns:** `t` if **label** has a string attribute."
  (not (zerop (%ocaf-has-string (ocaf-label-ptr label)))))

;; --- Name Attributes ---

(defun ocaf-set-name (label name)
  "Set a name attribute on an OCAF **label**."
  (%ocaf-set-name (ocaf-label-ptr label) name))

(defun ocaf-get-name (label)
  "Get the name attribute value from an OCAF **label**."
  (%ocaf-get-name (ocaf-label-ptr label)))

(in-package :cl-occt)

(defun convert-units (value from-unit to-unit)
  "Convert VALUE from FROM-UNIT to TO-UNIT.
  Units are strings like \"mm\", \"inch\", \"kg\", \"lbm\"."
  (check-type from-unit string) (check-type to-unit string)
  (%units-convert (coerce value 'double-float) from-unit to-unit))

(defun convert-to-si (value unit)
  "Convert VALUE from UNIT to SI base units."
  (check-type unit string)
  (%units-convert-to-si (coerce value 'double-float) unit))

(defun convert-from-si (value unit)
  "Convert VALUE from SI base units to UNIT."
  (check-type unit string)
  (%units-convert-from-si (coerce value 'double-float) unit))

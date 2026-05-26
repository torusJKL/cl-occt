(in-package :cl-occt.impl)

(defcfun (%units-convert "units_convert") :double
  (value :double)
  (from-unit :string)
  (to-unit :string))

(defcfun (%units-convert-to-si "units_convert_to_si") :double
  (value :double)
  (unit :string))

(defcfun (%units-convert-from-si "units_convert_from_si") :double
  (value :double)
  (unit :string))

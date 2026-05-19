(in-package :cl-occt.impl)

(defstruct model
  (name nil :type symbol)
  (fn nil :type function)
  (param-keys nil :type list)
  (model-deps nil :type list)
  (dependents nil :type list)
  (dirty nil :type boolean)
  (cached-shape nil)
  (last-param-hash nil :type (or null fixnum))
  (color nil :type (or null list))
  (display-name nil :type (or null string))
  (layer nil :type (or null string)))

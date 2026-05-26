(in-package :cl-occt)

(defun convert-to-revolution (shape)
  "Convert elementary surfaces of a shape to revolution surfaces.

  - **shape** a shape to convert

  **Returns:** a new shape with surfaces converted to revolution form where possible,
  or `nil` if `shape` is null or conversion is not applicable.

  **Example:**

      (convert-to-revolution (make-cylinder 5 20))

  **See also:** `convert-swept-to-elementary`, `convert-surface-to-bspline`"
  (if (null shape)
      nil
      (make-shape (%convert-to-revolution (%ptr shape)))))

(defun convert-swept-to-elementary (shape)
  "Convert swept surfaces of a shape to elementary surfaces.

  - **shape** a shape to convert

  **Returns:** a new shape with surfaces converted to elementary form where possible,
  or `nil` if `shape` is null or conversion is not applicable.

  **Example:**

      (convert-swept-to-elementary (make-cylinder 5 20))

  **See also:** `convert-to-revolution`, `convert-surface-to-bspline`"
  (if (null shape)
      nil
      (make-shape (%convert-swept-to-elementary (%ptr shape)))))

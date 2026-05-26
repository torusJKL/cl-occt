(in-package :cl-occt)

(defun curve-value (curve t-param)
  "Evaluate a `curve` at parameter `t-param` and return the 3D point.
  **Returns:** three values x, y, z, or nil."
  (unless (curve-p curve)
    (return-from curve-value (values nil nil nil)))
  (let ((ptr (%ptr curve)))
    (when (cffi:null-pointer-p ptr)
      (return-from curve-value (values nil nil nil)))
    (cffi:with-foreign-objects ((x :double) (y :double) (z :double))
      (when (zerop (%curve-value ptr (coerce t-param 'double-float) x y z))
        (return-from curve-value (values nil nil nil)))
      (values (cffi:mem-ref x :double)
              (cffi:mem-ref y :double)
              (cffi:mem-ref z :double)))))

(defun surface-value (surface u v)
  "Evaluate a `surface` at parameters (u, v) and return the 3D point.
  **Returns:** three values x, y, z, or nil."
  (unless (surface-p surface)
    (return-from surface-value (values nil nil nil)))
  (let ((ptr (%ptr surface)))
    (when (cffi:null-pointer-p ptr)
      (return-from surface-value (values nil nil nil)))
    (cffi:with-foreign-objects ((x :double) (y :double) (z :double))
      (when (zerop (%surface-value ptr
                       (coerce u 'double-float)
                       (coerce v 'double-float)
                       x y z))
        (return-from surface-value (values nil nil nil)))
      (values (cffi:mem-ref x :double)
              (cffi:mem-ref y :double)
              (cffi:mem-ref z :double)))))

(defparameter +precision-confusion+   (%precision-confusion)
  "OCPT Precision::Confusion() — typically 1e-7.")

(defparameter +precision-angular+     (%precision-angular)
  "OCCT Precision::Angular() — typically 1e-12.")

(defparameter +precision-intersection+ (%precision-intersection)
  "OCCT Precision::Intersection() — typically 1e-10.")

(in-package :cl-occt)

(defun find-edges-by-type (shape curve-type)
  "Find edges in **shape** matching a curve **type**.

  **curve-type** is an integer corresponding to GeomAbs_CurveType
  (0=Line, 1=Circle, 2=Ellipse, 3=Hyperbola, 4=Parabola,
  5=BezierCurve, 6=BSplineCurve).

  Returns a list of edge shapes, or nil.

  **Example:**

      (find-edges-by-type my-shape 1)  ; find all circular edges

  **See also:** `find-edges-by-radius`"
  (if (null shape)
      nil
      (cffi:with-foreign-object (count :int)
        (let ((arr (%find-edges-by-type (%ptr shape) curve-type count)))
          (if (cffi:null-pointer-p arr)
              nil
              (let ((n (cffi:mem-ref count :int)))
                (unwind-protect
                     (loop for i below n
                           for ptr = (cffi:mem-aref arr :pointer i)
                           collect (make-shape ptr))
                  (when (not (cffi:null-pointer-p arr))
                     (%free-shape-array arr)))))))))

(defun find-edges-by-radius (shape radius)
  "Find edges in **shape** whose curve has the given **radius**.

  Only applies to circular edges. Returns a list of edge shapes, or nil.

  **Example:**

      (find-edges-by-radius my-shape 5.0)

  **See also:** `find-edges-by-type`"
  (if (null shape)
      nil
      (cffi:with-foreign-object (count :int)
        (let ((arr (%find-edges-by-radius (%ptr shape)
                                          (coerce radius 'double-float)
                                          count)))
          (if (cffi:null-pointer-p arr)
              nil
              (let ((n (cffi:mem-ref count :int)))
                (unwind-protect
                     (loop for i below n
                           for ptr = (cffi:mem-aref arr :pointer i)
                           collect (make-shape ptr))
                  (when (not (cffi:null-pointer-p arr))
                     (%free-shape-array arr)))))))))

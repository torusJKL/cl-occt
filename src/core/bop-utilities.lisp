(in-package :cl-occt)

(defun boolean-argument-analyzer (shapes)
  "Analyze a set of shapes for potential boolean operation issues.
  - **shapes** a list of shapes to analyze.
  Returns a string describing issues, or nil if no issues found."
  (if (or (null shapes) (null (first shapes)))
      nil
      (let* ((count (length shapes))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for s in shapes
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if s (%ptr s) (cffi:null-pointer))))
               (let ((result (%argument-analyzer arr count)))
                 (if (and (stringp result) (string= result ""))
                     nil
                     result)))
          (cffi:foreign-free arr)))))

(defun make-connected (shapes)
  "Connect a set of shapes along common faces to form a watertight result.
  - **shapes** a list of shapes to connect.
  Returns a connected shape, or nil if shapes is empty."
  (if (null shapes)
      nil
      (let* ((count (length shapes))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for s in shapes
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if s (%ptr s) (cffi:null-pointer))))
               (make-shape (%make-connected-shapes arr count)))
          (cffi:foreign-free arr)))))

(defun make-periodic (shape dx dy dz)
  "Make a shape periodic along the specified direction.
  - **dx dy dz** direction vector (the dominant axis determines periodicity).
  Returns a periodic shape, or nil if shape is null or cannot be made periodic."
  (if (null shape)
      nil
      (make-shape (%make-shape-periodic (%ptr shape)
                                         (coerce dx 'double-float)
                                         (coerce dy 'double-float)
                                         (coerce dz 'double-float)))))

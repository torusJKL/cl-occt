(in-package :cl-occt)

(defun split-shape (shape tools)
  "Split a shape by one or more tool shapes.
  - **tools** a single shape or a list of tool shapes.
  Returns a compound of split pieces, or nil if shape is null."
  (if (null shape)
      nil
      (let* ((tool-list (if (listp tools) tools (list tools)))
             (count (length tool-list))
             (arr (cffi:foreign-alloc :pointer :count count)))
        (unwind-protect
             (progn
               (loop for i from 0 below count
                     for tl in tool-list
                     do (setf (cffi:mem-aref arr :pointer i)
                              (if tl (%ptr tl) (cffi:null-pointer))))
               (make-shape (%split-shape (%ptr shape) arr count)))
          (cffi:foreign-free arr)))))

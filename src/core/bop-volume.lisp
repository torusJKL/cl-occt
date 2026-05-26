(in-package :cl-occt)

(defun make-volume (shapes)
  "Create solids from enclosed cavities between a set of shapes.
  - **shapes** a list of shapes forming cavities.
  Returns a compound of resulting volumes, or nil if shapes is empty."
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
               (make-shape (%make-volume arr count)))
          (cffi:foreign-free arr)))))

(defun cells-builder (shapes operation &optional selection)
  "Select specific cells from a boolean operation result.
  - **shapes** a list of argument shapes.
  - **operation** 0=FUSE, 1=COMMON, 2=CUT, 3=CUT21, 4=SECTION.
  - **selection** optional list of shape indices whose cells to include.
  Returns a compound of selected cells, or nil if shapes is empty."
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
               (if selection
                   (let* ((sel-count (length selection))
                          (sel-arr (cffi:foreign-alloc :int :count sel-count)))
                     (unwind-protect
                          (progn
                            (loop for i from 0 below sel-count
                                  for idx in selection
                                  do (setf (cffi:mem-aref sel-arr :int i) idx))
                            (make-shape (%cells-builder arr count operation sel-arr sel-count)))
                       (cffi:foreign-free sel-arr)))
                   (make-shape (%cells-builder arr count operation (cffi:null-pointer) 0))))
          (cffi:foreign-free arr)))))

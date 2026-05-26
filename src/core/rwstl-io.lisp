(in-package :cl-occt)

(defun read-stl-triangulation (filename)
  (let ((ptr (%rwstl-read-file filename)))
    (if (cffi:null-pointer-p ptr)
        nil
        ptr)))

(defun write-stl-triangulation (triangulation filename)
  (if (null triangulation)
      nil
      (let ((ok (%rwstl-write-file triangulation filename)))
        (not (= ok 0)))))

(defun free-stl-triangulation (triangulation)
  (when triangulation
    (%rwstl-free-triangulation triangulation)))

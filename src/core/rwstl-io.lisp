(in-package :cl-occt)

(defun read-stl-triangulation (filename)
  "Read an STL file and return a raw triangulation handle.

  Returns an opaque pointer to the triangulation data, or nil on failure.
  The handle must be freed with `free-stl-triangulation`.

  **See also:** `write-stl-triangulation`, `free-stl-triangulation`"
  (let ((ptr (%rwstl-read-file filename)))
    (if (cffi:null-pointer-p ptr)
        nil
        ptr)))

(defun write-stl-triangulation (triangulation filename)
  "Write a raw triangulation handle to an STL file.

  Returns `t` on success, `nil` on failure.

  **See also:** `read-stl-triangulation`"
  (if (null triangulation)
      nil
      (let ((ok (%rwstl-write-file triangulation filename)))
        (not (= ok 0)))))

(defun free-stl-triangulation (triangulation)
  "Free a raw triangulation handle obtained from `read-stl-triangulation`.

  Safe to call on nil.

  **See also:** `read-stl-triangulation`"
  (when triangulation
    (%rwstl-free-triangulation triangulation)))

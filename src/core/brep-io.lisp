(in-package :cl-occt)

(defun write-brep (shape filename)
  "Write **shape** to a BREP file at **filename**.

  Returns `t` on success, `nil` if **shape** is nil.

  **Example:**

      (write-brep (make-box 10 20 30) \"/tmp/box.brep\")

  **See also:** `read-brep`, `write-step`"
  (if (null shape)
      nil
      (let ((ok (%brep-write-shape (%ptr shape) filename)))
        (not (= ok 0)))))

(defun read-brep (filename)
  "Read a shape from a BREP file at **filename**.

  Returns a shape object, or `nil` if the file cannot be read.

  **Example:**

      (let ((shape (read-brep \"/tmp/box.brep\")))
        (when shape (shape-type shape)))

  **See also:** `write-brep`, `read-step`"
  (make-shape (%brep-read-shape filename)))

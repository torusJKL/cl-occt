(in-package :cl-occt)

(defun apply-shape-process (shape operator)
  "Apply a shape processing operation or sequence of operations.

  **shape** -- a shape object to process
  **operator** -- a string naming an operator (e.g. \"FixShape\",
              \"SameParameter\")
              or a list of operator strings for sequential application

  Supported operators: FixShape, FixSolid, FixWire, FixEdge, FixFace,
  SameParameter, SplitContinuity.

  Returns a new processed shape, or `nil` on error.

  **Example:**

    (apply-shape-process my-shape \"SameParameter\")

  **See also:** `apply-healing-pipeline`, `heal-shape`"
  (unless (shape-p shape)
    (return-from apply-shape-process nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from apply-shape-process nil))
    (if (listp operator)
        (let* ((count (length operator))
               (op-vec (cffi:foreign-alloc :pointer :count count)))
          (unwind-protect
               (progn
                 (loop for op in operator
                       for i from 0
                       do (setf (cffi:mem-aref op-vec :pointer i)
                                (cffi:foreign-string-alloc (string op))))
                 (make-shape (%apply-operator-sequence ptr op-vec count)))
            (loop for i from 0 below count
                  do (cffi:foreign-free (cffi:mem-aref op-vec :pointer i)))
            (cffi:foreign-free op-vec)))
        (make-shape (%apply-shape-process ptr (string operator))))))

(defun apply-healing-pipeline (shape pipeline &key resource)
  "Apply a named healing pipeline to a shape.

  **shape** -- a shape object to heal
  **pipeline** -- string naming a pipeline defined in a ShapeProcess resource file.
              \"StdHealing\" is available when OCCT resource files are installed.
  **resource** -- optional resource file path (string) for custom pipeline definitions.
              When omitted, OCCT's default resources are searched.

  Pipeline names come from ShapeProcess resource files shipped with OCCT
  (e.g., Resource_ShapeProcess.xx). See OCCT documentation for details.

  Returns a new healed shape, or `nil` on error.

  **Example:**

    (apply-healing-pipeline my-shape \"StdHealing\")

  **See also:** `apply-shape-process`, `heal-shape`"
  (unless (shape-p shape)
    (return-from apply-healing-pipeline nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from apply-healing-pipeline nil))
    (make-shape (%apply-healing-pipeline ptr (string pipeline)
                                          (or resource "")))))

(defun heal-shape (shape)
  "Apply OCCT's default shape healing to repair a shape.

  This runs the standard healing pipeline which fixes common issues
  like small edges, gaps, and incorrect orientations.

  Returns a new healed shape, or `nil` on error.

  **Example:**

    (let ((healed (heal-shape some-problematic-shape)))
      (when healed
        (shape-valid-p healed)))

  **See also:** `apply-shape-process`, `apply-healing-pipeline`, `fix-shape`"
  (unless (shape-p shape)
    (return-from heal-shape nil))
  (let ((ptr (%ptr shape)))
    (when (or (null ptr) (cffi:null-pointer-p ptr))
      (return-from heal-shape nil))
    (make-shape (%heal-shape-default ptr))))

(in-package :cl-occt)

(defparameter *ocaf-evolution-map*
  '((:primitive . 0)
    (:generated . 1)
    (:modified  . 2)
    (:deleted   . 3)
    (:selected  . 5))
  "Maps OCAF naming evolution keywords to integer codes.")

(defun ocaf-evolution-code (keyword)
  "Convert an evolution **keyword** to integer code.
  Keywords: :primitive, :generated, :modified, :deleted, :selected.

  **See also:** `ocaf-name-shape`, `ocaf-get-named-shape`"
  (let ((code (cdr (assoc keyword *ocaf-evolution-map*))))
    (if code
        code
        (error "Unknown evolution keyword: ~A (use :primitive, :generated, :modified, :deleted, or :selected)" keyword))))

(defun ocaf-name-shape (label shape evolution)
  "Associate a **shape** with an OCAF **label** under the given **evolution** keyword.

  **See also:** `ocaf-get-named-shape`, `ocaf-shape-deleted-p`"
  (%ocaf-name-shape (ocaf-label-ptr label) (%ptr shape) (ocaf-evolution-code evolution)))

(defun ocaf-get-named-shape (label &optional (evolution :generated))
  "Get the shape associated with an OCAF **label** under the given **evolution**.
  Returns a shape object, or nil.

  **See also:** `ocaf-name-shape`, `ocaf-shape-deleted-p`"
  (let ((ptr (%ocaf-get-named-shape (ocaf-label-ptr label) (ocaf-evolution-code evolution))))
    (if (cffi:null-pointer-p ptr)
        nil
        (let ((s (make-shape ptr)))
          (tg:finalize s (lambda () (%free-shape ptr)))
          s))))

(defun ocaf-shape-deleted-p (label)
  "**Returns:** `t` if the named shape on **label** has been deleted.

  **See also:** `ocaf-get-named-shape`"
  (not (zerop (%ocaf-named-shape-is-deleted (ocaf-label-ptr label)))))

(in-package :cl-occt)

(defparameter *ocaf-evolution-map*
  '((:primitive . 0)
    (:generated . 1)
    (:modified  . 2)
    (:deleted   . 3)
    (:selected  . 5)))

(defun ocaf-evolution-code (keyword)
  (let ((code (cdr (assoc keyword *ocaf-evolution-map*))))
    (if code
        code
        (error "Unknown evolution keyword: ~A (use :primitive, :generated, :modified, :deleted, or :selected)" keyword))))

(defun ocaf-name-shape (label shape evolution)
  (%ocaf-name-shape (ocaf-label-ptr label) (%ptr shape) (ocaf-evolution-code evolution)))

(defun ocaf-get-named-shape (label &optional (evolution :generated))
  (let ((ptr (%ocaf-get-named-shape (ocaf-label-ptr label) (ocaf-evolution-code evolution))))
    (if (cffi:null-pointer-p ptr)
        nil
        (let ((s (make-shape ptr)))
          (tg:finalize s (lambda () (%free-shape ptr)))
          s))))

(defun ocaf-shape-deleted-p (label)
  (not (zerop (%ocaf-named-shape-is-deleted (ocaf-label-ptr label)))))

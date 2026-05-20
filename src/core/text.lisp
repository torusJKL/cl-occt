(in-package :cl-occt)

(defclass brep-font ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun brep-font-p (obj)
  (typep obj 'brep-font))

(in-package :cl-occt.impl)

(defun make-brep-font (ptr)
  (if (cffi:null-pointer-p ptr)
      nil
      (let ((f (make-instance 'cl-occt:brep-font :ptr ptr)))
        (tg:finalize f (lambda () (%free-brep-font ptr)))
        f)))

(defun %font-aspect-value (aspect)
  (ecase aspect
    (:regular    0)
    (:bold       1)
    (:italic     2)
    (:bold-italic 3)))

(defun %h-align-value (align)
  (ecase align
    (:left   0)
    (:center 1)
    (:right  2)))

(defun %v-align-value (align)
  (ecase align
    (:bottom 0)
    (:center 1)
    (:top    2)
    (:top-first-line 3)))

(in-package :cl-occt)

(defun make-brep-font-from-file (path size &optional (face-id 0))
  (make-brep-font (%make-brep-font-from-file path
                                             (coerce size 'double-float)
                                             face-id)))

(defun make-brep-font-from-name (name size &key (aspect :regular))
  (make-brep-font (%make-brep-font-from-name name
                                              (%font-aspect-value aspect)
                                              (coerce size 'double-float))))

(defun make-text-shape (font text &key (h-align :left) (v-align :bottom))
  (when font
    (let ((ptr (%make-text-shape (%ptr font)
                                 text
                                 (%h-align-value h-align)
                                 (%v-align-value v-align))))
      (make-shape ptr))))

(defun make-text-shape-3d (font text depth &key (h-align :left) (v-align :bottom))
  (unless (and font (> (coerce depth 'double-float) 0))
    (return-from make-text-shape-3d nil))
  (let ((flat (make-text-shape font text :h-align h-align :v-align v-align)))
    (when flat
      (make-prism flat 0 0 (coerce depth 'double-float)))))

(in-package :cl-occt)

(defclass brep-font ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun brep-font-p (obj)
  (typep obj 'brep-font))

(defclass ais-text-label ()
  ((%ptr :initarg :ptr :reader %ptr)
   (text :initform nil :reader ais-text-label-text)
   (position :initform nil :reader ais-text-label-position)
   (color :initform nil :reader ais-text-label-color)))

(defun ais-text-label-p (obj)
  (typep obj 'ais-text-label))

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

(defun %compute-gp-ax3 (position normal)
  (let ((p (or position '(0 0 0)))
        (n (or normal '(0 0 1))))
    (values (coerce (first p) 'double-float)
            (coerce (second p) 'double-float)
            (coerce (third p) 'double-float)
            (coerce (first n) 'double-float)
            (coerce (second n) 'double-float)
            (coerce (third n) 'double-float))))

(defun make-brep-font-from-file (path size &optional (face-id 0))
  (make-brep-font (%make-brep-font-from-file path
                                             (coerce size 'double-float)
                                             face-id)))

(defun make-brep-font-from-name (name size &key (aspect :regular))
  (make-brep-font (%make-brep-font-from-name name
                                              (%font-aspect-value aspect)
                                              (coerce size 'double-float))))

(defun make-text-shape (font text &key (h-align :left) (v-align :bottom)
                                              position normal)
  (when font
    (if (or position normal)
        (multiple-value-bind (px py pz nx ny nz)
            (%compute-gp-ax3 (or position '(0 0 0)) (or normal '(0 0 1)))
          (let ((ptr (%make-text-shape-on-plane (%ptr font) text
                                                (%h-align-value h-align)
                                                (%v-align-value v-align)
                                                (coerce px 'double-float)
                                                (coerce py 'double-float)
                                                (coerce pz 'double-float)
                                                (coerce nx 'double-float)
                                                (coerce ny 'double-float)
                                                (coerce nz 'double-float))))
            (make-shape ptr)))
        (let ((ptr (%make-text-shape (%ptr font) text
                                     (%h-align-value h-align)
                                     (%v-align-value v-align))))
          (make-shape ptr)))))

(defun make-text-shape-3d (font text depth &key (h-align :left) (v-align :bottom)
                                                    position normal)
  (unless (and font (> (coerce depth 'double-float) 0))
    (return-from make-text-shape-3d nil))
  (let ((flat (make-text-shape font text
                               :h-align h-align :v-align v-align
                               :position position :normal normal)))
    (when flat
      (make-prism flat 0 0 (coerce depth 'double-float)))))

(defun make-text-shape-on-plane (font text &key (h-align :left) (v-align :bottom)
                                                   (position '(0 0 0)) (normal '(0 0 1)))
  (make-text-shape font text
                   :h-align h-align :v-align v-align
                   :position position :normal normal))

(defun text-bounding-box (font text &key (h-align :left) (v-align :bottom))
  (when font
    (cffi:with-foreign-objects ((w :double) (h :double))
      (%text-bounding-box (%ptr font) text
                          (%h-align-value h-align)
                          (%v-align-value v-align)
                          w h)
      (let ((width (cffi:mem-ref w :double))
            (height (cffi:mem-ref h :double)))
        (when (and (> width 0) (> height 0))
          (values width height))))))

(defun list-available-fonts ()
  (let ((ptr (%enumerate-fonts)))
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (let* ((str (cffi:foreign-string-to-lisp ptr))
             (len (length str))
             (result nil))
        (when (and (> len 2)
                   (char= (char str 0) #\[)
                   (char= (char str (1- len)) #\]))
          (let ((inner (subseq str 1 (1- len))))
            (unless (zerop (length inner))
              (loop with start = 0
                    do (let ((qpos (position #\" inner :start start)))
                         (unless qpos (loop-finish))
                         (let ((end (position #\" inner :start (1+ qpos))))
                           (unless end (loop-finish))
                           (push (subseq inner (1+ qpos) end) result)
                           (setf start (1+ end)))))
              (nreverse result))))))))

(defun font-info (name)
  (let ((ptr (%query-font-info name)))
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (let* ((str (cffi:foreign-string-to-lisp ptr))
             (name-start (and str (search "\"name\":\"" str)))
             (key-start (and str (search "\"key\":\"" str))))
        (when (and name-start key-start)
          (let ((name-end (position #\" str :start (+ name-start 8)))
                (key-end (position #\" str :start (+ key-start 7))))
            (list :name (when name-end (subseq str (+ name-start 8) name-end))
                  :key (when key-end (subseq str (+ key-start 7) key-end)))))))))

(defun make-ais-text-label (text &key position color font height)
  (let* ((ptr (%ais-text-label-create text))
         (label (when (and ptr (not (cffi:null-pointer-p ptr)))
                  (make-instance 'ais-text-label :ptr ptr))))
    (when label
      (when position
        (%ais-text-label-set-position ptr
                                      (coerce (first position) 'double-float)
                                      (coerce (second position) 'double-float)
                                      (coerce (third position) 'double-float)))
      (when color
        (%ais-text-label-set-color ptr
                                   (coerce (first color) 'double-float)
                                   (coerce (second color) 'double-float)
                                   (coerce (third color) 'double-float)))
      (when font
        (%ais-text-label-set-font ptr font (coerce (or height 12) 'double-float)))
      (when (and height (not font))
        (%ais-text-label-set-height ptr (coerce height 'double-float)))
      (setf (slot-value label 'text) text
            (slot-value label 'position) position
            (slot-value label 'color) color)
      (tg:finalize label (lambda () (ais-free-text-label label))))
    label))

(defun ais-free-text-label (label)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-free ptr)
        (setf (slot-value label '%ptr) (cffi:null-pointer))))))

(defun (setf ais-text-label-text) (new-text label)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr))
                 new-text)
        (%ais-text-label-set-text ptr new-text))
      (setf (slot-value label 'text) new-text))))

(defun (setf ais-text-label-position) (new-pos label)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr))
                 new-pos (listp new-pos) (= (length new-pos) 3))
        (%ais-text-label-set-position ptr
                                      (coerce (first new-pos) 'double-float)
                                      (coerce (second new-pos) 'double-float)
                                      (coerce (third new-pos) 'double-float)))
      (setf (slot-value label 'position) new-pos))))

(defun (setf ais-text-label-color) (new-color label)
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr))
                 new-color (listp new-color) (= (length new-color) 3))
        (%ais-text-label-set-color ptr
                                   (coerce (first new-color) 'double-float)
                                   (coerce (second new-color) 'double-float)
                                   (coerce (third new-color) 'double-float)))
      (setf (slot-value label 'color) new-color))))

(defun text-glyph-as-shape (font codepoint)
  (when font
    (let ((ptr (%font-render-glyph (%ptr font) codepoint)))
      (make-shape ptr))))

(defun text-glyph-as-shape-3d (font codepoint depth)
  (unless (and font (> (coerce depth 'double-float) 0))
    (return-from text-glyph-as-shape-3d nil))
  (let ((flat (text-glyph-as-shape font codepoint)))
    (when flat
      (make-prism flat 0 0 (coerce depth 'double-float)))))

(defun text-font-ascender (font)
  (when font
    (%font-ascender (%ptr font))))

(defun text-font-descender (font)
  (when font
    (%font-descender (%ptr font))))

(defun text-font-line-spacing (font)
  (when font
    (%font-line-spacing (%ptr font))))

(defun text-font-advance-x (font c1 c2)
  (when font
    (%font-advance-x (%ptr font) c1 c2)))

(defun text-font-advance-y (font c1 c2)
  (when font
    (%font-advance-y (%ptr font) c1 c2)))

(defun text-font-set-width-scaling (font scale)
  (when font
    (%font-set-width-scaling (%ptr font) (coerce scale 'double-float))))

(defun text-font-set-composite-curve-mode (font on)
  (when font
    (%font-set-composite-curve-mode (%ptr font) (if on 1 0))))

(defun %split-lines (text)
  (loop with start = 0
        for pos = (position #\Newline text :start start)
        collect (subseq text start pos)
        while pos
        do (setf start (1+ pos))))

(defun make-multi-line-text (font text &key (h-align :left) (v-align :bottom)
                                              position normal
                                              (line-spacing (text-font-line-spacing font)))
  (when font
    (let* ((lines (%split-lines text))
           (line-height (or line-spacing (text-font-line-spacing font) 1.0d0))
           (shapes (loop for line in lines
                         for i from 0
                         for y-off = (- (* i line-height))
                         for line-shape = (make-text-shape font line
                                                           :h-align h-align
                                                           :v-align v-align
                                                           :position position
                                                           :normal normal)
                         when line-shape
                         collect (if (zerop y-off)
                                     line-shape
                                     (translate line-shape 0 y-off 0)))))
      (when shapes
        (if (= (length shapes) 1)
            (first shapes)
            (make-compound shapes))))))

(defun make-formatted-text (font text &key (h-align :left) (v-align :bottom)
                                              position normal
                                              (line-spacing (text-font-line-spacing font)))
  (make-multi-line-text font text
                        :h-align h-align :v-align v-align
                        :position position :normal normal
                        :line-spacing (or line-spacing (text-font-line-spacing font) 1.0d0)))

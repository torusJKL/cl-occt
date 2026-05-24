(in-package :cl-occt)

(defclass brep-font ()
  ((%ptr :initarg :ptr :reader %ptr)))

(defun brep-font-p (obj)
  "Return `t` if **obj** is a BREP font object.

  Checks whether the argument is an instance of the BREP font class,
  which represents TrueType/OpenType fonts loaded for 3D text extrusion.

  **See also:** `make-brep-font-from-file`, `make-brep-font-from-name`"
  (typep obj 'brep-font))

(defclass ais-text-label ()
  ((%ptr :initarg :ptr :reader %ptr)
   (text :initform nil :reader ais-text-label-text)
   (position :initform nil :reader ais-text-label-position)
   (color :initform nil :reader ais-text-label-color)))

(defun ais-text-label-p (obj)
  "Return `t` if **obj** is an AIS text label object.

  Checks whether the argument is an instance of the text label class,
  which represents interactive 3D text annotations in the viewer.

  **See also:** `make-ais-text-label`, `ais-free-text-label`"
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
  "Load a TrueType or OpenType font from a file path.

  Returns a BREP font object for use with text shaping functions,
  or `nil` if the font could not be loaded.  **size** specifies the nominal
  font size in mm.  **face-id** selects a specific font face from font
  collections (e.g., .ttc files).

  **Example:**

    (let ((font (make-brep-font-from-file \"/usr/share/fonts/truetype/arial.ttf\" 10)))
      (when font
        (make-text-shape font \"Hello\")))

  **See also:** `make-brep-font-from-name`, `make-text-shape`, `make-text-shape-3d`"
  (make-brep-font (%make-brep-font-from-file path
                                             (coerce size 'double-float)
                                             face-id)))

(defun make-brep-font-from-name (name size &key (aspect :regular))
  "Load a font by its system name.

  Looks up the font named **name** in the system font database and returns
  a BREP font object, or `nil` if the font is not found.  **size** is the
  nominal size in mm.  **aspect** selects the font variant: `:regular`, `:bold`,
  `:italic`, or `:bold-italic`.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10 :aspect :bold)))
      (when font
        (make-text-shape font \"Hello\")))

  **See also:** `make-brep-font-from-file`, `make-text-shape`, `list-available-fonts`"
  (make-brep-font (%make-brep-font-from-name name
                                              (%font-aspect-value aspect)
                                              (coerce size 'double-float))))

(defun make-text-shape (font text &key (h-align :left) (v-align :bottom)
                                              position normal)
  "Create a flat 2D text shape from **font** and **text** string.

  Returns a shape containing the outline of the rendered text.
  **h-align** controls horizontal alignment (`:left`, `:center`, `:right`).
  **v-align** controls vertical alignment (`:bottom`, `:center`, `:top`,
  `:top-first-line`).  **position** is a 3-element list (X Y Z); **normal**
  is a 3-element list specifying the plane normal.  Returns `nil` if
  **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (make-text-shape font \"Hello\" :h-align :center :position '(0 0 0)))

  **See also:** `make-text-shape-3d`, `make-text-shape-on-plane`, `make-brep-font-from-name`"
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
  "Create an extruded 3D text shape from **font** and **text**.

  Extrudes the flat text outline by **depth** along Z to create a solid.
  Returns `nil` if **font** is null or **depth** is not positive.  All keyword
  arguments are forwarded to `make-text-shape`.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (make-text-shape-3d font \"Hello\" 5 :h-align :center))

  **See also:** `make-text-shape`, `make-text-shape-on-plane`, `make-prism`"
  (unless (and font (> (coerce depth 'double-float) 0))
    (return-from make-text-shape-3d nil))
  (let ((flat (make-text-shape font text
                               :h-align h-align :v-align v-align
                               :position position :normal normal)))
    (when flat
      (make-prism flat 0 0 (coerce depth 'double-float)))))

(defun make-text-shape-on-plane (font text &key (h-align :left) (v-align :bottom)
                                                   (position '(0 0 0)) (normal '(0 0 1)))
  "Create a flat text shape positioned on a plane.

  Convenience wrapper around `make-text-shape` that specifies both
  **position** and **normal** explicitly, defaulting to the XY plane at
  the origin.  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (make-text-shape-on-plane font \"Hello\"
                                :position '(10 20 0) :normal '(0 0 1)))

  **See also:** `make-text-shape`, `make-text-shape-3d`"
  (make-text-shape font text
                   :h-align h-align :v-align v-align
                   :position position :normal normal))

(defun text-bounding-box (font text &key (h-align :left) (v-align :bottom))
  "Compute the bounding box width and height of **text** in **font**.

  Returns two values: **width** and **height** in mm, or `nil` if **font** is null
  or the text is empty.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-bounding-box font \"Hello\"))

  **See also:** `text-font-ascender`, `text-font-descender`"
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
  "List all fonts available in the system font database.

  Returns a list of font name strings, or `nil` if no fonts are found
  or the font database is unavailable.

  **Example:**

    (list-available-fonts)

  **See also:** `font-info`, `make-brep-font-from-name`"
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
  "Query information about a font by name.

  Returns a plist with `:name` and `:key` for the font, or `nil` if the
  font is not found in the system database.

  **Example:**

    (font-info \"Arial\")

  **See also:** `list-available-fonts`, `make-brep-font-from-name`"
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
  "Create an AIS interactive text label for display in the viewer.

  Returns a text label object, or `nil` if creation fails.  **position**
  is a 3-element list (X Y Z).  **color** is an RGB list (R G B) with
  components in [0, 1].  **font** is a BREP font object; **height** is the
  text height in mm (default 12).

  The label is finalized with `ais-free-text-label` when garbage
  collected.

  **Example:**

    (let ((label (make-ais-text-label \"Hello\"
                                       :position '(0 0 0)
                                       :color '(1 0 0))))
      (ais-display label))

  **See also:** `ais-free-text-label`, `(setf ais-text-label-text)`,
  `(setf ais-text-label-position)`, `(setf ais-text-label-color)`"
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
  "Free the native resources held by an AIS text label.

  After calling this, **label** should not be used.  This is called
  automatically by the garbage collector via finalization.

  **Example:**

    (let ((label (make-ais-text-label \"Temp\")))
      (ais-free-text-label label))

  **See also:** `make-ais-text-label`"
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%ais-text-label-free ptr)
        (setf (slot-value label '%ptr) (cffi:null-pointer))))))

(defun (setf ais-text-label-text) (new-text label)
  "Set the text content of an AIS text label.

  Updates both the Lisp slot and the underlying OCCT label.
  Returns the new text string, or `nil` if **label** is invalid.

  **Example:**

    (let ((label (make-ais-text-label \"Old\")))
      (setf (ais-text-label-text label) \"New\"))

  **See also:** `make-ais-text-label`, `(setf ais-text-label-position)`,
  `(setf ais-text-label-color)`"
  (when (ais-text-label-p label)
    (let ((ptr (%ptr label)))
      (when (and ptr (not (cffi:null-pointer-p ptr))
                 new-text)
        (%ais-text-label-set-text ptr new-text))
      (setf (slot-value label 'text) new-text))))

(defun (setf ais-text-label-position) (new-pos label)
  "Set the 3D position of an AIS text label.

  **new-pos** is a 3-element list (X Y Z).  Updates both the Lisp slot
  and the underlying OCCT label.  Returns **new-pos** or `nil` if **label**
  is invalid.

  **Example:**

    (let ((label (make-ais-text-label \"Text\" :position '(0 0 0))))
      (setf (ais-text-label-position label) '(10 20 30)))

  **See also:** `make-ais-text-label`, `(setf ais-text-label-text)`,
  `(setf ais-text-label-color)`"
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
  "Set the color of an AIS text label.

  **new-color** is an RGB list (R G B) with components in [0, 1].
  Updates both the Lisp slot and the underlying OCCT label.
  Returns **new-color** or `nil` if **label** is invalid.

  **Example:**

    (let ((label (make-ais-text-label \"Text\")))
      (setf (ais-text-label-color label) '(1 0 0)))

  **See also:** `make-ais-text-label`, `(setf ais-text-label-text)`,
  `(setf ais-text-label-position)`"
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
  "Render a single glyph by Unicode code point as a flat shape.

  Returns a shape object containing the outline of the specified
  glyph, or `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-glyph-as-shape font (char-code #\\A)))

  **See also:** `text-glyph-as-shape-3d`, `make-text-shape`,
  `text-font-advance-x`, `text-font-advance-y`"
  (when font
    (let ((ptr (%font-render-glyph (%ptr font) codepoint)))
      (make-shape ptr))))

(defun text-glyph-as-shape-3d (font codepoint depth)
  "Render a single glyph as an extruded 3D shape.

  Extrudes the glyph outline by **depth** along Z.  Returns `nil` if
  **font** is null or **depth** is not positive.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-glyph-as-shape-3d font (char-code #\\A) 5))

  **See also:** `text-glyph-as-shape`, `make-text-shape-3d`"
  (unless (and font (> (coerce depth 'double-float) 0))
    (return-from text-glyph-as-shape-3d nil))
  (let ((flat (text-glyph-as-shape font codepoint)))
    (when flat
      (make-prism flat 0 0 (coerce depth 'double-float)))))

(defun text-font-ascender (font)
  "Return the ascender value of **font** in mm.

  The ascender is the distance from the baseline to the top of the
  tallest glyph.  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-ascender font))

  **See also:** `text-font-descender`, `text-font-line-spacing`,
  `text-bounding-box`"
  (when font
    (%font-ascender (%ptr font))))

(defun text-font-descender (font)
  "Return the descender value of **font** in mm.

  The descender is the distance from the baseline to the bottom of
  the lowest glyph (typically negative).  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-descender font))

  **See also:** `text-font-ascender`, `text-font-line-spacing`,
  `text-bounding-box`"
  (when font
    (%font-descender (%ptr font))))

(defun text-font-line-spacing (font)
  "Return the recommended line spacing of **font** in mm.

  This is the distance from baseline to baseline for consecutive
  lines of text.  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-line-spacing font))

  **See also:** `text-font-ascender`, `text-font-descender`,
  `make-multi-line-text`"
  (when font
    (%font-line-spacing (%ptr font))))

(defun text-font-advance-x (font c1 c2)
  "Return the horizontal advance from character **c1** to **c2** in **font**.

  Returns the kerning-adjusted X advance value in mm, taking into
  account the pair (**c1**, **c2**).  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-advance-x font (char-code #\\A) (char-code #\\B)))

  **See also:** `text-font-advance-y`, `text-font-ascender`,
  `text-font-line-spacing`"
  (when font
    (%font-advance-x (%ptr font) c1 c2)))

(defun text-font-advance-y (font c1 c2)
  "Return the vertical advance from character **c1** to **c2** in **font**.

  Returns the kerning-adjusted Y advance value in mm, typically 0
  for horizontal writing.  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-advance-y font (char-code #\\A) (char-code #\\B)))

  **See also:** `text-font-advance-x`, `text-font-ascender`,
  `text-font-line-spacing`"
  (when font
    (%font-advance-y (%ptr font) c1 c2)))

(defun text-font-set-width-scaling (font scale)
  "Set the width scaling factor for **font**.

  **scale** is a multiplier applied to glyph widths (1.0 = normal).
  Values > 1 widen glyphs; values < 1 narrow them.  Returns the
  scale value or `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-set-width-scaling font 2.0))

  **See also:** `text-font-set-composite-curve-mode`,
  `make-brep-font-from-name`"
  (when font
    (%font-set-width-scaling (%ptr font) (coerce scale 'double-float))))

(defun text-font-set-composite-curve-mode (font on)
  "Enable or disable composite curve mode for **font**.

  When **on** is `t`, glyph outlines are decomposed into simpler curves
  (lines and bezier arcs).  When `nil`, the original glyph outlines
  are used as-is.  Returns `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (text-font-set-composite-curve-mode font t))

  **See also:** `text-font-set-width-scaling`, `make-brep-font-from-name`"
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
  "Create a multi-line text shape by splitting **text** on newlines.

  Each line is rendered as a separate shape and arranged vertically
  with **line-spacing** between baselines (defaulting to the font's
  recommended line spacing).  Returns a compound shape, a single
  shape for one-line text, or `nil` if **font** is null.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (make-multi-line-text font \"Line 1\\nLine 2\\nLine 3\"
                            :h-align :center))

  **See also:** `make-formatted-text`, `make-text-shape`, `make-compound`"
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
  "Create a formatted multi-line text shape.

  Alias for `make-multi-line-text` with the same arguments.  Provided
  for API clarity when the text contains formatting markup.

  **Example:**

    (let ((font (make-brep-font-from-name \"Arial\" 10)))
      (make-formatted-text font \"Header\\n\\nBody text\"
                           :h-align :center :v-align :center))

  **See also:** `make-multi-line-text`, `make-text-shape`"
  (make-multi-line-text font text
                        :h-align h-align :v-align v-align
                        :position position :normal normal
                        :line-spacing (or line-spacing (text-font-line-spacing font) 1.0d0)))

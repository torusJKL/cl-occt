(in-package :cl-occt)

(defclass material ()
  ((%ambient :initarg :ambient :reader material-ambient)
   (%diffuse :initarg :diffuse :reader material-diffuse)
   (%specular :initarg :specular :reader material-specular)
   (%shininess :initarg :shininess :initform 0.5 :reader material-shininess)
   (%transparency :initarg :transparency :initform 0.0 :reader material-transparency)))

(defun material-p (obj)
  "Returns `t` if **obj** is a `material` instance."
  (typep obj 'material))

(defun make-material (&key (ambient '(0.2 0.2 0.2)) (diffuse '(0.8 0.8 0.8))
                        (specular '(1.0 1.0 1.0)) (shininess 0.5) (transparency 0.0))
  "Creates a `material` with the given component colors and properties.

  **ambient**, **diffuse**, and **specular** are (R G B) triples.
  **shininess** and **transparency** are in [0, 1].

  **Example:**

      (make-material :ambient '(0.1 0.1 0.1) :diffuse '(0.9 0.5 0.2) :shininess 0.8)"
  (make-instance 'material
    :ambient ambient :diffuse diffuse :specular specular
    :shininess shininess :transparency transparency))

(defparameter *material-presets*
  '(:brass :bronze :copper :gold :pewter :plastic :silver :steel :stone
    :shiny-plastic :satin :metalized :neon-phc :chrome :aluminium :obsidian
    :glass :jade :matte :shiny :default))

(defun material-preset-list ()
  "Returns the list of available material preset keyword names.

  **Example:**

      (material-preset-list)
      => (:BRASS :BRONZE :COPPER ...)"
  *material-presets*)

(defun ais-set-transparency (context obj value)
  "Sets the transparency of AIS object **obj** in **context**.

  **value** ranges from 0.0 (opaque) to 1.0 (fully transparent).

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-transparency ctx box 0.5))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-transparency ctx-ptr obj-ptr (coerce value 'double-float))
        obj))))

(defun ais-set-custom-material (context obj mat)
  "Applies a custom `material` **mat** to AIS object **obj** in **context**.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30)))
             (mat (make-material :diffuse '(0.9 0.5 0.2) :shininess 0.8)))
        (ais-set-custom-material ctx box mat))"
  (when (and (ais-context-p context) (ais-object-p obj) (material-p mat))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (let ((mat-ptr (%make-material
                        (coerce (first (material-ambient mat)) 'double-float)
                        (coerce (second (material-ambient mat)) 'double-float)
                        (coerce (third (material-ambient mat)) 'double-float)
                        (coerce (first (material-diffuse mat)) 'double-float)
                        (coerce (second (material-diffuse mat)) 'double-float)
                        (coerce (third (material-diffuse mat)) 'double-float)
                        (coerce (first (material-specular mat)) 'double-float)
                        (coerce (second (material-specular mat)) 'double-float)
                        (coerce (third (material-specular mat)) 'double-float)
                        (coerce (material-shininess mat) 'double-float)
                        (coerce (material-transparency mat) 'double-float))))
          (when (and mat-ptr (not (cffi:null-pointer-p mat-ptr)))
            (%ais-set-custom-material ctx-ptr obj-ptr mat-ptr)
            obj))))))

(defun ais-set-material (context obj material)
  "Applies a named preset material to AIS object **obj** in **context**.

  **material** is a keyword from `material-preset-list`.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-material ctx box :brass))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (let ((name (if (keywordp material)
                        (string-downcase (string material))
                        (return-from ais-set-material nil))))
          (when (plusp (%ais-set-material-by-name ctx-ptr obj-ptr name))
            obj))))))

(defun ais-set-line-width (context obj width)
  "Sets the line width for AIS object **obj** in **context**.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-line-width ctx box 2.0))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-line-width ctx-ptr obj-ptr (coerce width 'double-float))
        obj))))

(defun ais-show-edges (context obj on)
  "Shows or hides edges of AIS object **obj**.

  When **on** is `t`, edges are displayed. Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-show-edges ctx box t))"
  (declare (ignore context))
  (when (ais-object-p obj)
    (let ((obj-ptr (%ptr obj)))
      (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-edges-display obj-ptr (if on 1 0))
        obj))))

(defun ais-set-edge-styling (context obj &key color width)
  "Configures edge appearance for AIS object **obj**.

  **color** can be any color representation. **width** is a numeric line width.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-show-edges ctx box t)
        (ais-set-edge-styling ctx box :color :red :width 2.0))"
  (declare (ignore context))
  (when (ais-object-p obj)
    (let ((obj-ptr (%ptr obj)))
      (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
        (when color
          (let ((rgb (normalize-color color)))
            (when rgb
              (destructuring-bind (r g b) rgb
                (%ais-set-edge-color obj-ptr
                  (coerce r 'double-float)
                  (coerce g 'double-float)
                  (coerce b 'double-float))))))
        obj))))

(defparameter *selection-mode-map*
  '((:shape . 0) (:face . 1) (:edge . 2) (:vertex . 3)))

(defun ais-set-selection-mode (context obj mode)
  "Sets the selection mode for AIS object **obj** in **context**.

  **mode** is `:shape`, `:face`, `:edge`, `:vertex`, or an integer. Pass `nil` to deactivate.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selection-mode ctx box :edge))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj))
          (mode-int (if (keywordp mode)
                        (cdr (assoc mode *selection-mode-map*))
                        mode)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (if mode-int
            (%ais-set-selection-mode ctx-ptr obj-ptr mode-int)
            (%ais-deactivate-selection ctx-ptr obj-ptr))
        obj))))

(defun ais-set-tessellation (obj &key quality (deviation 0.001))
  "Sets the tessellation quality for AIS object **obj**.

  **quality** controls mesh resolution (higher = finer). **deviation** is max chord error.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-tessellation box :quality 0.5))"
  (when (ais-object-p obj)
    (let ((obj-ptr (%ptr obj)))
      (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-tessellation obj-ptr
          (coerce (or quality 0.1) 'double-float)
          (coerce deviation 'double-float))
        obj))))

;; --- Selection Management ---

(defun ais-set-selected (context obj &key (update t))
  "Selects **obj** in **context** (replaces current selection).

  When **update** is `nil`, the display is not refreshed immediately.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selected ctx box))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-set-selected ctx-ptr obj-ptr (if update 1 0))
        obj))))

(defun ais-add-or-remove-selected (context obj &key (update t))
  "Toggles selection state of **obj** in **context**.

  If **obj** is selected it becomes unselected, and vice versa.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-add-or-remove-selected ctx box))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-add-or-remove-selected ctx-ptr obj-ptr (if update 1 0))
        obj))))

(defun ais-clear-selected (context &key (update t))
  "Clears all selected objects in **context**.

  When **update** is `nil`, the display is not refreshed immediately.

  **Example:**

      (ais-clear-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-clear-selected ctx-ptr (if update 1 0))))))

(defun ais-is-selected (context obj)
  "Returns `t` if **obj** is currently selected in **context**.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selected ctx box)
        (ais-is-selected ctx box))
      => T"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (not (zerop (%ais-context-is-selected ctx-ptr obj-ptr)))))))

;; --- Selection Iteration ---

(defun ais-nb-selected (context)
  "Returns the number of selected objects in **context**.

  **Example:**

      (ais-nb-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-nb-selected ctx-ptr)))))

(defun ais-init-selected (context)
  "Initializes the selection iterator in **context**.

  **See also:** `ais-more-selected`, `ais-next-selected`

  **Example:**

      (ais-init-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-init-selected ctx-ptr)))))

(defun ais-more-selected (context)
  "Returns `t` if there are more selected objects in the iteration.

  **See also:** `ais-init-selected`, `ais-next-selected`

  **Example:**

      (ais-more-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-more-selected ctx-ptr)))))))

(defun ais-next-selected (context)
  "Advances the selection iterator and returns the next AIS object.

  **See also:** `ais-init-selected`, `ais-more-selected`

  **Example:**

      (ais-next-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-next-selected ctx-ptr)))))

(defun ais-selected-interactive (context)
  "Returns the current selected interactive object, or `nil`.

  **Example:**

      (ais-selected-interactive ctx)"
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-selected-interactive ctx-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun ais-selected-shape (context)
  "Returns the current selected shape, or `nil`.

  **Example:**

      (ais-selected-shape ctx)"
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-selected-shape ctx-ptr))))
      (make-shape ptr))))

(defun ais-has-selected-shape (context)
  "Returns `t` if there is a selected shape in **context**.

  **Example:**

      (ais-has-selected-shape ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-has-selected-shape ctx-ptr)))))))

(defun ais-selected-objects (context)
  "Return a list of all selected AIS objects.

  Iterates using `init-selected`/`more-selected`/`next-selected` internally.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selected ctx box)
        (ais-selected-objects ctx))"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (let ((result nil))
          (%ais-context-init-selected ctx-ptr)
          (loop while (not (zerop (%ais-context-more-selected ctx-ptr)))
                do (let* ((ptr (%ais-context-selected-interactive ctx-ptr))
                          (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                                 (let ((o (make-instance 'ais-object :ptr ptr)))
                                   (tg:finalize o (lambda () (ais-free o)))
                                   o))))
                     (when obj (push obj result)))
                (%ais-context-next-selected ctx-ptr))
          (nreverse result))))))

(defun ais-selected-shapes (context)
  "Return a list of all selected shapes.

  Iterates using `init-selected`/`more-selected`/`next-selected` internally.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selected ctx box)
        (ais-selected-shapes ctx))"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (let ((result nil))
          (%ais-context-init-selected ctx-ptr)
          (loop while (not (zerop (%ais-context-more-selected ctx-ptr)))
                do (let* ((ptr (%ais-context-selected-shape ctx-ptr))
                          (shape (make-shape ptr)))
                     (when shape (push shape result)))
                (%ais-context-next-selected ctx-ptr))
          (nreverse result))))))

;; --- Mouse Detection ---

(defun ais-move-to (context view x y)
  "Moves the mouse cursor to pixel coordinates (X Y) on **view** for detection.

  Used before `ais-select-detected` to select objects under the cursor.

  **Example:**

      (ais-move-to ctx view 100 200)"
  (when (and (ais-context-p context) (viewer-p view))
    (let ((ctx-ptr (%ptr context))
          (view-ptr (%view view)))
      (when (and ctx-ptr view-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p view-ptr)))
        (%ais-context-move-to ctx-ptr view-ptr x y)))))

(defun ais-select-detected (context &optional (scheme :replace))
  "Selects the object detected by the last `ais-move-to` call.

  **scheme** is `:replace`, `:add`, `:toggle`, `:remove`, or an integer.

  **Example:**

      (ais-move-to ctx view 100 200)
      (ais-select-detected ctx :add)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context))
          (scheme-int (if (keywordp scheme)
                          (cdr (assoc scheme *selection-scheme-map*))
                          scheme)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)) scheme-int)
        (%ais-context-select-detected ctx-ptr scheme-int)))))

(defun ais-select-point (context view x y &optional (scheme :replace))
  "Selects objects at pixel (X Y) by combining `ais-move-to` and `ais-select-detected`.

  **scheme** is `:replace`, `:add`, `:toggle`, `:remove`, or an integer.

  **Example:**

      (ais-select-point ctx view 100 200 :add)"
  (when (and (ais-context-p context) (viewer-p view))
    (let ((ctx-ptr (%ptr context))
          (view-ptr (%view view))
          (scheme-int (if (keywordp scheme)
                          (cdr (assoc scheme *selection-scheme-map*))
                          scheme)))
      (when (and ctx-ptr view-ptr scheme-int
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p view-ptr)))
        (%ais-context-select-point ctx-ptr view-ptr x y scheme-int)))))

;; --- Highlight & Configuration ---

(defun ais-hilight-selected (context &key (update t))
  "Highlights all selected objects in **context**.

  When **update** is `nil`, the display is not refreshed immediately.

  **Example:**

      (ais-hilight-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-hilight-selected ctx-ptr (if update 1 0))))))

(defun ais-unhilight-selected (context &key (update t))
  "Unhighlights all selected objects in **context**.

  When **update** is `nil`, the display is not refreshed immediately.

  **Example:**

      (ais-unhilight-selected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-unhilight-selected ctx-ptr (if update 1 0))))))

(defun ais-fit-selected (context view &optional (margin 0.01))
  "Fits **view** to show all selected objects with **margin** around them.

  **Example:**

      (ais-fit-selected ctx view 0.05)"
  (when (and (ais-context-p context) (viewer-p view))
    (let ((ctx-ptr (%ptr context))
          (view-ptr (%view view)))
      (when (and ctx-ptr view-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p view-ptr)))
        (%ais-context-fit-selected ctx-ptr view-ptr (coerce margin 'double-float))))))

(defun ais-detected-interactive (context)
  "Returns the interactive object detected by the last `ais-move-to`, or `nil`.

  **Example:**

      (ais-detected-interactive ctx)"
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-detected-interactive ctx-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun ais-has-detected (context)
  "Returns `t` if an object was detected by the last `ais-move-to` call.

  **Example:**

      (ais-has-detected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-has-detected ctx-ptr)))))))

(defun ais-clear-detected (context)
  "Clears the detected object state in **context**.

  **Example:**

      (ais-clear-detected ctx)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-clear-detected ctx-ptr)))))

(defun ais-set-selection-sensitivity (context obj mode sensitivity)
  "Sets selection sensitivity for a given selection **mode** on **obj**.

  **sensitivity** controls how close the cursor must be for selection.

  Returns **obj** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (ctx (ais-create-context v))
             (box (ais-create-shape ctx (make-box 10 20 30))))
        (ais-set-selection-sensitivity ctx box 2 5))"
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-set-selection-sensitivity ctx-ptr obj-ptr mode sensitivity)
        obj))))

(defun ais-set-pixel-tolerance (context pixels)
  "Sets the pixel tolerance for selection in **context**.

  **Example:**

      (ais-set-pixel-tolerance ctx 5)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-pixel-tolerance ctx-ptr pixels)))))

(defun ais-set-automatic-hilight (context on)
  "Enables or disables automatic highlighting of detected objects.

  **Example:**

      (ais-set-automatic-hilight ctx nil)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-automatic-hilight ctx-ptr (if on 1 0))))))

(defun ais-set-to-hilight-selected (context on)
  "Enables or disables highlighting of selected objects.

  **Example:**

      (ais-set-to-hilight-selected ctx t)"
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-to-hilight-selected ctx-ptr (if on 1 0))))))

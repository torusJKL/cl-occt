(in-package :cl-occt)

(defclass material ()
  ((%ambient :initarg :ambient :reader material-ambient)
   (%diffuse :initarg :diffuse :reader material-diffuse)
   (%specular :initarg :specular :reader material-specular)
   (%shininess :initarg :shininess :initform 0.5 :reader material-shininess)
   (%transparency :initarg :transparency :initform 0.0 :reader material-transparency)))

(defun material-p (obj) (typep obj 'material))

(defun make-material (&key (ambient '(0.2 0.2 0.2)) (diffuse '(0.8 0.8 0.8))
                        (specular '(1.0 1.0 1.0)) (shininess 0.5) (transparency 0.0))
  (make-instance 'material
    :ambient ambient :diffuse diffuse :specular specular
    :shininess shininess :transparency transparency))

(defparameter *material-presets*
  '(:brass :bronze :copper :gold :pewter :plastic :silver :steel :stone
    :shiny-plastic :satin :metalized :neon-phc :chrome :aluminium :obsidian
    :glass :jade :matte :shiny :default))

(defun material-preset-list ()
  *material-presets*)

(defun ais-set-transparency (context obj value)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-transparency ctx-ptr obj-ptr (coerce value 'double-float))
        obj))))

(defun ais-set-custom-material (context obj mat)
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
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-line-width ctx-ptr obj-ptr (coerce width 'double-float))
        obj))))

(defun ais-show-edges (context obj on)
  (declare (ignore context))
  (when (ais-object-p obj)
    (let ((obj-ptr (%ptr obj)))
      (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-edges-display obj-ptr (if on 1 0))
        obj))))

(defun ais-set-edge-styling (context obj &key color width)
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
  (when (ais-object-p obj)
    (let ((obj-ptr (%ptr obj)))
      (when (and obj-ptr (not (cffi:null-pointer-p obj-ptr)))
        (%ais-set-tessellation obj-ptr
          (coerce (or quality 0.1) 'double-float)
          (coerce deviation 'double-float))
        obj))))

;; --- Selection Management ---

(defun ais-set-selected (context obj &key (update t))
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-set-selected ctx-ptr obj-ptr (if update 1 0))
        obj))))

(defun ais-add-or-remove-selected (context obj &key (update t))
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-add-or-remove-selected ctx-ptr obj-ptr (if update 1 0))
        obj))))

(defun ais-clear-selected (context &key (update t))
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-clear-selected ctx-ptr (if update 1 0))))))

(defun ais-is-selected (context obj)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (not (zerop (%ais-context-is-selected ctx-ptr obj-ptr)))))))

;; --- Selection Iteration ---

(defun ais-nb-selected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-nb-selected ctx-ptr)))))

(defun ais-init-selected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-init-selected ctx-ptr)))))

(defun ais-more-selected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-more-selected ctx-ptr)))))))

(defun ais-next-selected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-next-selected ctx-ptr)))))

(defun ais-selected-interactive (context)
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-selected-interactive ctx-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun ais-selected-shape (context)
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-selected-shape ctx-ptr))))
      (make-shape ptr))))

(defun ais-has-selected-shape (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-has-selected-shape ctx-ptr)))))))

(defun ais-selected-objects (context)
  "Return a list of all selected AIS objects."
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
  "Return a list of all selected shapes."
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
  (when (and (ais-context-p context) (viewer-p view))
    (let ((ctx-ptr (%ptr context))
          (view-ptr (%view view)))
      (when (and ctx-ptr view-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p view-ptr)))
        (%ais-context-move-to ctx-ptr view-ptr x y)))))

(defun ais-select-detected (context &optional (scheme :replace))
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context))
          (scheme-int (if (keywordp scheme)
                          (cdr (assoc scheme *selection-scheme-map*))
                          scheme)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)) scheme-int)
        (%ais-context-select-detected ctx-ptr scheme-int)))))

(defun ais-select-point (context view x y &optional (scheme :replace))
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
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-hilight-selected ctx-ptr (if update 1 0))))))

(defun ais-unhilight-selected (context &key (update t))
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-unhilight-selected ctx-ptr (if update 1 0))))))

(defun ais-fit-selected (context view &optional (margin 0.01))
  (when (and (ais-context-p context) (viewer-p view))
    (let ((ctx-ptr (%ptr context))
          (view-ptr (%view view)))
      (when (and ctx-ptr view-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p view-ptr)))
        (%ais-context-fit-selected ctx-ptr view-ptr (coerce margin 'double-float))))))

(defun ais-detected-interactive (context)
  (when (ais-context-p context)
    (let* ((ctx-ptr (%ptr context))
           (ptr (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
                  (%ais-context-detected-interactive ctx-ptr))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((obj (make-instance 'ais-object :ptr ptr)))
          (tg:finalize obj (lambda () (ais-free obj)))
          obj)))))

(defun ais-has-detected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (not (zerop (%ais-context-has-detected ctx-ptr)))))))

(defun ais-clear-detected (context)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-clear-detected ctx-ptr)))))

(defun ais-set-selection-sensitivity (context obj mode sensitivity)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (%ais-context-set-selection-sensitivity ctx-ptr obj-ptr mode sensitivity)
        obj))))

(defun ais-set-pixel-tolerance (context pixels)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-pixel-tolerance ctx-ptr pixels)))))

(defun ais-set-automatic-hilight (context on)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-automatic-hilight ctx-ptr (if on 1 0))))))

(defun ais-set-to-hilight-selected (context on)
  (when (ais-context-p context)
    (let ((ctx-ptr (%ptr context)))
      (when (and ctx-ptr (not (cffi:null-pointer-p ctx-ptr)))
        (%ais-context-set-to-hilight-selected ctx-ptr (if on 1 0))))))

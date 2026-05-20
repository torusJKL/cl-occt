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

(defun ais-set-selection-mode (context obj mode)
  (when (and (ais-context-p context) (ais-object-p obj))
    (let ((ctx-ptr (%ptr context))
          (obj-ptr (%ptr obj)))
      (when (and ctx-ptr obj-ptr
                 (not (cffi:null-pointer-p ctx-ptr))
                 (not (cffi:null-pointer-p obj-ptr)))
        (if mode
            (%ais-set-selection-mode ctx-ptr obj-ptr mode)
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

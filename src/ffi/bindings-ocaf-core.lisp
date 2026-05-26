(in-package :cl-occt.impl)

;; --- OCAF Document Lifecycle ---

(defcfun (%ocaf-new-doc "ocaf_new_doc") :pointer)

(defcfun (%ocaf-free-doc "ocaf_free_doc") :void
  (doc :pointer))

;; --- Label Tree Navigation ---

(defcfun (%ocaf-root-label "ocaf_root_label") :pointer
  (doc :pointer))

(defcfun (%ocaf-find-label "ocaf_find_label") :pointer
  (doc :pointer)
  (tags :pointer)
  (count :int)
  (create :int))

(defcfun (%ocaf-label-tag "ocaf_label_tag") :int
  (label :pointer))

(defcfun (%ocaf-label-depth "ocaf_label_depth") :int
  (label :pointer))

(defcfun (%ocaf-label-children "ocaf_label_children") :pointer
  (label :pointer)
  (out-count :pointer))

;; --- Transactions ---

(defcfun (%ocaf-begin-transaction "ocaf_begin_transaction") :void
  (doc :pointer)
  (name :string))

(defcfun (%ocaf-commit-transaction "ocaf_commit_transaction") :void
  (doc :pointer))

(defcfun (%ocaf-undo-transaction "ocaf_undo_transaction") :void
  (doc :pointer))

;; --- Attributes — Integer ---

(defcfun (%ocaf-set-integer "ocaf_set_integer") :void
  (label :pointer)
  (value :int))

(defcfun (%ocaf-get-integer "ocaf_get_integer") :int
  (label :pointer))

(defcfun (%ocaf-has-integer "ocaf_has_integer") :int
  (label :pointer))

;; --- Attributes — Real ---

(defcfun (%ocaf-set-real "ocaf_set_real") :void
  (label :pointer)
  (value :double))

(defcfun (%ocaf-get-real "ocaf_get_real") :double
  (label :pointer))

(defcfun (%ocaf-has-real "ocaf_has_real") :int
  (label :pointer))

;; --- Attributes — String ---

(defcfun (%ocaf-set-string "ocaf_set_string") :void
  (label :pointer)
  (value :string))

(defcfun (%ocaf-get-string "ocaf_get_string") :string
  (label :pointer))

(defcfun (%ocaf-has-string "ocaf_has_string") :int
  (label :pointer))

;; --- Attributes — Name ---

(defcfun (%ocaf-set-name "ocaf_set_name") :void
  (label :pointer)
  (name :string))

(defcfun (%ocaf-get-name "ocaf_get_name") :string
  (label :pointer))

;; --- Resource Management ---

(defcfun (%ocaf-free-label "ocaf_free_label") :void
  (label :pointer))

(defcfun (%ocaf-free-label-array "ocaf_free_label_array") :void
  (labels :pointer)
  (count :int))

(defcfun (%ocaf-free-string "ocaf_free_string") :void
  (str :string))

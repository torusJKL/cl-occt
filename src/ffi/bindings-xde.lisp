(in-package :cl-occt.impl)

;; --- XDE Document Lifecycle ---

(defcfun (%xde-new-doc "xde_new_doc") :pointer)

(defcfun (%xde-free-doc "xde_free_doc") :void
  (doc :pointer))

(defcfun (%xde-read-step "xde_read_step") :pointer
  (filename :string))

(defcfun (%xde-write-step "xde_write_step") :int
  (doc :pointer)
  (filename :string))

;; --- Label Navigation ---

(defcfun (%xde-get-root-count "xde_get_root_count") :int
  (doc :pointer))

(defcfun (%xde-get-root-path "xde_get_root_path") :void
  (doc :pointer)
  (index :int)
  (buf :pointer)
  (buf-size :int))

(defcfun (%xde-get-child-count "xde_get_child_count") :int
  (doc :pointer)
  (path :string))

(defcfun (%xde-get-child-path "xde_get_child_path") :void
  (doc :pointer)
  (parent-path :string)
  (index :int)
  (buf :pointer)
  (buf-size :int))

;; --- Attribute Read ---

(defcfun (%xde-get-shape-at "xde_get_shape_at") :pointer
  (doc :pointer)
  (path :string))

(defcfun (%xde-get-name-at "xde_get_name_at") :void
  (doc :pointer)
  (path :string)
  (buf :pointer)
  (buf-size :int))

(defcfun (%xde-get-color-at "xde_get_color_at") :int
  (doc :pointer)
  (path :string)
  (type :pointer)
  (r :pointer)
  (g :pointer)
  (b :pointer)
  (a :pointer))

(defcfun (%xde-get-location-at "xde_get_location_at") :int
  (doc :pointer)
  (path :string)
  (matrix :pointer))

;; --- Attribute Write ---

(defcfun (%xde-add-part "xde_add_part") :void
  (doc :pointer)
  (parent-path :string)
  (shape :pointer)
  (name :string)
  (color-type :int)
  (r :double)
  (g :double)
  (b :double)
  (a :double)
  (matrix :pointer)
  (buf :pointer)
  (buf-size :int))

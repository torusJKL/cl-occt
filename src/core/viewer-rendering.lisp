(in-package :cl-occt)

(defparameter *transparency-method-map*
  '((:blend-unordered . 0) (:blend-oit . 1) (:depth-peeling-oit . 2)))

(defparameter *back-face-model-map*
  '((:auto . 0) (:force . 1) (:disable . 2)))

(defun set-computed-mode (view on)
  "Enables or disables computed mode for **view**.

  When **on** is `t`, OCCT recalculates the display each frame.

  **Example:**
    (with-viewer (v)
      (set-computed-mode v t))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-computed-mode view-ptr (if on 1 0))
        view))))

(defun computed-mode-p (view)
  "Returns `t` if computed mode is enabled for **view**.

  **Example:**
    (with-viewer (v)
      (set-computed-mode v t)
      (computed-mode-p v))
    => `t`"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (not (zerop (%v3d-view-computed-mode view-ptr)))))))

(defun set-back-face-model (view model)
  "Sets the back-face rendering model.

  **model** is one of `:auto`, `:force`, or `:disable`.

  **Example:**
    (with-viewer (v)
      (set-back-face-model v :force))"
  (when (viewer-p view)
    (let ((mode-int (cdr (assoc model *back-face-model-map*)))
          (view-ptr (%view view)))
      (when (and mode-int view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-back-face-model view-ptr mode-int)
        view))))

(defun set-transparency-method (view method)
  "Sets the transparency rendering method for **view**.

  - **view** — a viewer object
  - **method** — one of `:blend-unordered`, `:blend-oit`, or `:depth-peeling-oit`

  **Returns:** **view** on success, `nil` on error.

  **Example:**
    (with-viewer (v)
      (set-transparency-method v :blend-oit))"
  (when (viewer-p view)
    (let ((method-int (cdr (assoc method *transparency-method-map*)))
          (view-ptr (%view view)))
      (when (and method-int view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-transparency-method view-ptr method-int)
        view))))

(defun set-frustum-culling (view on)
  "Enables or disables frustum culling for **view**.

  When **on** is `t`, objects outside the view frustum are not drawn.

  **Example:**
    (with-viewer (v)
      (set-frustum-culling v t))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-frustum-culling view-ptr (if on 1 0))
        view))))

(defun redraw-view (view)
  "Immediately redraws the view.

  **Example:**
    (with-viewer (v)
      (redraw-view v))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-redraw view-ptr)
        view))))

(defun set-immediate-update (view on)
  "Enables or disables immediate update mode.

  When **on** is `t`, the view is updated immediately after changes.

  **Example:**
    (with-viewer (v)
      (set-immediate-update v t))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-immediate-update view-ptr (if on 1 0))
        view))))

(defun set-transparent-shading (view method)
  "Alias for `set-transparency-method`.

  - **view** — a viewer object
  - **method** — a transparency method keyword (same as `set-transparency-method`)

  **Returns:** **view** on success, `nil` on error.

  **Example:**
    (with-viewer (v)
      (set-transparent-shading v :depth-peeling-oit))"
  (set-transparency-method view method))

(in-package :cl-occt)

(defun grid-active-p (viewer)
  "Returns `t` if the grid is currently active for **viewer**.

  **Example:**
    (with-viewer (v)
      (activate-grid v :rectangular :lines)
      (grid-active-p v))
    => `t`"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (not (zerop (%v3d-viewer-grid-active v-ptr)))))))

(defun set-grid-xy-size (viewer x-step y-step)
  "Sets the grid spacing in the X and Y directions.

  **Example:**
    (with-viewer (v)
      (set-grid-xy-size v 5.0 5.0))"
  (set-rectangular-grid-values viewer :x-step x-step :y-step y-step))

(defun set-grid-offset (viewer x-offset y-offset)
  "Sets the grid origin offset in the X and Y directions.

  **Example:**
    (with-viewer (v)
      (set-grid-offset v 10.0 10.0))"
  (set-rectangular-grid-values viewer :x-origin x-offset :y-origin y-offset))

(defun set-rectangular-grid-values (viewer &key (x-origin 0.0) (y-origin 0.0) (x-step 10.0) (y-step 10.0) (rotation-angle 0.0))
  "Configures the rectangular grid parameters.

  Sets origin, step size, and rotation angle.  Returns **viewer**
  on success.

  **Example:**
    (with-viewer (v)
      (set-rectangular-grid-values v :x-step 5.0 :y-step 5.0))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-set-rectangular-grid-values v-ptr
          (coerce x-origin 'double-float)
          (coerce y-origin 'double-float)
          (coerce x-step 'double-float)
          (coerce y-step 'double-float)
          (coerce rotation-angle 'double-float))
        viewer))))

(defun grid-display (view &key (color '(0.5 0.5 0.5)) (size-x 10.0) (size-y 10.0))
  "Displays the grid on **view** with the given **color** and **size**.

  Returns **view** on success.

  **Example:**
    (with-viewer (v)
      (grid-display v :color '(0.8 0.8 0.8) :size-x 20.0 :size-y 20.0))"
  (when (viewer-p view)
    (let ((rgb (normalize-color color))
          (view-ptr (%view view)))
      (when (and rgb view-ptr (not (cffi:null-pointer-p view-ptr)))
        (destructuring-bind (r g b) rgb
          (%v3d-view-grid-display view-ptr
            (coerce r 'double-float) (coerce g 'double-float) (coerce b 'double-float)
            (coerce size-x 'double-float) (coerce size-y 'double-float)))
        view))))

(defun set-grid-color (viewer color)
  "Sets the grid color.  **color** is an RGB list (r g b).

  **Example:**
    (with-viewer (v)
      (set-grid-color v '(1.0 0.0 0.0)))"
  (grid-display viewer :color color))

(defun set-grid-size (viewer size)
  "Sets the grid spacing equally in X and Y.

  **Example:**
    (with-viewer (v)
      (set-grid-size v 5.0))"
  (set-grid-xy-size viewer size size))

(defun grid-color (viewer)
  "Returns the current grid color as an RGB list.

  Note: currently returns `nil` (not yet implemented).

  **Example:**
    (with-viewer (v)
      (grid-color v))"
  (declare (ignore viewer))
  nil)

(defun grid-size (viewer)
  "Returns the current grid size.

  Note: currently returns `nil` (not yet implemented).

  **Example:**
    (with-viewer (v)
      (grid-size v))"
  (declare (ignore viewer))
  nil)

(defun grid-offset (viewer)
  "Returns the current grid offset.

  Note: currently returns `nil` (not yet implemented).

  **Example:**
    (with-viewer (v)
      (grid-offset v))"
  (declare (ignore viewer))
  nil)

(in-package :cl-occt)

(defparameter *gradient-style-map*
  '((:x-pos . 0) (:x-neg . 1) (:y-pos . 2) (:y-neg . 3) (:z-pos . 4) (:z-neg . 5)))

(defun set-gradient-background (view &key color1 color2 (style :y-pos))
  "Sets a gradient background from **color1** to **color2**.

  **style** is one of `:x-pos`, `:x-neg`, `:y-pos`, `:y-neg`, `:z-pos`, `:z-neg`.

  **Example:**
    (with-viewer (v)
      (set-gradient-background v
        :color1 '(0.1 0.1 0.3)
        :color2 '(0.8 0.8 0.9)))"
  (when (viewer-p view)
    (let* ((rgb1 (normalize-color (or color1 '(0.1 0.1 0.3))))
           (rgb2 (normalize-color (or color2 '(0.8 0.8 0.9))))
           (style-int (or (cdr (assoc style *gradient-style-map*)) 2))
           (view-ptr (%view view)))
      (when (and rgb1 rgb2 view-ptr (not (cffi:null-pointer-p view-ptr)))
        (destructuring-bind (r1 g1 b1) rgb1
          (destructuring-bind (r2 g2 b2) rgb2
            (%v3d-view-set-bg-gradient view-ptr
              (coerce r1 'double-float) (coerce g1 'double-float) (coerce b1 'double-float)
              (coerce r2 'double-float) (coerce g2 'double-float) (coerce b2 'double-float)
              style-int)))
        view))))

(defun set-background-cubemap (view &key pos-x neg-x pos-y neg-y pos-z neg-z)
  "Sets a cubemap background from six image file paths.

  Each keyword argument is a path to an image file for that face.

  **Example:**
    (with-viewer (v)
      (set-background-cubemap v
        :pos-x \"/path/to/pos-x.jpg\" :neg-x \"/path/to/neg-x.jpg\"
        :pos-y \"/path/to/pos-y.jpg\" :neg-y \"/path/to/neg-y.jpg\"
        :pos-z \"/path/to/pos-z.jpg\" :neg-z \"/path/to/neg-z.jpg\"))"
  (when (viewer-p view)
    (let* ((strings (list pos-x neg-x pos-y neg-y pos-z neg-z))
           (cffi-vec (cffi:foreign-alloc :pointer :initial-contents
                       (mapcar #'cffi:foreign-string-alloc strings)))
           (ptr (%make-cubemap-separate cffi-vec 6)))
      (dotimes (i 6)
        (cffi:foreign-free (cffi:mem-aref cffi-vec :pointer i)))
      (cffi:foreign-free cffi-vec)
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((view-ptr (%view view)))
          (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
            (%v3d-view-set-bg-cubemap view-ptr ptr))))
      ;; Note: cubemap handle is intentionally NOT freed here.
      ;; OCCT's V3d_View keeps a reference to it via SetBackgroundCubeMap.
      ;; The cubemap will be freed when the viewer is destroyed.
      view)))

;; (defun set-background-cubemap () already returns view)

(defun set-image-background (view path)
  "Sets a single image as the view background.

  **path** is a string path to an image file.

  **Example:**
    (with-viewer (v)
      (set-image-background v \"/path/to/background.jpg\"))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-set-bg-image view-ptr path)
        view))))

(defun reset-background (view)
  "Resets the background to the default solid color.

  **Example:**
    (with-viewer (v)
      (set-gradient-background v)
      (reset-background v))"
  (when (viewer-p view)
    (let ((view-ptr (%view view)))
      (when (and view-ptr (not (cffi:null-pointer-p view-ptr)))
        (%v3d-view-reset-background view-ptr)
        view))))

(defun set-cube-map (view &key pos-x neg-x pos-y neg-y pos-z neg-z)
  "Alias for `set-background-cubemap`.

  **Example:**
    (with-viewer (v)
      (set-cube-map v :pos-x \"/path/to/pos-x.jpg\" :neg-x \"/path/to/neg-x.jpg\"))"
  (set-background-cubemap view
    :pos-x pos-x :neg-x neg-x
    :pos-y pos-y :neg-y neg-y
    :pos-z pos-z :neg-z neg-z))

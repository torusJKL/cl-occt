(in-package :cl-occt)

(defun make-pipe-feature (shape base-face profile path
                           &key (operation :cut))
  "Create a pipe feature (cut or add) along a `path` on a face.

  - **operation** `:cut` (default, depression) or `:add` (protrusion)

  Returns a new shape, or `nil` if any required argument is null.

  **Example:**

      (let* ((box (make-box 50 50 50))
             (faces (map-shape-subshapes box :face))
             (profile (let ((w (make-wire (make-edge -3 -3 3 -3)
                                          (make-edge 3 -3 3 3)
                                          (make-edge 3 3 -3 3)
                                          (make-edge -3 3 -3 -3))))
                        w))
             (path (make-wire (make-edge-3d 0 0 0 0 0 20))))
        (when faces
          (make-pipe-feature box (first faces) profile path :operation :cut)))

  **See also:** `make-prism-feature`, `make-revol-feature`"
  (if (or (null shape) (null base-face) (null profile) (null path))
      nil
      (let ((op-flag (if (eq operation :cut) 0 1)))
        (make-shape (%make-pipe-feature
                      (%ptr shape) (%ptr base-face) (%ptr profile)
                      (%ptr path) op-flag)))))

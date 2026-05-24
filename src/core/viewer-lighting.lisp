(in-package :cl-occt)

(defparameter *light-registry* (make-hash-table :test 'eq))

(defun %register-light (viewer light)
  (let* ((v-ptr (%viewer viewer))
         (lights (gethash v-ptr *light-registry*)))
    (pushnew light lights :test #'eq)
    (setf (gethash v-ptr *light-registry*) lights)))

(defun %deregister-light (viewer light)
  (let* ((v-ptr (%viewer viewer))
         (lights (gethash v-ptr *light-registry*)))
    (setf (gethash v-ptr *light-registry*)
          (remove light lights :test #'eq))))

(defclass viewer-light ()
  ((%ptr :initarg :ptr :reader %ptr)
   (%type :initarg :type :reader light-type)))

(defun viewer-light-p (obj)
  "Returns `t` if **obj** is a `viewer-light` instance."
  (typep obj 'viewer-light))

(defun make-light (type &key color intensity direction position)
  "Creates a `viewer-light` of the given **type**.

  **type** is `:ambient`, `:directional`, `:positional`, or `:spot`.
  **color** may be any color representation (default white).
  **intensity** defaults to 1.0.
  **direction** is a (DX DY DZ) list for directional/spot lights.
  **position** is an (X Y Z) list for positional/spot lights.

  **Example:**

      (make-light :ambient :color :warm-gray :intensity 0.3)
      (make-light :directional :color :white :direction '(0 0 -1))"
  (let* ((rgb (normalize-color (or color '(1 1 1))))
         (int-val (coerce (if intensity intensity 1.0) 'double-float)))
    (destructuring-bind (r g b) rgb
      (let ((ptr (ecase type
                   (:ambient
                    (%make-light-ambient
                     (coerce r 'double-float) (coerce g 'double-float)
                     (coerce b 'double-float) int-val))
                   (:directional
                    (let ((dir (or direction '(0 0 -1))))
                      (destructuring-bind (dx dy dz) dir
                        (%make-light-directional
                         (coerce r 'double-float) (coerce g 'double-float)
                         (coerce b 'double-float) int-val
                         (coerce dx 'double-float) (coerce dy 'double-float)
                         (coerce dz 'double-float)))))
                   (:positional
                    (let ((pos (or position '(0 0 0))))
                      (destructuring-bind (x y z) pos
                        (%make-light-positional
                         (coerce r 'double-float) (coerce g 'double-float)
                         (coerce b 'double-float) int-val
                         (coerce x 'double-float) (coerce y 'double-float)
                         (coerce z 'double-float)))))
                   (:spot
                    (let ((pos (or position '(0 0 0)))
                          (dir (or direction '(0 0 -1))))
                      (destructuring-bind (x y z) pos
                        (destructuring-bind (dx dy dz) dir
                          (%make-light-spot
                           (coerce r 'double-float) (coerce g 'double-float)
                           (coerce b 'double-float) int-val
                           (coerce x 'double-float) (coerce y 'double-float)
                           (coerce z 'double-float)
                           (coerce dx 'double-float) (coerce dy 'double-float)
                           (coerce dz 'double-float)
                           30.0d0 0.5d0))))))))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (let ((light (make-instance 'viewer-light :ptr ptr :type type)))
            (tg:finalize light (lambda () (%light-free ptr)))
            light))))))

(defun free-light (light)
  "Frees the C resource backing **light**.

  Normally not needed — lights are garbage-collected automatically.

  **Example:**

      (let ((l (make-light :ambient)))
        (free-light l))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-free ptr)
        (setf (slot-value light '%ptr) (cffi:null-pointer))))))

(defun viewer-add-light (viewer light)
  "Adds **light** to **viewer**. The light is registered and available for display.

  Returns **light** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (l (make-light :ambient)))
        (viewer-add-light v l)
        (free-viewer v))"
  (when (and (viewer-p viewer) (viewer-light-p light))
    (let ((v-ptr (%viewer viewer))
          (l-ptr (%ptr light)))
      (when (and v-ptr l-ptr (not (cffi:null-pointer-p v-ptr))
                 (not (cffi:null-pointer-p l-ptr)))
        (%v3d-viewer-add-light v-ptr l-ptr)
        (%register-light viewer light)
        light))))

(defun viewer-remove-light (viewer light)
  "Removes **light** from **viewer** and deregisters it.

  **Example:**

      (let* ((v (make-viewer))
             (l (make-light :ambient)))
        (viewer-add-light v l)
        (viewer-remove-light v l)
        (free-viewer v))"
  (when (and (viewer-p viewer) (viewer-light-p light))
    (let ((v-ptr (%viewer viewer))
          (l-ptr (%ptr light)))
      (when (and v-ptr l-ptr (not (cffi:null-pointer-p v-ptr))
                 (not (cffi:null-pointer-p l-ptr)))
        (%v3d-viewer-remove-light v-ptr l-ptr)
        (%deregister-light viewer light)))))

(defun viewer-light-on (viewer light)
  "Turns **light** on in **viewer**.

  Returns **light** on success, `nil` otherwise.

  **Example:**

      (let* ((v (make-viewer))
             (l (make-light :ambient)))
        (viewer-add-light v l)
        (viewer-light-on v l)
        (free-viewer v))"
  (when (and (viewer-p viewer) (viewer-light-p light))
    (let ((v-ptr (%viewer viewer))
          (l-ptr (%ptr light)))
      (when (and v-ptr l-ptr (not (cffi:null-pointer-p v-ptr))
                 (not (cffi:null-pointer-p l-ptr)))
        (%v3d-viewer-light-on v-ptr l-ptr)
        light))))

(defun viewer-light-off (viewer light)
  "Turns **light** off in **viewer**.

  **Example:**

      (let* ((v (make-viewer))
             (l (make-light :ambient)))
        (viewer-add-light v l)
        (viewer-light-off v l)
        (free-viewer v))"
  (when (and (viewer-p viewer) (viewer-light-p light))
    (let ((v-ptr (%viewer viewer))
          (l-ptr (%ptr light)))
      (when (and v-ptr l-ptr (not (cffi:null-pointer-p v-ptr))
                 (not (cffi:null-pointer-p l-ptr)))
        (%v3d-viewer-light-off v-ptr l-ptr)))))

(defun viewer-light-active-p (viewer light)
  "Returns `t` if **light** is currently active (on) in **viewer**.

  **Example:**

      (let* ((v (make-viewer))
             (l (make-light :ambient)))
        (viewer-add-light v l)
        (viewer-light-on v l)
        (viewer-light-active-p v l))
      => T"
  (when (and (viewer-p viewer) (viewer-light-p light))
    (let ((v-ptr (%viewer viewer))
          (l-ptr (%ptr light)))
      (when (and v-ptr l-ptr (not (cffi:null-pointer-p v-ptr))
                 (not (cffi:null-pointer-p l-ptr)))
        (not (zerop (%light-is-on l-ptr)))))))

(defun set-light-color (light color)
  "Sets the color of **light**. Returns **light** on success.

  **Example:**

      (let ((l (make-light :ambient)))
        (set-light-color l :warm-gray))"
  (when (viewer-light-p light)
    (let ((rgb (normalize-color color))
          (ptr (%ptr light)))
      (when (and rgb ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (r g b) rgb
          (%light-set-color ptr
            (coerce r 'double-float)
            (coerce g 'double-float)
            (coerce b 'double-float)))
        light))))

(defun set-light-intensity (light v)
  "Sets the intensity of **light** to **v** (0.0 to 1.0). Returns **light** on success.

  **Example:**

      (let ((l (make-light :ambient)))
        (set-light-intensity l 0.5))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-set-intensity ptr (coerce v 'double-float))
        light))))

(defun set-light-direction (light direction)
  "Sets the direction of **light** to (DX DY DZ). Returns **light** on success.

  **Example:**

      (let ((l (make-light :directional)))
        (set-light-direction l '(0 0 -1)))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (dx dy dz) direction
          (%light-set-direction ptr
            (coerce dx 'double-float)
            (coerce dy 'double-float)
            (coerce dz 'double-float)))
        light))))

(defun set-light-position (light position)
  "Sets the position of **light** to (X Y Z). Returns **light** on success.

  **Example:**

      (let ((l (make-light :positional)))
        (set-light-position l '(10 10 10)))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (destructuring-bind (x y z) position
          (%light-set-position ptr
            (coerce x 'double-float)
            (coerce y 'double-float)
            (coerce z 'double-float)))
        light))))

(defun set-light-angle (light angle-degrees)
  "Sets the cone angle of a spot **light** in degrees. Returns **light** on success.

  **Example:**

      (let ((l (make-light :spot :position '(0 0 0) :direction '(0 0 -1)))
        (set-light-angle l 45.0))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-set-angle ptr (coerce angle-degrees 'double-float))
        light))))

(defun set-light-concentration (light v)
  "Sets the concentration (hotspot) of a spot **light** to **v**. Returns **light** on success.

  **Example:**

      (let ((l (make-light :spot :position '(0 0 0) :direction '(0 0 -1)))
        (set-light-concentration l 0.8))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-set-concentration ptr (coerce v 'double-float))
        light))))

(defun set-headlight (light on)
  "Marks **light** as a headlight (moves with the camera) when **on** is `t`.

  Returns **light** on success.

  **Example:**

      (let ((l (make-light :directional)))
        (set-headlight l t))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-set-headlight ptr (if on 1 0))
        light))))

(defun set-light-shadows (light on)
  "Enables or disables shadow casting for **light**. Returns **light** on success.

  **Example:**

      (let ((l (make-light :directional :direction '(0 0 -1)))
        (set-light-shadows l t))"
  (when (viewer-light-p light)
    (let ((ptr (%ptr light)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%light-set-shadows ptr (if on 1 0))
        light))))

(defun viewer-default-lights (viewer)
  "Resets **viewer** to its default lighting configuration.

  Returns the viewer on success, `nil` otherwise.

  **Example:**

      (let ((v (make-viewer)))
        (viewer-default-lights v)
        (free-viewer v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (when (and v-ptr (not (cffi:null-pointer-p v-ptr)))
        (%v3d-viewer-default-lights v-ptr)
        viewer))))

(defun viewer-lights (viewer)
  "Returns a list of all lights registered for **viewer**.

  **Example:**

      (let ((v (make-viewer)))
        (viewer-lights v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (gethash v-ptr *light-registry*))))

(defun viewer-active-lights (viewer)
  "Returns a list of lights that are currently active (on) in **viewer**.

  **Example:**

      (let ((v (make-viewer)))
        (viewer-active-lights v))"
  (when (viewer-p viewer)
    (let ((v-ptr (%viewer viewer)))
      (remove-if-not (lambda (light)
                       (viewer-light-active-p viewer light))
                     (gethash v-ptr *light-registry*)))))

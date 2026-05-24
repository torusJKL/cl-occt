(in-package :cl-occt)

(defun sweep-profile (profile spine &key (mode :sliding))
  "Sweep a PROFILE shape along a SPINE wire.

  MODE is either :SLIDING (default, the profile slides along
  the spine) or :FIXED (the profile maintains a fixed orientation).
  Returns a new shape, or NIL if PROFILE or SPINE is null.

  Example:
    (let* ((circ (make-circle-edge 0 0 5))
           (face (make-face (make-wire circ)))
           (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
      (sweep-profile face spine))

  See also: sweep-sections, sweep-with-aux-spine"
  (when (or (null profile) (null spine))
    (return-from sweep-profile nil))
  (let ((profile-ptr (%ptr profile))
        (spine-ptr (%ptr spine)))
    (if (eq mode :fixed)
        (make-shape (%sweep-pipe-fixed profile-ptr spine-ptr))
        (make-shape (%sweep-pipe profile-ptr spine-ptr)))))

(defun sweep-sections (spine sections params &key (mode :sliding) initial-tangent final-tangent)
  "Sweep a surface through multiple cross-section wires along a SPINE.

  SECTIONS is a list of wire shapes, PARAMS is a list of parameter
  values (matching the number of sections) along the spine.  MODE is
  :SLIDING (default) or :FIXED.  Optional INITIAL-TANGENT and
  FINAL-TANGENT are vectors to constrain the tangency at ends.
  Returns a new shape, or NIL on invalid input.

  Example:
    (let* ((w1 (make-wire (make-circle-edge 0 0 5)))
           (w2 (make-wire (make-circle-edge 20 0 10)))
           (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
      (sweep-sections spine (list w1 w2) '(0.0 1.0)))

  See also: sweep-profile, sweep-with-aux-spine"
  (when (or (null spine) (null sections) (null params)
            (/= (length sections) (length params))
            (< (length sections) 1))
    (return-from sweep-sections nil))
  (let* ((count (length sections))
         (ptr-vec (map 'vector (lambda (s) (%ptr s)) sections))
         (sections-ff (cffi:foreign-alloc :pointer :initial-contents ptr-vec))
         (params-ff (cffi:foreign-alloc :double :initial-contents (mapcar (lambda (p) (coerce p 'double-float)) params)))
         (spine-ptr (%ptr spine))
         result)
    (unwind-protect
         (setf result
               (cond
                 ((eq mode :sliding)
                  (make-shape (%sweep-pipe-shell-sliding spine-ptr sections-ff params-ff count)))
                 ((eq mode :fixed)
                  (make-shape (%sweep-pipe-shell-fixed spine-ptr sections-ff params-ff count)))
                 (t
                  (make-shape (%sweep-pipe-shell spine-ptr sections-ff params-ff count)))))
      (cffi:foreign-free sections-ff)
      (cffi:foreign-free params-ff))
    result))

(defun sweep-with-aux-spine (profile main-spine aux-spine)
  "Sweep a PROFILE along a MAIN-SPINE guided by an AUX-SPINE.

  The auxiliary spine provides additional orientation control
  during the sweep.  Returns a new shape, or NIL if any argument
  is null.

  Example:
    (let* ((circ (make-circle-edge 0 0 5))
           (face (make-face (make-wire circ)))
           (main (make-wire (make-edge-3d 0 0 0 20 0 0)))
           (aux (make-wire (make-edge-3d 0 0 0 20 5 0))))
      (sweep-with-aux-spine face main aux))

  See also: sweep-profile, sweep-sections"
  (when (or (null profile) (null main-spine) (null aux-spine))
    (return-from sweep-with-aux-spine nil))
  (make-shape (%sweep-pipe-shell-aux (%ptr profile) (%ptr main-spine) (%ptr aux-spine))))
(in-package :cl-occt)

(defun sweep-profile (profile spine &key (mode :sliding))
  (when (or (null profile) (null spine))
    (return-from sweep-profile nil))
  (let ((profile-ptr (%ptr profile))
        (spine-ptr (%ptr spine)))
    (if (eq mode :fixed)
        (make-shape (%sweep-pipe-fixed profile-ptr spine-ptr))
        (make-shape (%sweep-pipe profile-ptr spine-ptr)))))

(defun sweep-sections (spine sections params &key (mode :sliding) initial-tangent final-tangent)
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
  (when (or (null profile) (null main-spine) (null aux-spine))
    (return-from sweep-with-aux-spine nil))
  (make-shape (%sweep-pipe-shell-aux (%ptr profile) (%ptr main-spine) (%ptr aux-spine))))
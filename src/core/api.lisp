(in-package :cl-occt)

(defun %mark-models-dirty (key)
  (loop for name being the hash-keys of cl-occt.impl:*model-registry*
        using (hash-value m)
        when (member key (model-param-keys m))
        do (cl-occt.impl:dirty-model! name)))

(defun set-param! (key value)
  (setf cl-occt.impl:*params*
        (list* key value
               (loop for (k v) on cl-occt.impl:*params* by #'cddr
                     unless (eql k key)
                     append (list k v))))
  (%mark-models-dirty key)
  (cl-occt.impl:propagate-changes)
  value)

(defun set-params! (&rest key-values)
  (let ((changed-keys '()))
    (loop for (key value) on key-values by #'cddr
          do (setf cl-occt.impl:*params*
                   (list* key value
                          (loop for (k v) on cl-occt.impl:*params* by #'cddr
                                unless (eql k key)
                                append (list k v))))
          (pushnew key changed-keys))
    (dolist (k changed-keys)
      (%mark-models-dirty k))
    (cl-occt.impl:propagate-changes)
    cl-occt.impl:*params*))

(in-package :cl-occt)

(defun model-ref (name)
  (let ((m (cl-occt.impl:find-model name)))
    (if m
        (model-cached-shape m)
        (error "Model ~S not found" name))))

(defun %collect-model-refs (form)
  (when (consp form)
    (if (and (eq (car form) 'model-ref)
             (symbolp (cadr form)))
        (list (cadr form))
        (append (%collect-model-refs (car form))
                (%collect-model-refs (cdr form))))))

(defun %model-keys-from-params (body)
  (let ((keys '()))
    (labels ((walk (form)
               (when (consp form)
                 (when (and (eq (car form) 'param)
                            (keywordp (cadr form))
                            (not (member (cadr form) keys)))
                   (push (cadr form) keys))
                 (walk (car form))
                 (walk (cdr form)))))
      (walk body))
    (nreverse keys)))

(defmacro defmodel (name (&rest param-keys) &body body)
  (let ((model-deps (%collect-model-refs body))
        (detected-keys (or param-keys (%model-keys-from-params body))))
    (let ((arg-names (loop for k in detected-keys collect (gensym (string k))))
          (key-syms (loop for k in detected-keys collect (intern (string k) :keyword))))
      `(progn
         (let ((old (cl-occt.impl:find-model ',name)))
           (when old
             (cl-occt.impl:unregister-model ',name)))
         (let ((m (make-model :name ',name
                              :fn (lambda () ,@body)
                              :param-keys ',detected-keys
                              :model-deps ',model-deps
                              :dirty t)))
           (cl-occt.impl:register-model ',name m)
           (dolist (dep ',model-deps)
             (let ((dm (cl-occt.impl:find-model dep)))
               (when dm
                 (pushnew ',name (model-dependents dm)))))
           (cl-occt.impl:propagate-changes))
         (defun ,name (&key ,@(loop for k in key-syms
                                    for g in arg-names
                                    collect `((,k ,g) (param ',k))))
           (let ((cl-occt:*local-params*
                   (list ,@(loop for k in key-syms
                                 for g in arg-names
                                 append `(,k ,g)))))
             (declare (ignorable cl-occt:*local-params*))
             ,@body))
         ',name))))

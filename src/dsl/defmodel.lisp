(in-package :cl-occt)

(defun model-color (name)
  (let ((m (cl-occt.impl:find-model name)))
    (if m
        (cl-occt.impl:model-color m)
        (error "Model ~S not found" name))))

(defun model-display-name (name)
  (let ((m (cl-occt.impl:find-model name)))
    (if m
        (cl-occt.impl:model-display-name m)
        (error "Model ~S not found" name))))

(defun model-layer (name)
  (let ((m (cl-occt.impl:find-model name)))
    (if m
        (cl-occt.impl:model-layer m)
        (error "Model ~S not found" name))))

(defun model-ref (name)
  (let ((m (cl-occt.impl:find-model name)))
    (if m
        (model-cached-shape m)
        (error "Model ~S not found" name))))

(defmacro text (string &key font (h-align :left) (v-align :bottom) position normal)
  `(make-text-shape (or ,font
                        (error "text: :font is required"))
                    ,string
                    :h-align ,h-align
                    :v-align ,v-align
                    :position ,position
                    :normal ,normal))

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

(defun %parse-metadata (body)
  (let ((metadata '())
        (rest body))
    (loop while (and rest (consp (car rest))
                     (member (caar rest) '(:color :name :layer)))
          do (push (pop rest) metadata))
    (values (nreverse metadata) rest)))

(defun %metadata-form (form)
  (if (and (consp form) (keywordp (car form)))
      `',form
      form))

(defmacro defmodel (name (&rest param-keys) &body body)
  (multiple-value-bind (metadata-clauses real-body) (%parse-metadata body)
    (let* ((all-keys (or param-keys (%model-keys-from-params body)))
           (color-form (cadr (assoc :color metadata-clauses)))
           (name-form (cadr (assoc :name metadata-clauses)))
           (layer-form (cadr (assoc :layer metadata-clauses)))
           (model-deps (%collect-model-refs real-body))
           (detected-keys all-keys))
      (let ((arg-names (loop for k in detected-keys collect (gensym (string k))))
            (key-syms (loop for k in detected-keys collect (intern (string k) :keyword))))
        `(progn
           (let ((old (cl-occt.impl:find-model ',name)))
             (when old
               (cl-occt.impl:unregister-model ',name)))
           (let ((m (make-model :name ',name
                                :fn (lambda ()
                                      (let ((shape (progn ,@real-body)))
                                         (values shape
                                                 ,(%metadata-form color-form)
                                                 ,(%metadata-form name-form)
                                                 ,(%metadata-form layer-form))))
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
             (let ((shape (progn ,@real-body)))
                (values shape
                        ,(%metadata-form color-form)
                        ,(%metadata-form name-form)
                        ,(%metadata-form layer-form)))))
         ',name)))))

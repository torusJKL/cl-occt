(asdf:load-system :staple-markdown)
(ql:quickload :3bmd-ext-tables)
(setf 3bmd-tables:*tables* t)

(defclass cl-occt-page (staple:simple-page) ())

(defmethod staple:page-type ((system (eql (asdf:find-system :cl-occt))))
  'cl-occt-page)

(defmethod staple:packages ((system (eql (asdf:find-system :cl-occt))))
  (mapcar #'find-package '(:cl-occt :cl-occt.impl)))

(defmethod staple:images ((system (eql (asdf:find-system :cl-occt))))
  ())

(defmethod staple:documents ((system (eql (asdf:find-system :cl-occt))))
  (let ((source (asdf:system-source-directory system)))
    (when source
      (list (merge-pathnames "README.md" source)))))

(defmethod staple:subsystems ((system (eql (asdf:find-system :cl-occt))))
  ())

(defmethod staple:template ((system (eql (asdf:find-system :cl-occt))))
  (asdf:system-relative-pathname :cl-occt "staple-template.ctml"))

(defmethod staple:title ((page cl-occt-page))
  "cl-occt")

(defmethod staple:format-documentation ((docstring string) (page cl-occt-page))
  (let ((*package* (first (staple:packages page))))
    (staple:markup-code-snippets-ignoring-errors
     (staple:compile-source docstring :markdown))))

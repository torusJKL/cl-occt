(asdf:load-system :staple-markdown)

(defclass cl-occt-page (staple:simple-page) ())

(defmethod staple:page-type ((system (eql (asdf:find-system :cl-occt))))
  'cl-occt-page)

(defmethod staple:packages ((system (eql (asdf:find-system :cl-occt))))
  (mapcar #'find-package '(:cl-occt :cl-occt.impl)))

(defmethod staple:format-documentation ((docstring string) (page cl-occt-page))
  (let ((*package* (first (staple:packages page))))
    (staple:markup-code-snippets-ignoring-errors
     (staple:compile-source docstring :markdown))))

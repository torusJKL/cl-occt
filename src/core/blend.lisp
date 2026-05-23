(in-package :cl-occt)

(defun blend-faces (face1 face2 radius)
  (if (or (null face1) (null face2))
      nil
      (make-shape (%blend-faces-constant (%ptr face1) (%ptr face2)
                                          (coerce radius 'double-float)))))

(defun make-blend (face1 face2 type radius-law)
  (if (or (null face1) (null face2))
      nil
      (ecase type
        (:constant
         (make-shape (%blend-make-constant (%ptr face1) (%ptr face2)
                                            (coerce radius-law 'double-float))))
        (:evolving
         radius-law
         nil))))

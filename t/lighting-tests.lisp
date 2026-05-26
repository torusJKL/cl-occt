(in-package :cl-occt)
(deftest make-light-ambient-valid
  (let ((light (make-light :ambient :color :warm-gray :intensity 0.5)))
    (assert-true (viewer-light-p light) "ambient light should be viewer-light")
    (free-light light)))
(deftest make-light-directional-valid
  (let ((light (make-light :directional :color :white :direction '(0 0 -1))))
    (assert-true (viewer-light-p light) "directional light should be viewer-light")
    (free-light light)))
(deftest make-light-positional-valid
  (let ((light (make-light :positional :color :red :position '(5 5 5))))
    (assert-true (viewer-light-p light) "positional light should be viewer-light")
    (free-light light)))
(deftest make-light-spot-valid
  (let ((light (make-light :spot :color :white :position '(0 0 0) :direction '(0 0 -1))))
    (assert-true (viewer-light-p light) "spot light should be viewer-light")
    (free-light light)))
(deftest set-light-position-angle-concentration
  (let ((light (make-light :spot)))
    (assert-true (set-light-position light '(5 5 5))
                 "set-light-position should return the light")
    (assert-true (set-light-angle light 30.0)
                 "set-light-angle should return the light")
    (assert-true (set-light-concentration light 0.8)
                 "set-light-concentration should return the light")
    (free-light light)))
(deftest set-light-color-intensity
  (let ((light (make-light :ambient)))
    (assert-true (set-light-color light :red) "set-light-color should work")
    (assert-true (set-light-intensity light 0.8) "set-light-intensity should work")
    (free-light light)))
(deftest set-light-direction-valid
  (let ((light (make-light :directional)))
    (assert-true (set-light-direction light '(0 -1 0)) "set-light-direction should work")
    (free-light light)))
(deftest set-headlight-valid
  (let ((light (make-light :directional)))
    (assert-true (set-headlight light t) "set-headlight should work")
    (free-light light)))
(deftest viewer-add-and-toggle-light
  (with-viewer (v)
    (let ((light (make-light :ambient :color :warm-gray)))
      (viewer-add-light v light)
      (viewer-light-on v light)
      (assert-true (viewer-light-active-p v light)
                   "light should be active after set-light-on")
      (viewer-light-off v light)
      (free-light light))))
(deftest viewer-default-lights-valid
  (with-viewer (v)
    (assert-true (viewer-default-lights v) "default lights should restore")))

;; --- Grid ---
(deftest viewer-lights-and-active
  (with-viewer (v)
    (let* ((l1 (make-light :ambient :color :warm-gray))
           (l2 (make-light :directional :color :white :direction '(0 0 -1))))
      (viewer-add-light v l1)
      (viewer-add-light v l2)
      (viewer-light-on v l1)
      (let ((all (viewer-lights v))
            (active (viewer-active-lights v)))
        (assert-true (and (listp all) (= (length all) 2)) "viewer-lights should return 2 lights")
        (assert-true (listp active) "viewer-active-lights should return a list")
        (free-light l1)
        (free-light l2)))))

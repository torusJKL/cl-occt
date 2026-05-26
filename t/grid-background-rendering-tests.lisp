(in-package :cl-occt)
(deftest grid-active-p-after-activate
  (with-viewer (v)
    (activate-grid v :rectangular :lines)
    (assert-true (grid-active-p v) "grid should be active after activate")))
(deftest grid-active-p-after-deactivate
  (with-viewer (v)
    (activate-grid v :rectangular :lines)
    (deactivate-grid v)
    (assert-nil (grid-active-p v) "grid should not be active after deactivate")))

;; --- Background ---
(deftest set-gradient-background-valid
  (with-viewer (v)
    (assert-true (set-gradient-background v :color1 '(0.1 0.1 0.3) :color2 '(0.8 0.8 0.9))
                 "gradient background should work")))
(deftest set-gradient-background-style
  (with-viewer (v)
    (assert-true (set-gradient-background v :style :x-neg)
                 "gradient with style should work")))

;; Cubemap test requires valid image files. Manual test:
;; (set-background-cubemap view :pos-x "px.jpg" ...)
(deftest set-background-cubemap-creation
  (let* ((dir *test-image-dir*)
         (strings (list (concatenate 'string dir "px.png")
                        (concatenate 'string dir "nx.png")
                        (concatenate 'string dir "py.png")
                        (concatenate 'string dir "ny.png")
                        (concatenate 'string dir "pz.png")
                        (concatenate 'string dir "nz.png")))
         (foreign-strings (mapcar #'cffi:foreign-string-alloc strings))
         (cffi-vec (cffi:foreign-alloc :pointer :initial-contents foreign-strings))
         (ptr (%make-cubemap-separate cffi-vec 6)))
    (dotimes (i 6)
      (cffi:foreign-free (cffi:mem-aref cffi-vec :pointer i)))
    (cffi:foreign-free cffi-vec)
    (assert-true (and ptr (not (cffi:null-pointer-p ptr)))
                 "cubemap creation from valid images should succeed")
    (when (and ptr (not (cffi:null-pointer-p ptr)))
      (%free-cubemap ptr))))
(deftest reset-background-valid
  (with-viewer (v)
    (assert-true (reset-background v) "reset-background should work")))

;; --- Rendering ---
(deftest set-computed-mode-toggle
  (with-viewer (v)
    (set-computed-mode v t)
    (assert-true (computed-mode-p v) "computed-mode-p should be t")
    (set-computed-mode v nil)
    (assert-nil (computed-mode-p v) "computed-mode-p should be nil")))
(deftest set-back-face-model-valid
  (with-viewer (v)
    (assert-true (set-back-face-model v :force)
                 "set-back-face-model should return the viewer")))
(deftest set-frustum-culling-valid
  (with-viewer (v)
    (assert-true (set-frustum-culling v t)
                 "set-frustum-culling should return the viewer")))
(deftest set-transparency-method-valid
  (with-viewer (v)
    (assert-true (set-transparency-method v :blend-oit)
                 "set-transparency-method should return the viewer")))
(deftest redraw-view-valid
  (with-viewer (v)
    (assert-true (redraw-view v) "redraw-view should return the viewer")))
(deftest set-immediate-update-valid
  (with-viewer (v)
    (assert-true (set-immediate-update v t)
                 "set-immediate-update should return the viewer")))

;; --- Text Labels ---
(deftest set-transparent-shading-alias
  (with-viewer (v)
    (assert-true (set-transparent-shading v :blend-oit)
                 "set-transparent-shading alias should work")))

;; --- Mass Properties ---

(in-package :cl-occt.impl)

;; --- Dimensions ---

(defcfun (%prsdim-set-measured-edge "prsdim_set_measured_edge") :void
  (dim :pointer) (shape :pointer)
  (px :double) (py :double) (pz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%prsdim-set-custom-value "prsdim_set_custom_value") :void
  (dim :pointer) (value :string))

(defcfun (%prsdim-set-angle-edges "prsdim_set_angle_edges") :void
  (dim :pointer) (edge1 :pointer) (edge2 :pointer))

(defcfun (%prsdim-set-arrow-length "prsdim_set_arrow_length") :void
  (dim :pointer) (v :double))

(defcfun (%prsdim-set-extension-size "prsdim_set_extension_size") :void
  (dim :pointer) (v :double))

(defcfun (%prsdim-make-length-2p "prsdim_make_length_2p") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%prsdim-make-angle-3p "prsdim_make_angle_3p") :pointer
  (vx :double) (vy :double) (vz :double)
  (p1x :double) (p1y :double) (p1z :double)
  (p2x :double) (p2y :double) (p2z :double))

(defcfun (%prsdim-make-diameter "prsdim_make_diameter") :pointer
  (shape :pointer))

(defcfun (%prsdim-make-radius "prsdim_make_radius") :pointer
  (shape :pointer))

(defcfun (%prsdim-set-text-position "prsdim_set_text_position") :void
  (dim :pointer) (x :double) (y :double) (z :double))

(defcfun (%prsdim-set-display-units "prsdim_set_display_units") :void
  (dim :pointer) (units :string))

(defcfun (%prsdim-set-flyout "prsdim_set_flyout") :void
  (dim :pointer) (v :double))

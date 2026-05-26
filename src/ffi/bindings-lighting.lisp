(in-package :cl-occt.impl)

;; --- Lighting ---

(defcfun (%make-light-ambient "make_light_ambient") :pointer
  (r :double) (g :double) (b :double) (intensity :double))

(defcfun (%make-light-directional "make_light_directional") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-light-positional "make_light_positional") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (x :double) (y :double) (z :double))

(defcfun (%make-light-spot "make_light_spot") :pointer
  (r :double) (g :double) (b :double) (intensity :double)
  (x :double) (y :double) (z :double)
  (dx :double) (dy :double) (dz :double)
  (angle :double) (concentration :double))

(defcfun (%light-free "light_free") :void
  (light :pointer))

(defcfun (%v3d-viewer-add-light "v3d_viewer_add_light") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-remove-light "v3d_viewer_remove_light") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-light-on "v3d_viewer_light_on") :void
  (viewer :pointer) (light :pointer))

(defcfun (%v3d-viewer-light-off "v3d_viewer_light_off") :void
  (viewer :pointer) (light :pointer))

(defcfun (%light-is-on "light_is_on") :int
  (light :pointer))

(defcfun (%light-set-color "light_set_color") :void
  (light :pointer) (r :double) (g :double) (b :double))

(defcfun (%light-set-intensity "light_set_intensity") :void
  (light :pointer) (v :double))

(defcfun (%light-set-direction "light_set_direction") :void
  (light :pointer) (dx :double) (dy :double) (dz :double))

(defcfun (%light-set-position "light_set_position") :void
  (light :pointer) (x :double) (y :double) (z :double))

(defcfun (%light-set-angle "light_set_angle") :void
  (light :pointer) (angle :double))

(defcfun (%light-set-concentration "light_set_concentration") :void
  (light :pointer) (v :double))

(defcfun (%light-set-headlight "light_set_headlight") :void
  (light :pointer) (on :int))

(defcfun (%light-set-shadows "light_set_shadows") :void
  (light :pointer) (on :int))

(defcfun (%v3d-viewer-default-lights "v3d_viewer_default_lights") :void
  (viewer :pointer))

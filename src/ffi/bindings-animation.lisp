(in-package :cl-occt.impl)

;; --- AIS Animation ---

(defcfun (%ais-animation-create "ais_animation_create") :pointer
  (name :string))

(defcfun (%ais-animation-free "ais_animation_free") :void
  (anim :pointer))

(defcfun (%ais-animation-start "ais_animation_start") :void
  (anim :pointer))

(defcfun (%ais-animation-stop "ais_animation_stop") :void
  (anim :pointer))

(defcfun (%ais-animation-is-playing "ais_animation_is_playing") :int
  (anim :pointer))

(defcfun (%ais-animation-set-duration "ais_animation_set_duration") :void
  (anim :pointer)
  (seconds :double))

(defcfun (%ais-animation-duration "ais_animation_duration") :double
  (anim :pointer))

(defcfun (%ais-animation-set-progress "ais_animation_set_progress") :void
  (anim :pointer)
  (progress :double))

(defcfun (%ais-animation-progress "ais_animation_progress") :double
  (anim :pointer))

(defcfun (%ais-animation-set-start-pause "ais_animation_set_start_pause") :void
  (anim :pointer)
  (seconds :double))

(defcfun (%ais-animation-add "ais_animation_add") :void
  (parent :pointer)
  (child :pointer))

(defcfun (%ais-animation-remove "ais_animation_remove") :void
  (parent :pointer)
  (child :pointer))

(defcfun (%ais-animation-object-create "ais_animation_object_create") :pointer
  (name :string)
  (ctx :pointer)
  (ais-obj :pointer)
  (tx :double) (ty :double) (tz :double)
  (rx :double) (ry :double) (rz :double)
  (angle-deg :double))

(defcfun (%ais-animation-object-get-object "ais_animation_object_get_object") :pointer
  (anim :pointer))

(defcfun (%ais-animation-camera-create "ais_animation_camera_create") :pointer
  (name :string)
  (view :pointer)
  (sex :double) (sey :double) (sez :double)
  (stx :double) (sty :double) (stz :double)
  (sux :double) (suy :double) (suz :double)
  (eex :double) (eey :double) (eez :double)
  (etx :double) (ety :double) (etz :double)
  (eux :double) (euy :double) (euz :double))

(defcfun (%ais-animation-axis-rotation-create "ais_animation_axis_rotation_create") :pointer
  (name :string)
  (ctx :pointer)
  (ais-obj :pointer)
  (ox :double) (oy :double) (oz :double)
  (dx :double) (dy :double) (dz :double)
  (angle-start-deg :double)
  (angle-end-deg :double))

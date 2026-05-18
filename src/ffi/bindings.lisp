(in-package :cl-occt.impl)

(defcfun (%make-box "make_box") :pointer
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-cylinder "make_cylinder") :pointer
  (radius :double)
  (height :double))

(defcfun (%make-sphere "make_sphere") :pointer
  (radius :double))

(defcfun (%make-cone "make_cone") :pointer
  (r1 :double)
  (r2 :double)
  (height :double))

(defcfun (%make-torus "make_torus") :pointer
  (major-radius :double)
  (minor-radius :double))

(defcfun (%make-prism "make_prism") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%make-revol "make_revol") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

(defcfun (%boolean-cut "boolean_cut") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-fuse "boolean_fuse") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-common "boolean_common") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%boolean-section "boolean_section") :pointer
  (a :pointer)
  (b :pointer))

(defcfun (%translate "translate") :pointer
  (shape :pointer)
  (dx :double)
  (dy :double)
  (dz :double))

(defcfun (%rotate "rotate") :pointer
  (shape :pointer)
  (ax :double)
  (ay :double)
  (az :double)
  (angle-deg :double))

(defcfun (%write-step "write_step") :int
  (shape :pointer)
  (filename :string))

(defcfun (%read-step "read_step") :pointer
  (filename :string))

(defcfun (%make-pnt2d "make_pnt2d") :pointer
  (x :double)
  (y :double))

(defcfun (%make-vec2d "make_vec2d") :pointer
  (x :double)
  (y :double))

(defcfun (%make-dir2d "make_dir2d") :pointer
  (x :double)
  (y :double))

(defcfun (%free-geom2d "free_geom2d") :void
  (g :pointer))

(defcfun (%make-line-2d "make_line_2d") :pointer
  (x :double)
  (y :double)
  (dx :double)
  (dy :double))

(defcfun (%make-circle-2d "make_circle_2d") :pointer
  (x :double)
  (y :double)
  (radius :double))

(defcfun (%make-edge-line-2d "make_edge_line_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double))

(defcfun (%make-edge-line-3d "make_edge_line_3d") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%make-edge-circle-2d "make_edge_circle_2d") :pointer
  (x :double) (y :double)
  (radius :double))

(defcfun (%make-edge-arc-2d "make_edge_arc_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double)
  (x3 :double) (y3 :double))

(defcfun (%make-wire "make_wire") :pointer
  (edges :pointer)
  (count :int))

(defcfun (%make-face "make_face") :pointer
  (wire :pointer))

(defcfun (%make-face-on-plane "make_face_on_plane") :pointer
  (wire :pointer)
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%free-shape "free_shape") :void
  (shape :pointer))

(defcfun (%get-error-code "get_error_code") :int)

(defcfun (%get-error-message "get_error_message") :string)

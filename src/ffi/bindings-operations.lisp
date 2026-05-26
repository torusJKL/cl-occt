(in-package :cl-occt.impl)

;; --- Fillet / Chamfer / Blend ---

(defcfun (%fillet-edge-constant "fillet_edge_constant") :pointer
  (shape :pointer)
  (edge :pointer)
  (radius :double))

(defcfun (%fillet-edges-constant "fillet_edges_constant") :pointer
  (shape :pointer)
  (edges :pointer)
  (num-edges :int)
  (radius :double))

(defcfun (%fillet-edge-variable "fillet_edge_variable") :pointer
  (shape :pointer)
  (edge :pointer)
  (params-and-radii :pointer)
  (num-pairs :int))

(defcfun (%fillet-wire-corner "fillet_wire_corner") :pointer
  (wire :pointer)
  (radius :double))

(defcfun (%fillet-wire-all-corners "fillet_wire_all_corners") :pointer
  (wire :pointer)
  (radius :double))

(defcfun (%chamfer-edge-equal "chamfer_edge_equal") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance :double))

(defcfun (%chamfer-edges-equal "chamfer_edges_equal") :pointer
  (shape :pointer)
  (edges :pointer)
  (num-edges :int)
  (distance :double))

(defcfun (%chamfer-edge-asym "chamfer_edge_asym") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance1 :double)
  (distance2 :double))

(defcfun (%chamfer-edge-on-face "chamfer_edge_on_face") :pointer
  (shape :pointer)
  (edge :pointer)
  (distance :double)
  (face :pointer))

(defcfun (%blend-faces-constant "blend_faces_constant") :pointer
  (face1 :pointer)
  (face2 :pointer)
  (radius :double))

(defcfun (%blend-make-constant "blend_make_constant") :pointer
  (face1 :pointer)
  (face2 :pointer)
  (radius :double))

;; --- Sweep / Pipe ---

(defcfun (%sweep-pipe "sweep_pipe") :pointer
  (profile :pointer)
  (spine :pointer))

(defcfun (%sweep-pipe-fixed "sweep_pipe_fixed") :pointer
  (profile :pointer)
  (spine :pointer))

(defcfun (%sweep-pipe-shell "sweep_pipe_shell") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-sliding "sweep_pipe_shell_sliding") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-fixed "sweep_pipe_shell_fixed") :pointer
  (spine :pointer)
  (sections :pointer)
  (params :pointer)
  (count :int))

(defcfun (%sweep-pipe-shell-aux "sweep_pipe_shell_aux") :pointer
  (profile :pointer)
  (main-spine :pointer)
  (aux-spine :pointer))

;; --- Loft ---

(defcfun (%loft-sections "loft_sections") :pointer
  (wires :pointer)
  (count :int)
  (solid :int))

(defcfun (%loft-sections-ruled "loft_sections_ruled") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (ruled :int))

(defcfun (%loft-sections-smooth "loft_sections_smooth") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (smooth :int))

(defcfun (%loft-sections-tangency "loft_sections_tangency") :pointer
  (wires :pointer)
  (count :int)
  (solid :int)
  (init-face :pointer)
  (final-face :pointer))

;; --- Face Filling ---

(defcfun (%fill-face "fill_face") :pointer
  (wire :pointer))

(defcfun (%fill-face-constrained "fill_face_constrained") :pointer
  (wire :pointer)
  (support-faces :pointer)
  (continuities :pointer)
  (count :int))

(defcfun (%fill-n-sided-face "fill_n_sided_face") :pointer
  (edges :pointer)
  (count :int)
  (continuity :int))

;; --- Shell / Thicken ---

(defcfun (%shell-shape "shell_shape") :pointer
  (shape :pointer)
  (faces :pointer)
  (num-faces :int)
  (thickness :double))

;; --- Offset ---

(defcfun (%offset-shape-3d "offset_shape_3d") :pointer
  (shape :pointer)
  (offset :double)
  (join :int))

(defcfun (%offset-wire-2d "offset_wire_2d") :pointer
  (wire :pointer)
  (offset :double))

;; --- Draft ---

(defcfun (%draft-face "draft_face") :pointer
  (shape :pointer)
  (face :pointer)
  (angle :double)
  (dx :double) (dy :double) (dz :double)
  (px :double) (py :double) (pz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%make-evolved "make_evolved") :pointer
  (profile :pointer)
  (spine :pointer)
  (offset :double)
  (join :int))

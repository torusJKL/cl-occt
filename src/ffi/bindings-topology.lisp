(in-package :cl-occt.impl)

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

(defcfun (%make-compound "make_compound") :pointer
  (shapes :pointer)
  (count :int))

(defcfun (%add-to-compound "add_to_compound") :pointer
  (compound :pointer)
  (shape :pointer))

(defcfun (%compound-is-empty "compound_is_empty") :int
  (shape :pointer))

(defcfun (%shape-is-compound "shape_is_compound") :int
  (shape :pointer))

(defcfun (%make-wire "make_wire") :pointer
  (edges :pointer)
  (count :int))

(defcfun (%make-face "make_face") :pointer
  (wire :pointer))

(defcfun (%make-face-on-plane "make_face_on_plane") :pointer
  (wire :pointer)
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))
